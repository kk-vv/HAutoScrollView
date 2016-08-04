Pod::Spec.new do |s|
  s.name             = 'HAutoScrollView'
  s.version          = '1.0.0'
  s.summary          = 'HAutoScrollView'
  s.description      = <<-DESC
  循环ScrollView,支持自动滚动、支持点击事件代理回调，已处理NSTimer 销毁，处理AutoLayout 适配。
                       DESC

  s.homepage         = 'https://github.com/iFallen/HAutoScrollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiangJun.Hu' => 'hulj1204@yahoo.com' }
  s.source           = { :git => 'https://github.com/iFallen/HAutoScrollView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://ifallen.github.io'

  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'HAutoScrollView/Classes/**/*'
  s.public_header_files = 'HAutoScrollView/Classes/**/*.h'
end
