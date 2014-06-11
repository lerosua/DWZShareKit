Pod::Spec.new do |s|
  s.name         = "DWZShareKit"
  s.version      = "1.0.0"
  s.summary      = "DWZShareKit"

  s.homepage     = "https://github.com/lerosua/DWZShareKit.git"
  s.license      = {
       :type => 'Copyright', 
       :text => 'LICENSE  ©2014 cyclone, Inc. All rights reserved.' 
    }
  s.author             = { "lerosua" => "lerosua@gmail.com" }
  s.platform     = :ios

  s.source       = { :git => "https://github.com/lerosua/DWZShareKit.git" }

  s.source_files  = "DWZShareSDKDemo/DWZShareSDKDemo/Core","DWZShareSDKDemo/DWZShareSDKDemo/Core/*.{h,m}","DWZShareSDKDemo/DWZShareSDKDemo/Extend/**/*.{h,m}"
  s.libraries = "z", "sqlite3"
  s.frameworks = "CoreTelephony", "CoreGraphics"
  s.vendored_libraries = 'Extend/**/*.{a}';
  s.resource = 'Extend/**/*.{bundle}','Media.xcassets/**/*.{png}';
  s.requires_arc = true


end
