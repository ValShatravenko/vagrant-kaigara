module VagrantPlugins
  module Kaigara
    class Provisioner < Vagrant.plugin(2, :provisioner)
      def initialize(machine, opts)
        @machine = machine
      end

      def provision
        if rvm_installed?
          @machine.ui.info("RVM is already installed")
        else
          @machine.ui.info("Installing RVM...")

          install_rvm = %{
            gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
            curl -L get.rvm.io | sudo bash -s stable
            rvm use --default --install ruby-2.3
            gpasswd -a vagrant rvm
          }

          install_rvm.strip.each_line do |l|
            @machine.ui.info(l.strip)
            action(l)
          end
        end

        if kaigara_installed?
          @machine.ui.info("Kaigara is already installed")
        else
          @machine.ui.info("Installing Kaigara...")
          action("gem install kaigara")
        end

        @machine.ui.info("Provisioning...")
        action("cd /vagrant && kaish sysops exec")

        action("echo 'source /etc/profile' >> /root/.bashrc")
      end

      # Execute a command at vm
      def action(command, opts = {})
        @machine.communicate.tap do |comm|
          comm.execute(command, { error_key: :ssh_bad_exit_status_muted, sudo: true }.merge(opts) ) do |type, data|
            handle_comm(type, data)
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

          @machine.ui.info(data.chomp.strip, options) if data.chomp.length > 1
        end
      end

      def rvm_installed?
        @machine.communicate.test('rvm', sudo: true)
      end

      def kaigara_installed?
        @machine.communicate.test('kaish', sudo: true)
      end
    end
  end
end
