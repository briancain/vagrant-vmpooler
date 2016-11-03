# Vagrant Vmpooler Provider

vagrant-vmpooler is still a work in progress and a lot of things might not work at the moment. If you find a bug, feel free to open up an issue on this repository.

[![Gem Version](https://badge.fury.io/rb/vagrant-vmpooler.svg)](https://badge.fury.io/rb/vagrant-vmpooler)

### Features

* Quickly provision virtual machines with vmpooler and vagrant
* SSH into machines
* Provision the instances with any built-in Vagrant provisioner
* Sync folders with Rsync
* Built off of the [vmfloaty](https://github.com/briancain/vmfloaty) library, using the [vmpooler](https://github.com/puppetlabs/vmpooler) api

## Usage

### Quick Start

To quickly get started, install the vagrant plugin with the command below. Then you'll want to add a dummy box from the [example_box](example_box) directory...finally create a Vagrantfile and run the up command with the `vmpooler` provider.

```
$ vagrant plugin install vagrant-vmpooler
...
$ vagrant box add dummy https://github.com/briancain/vagrant-vmpooler/raw/master/example_box/dummy.box
...
$ vagrant up --provider=vmpooler
...
```

### Example Vagrantfile

A few examples to get you started

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Provisioning script
provision_script = <<SCRIPT
#!/bin/bash
echo "Hello there" > ~/hi.txt
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provision :shell, :inline => provision_script

  config.vm.provider :vmpooler do |vmpooler|
    vmpooler.url = "https://vmpooler.com/api/v1"
    vmpooler.os = "centos-7-x86_64"
    vmpooler.ttl = 24
    vmpooler.password = "secretpassword"
  end
end
```

## Configuration

Similar to [vmfloaty](https://github.com/briancain/vmfloaty#vmfloaty-dotfile), a few of these settings can be defined in the `vmfloaty` dotfile located in your home directory. However, they can be overridden in a Vagrantfile if needed. The configuration values that can be set in that dotfile below are explicitly called out.

* `url`
  + __REQUIRED__
  + __vmfloaty dotfile config setting__
  + string
  + The url to your vmpooler installation
* `os`
  + __REQUIRED__
  + string
  + The type of operatingsystem to get from the pooler
* `password`
  + __REQUIRED__
  + string
  + The password to use to log into the vmpooler machine
* `verbose`
  + boolean
  + Whether or not to run vmfloaty api calls in verbose mode
  + defaults to `false`
* `token`
  + __vmfloaty dotfile config setting__
  + string
  + The token used to obtain vms
* `ttl`
  + integer
  + How long the vm should additionally stay active for (default is 12 with token)
* `disk`
  + integer
  + Increases default disk space by this size

These can be set like any other vagrant provider:

```ruby
Vagrant.configure("2") do |config|
  # ... other stuff

  config.vm.provider :vmpooler do |vmpooler|
    vmpooler.password = "foo"
    vmpooler.os = "ubuntu-1604-x86_64"
    vmpooler.ttl = 48
  end
end
```

## Synced Folders

At the moment, vagrant-vmpooler only supports rsync for syncing folders. It requires both the host machine and remote machine to have rsync installed. Right now there's a basic setup step that will install rsync on the remote host before syncing folders since several vmpooler machines do not have it installed by default.

## Limitations

Both of the commands are not supported in this plugin since vmpooler gives no api support for halting or suspending vms. Running these commands will result in a warning from vagrant-vmpooler.

* `vagrant halt`
* `vagrant suspend`

vagrant-vmpooler assumes that it will be logging in as root or Administrator (windows) to any vmpooler vm.

## Development

To work on the `vagrant-vmpooler` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

Once you have the dependencies, verify the unit tests pass with `rake`:

```
$ bundle exec rake
```

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by just
creating a `Vagrantfile` in the top level of this directory (it is gitignored)
and add the following line to your `Vagrantfile`

```ruby
Vagrant.require_plugin "vagrant-vmpooler"
```
Use bundler to execute Vagrant:
```
$ bundle exec vagrant up --provider=vmpooler
```
