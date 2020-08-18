Pod::Spec.new do |s|
  s.name             = 'tinkoff_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter TinkoffSDK plugin'
  s.description      = 'TinkoffSDK Flutter implementation'
  s.homepage         = 'https://pmobi.tech'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Progressive Mobile' => 'd.mamnitskiy@pmobi.tech' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TinkoffASDKCore', '2.0.2'
  s.dependency 'TinkoffASDKUI', '2.0.2'
  s.platform = :ios, '11.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
