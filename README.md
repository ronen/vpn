# vpn
[![Gem Version](https://badge.fury.io/rb/vpn.png)](http://badge.fury.io/rb/vpn)
[![Build Status](https://travis-ci.org/ronen/vpn.svg?branch=master)](https://travis-ci.org/ronen/vpn)

A shell command for making vpn connections.  It's a convenience wrapper around [openconnect](http://www.infradead.org/openconnect/), in which you set up a configuration file with connection details, then just "vpn up" to connect.

Requires ruby version >= 2.1.0

## Usage

```sh
$ vpn up [site]
$ vpn down
$ vpn reset # if your lan connection glitches
$ vpn status # tells you if vpn is up or down
```

The script will prompt for your vpn password on the site as well as for the sudo password on your machine (if needed).

## Installation

1. Install [openconnect](http://www.infradead.org/openconnect/).  On OS X you can use [homebrew](http://brew.sh):

  ```sh
  $ brew install openconnect
  ```

2. Install the `vpn` script, by either:

  * `$ gem install vpn`
  
  or
  
  * Download the script from [here](https://raw.githubusercontent.com/ronen/vpn/master/bin/vpn) and put it somewhere in your PATH.
  
## Configuration

Create a config file `~/.vpn`, which is a YAML file containing one or more "site" entries of the form:

```yaml
mycompany:
    server:    vpn.mycompany.com
    usergroup: OTP
    user:      mylogin
```

Each entry must specify a `server`. All other fields get passed as options to openconnect -- see `$ man openconnect` to find out what they are.  Options that don't take values can be specified using the value `true`.

## History

* 0.2.1 - Fix so it runs when installed as a gem
* 0.2.0 - Add `vpn status`
* 0.1.0 - Initial release

## Last but not least...

Comments, suggestions, and pull requests are all welcome!
