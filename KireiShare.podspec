#
#  Be sure to run `pod spec lint KireiShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "KireiShare"
    s.version      = "0.0.1"
    s.summary      = "Modal view for sharing action."
    spec.homepage  = "https://github.com/entotsu/KireiShare"
    s.license      = "MIT"
    spec.authors   = "Takuya Okamoto"
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/entotsu/KireiShare.git", :tag => "0.0.1" }
    s.source_files = "Classes", "Classes/**/*.{h,m, swift}"
end
