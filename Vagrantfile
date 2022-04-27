# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = 2
  end

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/me.pub"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/me.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL
  
  config.vm.define "centos7_lemp" do |wb|
    wb.vm.box = 'centos/7'
    wb.vm.hostname = 'lemp.loc'
    wb.vm.network "private_network", ip: "192.168.20.221"
    wb.vm.provision "shell", path: "bootstrap.sh"
    wb.vm.network "forwarded_port", id: "centos7_webmin", guest: 80, host: 8080, guest_ip: "10.0.2.15", host_ip: "127.0.0.1", protocol: "tcp"
  end

end