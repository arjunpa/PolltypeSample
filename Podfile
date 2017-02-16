source 'git@github.com:CocoaPods/Specs.git'
#source "https://github.com/CocoaPods/Old-Specs"



platform :ios, '9.3'
use_frameworks!
inhibit_all_warnings!

project 'PollSample'


target 'PollSample' do
	pod 'DFImageManager',:git => 'https://github.com/arjunpa/DFImageManager.git', :commit => '8e64a7a'
	pod 'DFImageManager/AFNetworking' ,:git => 'https://github.com/arjunpa/DFImageManager.git', :commit => '8e64a7a'
	pod 'DFImageManager/GIF',:git => 'https://github.com/arjunpa/DFImageManager.git', :commit => '8e64a7a'
	pod 'DFImageManager/WebP' ,:git => 'https://github.com/arjunpa/DFImageManager.git', :commit => '8e64a7a'
end

post_install do |installer| 
  installer.pods_project.targets.each  do |target| 
      target.build_configurations.each  do |config| config.build_settings['SWIFT_VERSION'] = '3.0' 
      end 
   end 
end