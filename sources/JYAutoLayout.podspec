Pod::Spec.new do |s|

  s.name         = "JYAutoLayout"
  s.version      = "1.0.0"
  s.summary      = "AutoLayout一种简单封装形式"

  s.homepage     = "https://github.com/weijingyunIOS/JYAutoLayout"

  s.license      = "MIT"

  s.author             = { "魏景云" => "wei_jingyun@outlook.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/weijingyunIOS/JYAutoLayout",:branch => "master", :tag => "1.0.0" }
  s.requires_arc = true
  s.source_files  = "JYAutoLayout-Swift/JYAutoLayout/*.{swift}"

  s.framework  = "UIKit","Foundation"

end
