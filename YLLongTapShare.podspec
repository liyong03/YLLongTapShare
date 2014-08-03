#
#  Be sure to run `pod spec lint YLLongTapShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "YLLongTapShare"
  s.version      = "0.1"
  s.summary      = "Long tap for sharing control for iOS."
  s.description  = "Long tap for sharing control for iOS. Using Core Animation without any other 3rd libs." 

  s.homepage     = "https://github.com/liyong03/YLLongTapShare"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "liyong03" => "liyong03@gmail.com" }
  s.social_media_url   = "http://twitter.com/liyong03"
  
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/liyong03/YLLongTapShare.git", :tag => "0.1" }

  s.source_files  = "YLLongTapShareControl", "YLLongTapShareControl/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.framework  = "CoreGraphics"
  s.requires_arc = true

end
