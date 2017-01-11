module VagrantPlugins
  module Kaigara
    class Provisioner < Vagrant.plugin(2, :provisioner)
      def initialize(machine, opts)
        @machine = machine
      end

      def provision
        # if ruby_installed?
        #          @machine.ui.info('Ruby is already installed')
        #        else
        #          @machine.ui.info("Installing Ruby...")
        #        end

        if kaigara_installed?
          @machine.ui.info('Kaigara is already installed')
        else
          @machine.ui.info('Installing Kaigara...')
          action('export KAIGARA_VERSION=v0.0.4')
          @machine.ui.info('Downloading...')
          action('wget --quiet https://github.com/mod/kaigara/releases/download/$KAIGARA_VERSION/kaigara-linux-amd64-$KAIGARA_VERSION.tar.gz')
          @machine.ui.info('Unpacking...')
          action('sudo tar -C /usr/local/bin -xzf kaigara-linux-amd64-$KAIGARA_VERSION.tar.gz')
          @machine.ui.info('Installed successfully!')
        end

        @machine.ui.info("Provisioning...")
        # action('mkdir -p work/application/myapp')
        # action('cd work/application/myapp')
        # action('mkdir resources operations')
        # action('touch defaults.yml')
        # action('echo
        # {}"## <[ Kaigara\n
        # RUN curl -sL https://kaigara.org/get | sh\n\n

#       COPY operations   /opt/kaigara/operations\n
#        COPY resources    /etc/kaigara/resources\n
#        COPY defaults.yml /etc/kaigara/defaults.yml\n

#        ENTRYPOINT [/"kaigara/"]\n
#        CMD [/"start/", /"myapp.sh/"]\n
#        ## Kaigara ]>##"
#        >> Dockerfile
#        ')
        # if test('test -f /vagrant/metadata.rb')
        # else
        #  @machine.ui.info("No operations found")
        # end
      end

      # Execute a command at vm
      def action(command, opts = {})
        @machine.communicate.tap do |comm|
          comm.execute(command, { error_key: :ssh_bad_exit_status_muted, sudo: true }.merge(opts) ) do |type, data|
            handle_comm(type, data)
          end
        end
      end

      # Handle the command output
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

      def ruby_installed?
        test('test -d /opt/kaigara') && test('ruby -v')
      end

      def kaigara_installed?
        test('[ -d /usr/bin/kaigara ]')
      end

      def test(t)
        @machine.communicate.test(t, sudo: false)
      end
    end
  end
end
