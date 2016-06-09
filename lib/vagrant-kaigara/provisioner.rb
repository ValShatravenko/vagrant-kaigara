module VagrantPlugins
  module Kaigara
    class Provisioner < Vagrant.plugin(2, :provisioner)
      def provision
        puts "Installing RVM..."
        script = %{apt-get install curl
echo 'export rvm_prefix="$HOME"' > /root/.rvmrc
echo 'export rvm_path="$HOME/.rvm"' >> /root/.rvmrc
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -L get.rvm.io |rvm_path=/opt/rvm bash -s stable
rvm use --install --default 2.3.0}
        script.each_line do |l|
          @machine.communicate.sudo(l)
        end
        puts "Installing Kaigara..."
        @machine.communicate.sudo("gem install kaigara")
        puts "Provisioning..."
        @machine.communicate.sudo("cd /vagrant && kaish sysops exec")
      end
    end
  end
end
