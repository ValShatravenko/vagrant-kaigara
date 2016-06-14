# Vagrant::Kaigara

[![Build Status](https://travis-ci.org/helios-technologies/vagrant-kaigara.svg?branch=master)](https://travis-ci.org/helios-technologies/vagrant-kaigara) [![Gem Version](https://badge.fury.io/rb/vagrant-kaigara.svg)](https://badge.fury.io/rb/vagrant-kaigara) 

This is a gem for provisioning vagrant with [kaigara](https://github.com/helios-technologies/kaigara)

## Installation

You can install with plugin with vagrant cli:

    $ vagrant plugin install vagrant-kaigara

## Usage

You should have [kaigara](https://github.com/helios-technologies/kaigara) installed on host machine.

Add this to your Vagrantfile:
```ruby
  config.vm.provision :kaigara
```

Then run `vagrant provision`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/helios-technologies/vagrant-kaigara.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
