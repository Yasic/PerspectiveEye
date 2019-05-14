Pod::Spec.new do |s|
  s.name             = 'PerspectiveEye'
  s.version          = '0.1.0'
  s.summary          = 'A short description of PerspectiveEye.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Yasic/PerspectiveEye'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yasic' => 'yuxuan2580@gmail.com' }
  s.source           = { :git => 'https://github.com/Yasic/PerspectiveEye.git', :tag => s.version.to_s }
  s.frameworks = 'UIKit', 'Foundation', 'SceneKit'
  s.libraries = 'c++'
  s.ios.deployment_target = '8.0'
  s.prefix_header_contents = '#ifdef __OBJC__', '#import <Masonry/Masonry.h>', '#import <SceneKit/SceneKit.h>', '#import "PEYDefines.h"', '#endif'
  s.xcconfig = {
    'VALID_ARCHS' =>  'arm64 x86_64',
  }

  s.source_files = 'PerspectiveEye/Classes/**/*.{h,m,c}'
  s.public_header_files = 'PerspectiveEye/Classes/**/*.h'
  
   # s.resource_bundles = {
   #   'PerspectiveEye' => ['PerspectiveEye/Assets/*.png']
   # }

   s.dependency 'Masonry'
end
