
Pod::Spec.new do |s|
  s.name         = "yuntui-ios-sdk"
  s.version      = "0.0.1"
  s.summary      = "yuntui ios sdk"
  s.homepage     = "https://github.com/ctofunds/yuntui-ios-sdk"
  s.license      = "MIT"
  s.author       = { "ltebean" => "yucong1118@gmail.com" }
  s.source       = { :git => "https://github.com/ctofunds/yuntui-ios-sdk.git", :tag => s.version}
  s.source_files = "yuntui-ios-sdk/lib/*.swift"
  s.requires_arc = true
  s.platform     = :ios, '10.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.swift_version = '4.0'
end
