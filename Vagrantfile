# -*- mode: ruby -*-
# vi: set ft=ruby :

DOMAIN="example.com"
SUBNET="172.16.0"

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.hostmanager.enabled = true
  config.hostmanager.include_offline = true

  config.vm.define :web do |config|
    config.vm.box = "puppetnode1"
    config.vm.box_url = "https://codex.cegeka.be/vagrant/baseboxes/puppetnode1-centos6_virtualbox.box"

    config.vm.provider :virtualbox do |v|
      v.memory = 1024
    end

    config.vm.hostname = "web.#{DOMAIN}"
    config.vm.network :private_network, ip: "#{SUBNET}.2"
    config.vm.network "forwarded_port", guest: 8080, host: 48080

    config.vm.provision :hostmanager

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "web.pp"
      puppet.module_path = [ "../", "./modules" ]
      puppet.facter = {
        "vagrant_hostname" => "web.#{DOMAIN}",
        "vagrant_box_name" => "puppetnode1-centos6-x86_64"
      }
      puppet.options = "--verbose"
    end
  end

  config.vm.define :db do |config|
    config.vm.box = "puppetnode1"
    config.vm.box_url = "https://codex.cegeka.be/vagrant/baseboxes/puppetnode1-centos6_virtualbox.box"

    config.vm.provider :virtualbox do |v|
      v.memory = 512
    end

    config.vm.hostname = "db.#{DOMAIN}"
    config.vm.network :private_network, ip: "#{SUBNET}.3"
    config.vm.network "forwarded_port", guest: 3306, host: 43306

    config.vm.provision :hostmanager

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "db.pp"
      puppet.module_path = [ "../", "./modules" ]
      puppet.facter = {
        "vagrant_hostname" => "db.#{DOMAIN}",
        "vagrant_box_name" => "puppetnode1-centos6-x86_64"
      }
      puppet.options = "--verbose"
    end
  end

  config.vm.define :elasticsearch do |config|
    config.vm.box = "puppetnode1"
    config.vm.box_url = "https://codex.cegeka.be/vagrant/baseboxes/puppetnode1-centos6_virtualbox.box"

    config.vm.provider :virtualbox do |v|
      v.memory = 512
    end

    config.vm.hostname = "elasticsearch.#{DOMAIN}"
    config.vm.network :private_network, ip: "#{SUBNET}.4"
    config.vm.network "forwarded_port", guest: 9200, host: 49200

    config.vm.provision :hostmanager

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "elasticsearch.pp"
      puppet.module_path = [ "../", "./modules" ]
      puppet.facter = {
        "vagrant_hostname" => "elasticsearch.#{DOMAIN}",
        "vagrant_box_name" => "puppetnode1-centos6-x86_64"
      }
      puppet.options = "--verbose"
    end
  end

  config.vm.define :kibana do |config|
    config.vm.box = "puppetnode1"
    config.vm.box_url = "https://codex.cegeka.be/vagrant/baseboxes/puppetnode1-centos6_virtualbox.box"

    config.vm.provider :virtualbox do |v|
      v.memory = 1024
    end

    config.vm.hostname = "kibana.#{DOMAIN}"
    config.vm.network :private_network, ip: "#{SUBNET}.5"
    config.vm.network "forwarded_port", guest: 80, host: 40080

    config.vm.provision :hostmanager

    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "kibana.pp"
      puppet.module_path = [ "../", "./modules" ]
      puppet.facter = {
        "vagrant_hostname" => "kibana.#{DOMAIN}",
        "vagrant_box_name" => "puppetnode1-centos6-x86_64"
      }
      puppet.options = "--verbose"
    end
  end

end
