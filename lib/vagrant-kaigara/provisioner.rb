module VagrantPlugins
  module Kaigara
    class Provisioner < Vagrant.plugin(2, :provisioner)
      def initialize(machine, opts)
        @machine = machine
      end

      def provision
        if ruby_installed?
          @machine.ui.info("Ruby is already installed")
        else
          @machine.ui.info("Installing Ruby...")
          @machine.ui.info("curl http://mirror.kaigara.org/scripts/kairb.sh | bash /dev/stdin")
        end

        if kaigara_installed?
          @machine.ui.info("Kaigara is already installed")
        else
          @machine.ui.info("Installing Kaigara...")
          action("gem install kaigara")
        end

        @machine.ui.info("Provisioning...")
        action("cd /vagrant && kaish sysops exec")
      end

      # Execute a command at vm
      def action(command, opts = {})
        @machine.communicate.tap do |comm|
          comm.execute(command, { error_key: :ssh_bad_exit_status_muted, sudo: true }.merge(opts) ) do |type, data|
            Thread.new do
              handle_comm(type, data)
            end
          end
        end
      end

      # Handle the comand output
      def handle_comm(type, data)
        if [:stderr, :stdout].include?(type)
          color = type == :stdout ? :green : :red

          data = data.chomp
          return if data.empty?

          options = {}
          options[:color] = color

          Thread.new do
            @machine.ui.info(data.chomp.strip, options) if data.chomp.length > 1
          end
        end
      end

      def ruby_installed?
        @machine.communicate.test('ruby -v', sudo: true)
      end

      def kaigara_installed?
        @machine.communicate.test('kaish', sudo: true)
      end
    end
  end
end
