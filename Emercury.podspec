Pod::Spec.new do |s|
  s.name             = 'Emercury'
  s.version          = '0.1.0'
  s.summary          = 'A Swift package for Emercury functionality.'
  s.description      = <<-DESC
      A Swift package for Emercury functionality.
  DESC

  s.homepage         = 'https://github.com/resoul/Emercury'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Emercury' => 'you@example.com' }
  s.source           = { :git => 'https://github.com/resoul/Emercury.git', :tag => s.version.to_s }

  s.ios.deployment_target  = '13.0'
  s.macos.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'

  s.source_files = 'Sources/Emercury/**/*.swift'
end
