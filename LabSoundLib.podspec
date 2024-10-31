Pod::Spec.new do |spec|
  spec.name          = 'LabSoundLib'
  spec.version       = '0.0.1'
  spec.summary       = 'LabSoundLib'
  spec.description   = 'LabSound framework and dependent libraries for iOS'
  spec.homepage      = 'https://github.com/eliottparis/LabSoundLib'
  spec.author        = { 'Eliott Paris' => 'eliottparis@gmail.com' }
  spec.license       = { :type => 'BSD', :file => 'LICENSE' }
  spec.source        = { :git => 'https://github.com/eliottparis/LabSoundLib.git', :tag => spec.version.to_s }

  spec.swift_version = '5.0'
  spec.ios.deployment_target = '13.0'

  spec.ios.frameworks = "Foundation", "AVFoundation", "AudioToolbox", "Accelerate"

  spec.ios.vendored_frameworks = [
    "Frameworks/LabSound.xcframework",
    "Frameworks/LabSoundMiniAudio.xcframework",
    "Frameworks/labnyquist.xcframework",
  ]
end
