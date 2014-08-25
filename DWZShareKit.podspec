Pod::Spec.new do |s|
  s.name         = "DWZShareKit"
  s.version      = "1.2.4"
  s.summary      = "DWZShareKit"

  s.homepage     = "https://github.com/lerosua/DWZShareKit.git"
  s.license      = "MIT"
  s.author             = { "lerosua" => "lerosua@gmail.com" }
  s.platform     = :ios, '5.0'


  s.source       = { :git => "https://github.com/lerosua/DWZShareKit.git", :tag => "1.2.4" }

  s.source_files  = "DWZShareSDKDemo/DWZShareSDKDemo/Core","DWZShareSDKDemo/DWZShareSDKDemo/Core/*.{h,m}","DWZShareSDKDemo/DWZShareSDKDemo/Extend/**/*.{h,m}"
  s.libraries = "z", "sqlite3"
  s.frameworks = "CoreTelephony", "CoreGraphics","SystemConfiguration"
  s.vendored_libraries = 'DWZShareSDKDemo/DWZShareSDKDemo/Extend/**/*.{a}';
  s.resource = 'DWZShareSDKDemo/DWZShareSDKDemo/Extend/**/*.{bundle}','DWZShareSDKDemo/DWZShareSDKDemo/Media.xcassets/**/*.{png}';
  s.requires_arc = true


end
