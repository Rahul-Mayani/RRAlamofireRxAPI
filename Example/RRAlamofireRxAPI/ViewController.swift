//
//  ViewController.swift
//  RRAlamofireRxAPI
//
//  Created by Rahul Mayani on 23/12/19.
//  Copyright © 2019 RR. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RRAlamofireRxAPI

class ViewController: UIViewController {

    // MARK: - Variable -
    let rxbag = DisposeBag()
    
    // MARK: - View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let param = ["name":"test","salary":"123","age":"23"]
        RRAPIRxManager.shared.setURL("http://dummy.restapiexample.com/api/v1/create")
            .setHttpMethod(.post)
            .setParameter(param)
            .setDeferredAsObservable()
            .flatMap { (response1) -> Observable<Any> in
                return RRAPIRxManager.shared.setURL("http://dummy.restapiexample.com/api/v1/employees")
                        .setDeferredAsObservable()
            }.subscribe { (response) in
                print(response)
            } onError: { (error) in
                print(error)
            }.disposed(by: rxbag)*/
        
        /// Uses
        let createCustomSession = Session()
        let request =  RRAPIRxManager.shared
                          .setSessionManager(createCustomSession) //`Session` creates and manages Alamofire's `Request` types during their lifetimes.
                          .setHttpMethod(.get) // httpMethod: GET, POST, PUT & DELETE
                          .setURL("Your API URL")
                          .setHeaders([:]) // a dictionary of parameters to apply to a `HTTPHeaders`.
                          .setParameter([:]) // a dictionary of parameters to apply to a `URLRequest`.

        request.setDeferredAsObservable()
            .subscribeConcurrentBackgroundToMainThreads()
            .subscribe { (response) in
                /// The response of data type is Data.
                /// <#T##Here: decode JSON Data into your custom model structure / class#>
                print(response)
            } onError: { (error) in
                print(error.localizedDescription)
            }.disposed(by: rxbag)
            

        /// Example 1
        /// Loader start
        let userIds = [1, 2, 3]
        Observable.from(userIds)
            .flatMap { (userId) -> Observable<Any> in
                return RRAPIRxManager.shared.setURL("https://jsonplaceholder.typicode.com/users/\(userId)")
                        .setDeferredAsObservable()
            }
            .toArray() // collecting all users object data
            .asObservable()
            .subscribeConcurrentBackgroundToMainThreads()
            .subscribe { (response) in
                print("Got users:")
                /// Loader stop
            } onError: { (error) in
                print(error)
            }.disposed(by: rxbag)

        /// Example 2
        /// Loader start
        RRAPIRxManager.shared.setURL("https://jsonplaceholder.typicode.com/users/1")
            .flatMap { response -> Observable<Any> in
                guard let data = response as? [String:Any] else { return Observable.empty() }
                print(data["username"] ?? "")
                return RRAPIRxManager.shared.setURL("https://jsonplaceholder.typicode.com/users/2")
                        //.delaySubscribeConcurrentBackgroundToMainThreads(.milliseconds(200))
                        .setDeferredAsObservable()
            }
            .subscribeConcurrentBackgroundToMainThreads()
            .subscribe { (response) in
                guard let data = response as? [String:Any] else { return }
                print(data["username"] ?? "")
                /// Loader stop
            } onError: { (error) in
                print(error)
            }.disposed(by: rxbag)
    }
}

