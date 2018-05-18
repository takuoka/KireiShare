#
#  Be sure to run `pod spec lint KireiShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "KireiShare"
    s.version      = "0.0.2"
    s.summary      = "Modal view for sharing action."
    s.homepage     = "https://github.com/entotsu/KireiShare"
    s.license      = "MIT"
    s.authors      = "Takuya Okamoto"
    s.platform     = :ios, "8.0"
    s.source       = { :git => "https://github.com/entotsu/KireiShare.git", :tag => "0.0.1" }
    s.source_files = "KireiShare/Classes", "KireiShare/Classes/Supporting Files", "KireiShare/Classes/Assets.xcassets", "KireiShare/Classes/**/*.{h,m, swift}"
    s.swift_version = "4.0"
end
