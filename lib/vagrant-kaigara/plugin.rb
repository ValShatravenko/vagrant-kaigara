module VagrantPlugins
  module Kaigara
    class Plugin < Vagrant.plugin(2)
      name 'vagrant-kaigara'

      description "Provision VM with Kaigara."

      provisioner :kaigara do
        require_relative 'provisioner'
        Provisioner
      end

    end
  end
end
