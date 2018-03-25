#
# Be sure to run `pod lib lint AliyunContentDetect.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AliyunContentDetect'
  s.version          = '0.1.0'
  s.summary          = 'aliyun content detect service'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '阿里云内容安全服务SDK，包括图片鉴黄服务，图片涉政识别，OCR图文识别，图片广告识别，视频涉黄、涉政等检测.'

  s.homepage         = 'https://github.com/bluemap/AliyunContentDetect'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lijin' => 'bluemap@163.com' }
  s.source           = { :git => 'https://github.com/bluemap/AliyunContentDetect.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AliyunContentDetect/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AliyunContentDetect' => ['AliyunContentDetect/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'AFNetworking','~> 3.2.0'
s.dependency 'Base64nl', '~> 1.2'
s.dependency 'NSString-Hash'
s.dependency 'NSString-UrlEncode'
s.dependency 'CocoaSecurity'

end
