Pod::Spec.new do |s|
  s.name         = "CBStoreHouseRefreshControl"
  s.version      = "1.0"
  s.summary      = "Fully customizable pull-to-refresh control inspired by Storehouse iOS app"
  s.description  = <<-DESC
                   A fully customizable pull-to-refresh control for iOS inspired by Storehouse iOS app. 
			You can use any shape through a plist file.
                   DESC
  s.homepage     = "https://github.com/coolbeet/CBStoreHouseRefreshControl"
  s.screenshots  = "https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl1.gif", "https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl2.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Suyu Zhang" => "suyu_zhang@hotmail.com" }
  s.source       = { :git => "https://github.com/coolbeet/CBStoreHouseRefreshControl.git", :tag => "1.0" }
  s.social_media_url = "http://twitter.com/coolbeet11"
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Class'
end
