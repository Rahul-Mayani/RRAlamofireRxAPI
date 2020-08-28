//
//  RRAPIRxManager.swift
//  RRAlamofireRxAPI
//
//  Created by Rahul Mayani on 23/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Alamofire

public struct RRAPIRxManager: ObservableType {
    
    public typealias Element = Any       // The response data type.
    
    var apiUrl: String                  // The URL.
    var httpMethod: HTTPMethod          // The HTTP method.
    var param: [String:Any]?            // The parameters.
    var showingIndicator: Bool = false  // The custom indicator.
    
    // Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
    static var manager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200.0
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    // The HTTP headers. `nil` by default.
    static private func header() -> HTTPHeaders {
        var header = HTTPHeaders()
        header["Content-Type"] = "application/json"
        //header["Authorization"] = "Bearer" + " " + token
        return header
    }
    
    // The parameter encoding. `URLEncoding.default` by default.
    static private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.default
        if httpMethod == .get{
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, RRAPIRxManager.Element == Observer.Element {
        
        if showingIndicator {
            //AppLoader.startLoaderToAnimating()
        }
        
        let task = RRAPIRxManager.manager.request(apiUrl,
                                                 method: httpMethod,
                                                 parameters: param,
                                                 encoding: RRAPIRxManager.encoding(httpMethod),
                                                 headers: RRAPIRxManager.header())
            .responseJSON { (response) in
            
            //AppLoader.stopLoaderToAnimating()
                
                if response.response?.statusCode == StatusCode.unAuthorized.rawValue { // User unauthorized
                observer.onError(NSError(domain: response.request?.url?.absoluteString ?? "", code: StatusCode.unAuthorized.rawValue, userInfo: nil))
                return
            }
                
            switch response.result {
                case .success :
                    observer.onNext(response.value as RRAPIRxManager.Element)
                    observer.onCompleted()
                    break
                case .failure(let error):
                    if (error as NSError).code == StatusCode.noInternetConnection.rawValue {
                        observer.onError(NSError(domain: response.request?.url?.absoluteString ?? "", code: StatusCode.noInternetConnection.rawValue, userInfo: nil))
                    } else {
                        observer.onError(error)
                    }
                    break
            }
        }
        
        task.resume()
        
        // cURL Request Output
        debugPrint(" cURL Request ")
        debugPrint(task)
        debugPrint("")
        
        return Disposables.create { task.cancel() }
    }
}

extension RRAPIRxManager {
    
    public static func rxCall(apiUrl: String, httpMethod: HTTPMethod = .get, param: [String:Any]? = nil, showingIndicator: Bool = false) -> Observable<Element> {
        return Observable.deferred {
            return RRAPIRxManager(apiUrl: apiUrl,
                                 httpMethod: httpMethod,
                                 param: param,
                                 showingIndicator: showingIndicator)
                  .asObservable()
        }
    }
}

extension ObservableType {
    
    /**
     Makes the observable Subscribe to concurrent background thread and Observe on main thread
     */
    public func subscribeConcurrentBackgroundToMainThreads() -> Observable<Element> {
        return self.subscribeOn(RXScheduler.concurrentBackground)
            .observeOn(RXScheduler.main)
    }
}

public struct RXScheduler {
    static let main = MainScheduler.instance
    static let concurrentMain = ConcurrentMainScheduler.instance

    static let serialBackground = SerialDispatchQueueScheduler.init(qos: .background)
    static let concurrentBackground = ConcurrentDispatchQueueScheduler.init(qos: .background)

    static let serialUtility = SerialDispatchQueueScheduler.init(qos: .utility)
    static let concurrentUtility = ConcurrentDispatchQueueScheduler.init(qos: .utility)

    static let serialUser = SerialDispatchQueueScheduler.init(qos: .userInitiated)
    static let concurrentUser = ConcurrentDispatchQueueScheduler.init(qos: .userInitiated)

    static let serialInteractive = SerialDispatchQueueScheduler.init(qos: .userInteractive)
    static let concurrentInteractive = ConcurrentDispatchQueueScheduler.init(qos: .userInteractive)
}

enum StatusCode: Int {
    case ok = 200
    case create = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case noFound = 404
    case methodNotAllow = 405
    case conflict = 409
    case serverError = 500
    case unavailable = 503
    case requestTimeout = 408
    case noInternetConnection = -1009
}


/*
public class RRAPI: NSObject, ObservableType {
    
    /// `Singleton` variable of API class
    static let shared = RRAPI()
    
    // MARK: Types
    
    /// The response of data type.
    public typealias Element = Any
    
    // MARK: - Properties
    
    /// `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    private(set) var apiUrl: String?
    
    /// `HTTPMethod` for the `URLRequest`. `.get` by default..
    private(set) var httpMethod: HTTPMethod = .get
    
    /// `Param` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default..
    private(set) var param: [String: Any]?
    
    /// The custom loading indicator shows while getting the response from the server. `hide` by default..
    private(set) var showingIndicator: Bool = false
     
    // MARK: - Initializer
    
    /// Set url
    ///
    /// - Parameter apiUrl: URL to set for api request
    /// - Returns: Self
    public func setURL(_ url: String) -> Self {
        self.apiUrl = url
        return self
    }
    
    /// Set httpMethod
    ///
    /// - Parameter httpMethod: to change as get, post, put, delete etc..
    /// - Returns: Self
    public func setHttpMethod(_ httpMethod: HTTPMethod) -> Self {
        self.httpMethod = httpMethod
        return self
    }
    
    /// Set param
    ///
    /// - Parameter param: a dictionary of parameters to apply to a `URLRequest`.
    /// - Returns: Self
    public func setParameter(_ param: [String:Any]) -> Self {
        self.param = param
        return self
    }
    
    /// Set indicator
    ///
    /// - Parameter indicator: to show / hide
    /// - Returns: Self
    public func showIndicator(_ isLoder: Bool) -> Self {
        self.showingIndicator = isLoder
        return self
    }
    
    /// Get observable
    /// The Defer operator waits until an observer subscribes to it, and then it generates an Observable,
    /// typically with an Observable factory function. It does this afresh for each subscriber, so although each subscriber may think it is subscribing to the same Observable,
    /// in fact each subscriber gets its own individual sequence.
    /// Default implementation of converting `ObservableType` to `Observable`.
    /*public func setDeferredAsObservable() -> Observable<Element> {
        return Observable.deferred {
            return self.asObservable()
        }
    }*/
    
    /// `Session` creates and manages Alamofire's `Request` types during their lifetimes. It also provides common
    /// functionality for all `Request`s, including queuing, interception, trust management, redirect handling, and response
    /// cache handling.
    private var manager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200.0
        return Alamofire.Session(configuration: configuration)
    }()
    
    /// `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default..
    private func header(url: String = "") -> HTTPHeaders {
        var header = HTTPHeaders()
        header["Content-Type"] = "application/json"
        /*
        // API
        if let token = Preference.fetch(.accessToken) as? String{
            header["Authorization"] = "Bearer" + " " + token
        }*/
        return header
    }
    
    /// The parameter encoding. `URLEncoding.default` by default.
    private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.default
        if httpMethod == .get{
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    /// Subscription for `observer` that can be used to cancel production of sequence elements and free resources.
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
        
        if showingIndicator {
            RRLoader.startLoaderToAnimating()
        }
        
        let url = apiUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        /// Creates a `DataRequest` from a `URLRequest`.
        /// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
        let task = self.manager.request(url,
                                        method: httpMethod,
                                        parameters: param,
                                        encoding: self.encoding(httpMethod),
                                        headers: self.header(url: url))
            .responseJSON { (response) in
            
            if self.showingIndicator {
                RRLoader.stopLoaderToAnimating()
            }
                
            if response.response?.statusCode == RRHTTPStatusCode.unauthorized.rawValue {
                //RRLogout.logout()
                observer.onError(RRError.unauthorized)
                //observer.onCompleted()
                return
            }
                
            switch response.result {
            case .success :
                observer.onNext(response.value as Element)
                observer.onCompleted()
                break
            case .failure(let error):
                if error.isSessionTaskError {
                    observer.onError(RRError.noInternetConnection)
                } else {
                    observer.onError(error)
                }
                break
            }
        }
        
        task.resume()
        
        // cURL Request Output
        debugPrint(" cURL Request ")
        debugPrint(task)
        debugPrint("")
        
        return Disposables.create { task.cancel() }
    }
}

For Exmp:
class ViewController: UIViewController {

    let rxbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RRAPI.shared.setURL("https://reqres.in/api/users?page=1&per_page=8")
        .showIndicator(true)
        .setDeferredAsObservable()
        .subscribeConcurrentBackgroundToMainThreads()
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error.localizedDescription)
        }).disposed(by: rxbag)
    }
}
*/
