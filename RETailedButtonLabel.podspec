#
# Be sure to run `pod lib lint RETailedButtonLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RETailedButtonLabel'
  s.version          = '0.3.0'
  s.summary          = 'Label and button that follow the tail of the label.'
  s.homepage         = 'https://github.com/roceun/RETailedButtonLabel'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'roceun' => 'roceun@gmail.com' }
  s.source           = { :git => 'https://github.com/roceun/RETailedButtonLabel.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'RETailedButtonLabel/Classes/**/*'
end
