# vpn

A shell command for making vpn connections.  It's a convenience wrapper around [openconnect](http://www.infradead.org/openconnect/).

## Usage

```sh
$ vpn up [site]
$ vpn down
$ vpn reset # if your lan connection glitches
```

## Installation

1. Install [openconnect](http://www.infradead.org/openconnect/).  On OS X you can use [homebrew](http://brew.sh):

  ```sh
  $ brew install openconnect
  ```

2. Install the `vpn` script, by either:
  * `$ gem install vpn`
  * Download the script from [here](...) and put it somewhere in your PATH.
  
## Configuration

Create a config file `~/.vpn`, which is a YAML file containing one or more "site" entries of the form:

```yaml
mycompany:
    server:    vpn.mycompany.com
    usergroup: OTP
    user:      mylogin
```

Each entry must specify a `server`; all other fields get passed as arguments to openconnect.





