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
        
        let param = ["name":"test","salary":"123","age":"23"]
        RRAPIRxManager.rxCall(apiUrl: "http://dummy.restapiexample.com/api/v1/create", httpMethod: .post, param: param)
        .flatMap { (response1) -> Observable<Any> in
            print(response1)
            return RRAPIRxManager.rxCall(apiUrl: "http://dummy.restapiexample.com/api/v1/employees")
        }
        /*.delaySubscription(.seconds(5), scheduler: RXScheduler.concurrentBackground)*/
        .subscribeConcurrentBackgroundToMainThreads()
        .subscribe(onNext: { response in
            print(response)
        }, onError: { error in
            print(error)
        }).disposed(by: rxbag)
    }
}

