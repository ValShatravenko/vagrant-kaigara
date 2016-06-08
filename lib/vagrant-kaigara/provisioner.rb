module VagrantPlugins
  module Kaigara
    class Provisioner < Vagrant.plugin(2, :provisioner)
      def provision
        puts "Installing RVM..."
        script = %{sudo apt-get install curl
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -sSL https://get.rvm.io | bash -s stable --ruby
echo "source $HOME/.rvm/scripts/rvm" | sudo tee /etc/profile.d/rvm.sh
. /etc/profile && rvm rvmrc warning ignore allGemfiles
. /etc/profile && . $HOME/.rvm/scripts/rvm && rvm use --default --install 2.3.0}
        script.each_line do |l|
          @machine.communicate.test(l)
        end
        puts "Installing Kaigara..."
        @machine.communicate.test("gem install kaigara")
      end
    end
  end
end
