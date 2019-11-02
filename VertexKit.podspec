Pod::Spec.new do |spec|

  spec.name         = "VertexKit"
  spec.version      = "0.3.0"

  spec.summary      = "a Framework for iOS & macOS."
  spec.description  = <<-DESC
  					a collection of live graphics tools for realtime editing.
                   DESC

  spec.homepage     = "http://pixelkit.dev"
  
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Hexagons" => "anton@hexagons.se" }
  spec.social_media_url   = "https://twitter.com/anton_hexagons"

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.13"
  
  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/hexagons/VertexKit.git", :branch => "master", :tag => "#{spec.version}" }

  spec.source_files  = "Source", "Source/**/*.swift"

  spec.ios.resources = "Resources/Metal Libs/VertexKitShaders.metallib"
  spec.osx.resources = "Resources/Metal Libs/VertexKitShaders-macOS.metallib"

  spec.dependency 'LiveValues', '~> 1.1'
  spec.dependency 'RenderKit', '~> 0.3'
  spec.dependency "PixelKit", '~> 0.8'

end
