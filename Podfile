# Uncomment this line to define a global platform for your project
platform :ios, "7.0"

target "VirtualQ" do
  pod 'AFNetworking', '2.2.1'
  pod 'MagicalRecord', '2.2'
end

class Pod::Podfile
  def self.MR_preprocessor_definitions(installer)
    target = installer.project.targets.find{|t| t.to_s == "Pods-VirtualQ-MagicalRecord"}
    target.build_configurations.each do |config|
      s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
      s = [ '$(inherited)' ] if s == nil;
      s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0') if config.to_s == "Debug";
      s.push('MR_SHORTHAND');
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
    end
  end
end

post_install do |installer|
  Pod::Podfile::MR_preprocessor_definitions(installer)
end

