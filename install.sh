#!/usr/bin/env bash
# -*- mode: sh; coding: utf-8; tab-width: 4; indent-tabs-mode: nil -*-
set -euo pipefail
IFS=$'\n\t'
errcode=0
readonly script="$(readlink -f "$0")"

function on_exit {
    exit $errcode
}

trap on_exit EXIT

function on_error {
    errcode=$1  # NOTE: errcode is global
    linenum=$2
    echo "[ERROR] script: $script errcode: $errcode linenum: $linenum"
}

trap 'on_error $? $LINENO' ERR

# https://askubuntu.com/a/943775
# sudo apt install --reinstall libappstream3

sudo rm -f /etc/skel/examples.desktop /home/*/examples.desktop

sudo dpkg-divert --add --rename --divert /etc/apt/sources.list.orig /etc/apt/sources.lists

sudo rsync -qr ./ubuntu/ /

readonly KEYS="
    0EBFCD88  # docker
    EAAFC9CD  # emacs
    E15E78F4  # gitlab
    C9D8B80B  # osquery
"

for KEY in $KEYS
do
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ${KEY%%#*}
done

sudo apt update
sudo apt dist-upgrade

sudo apt install $(awk -F"#" '{print $1}' packages)

sudo snap install slack --classic
sudo snap refresh

python3 -m pip install --user -U awscli pip virtualenvwrapper

readonly CONFIGURE_ARGS="with-ldflags=-L/opt/vagrant/embedded/lib with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib"
export CONFIGURE_ARGS
readonly GEM_HOME=$HOME/.vagrant.d/gems
export GEM_HOME
readonly GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems
export GEM_PATH
readonly PATH=/opt/vagrant/embedded/bin:$PATH
export PATH

curl -s -o /tmp/vagrant.deb https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.deb
sudo dpkg -i /tmp/vagrant.deb
rm -f /tmp/vagrant.deb

# https://github.com/vagrant-libvirt/vagrant-libvirt#installation
sudo apt build-dep vagrant ruby-libvirt
sudo apt install qemu libvirt-clients ebtables dnsmasq-base
sudo apt install libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev

for PLUGIN in libvirt mutate
do
    vagrant plugin install vagrant-$PLUGIN
done

for GROUP in docker libvirtd
do
    sudo usermod -aG $GROUP $USER
done

sudo apt autoclean
sudo apt autoremove
sudo apt purge

fwupdmgr get-updates

exit 0
