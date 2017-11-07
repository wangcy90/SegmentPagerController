Pod::Spec.new do |s|
  s.name             = 'SegmentPagerController'
  s.version          = '1.0.0'
  s.summary          = '分页滚动视图控制器'
  s.homepage         = 'https://github.com/wangcy90/SegmentPagerController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WangChongyang' => 'chongyangfly@163.com' }
  s.source           = { :git => 'https://github.com/wangcy90/SegmentPagerController.git', :tag => s.version }
  s.requires_arc = true
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.framework  = "UIKit"
  s.source_files = 'SegmentPagerController/**/*'
  s.dependency 'HMSegmentedControl', '~> 1.5.4'
end
