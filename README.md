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

let param = [:]
RRAPIRxManager.shared.setURL("API URL") // Post Request
    .setHttpMethod(.post)
    .setParameter(param)
    .setDeferredAsObservable()
    .flatMap { (response1) -> Observable<Any> in
        return RRAPIRxManager.shared.setURL("API URL") // Get Request
                .setDeferredAsObservable()
    }.subscribe { (response) in
        print(response)
    } onError: { (error) in
        print(error)
    }.disposed(by: rxbag)

```

## Contribute 

We would love you for the contribution to **RRAlamofireRxAPI**, check the ``LICENSE`` file for more info.


## License

RRAlamofireRxAPI is available under the MIT license. See the LICENSE file for more info.
