
Pod::Spec.new do |s|
  s.name         = "Yuntui"
  s.version      = "0.0.3"
  s.summary      = "yuntui ios sdk"
  s.homepage     = "https://github.com/ctofunds/yuntui-ios-sdk"
  s.license      = "MIT"
  s.author       = { "ltebean" => "yucong1118@gmail.com" }
  s.source       = { :git => "https://github.com/ctofunds/yuntui-ios-sdk.git", :tag => "master"}
  s.requires_arc = true
  s.platform     = :ios, '9.0'
  s.swift_version = '4.0'
  s.ios.vendored_frameworks = 'Yuntui.framework'

end
