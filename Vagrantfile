# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  # must be at the top
  config.vm.define "fluentd-server" do |c|
      c.vm.hostname = "fluentd-server"
      c.vm.network "private_network", ip: "10.240.0.10"

      c.vm.provision :shell, :path => "scripts/common/setup-hosts-file.sh"
      c.vm.provision :shell, :path => "scripts/common/setup-tdagent.sh"

      c.vm.provider "virtualbox" do |vb|
        vb.memory = "256"
      end
  end

  (1..2).each do |n|
    config.vm.define "webserver-#{n}" do |c|
        c.vm.hostname = "webserver-#{n}"
        c.vm.network "private_network", ip: "10.240.0.1#{n}"

        c.vm.provision :shell, :path => "scripts/common/setup-hosts-file.sh"
        c.vm.provision :shell, :path => "scripts/common/setup-tdagent.sh"
    end
  end

end
