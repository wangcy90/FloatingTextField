Pod::Spec.new do |s|
  s.name             = 'FloatingTextField'
  s.version          = '1.0.0'
  s.summary          = '仿安卓TextInputLayout效果的TextField.'
  s.homepage         = 'https://github.com/wangcy90/FloatingTextField'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WangChongyang' => 'chongyangfly@163.com' }
  s.source           = { :git => 'https://github.com/wangcy90/FloatingTextField.git', :tag => s.version }
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.framework  = "UIKit"
  s.source_files = 'FloatingTextField/**/*'
end
