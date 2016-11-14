#!/bin/bash
apt-get update
apt-get dist-upgrade -y
apt-get -y install git
git clone https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible
cd /opt/openstack-ansible
git checkout stable/mitaka
OSA_VERSION=$(git describe --abbrev=0 --tags)
git checkout ${OSA_VERSION}
# VirtualBox Hack for minimum disk size
#sed -i 's/bootstrap_host_data_disk_min_size.*/bootstrap_host_data_disk_min_size: 30/g' /opt/openstack-ansible/tests/roles/bootstrap-host/defaults/main.yml
export BOOTSTRAP_OPTS="bootstrap_host_data_disk_device=sdb"
scripts/bootstrap-ansible.sh
scripts/bootstrap-aio.sh
rm -f /etc/network/interfaces.d/osa_interfaces.cfg
cp /vagrant/osa_interfaces.cfg /etc/network/interfaces.d
brctl addif br-mgmt eth1
brctl addif br-vxlan eth2
brctl addif br-vlan eth3
for a in {1..3}; do
  sudo ifconfig eth${a} 0.0.0.0 up
  sudo ip link set eth${a} promisc on
done
scripts/run-playbooks.sh
