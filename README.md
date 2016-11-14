# vagrantrpc-aio
Uses 3x VirtualBox (for now) Host-Only networks:

virtualbox0: 172.29.236.1 / 255.255.252.0
virtualbox1: 172.29.240.1 / 255.255.252.0
virtualbox2: 172.29.248.1 / 255/255/252/0

Create these in VirtualBox GUI under Preferences/Networks/Host-Only Networks

git clone https://github.com/uksysadmin/vagrantrpc-aio
cd vagrantrpc-aio
vagrant up

To use the floating/gateway provider network, create a shared gateway network with the following details

Network Type: Flat
Subnet: 172.29.248.0/22

After you've created a tenant network, a router (using the above created provider network as the gateway network) you can then attach floating IP addresses from this network.
You can then access the instances from the host (the computer you ran "vagrant up" on)
