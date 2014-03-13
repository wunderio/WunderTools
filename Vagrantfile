
# Only change these if possible:
INSTANCE_NAME     = "ansibleref"
INSTANCE_HOSTNAME = "local.ansibleref.com"
INSTANCE_MEM      = "4000" 
INSTANCE_CPUS     = "2"
INSTANCE_IP       = "192.168.10.10"
ANSIBLE_INVENTORY = "ansible/inventory"

# Write the inventory file for ansible
FileUtils.mkdir_p ANSIBLE_INVENTORY
File.open(ANSIBLE_INVENTORY + "/hosts", 'w') { |file| file.write("[vagrant]\n" + INSTANCE_IP) }

# And never anything below this line
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	Vagrant.require_version ">= 1.4.0"

	########################################
	# Default configuration
	########################################

	config.vm.hostname = INSTANCE_HOSTNAME
	config.vm.box      = "centos-6.5-x86_64"

	config.vm.network :private_network, ip: INSTANCE_IP

	# Cachier and an ssh tweak
	config.cache.auto_detect = true
	# config.ssh.forward_agent = true

	# Sync folders
	config.vm.synced_folder ".", "/vagrant", nfs: true
	
	########################################
	# Configuration for virtualbox
	########################################

	config.vm.provider "virtualbox" do |v, override|
		override.vm.box_url = "https://www.dropbox.com/s/vc2lxmybl4cyfpx/centos64-vb43.box?dl=1"
	end

	config.vm.provider :virtualbox do |vb|
		vb.name = INSTANCE_NAME
		vb.customize ["modifyvm", :id, "--memory", INSTANCE_MEM, "--ioapic", "on", "--rtcuseutc", "on", "--cpus", INSTANCE_CPUS]
	end

	########################################
	# Configuration for vmware_fusion
	########################################

	config.vm.provider "vmware_fusion" do |v, override|
		override.vm.box_url = "https://www.dropbox.com/s/9ln4acvgpl5h1ao/centos64-vmware.box?dl=1"
	end

	config.vm.provider "vmware_fusion" do |vb|
		vb.name = INSTANCE_NAME
		vb.vmx["memsize"]  = INSTANCE_MEM
		vb.vmx["numvcpus"] = INSTANCE_CPUS
	end

	########################################
	# Provisioning
	########################################

	config.vm.provision "ansible" do |ansible|
		#ansible.verbose        = "v"
		ansible.inventory_path = ANSIBLE_INVENTORY
		ansible.extra_vars     = "ansible/variables.yml"
		ansible.playbook       = "ansible/playbook/vagrant.yml"
		ansible.limit          = "all"
	end

	config.vm.provision :shell, :path => "ansible/shell/provision.sh"
	
end
