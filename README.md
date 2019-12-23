# RRAlamofireRxAPI
Alamofire API Request by RxSwift

## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'Alamofire'

## Installation

#### Manually
1. Download and drop ```RRAPIRxManager.swift``` in your project.
2. Add your API end point URL in your project.
3. Congratulations!  

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

let param = [:]
RRAPIRxManager.rxCall(apiUrl: "API URL", httpMethod: .post, param: param) // Post Request
.flatMap { (response1) -> Observable<Any> in
    print(response1)
    return RRAPIRxManager.rxCall(apiUrl: "API URL") // Get Request
}
/*.delaySubscription(.seconds(5), scheduler: RXScheduler.concurrentBackground)*/
.subscribeConcurrentBackgroundToMainThreads()
.subscribe(onNext: { response in
    print(response)
}, onError: { error in
    print(error)
}).disposed(by: rxbag)

```

## Contribute

We would love you for the contribution to **RRAlamofireRxAPI**, check the ``LICENSE`` file for more info.


## License

RRAlamofireRxAPI is available under the MIT license. See the LICENSE file for more info.
