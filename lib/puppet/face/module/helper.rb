module Puppet::Face::Module
  module Helper
    def find_module_root(path)
      for dir in [path, Dir.pwd].compact
        if File.exist?(File.join(dir, 'Modulefile'))
          return dir
        end
      end
      abort "Could not find a valid module at #{path ? path.inspect : 'current directory'}"
    end
  end  
end

