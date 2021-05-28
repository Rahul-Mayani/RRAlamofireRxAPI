//
//  RRAPIRxManager.swift
//  RRAlamofireRxAPI
//
//  Created by Rahul Mayani on 23/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import Foundation
import UIKit
import RxCocoaRuntime
import RxCocoa
import RxSwift
import Alamofire

public class RRAPIRxManager: ObservableType {
    
    /// `Singleton` variable of API class
    public static let shared = RRAPIRxManager()
        
    /// It's private for subclassing
    private init() {}
    
    // MARK: Types
    
    /// The response of data type.
    public typealias Element = Any
    
    // MARK: - Properties
    
    /// `Session` creates and manages Alamofire's `Request` types during their lifetimes. It also provides common
    /// functionality for all `Request`s, including queuing, interception, trust management, redirect handling, and response
    /// cache handling.
    private(set) var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200.0
        return Alamofire.Session(configuration: configuration)
    }()
    
    /// `HTTPHeaders` value to be added to the `URLRequest`. Set `["Content-Type": "application/json"]` by default..
    private(set) var headers: HTTPHeaders = ["Content-Type": "application/json"]
        
    /// `URLConvertible` value to be used as the `URLRequest`'s `URL`.
    private(set) var apiUrl: String?
    
    /// `HTTPMethod` for the `URLRequest`. `.get` by default..
    private(set) var httpMethod: HTTPMethod = .get
    
    /// `Param` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default..
    private(set) var param: [String: Any]?
    
         
    // MARK: - Initializer
    
    /// Set param
    ///
    /// - Parameter sessionManager: `Session` creates and manages Alamofire's `Request` types during their lifetimes.
    /// - Returns: Self
    public func setSessionManager(_ sessionManager: Session) -> Self {
        self.sessionManager = sessionManager
        return self
    }
    
    /// Set param
    ///
    /// - Parameter headers: a dictionary of parameters to apply to a `HTTPHeaders`.
    /// - Returns: Self
    public func setHeaders(_ headers: [String: String]) -> Self {
        for param in headers {
            self.headers[param.key] = param.value
        }
        return self
    }
    
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
    
    
    /// The parameter encoding. `URLEncoding.default` by default.
    private func encoding(_ httpMethod: HTTPMethod) -> ParameterEncoding {
        var encoding : ParameterEncoding = JSONEncoding.default
        if httpMethod == .get {
            encoding = URLEncoding.default
        }
        return encoding
    }
    
    /// Subscription for `observer` that can be used to cancel production of sequence elements and free resources.
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer : ObserverType, Element == Observer.Element {
                
        let url = apiUrl!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        /// Creates a `DataRequest` from a `URLRequest`.
        /// Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
        let task = sessionManager.request(url,
                                        method: httpMethod,
                                        parameters: param,
                                        encoding: encoding(httpMethod),
                                        headers: headers)
            .responseJSON { (response) in
     
                if response.response?.statusCode == RRHTTPStatusCode.unauthorized.rawValue {
                    observer.onError(RRError.unauthorized)
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
