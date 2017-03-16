Pod::Spec.new do |s|
  s.name             = 'LikeAnimation'
  s.version          = '0.1.0'
  s.summary          = 'Beautifule heart beating animation for iOS written in Swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Customizable like animation aka heart beating written in Swift.
                       DESC

  s.homepage         = 'https://github.com/anatoliyv/LikeAnimation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anatoliy Voropay' => 'anatoliy.voropay@gmail.com' }
  s.source           = { :git => 'https://github.com/anatoliyv/LikeAnimation.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/anatoliy_v'

  s.frameworks       = 'UIKit'
  s.ios.deployment_target = '9.0'
  s.source_files     = 'LikeAnimation/Classes/**/*'
end
