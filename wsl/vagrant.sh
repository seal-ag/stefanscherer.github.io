#!/bin/bash

echo "Preparing Vagrant"
if [ ! -e ~/.vagrant.d ]; then
  mkdir -p /mnt/c/Users/$(cmd.exe /c echo %USERNAME% | tr -d '\r')/.vagrant.d
  ln -s /mnt/c/Users/$(cmd.exe /c echo %USERNAME% | tr -d '\r')/.vagrant.d/ ~/.vagrant.d
fi

v=$(dpkg -l | grep vagrant)
if [ "$v" == "" ]; then
  echo "Installing Vagrant"
  wget https://releases.hashicorp.com/vagrant/2.0.4/vagrant_2.0.4_x86_64.deb
  sudo dpkg -i vagrant_2.0.4_x86_64.deb
  rm vagrant_2.0.4_x86_64.deb
  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
fi

echo "Preparing Vagrant VMware"
if [ ! -e /opt/vagrant-vmware-desktop ]; then
  sudo ln -s /mnt/c/ProgramData/HashiCorp/vagrant-vmware-desktop /opt/vagrant-vmware-desktop
fi
vagrant plugin install vagrant-vmware-desktop


if [ -d /opt/vagrant/embedded/gems/2.0.4/gems/vagrant-2.0.4/plugins ]; then
  echo "Fixing Vagrant 2.0.4 vmrun and shared folders"
  wget https://raw.githubusercontent.com/StefanScherer/dotfiles/master/bin/vmrun.exe-helper
  chmod +x vmrun.exe-helper
  sudo cp vmrun.exe-helper "/usr/bin/C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
  rm vmrun.exe-helper
fi

if [ -f /opt/vagrant/embedded/gems/2.0.4/gems/vagrant-2.0.4/plugins/hosts/linux/cap/rdp.rb ]; then
  echo "Fixing vagrant rdp"
  wget https://raw.githubusercontent.com/StefanScherer/vagrant/wsl-rdp/plugins/hosts/linux/cap/rdp.rb
  sudo mv rdp.rb /opt/vagrant/embedded/gems/2.0.4/gems/vagrant-2.0.4/plugins/hosts/linux/cap/rdp.rb
fi

if [ -f /opt/vagrant/embedded/gems/2.0.4/gems/vagrant-2.0.4/plugins/providers/virtualbox/driver/base.rb ]; then
  echo "Fixing vagrant status"
  wget https://raw.githubusercontent.com/StefanScherer/vagrant/wsl-remove-raise-vboxmanage-missing/plugins/providers/virtualbox/driver/base.rb
  sudo mv base.rb /opt/vagrant/embedded/gems/2.0.4/gems/vagrant-2.0.4/plugins/providers/virtualbox/driver/base.rb
fi

if [ ! -f ~/.vagrant.d/icense-vagrant-vmware-desktop.lic ]; then
  echo "Now run the following command"
  echo "  vagrant plugin license vagrant-vmware-desktop ./license.lic"
fi

echo "Please add the following command to your ~/.bashrc"
echo "  export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1"
