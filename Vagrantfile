
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/vivid64"
  # Change this to be something relevant to your project
  config.vm.hostname = "cityscrape"

  config.vm.provision :shell, inline: "apt-get -y install --fix-missing"
  config.vm.provision :shell, inline: "apt-get -y install python"
  config.vm.provision :shell, inline: "apt-get -y install python-dev"
  config.vm.provision :shell, inline: "apt-get -y install python-setuptools"
  config.vm.provision :shell, inline: "apt-get -y install python-pip"
  config.vm.provision :shell, inline: "apt-get -y install zip unzip"
  config.vm.provision :shell, inline: "apt-get -y install libssl-dev"
  config.vm.provision :shell, inline: "apt-get -y install libcurl4-openssl-dev"
  config.vm.provision :shell, inline: "apt-get -y install libpq-dev"
  config.vm.provision :shell, inline: "apt-get -y install postgresql"
  config.vm.provision :shell, inline: "apt-get -y install postgresql-contrib"
  config.vm.provision :shell, inline: "sudo -i -u postgres"

  # Copy dotfiles out of host homedir when they exist
  # Do not copy things like .bashrc since there are often many lines of code there that do not run
  # May cause problems
  dotfiles = %w{ bash_aliases }
  dotfiles.each do |dotfile|
    dotfile_full = File.expand_path("~/.#{dotfile}")
    puts "Copying #{dotfile_full}"
    if File.exists?(dotfile_full)
      config.vm.provision "file", source: dotfile_full, destination: "/home/vagrant/.#{dotfile}"
    end
  end

  # Copy over your personal SSH keys
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"

  # Port Forwarding
  # Forward the ports that you need to use here
  config.vm.network "forwarded_port", host: 8000, guest: 8000, auto_correct: true

  # This line will cause a warning `stdin: is not a tty` but googling says to ignore it
  # Refer to the startup script itself for more comments
  config.vm.provision "shell", inline: "echo '. /vagrant/vagrant-startup.sh' >> /home/vagrant/.bashrc"

  # Install Docker
  config.vm.provision :shell, inline: "wget -qO- https://get.docker.com/ | sh"
  config.vm.provision :shell, inline: "apt-get -y update"
  config.vm.provision :shell, inline: "usermod -aG docker vagrant"

  # Install and Setup Gdal
  config.vm.provision :shell, inline: "add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable"
  config.vm.provision :shell, inline: "apt-get -y update"
  config.vm.provision :shell, inline: "apt-get -y install gdal-bin"
  config.vm.provision :shell, inline: "echo `ogrinfo`"

  # Install and setup mdbtools
  config.vm.provision :shell, inline: "apt-get -y install mdbtools"

end
