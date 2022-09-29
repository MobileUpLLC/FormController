Pod::Spec.new do |spec|

  spec.name         = "FormController"
  spec.version      = "1.0.0"
  spec.summary      = "Controller for manage and validate screen with forms"
  spec.description  = "Manage and validate your interactive forms only with controller and view"
  spec.homepage     = "https://github.com/MobileUpLLC/FormController"

  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "MobileUp iOS Team" => "hello@mobileup.ru" }

  spec.platform     = :ios, "12.0"
  spec.ios.frameworks = 'UIKit'
  spec.swift_version = ['5']
  
  spec.source = { :git => 'https://github.com/MobileUpLLC/FormController.git', :tag => spec.version.to_s }
  spec.source_files  = "Sources/", "Sources/**/*.{swift}"
end
