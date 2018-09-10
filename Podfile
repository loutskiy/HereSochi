# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Hyroscop' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
	pod 'Alamofire', '~> 4.7'
  # Pods for Hyroscop
pod 'OneSignal', '>= 2.6.2', '< 3.0'
pod 'RealmSwift'
    	pod 'ObjectMapper', '~> 3.0'
    	pod 'AlamofireObjectMapper'
pod "ObjectMapper+Realm"
post_install do |installer|
    		installer.pods_project.build_configurations.each do |config|
        		config.build_settings.delete('CODE_SIGNING_ALLOWED')
        		config.build_settings.delete('CODE_SIGNING_REQUIRED')
    		end
	end
end

target 'OneSignalNotificationServiceExtension' do
use_frameworks!
  pod 'OneSignal', '>= 2.6.2', '< 3.0'
end

