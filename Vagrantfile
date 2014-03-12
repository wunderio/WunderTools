Vagrant.configure("2") do |config|

	Vagrant.require_version ">= 1.4.0"

	########################################
	# Default configuration
	########################################

	config.vm.hostname = "local.ansible.ref"
	config.vm.box = "centos-6.5-x86_64"

	config.vm.network :private_network, ip: "33.33.33.151"

	# Cachier and an ssh tweak
	config.cache.auto_detect = true
	config.ssh.forward_agent = true

	# Sync folders
	config.vm.synced_folder ".", "/vagrant", nfs: true
	
	########################################
	# Configuration for virtualbox
	########################################

	config.vm.provider "virtualbox" do |v, override|
		override.vm.box_url = "https://www.dropbox.com/s/vc2lxmybl4cyfpx/centos64-vb43.box?dl=1"
	end

	config.vm.provider :virtualbox do |vb|
		vb.name = "lehtiyhtyma"
		vb.customize ["modifyvm", :id, "--memory", "4000", "--ioapic", "on", "--rtcuseutc", "on", "--cpus", "2"]
	end

	########################################
	# Configuration for vmware_fusion
	########################################

	config.vm.provider "vmware_fusion" do |v, override|
		override.vm.box_url = "https://www.dropbox.com/s/9ln4acvgpl5h1ao/centos64-vmware.box?dl=1"
	end

	config.vm.provider "vmware_fusion" do |vb|
		vb.name = "lehtiyhtyma"
		vb.vmx["memsize"] = "4000"
		vb.vmx["numvcpus"] = "2"
	end

	########################################
	# Provisioning
	########################################

	config.vm.provision "ansible" do |ansible|
		#ansible.verbose = "vvvv"
		ansible.inventory_path = "ansible/inventory"
		ansible.extra_vars = "ansible/variables.yml"
		ansible.playbook = "ansible/playbook/vagrant.yml"
		ansible.limit = "all"
	end

	config.vm.provision :shell, :path => "ansible/shell/provision.sh"
	
end
