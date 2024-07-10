Pod::Spec.new do |s|
  s.name             = 'tinkoff_sdk'
  s.version          = '0.5.1'
  s.summary          = 'Flutter TinkoffSDK plugin'
  s.description      = 'TinkoffSDK Flutter implementation'
  s.homepage         = 'https://pmobi.tech'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Progressive Mobile' => 'd.mamnitskiy@pmobi.tech' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.static_framework = true
  s.dependency 'TASDKCore', '6.0.0'
  s.dependency 'TASDKUI', '5.0.0'
  s.dependency 'TASDKYandexPay', '4.0.0'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
