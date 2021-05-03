Pod::Spec.new do |s|
  s.name             = 'RRAlamofireRxAPI'
  s.version          = '1.0.0'
  s.summary          = 'Elegant rest HTTP Networking request in Swift'
  s.homepage         = 'https://github.com/Rahul-Mayani/RRAlamofireRxAPI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rahul Mayani' => 'mayani.rahul@gmail.com' }
  s.source           = { :git => 'https://github.com/Rahul-Mayani/RRAlamofireRxAPI.git', :branch => "master", :tag => s.version.to_s }

  s.cocoapods_version = '>= 1.10.1'
  s.ios.deployment_target = '12.0'
  s.swift_versions = ['5.1', '5.2', '5.3']
  
  s.static_framework = true
  s.dependency 'RxSwift', '~> 6.0.0'
  s.dependency 'RxRelay', '~> 6.0.0'
  s.dependency 'RxCocoa', '~> 6.0.0'
  s.dependency 'Alamofire', '~> 4.9.1'
  
  s.source_files = 'Sources/RRAlamofireRxAPI/*.swift'
end
