# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'aio'	=> [1, 100],
}

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    #config.vm.box_url = "http://files.vagrantup.com/xenial64.box"

    #Default is 2200..something, but port 2200 is used by forescout NAC agent.
    config.vm.usable_port_range= 2800..2900 

    nodes.each do |prefix, (count, ip_start)|
        count.times do |i|
            hostname = "%s" % [prefix, (i+1)]

            config.vm.define "#{hostname}" do |box|
                box.vm.hostname = "#{hostname}.book"
		box.vm.network :private_network, ip: "172.29.236.#{ip_start+i}", :netmask => "255.255.252.0", auto_config: false
                box.vm.network :private_network, ip: "172.29.240.#{ip_start+i}", :netmask => "255.255.252.0", auto_config: false
                box.vm.network :private_network, ip: "172.29.248.#{ip_start+i}", :netmask => "255.255.252.0", auto_config: false
                box.vm.network :private_network, ip: "10.10.0.#{ip_start+i}", :netmask => "255.255.255.0"

                box.vm.provision :shell, :path => "#{prefix}.sh"

                # If using Fusion
                box.vm.provider :vmware_fusion do |v|
                    v.vmx["memsize"] = 3172
                end

                # Otherwise using VirtualBox
                box.vm.provider :virtualbox do |vbox|
	            # Defaults
                    vbox.customize ["modifyvm", :id, "--memory", 8192]
                    vbox.customize ["modifyvm", :id, "--cpus", 2]
		    vbox.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
		    vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
 		    vbox.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
          	    vbox.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
            	    
		    dir = "#{ENV['HOME']}/vagrant-additional-disk"

                    unless File.directory?( dir )
                        Dir.mkdir dir
                    end

                    file_to_disk = "#{dir}/#{hostname}-sdb.vmdk"

                    unless File.exists?( file_to_disk )
                        vbox.customize ['createhd', '--filename', file_to_disk, '--size', 60 * 1024]
                    end
                    vbox.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
                end
            end
        end
    end
end
