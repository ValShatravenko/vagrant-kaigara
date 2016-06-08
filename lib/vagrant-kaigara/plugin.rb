module VagrantPlugins
  module Kaigara
    class Plugin < Vagrant.plugin(2)
      name 'vagrant-kaigara'

      description "Provision VM with Kaigara."

      command :kaigara do
        require_relative 'command'
        Command
      end

    end
  end
end
