### Implicit target definition :-/
source 'https://github.com/CocoaPods/Specs.git'
xcodeproj "iBiergarten.xcodeproj"
inhibit_all_warnings!
####

workspace 'iBiergarten.xcworkspace'

platform :ios, '8.0'
#pod 'AFNetworking'
pod 'Google-Maps-iOS-SDK'
pod 'BiergartenFetcher', :path => '/Users/platzerworld/cocoapodsrepo/BiergartenFetcher/0.0.1'

link_with 'iBiergarten', 'iBiergartenTests'

target :iBiergartenTests do
    pod 'Kiwi'
end
