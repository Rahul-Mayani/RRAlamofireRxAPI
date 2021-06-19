# RRAlamofireRxAPI

[![Cocoa Pod](https://img.shields.io/badge/Cocoapods-blue.svg?style=flat)](https://cocoapods.org/)
[![Version](https://img.shields.io/badge/Version-0.1.0-orange.svg?style=flat)](https://cocoapods.org/pods/RRAlamofireRxAPI)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Rahul-Mayani/RRAlamofireRxAPI/blob/master/LICENSE)
[![iOS](https://img.shields.io/badge/Platform-iOS-purpel.svg?style=flat)](https://developer.apple.com/ios/)

[![SPM](https://img.shields.io/badge/SPM-orange.svg?style=flat)](https://swift.org/package-manager/)

[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)


Alamofire API Request by RxSwift

## Requirements

pod 'RxCocoa'

pod 'RxSwift'

pod 'Alamofire'

## Installation

#### Manually
1. Download and drop `Source` folder with files in your project.
2. Add your API end point URL in your project.
3. Congratulations!  

#### Pod
RRAlamofireRxAPI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RRAlamofireRxAPI', '~> 2.0.0'
```

#### SPM (Swift Package Manager)
In Xcode, use the menu File > Swift Packages > Add Package Dependency... and enter the package URL `https://github.com/Rahul-Mayani/RRAlamofireRxAPI`.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage example
To run the example project, clone the repo, and run pod install from the Example directory first.


```swift

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

```

## Contribute 

We would love you for the contribution to **RRAlamofireRxAPI**, check the ``LICENSE`` file for more info.


## License

RRAlamofireRxAPI is available under the MIT license. See the LICENSE file for more info.
