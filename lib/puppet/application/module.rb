require 'puppet/application/face_base'

class Puppet::Application::Module < Puppet::Application::FaceBase
  should_parse_config
  run_mode :master
end
