require 'puppet/face'
require 'puppet/module/tool'
require 'puppet/face/module/helper'

Puppet::Face.define(:module, '0.0.1') do
  copyright "Puppet Labs", 2011
  license   "Apache 2 license; see COPYING"
  summary "Provides functionality for managing puppet modules"
 # 
  action :version do
    summary "shows the current version of module"
    when_invoked do
      Puppet::Module::Tool.version
    end
  end

  # we cannot set a default
#
  action :generate do
    summary 'generate boilerplate for a new module'
    description "generate USERNAME-MODNAME: Generate boilerplate for a new module"
    description <<-EOT
      Generate a module
      -----------------

      Generating a new module produces a new directory prepopulated with a
      directory structure and files recommended for Puppet best practices.

      For example, generate a new module:

          puppet module generate myuser-mymodule

      The above command will create a new *module directory* called
      `myuser-mymodule` under your current directory with the generated files.
    EOT
    option '--puppet_module_repository repo', '-r repo' do
      summary 'Module repo to use'
    end
    when_invoked do |name, options|
      Puppet::Module::Tool::Applications::Generator.run(name, options)
    end
  end

  # TODO Review whether the 'freeze' feature should be fixed or deleted.
#  desc "freeze", "Freeze the module skeleton (to customize for `generate`)"
#  def freeze
#    Puppet::Module::Tool::Applications::Freezer.run(options)
#  end

  action :clean do
    summary "Clears module cache for all repositories"
    description <<-EOT
      Cleaning the cache
      ------------------

      Modules that you install are saved to a cache within your `~/.puppet`
      directory. This cache can be cleaned out by running:

      puppet module clean

    EOT
    when_invoked do |options|
      Puppet::Module::Tool::Applications::Cleaner.run(options)
    end
  end

  action :build do
    summary "Build a module for release"
    examples "build [PATH_TO_MODULE]"
    when_invoked do |options|
      Puppet::Module::Tool::Applications::Builder.run(Puppet::Face::Module::Helper.find_module_root(path), options)
    end
  end

  # TODO Review whether the 'release' feature should be fixed or deleted.
#  desc "release FILENAME", "Release a module tarball (.tar.gz)"
#  method_option_repository
#  def release(filename)
#    Puppet::Module::Tool::Applications::Releaser.run(filename, options)
#  end

  # TODO Review whether the 'unrelease' feature should be fixed or deleted.
#  desc "unrelease MODULE_NAME", "Unrelease a module (eg, 'user-modname')"
#  method_option :version, :alias => :v, :required => true, :desc => "The version to unrelease"
#  method_option_repository
#  def unrelease(module_name)
#    Puppet::Module::Tool::Applications::Unreleaser.run(module_name,
#                                                       options)
#  end

#  method_option_repository
  action :install do
    option '--version version', '-v version' do
      summary "Version to install (can be a requirement, eg '>= 1.0.3', defaults to latest version)"
    end
    description <<-EOT
      Install a module release------------------------

      Installing a module release from a repository downloads a special
      archive file. This archive is then automatically unpacked into a new
      directory under your current directory. You can then add this *module
      directory* to your Puppet configuration files to use it.

      For example, install the latest release of the module named `mymodule`
      written by `myuser` from the default repository:

          puppet module install myuser-mymodule

      Or install a specific version:

          puppet module install myuser-mymodule --version=0.0.1

    EOT
    option '--puppet_module_repository repo', '-r repo' do
      summary 'Module repo to use'
    end
    option '--force', '-f' do
      summary "Force overwrite of existing module, if any"
    end
    when_invoked do |name, options|
      summary "Install a module (eg, 'user-modname') from a repository or file"
      examples "puppet module install MODULE_NAME_OR_FILE [OPTIONS]"
      Puppet::Module::Tool::Applications::Installer.run(name, options)
    end
  end
  
  action :search do
    summary "Search the module repository for a module matching TERM"
    examples "puppet module search TERM"
    description <<-EOT
      Search for modules
      ------------------

      Searching displays modules on the repository that match your query.

      For example, search the default repository for modules whose names
      include the substring `mymodule`:

          puppet module search mymodule

    EOT
    option '--puppet_module_repository repo', '-r repo' do
      summary 'Module repo to use'
    end
    when_invoked do |term, options|
      Puppet::Module::Tool::Applications::Searcher.run(term, options)
    end
  end

  # TODO Review whether the 'register' feature should be fixed or deleted.
  action :register do
    summary 'Register a new module (eg, "user-modname")'
    examples 'puppet module register MODULE_NAME'
    when_invoked do |module_name, options|
      Puppet::Module::Tool::Applications::Registrar.run(module_name, options)
    end
  end

  action :changes do
    when_invoked do |path, options|
      summary "Show modified files in an installed module"
      examples "puppet module changes [PATH_TO_MODULE]"
      Puppet::Module::Tool::Applications::Checksummer.run(find_module_root(path), options)
    end
  end

  action :repository do
    examples 'puppet module summary'
    summary 'Show currently configured repository'
    when_invoked do |options|
      Puppet::Module::Tool.prepare_settings(options)
      Puppet.settings[:puppet_module_repository]
    end
  end

  action :changelog do
    summary 'Display the changelog for this tool'
    when_invoked do |options|
      Puppet::Module::Tool.prepare_settings(options)
      if ENV['PAGER']
        exec ENV['PAGER'], Puppet::Module::Tool.changelog_filename
      else
        puts File.read(Puppet::Module::Tool.changelog_filename)
      end
    end
  end

  description <<-EOT

Search for modules
------------------

Searching displays modules on the repository that match your query.

For example, search the default repository for modules whose names
include the substring `mymodule`:

    puppet-module search mymodule

Install a module release
------------------------

Installing a module release from a repository downloads a special
archive file. This archive is then automatically unpacked into a new
directory under your current directory. You can then add this *module
directory* to your Puppet configuration files to use it.

For example, install the latest release of the module named `mymodule`
written by `myuser` from the default repository:

    puppet-module install myuser-mymodule

Or install a specific version:

    puppet-module install myuser-mymodule --version=0.0.1

Generate a module
-----------------

Generating a new module produces a new directory prepopulated with a
directory structure and files recommended for Puppet best practices.

For example, generate a new module:

    puppet-module generate myuser-mymodule

The above command will create a new *module directory* called
`myuser-mymodule` under your current directory with the generated files.

Please read the files in this generated directory for further details.

Build a module release
----------------------

Building a module release processes the files in your module directory
and produces a special archive file that you can share or install.

For example, build a module release from within the module directory:

    puppet-module build

The above command will report where it created the module release
archive file.

For example, if this was version `0.0.1` of `myuser-mymodule`, then this
would have created a `pkg/myuser-mymodule-0.0.1.tar.gz` release file.

The build process reads a `Modulefile` in your module directory and uses
its contents to build a `metadata.json` file. This generated JSON file
is included in the module release archive so that repositories and
installers can extract details from your release. Do **not** edit this
`metadata.json` file yourself, because it's clobbered each time during
the build process -- you should make all your changes to the
`Modulefile` instead.

All the files in the `pkg` directory of your module directory are
artifacts of the build process. You can delete them when you're done.

Write a valid `Modulefile`
--------------------------

The Modulefile resembles a configuration or data file, but is actually a Ruby domain-specific language (DSL), which means it's evaluated as code by the puppet-module tool. A Modulefile consists of a series of method calls which write or append to the available fields in the metadata object.

Normal rules of Ruby syntax apply:

    name 'myuser-mymodule'
    version '0.0.1'
    dependency( 'otheruser-othermodule', '1.2.3' )
    description "This is a full description
        of the module, and is being written as a multi-line string."

The following metadata fields/methods are available:

* `name` -- The full name of the module (e.g. "username-module").
* `version` -- The current version of the module.
* `dependency` -- A module that this module depends on. Unlike the other fields, the `dependency` method accepts up to three arguments: a module name, a version requirement, and a repository. A Modulefile may include multiple `dependency` lines.
* `source` -- The module's source. The use of this field is not specified.
* `author` -- The module's author. If not specified, this field will default to the username portion of the module's `name` field.
* `license` -- The license under which the module is made available.
* `summary` -- One-line description of the module.
* `description` -- Complete description of the module.
* `project_page` -- The module's website.

Share a module
--------------

Sharing a module release with others helps others avoid reinventing the
wheel, and encourages them to help with your work by improving it. For
every module you share, we hope you'll find many modules by others that
will be useful to you.

You can share your modules at http://forge.puppetlabs.com/

Building and sharing a new module version
-----------------------------------------

To build and share a new module version:

1. Edit the `Modulefile` and increase the `version` number.
2. Run the `puppet-module build` as explained in the *Build a module release* section.
3. Upload the new release file as explained in the *Share a module* section.

Cleaning the cache
------------------

Modules that you install are saved to a cache within your `~/.puppet`
directory. This cache can be cleaned out by running:

    puppet-module clean

Deleting a module
-----------------

The tool does not keep track of what modules you have installed. TO delete a
module just delete the directory the module was extracted into.

  EOT
end
