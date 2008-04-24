module Posy
  mattr_accessor :configuration_file
  @@configuration_file = File.join(RAILS_ROOT, 'config', 'access_control.yml')

  @@configuration = nil
  def self.configuration
    if @@configuration.nil? and File.exist?(@@configuration_file)
      @@configuration = YAML.load(ERB.new(IO.read(configuration_file)).result)
    end
    @@configuration ||= {}
  end

  def self.controllers
    configuration['controllers'] || []
  end

  def self.models
    configuration['models'] || []
  end

  def self.model_name_methods
    configuration['model_name_methods'] || {}
  end

  def self.name_method_for(model)
    model_name_methods[model.to_s.classify] || model_name_methods['default'] || 'name'
  end
end
