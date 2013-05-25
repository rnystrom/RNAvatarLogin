#
# Be sure to run `pod spec lint RNAvatarLogin.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "RNAvatarLogin"
  s.version      = "0.0.1"
  s.summary      = "A simple way to autocomplete Gravatar icons for text fields."
  s.description  = <<-DESC
This project was entirely inspired by the beautiful GoSquared Login. It is a really unique and peculiar way to "entertain" the user while a task completes. Using a Gravatar fulfills purposes in a login: it lets the user validate that they have entered their email, and it also provides a more personal experience by welcoming the user to see their account.
                   DESC
  s.homepage     = "https://github.com/rnystrom/RNAvatarLogin"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ryan Nystrom" => "rnystrom@whoisryannystrom.com" }
  s.source       = { :git => "https://github.com/rnystrom/RNAvatarLogin.git", :commit => '23a5f91a5d7cd91397818bd5cdb568ff802cb03f' }
  s.platform     = :ios, '6.0'
  s.source_files = 'RNAvatarLogin.{h,m}'
  s.framework  = 'QuartzCore'
  s.requires_arc = true
end
