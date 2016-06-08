require "bundler"

begin
  require "vagrant"
rescue LoadError
  Bundler.require(:default, :development)
end

require "vagrant-kaigara/plugin"
require "vagrant-kaigara/version"
