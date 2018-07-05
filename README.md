# Augment

Augment commands to your liking!

Have you ever felt annoyed having to type `https://` every time you want to
`git clone` a repository? Or that time where you wanted to change `go get` to
always use the `-u` flag? Well, this is exactly what `augment` is for.

`augment` sits as a proxy between you and these commands, applying small
changes to certain commands that you define in the configuration file.

## Installation

### Requirements

`augment` requires [Crystal](https://crystal-lang.org) to be installed on the
your system.

### Automatic

To install `augment`, you can use the installation script which will install
it into `~/.augment`. The script will remove any existing installation of
`augment` but will retain your configuration file.

Next, add `~/.augment/bin` to your `PATH`.

```bash
export PATH=~/.augment/bin:$PATH
```

*Note: It is important that the `bin` directory is the first entry as it needs
to precede an entry in order be its proxy.*

### Manual

Clone the repository into your desired path.

```bash
$ git clone https://github.com/ravernkoh/augment.git /desired/path
Cloning into 'path'...
```

Make sure to add the `bin` directory at your desired path to your `PATH`.

```bash
export PATH=$PATH:/desired/path/bin
```

## Usage

The configuration file is where you define all your augments. It is located
at `~/.augment/config`. The following shows a sample configuration.

```crystal
require "augment"

# Adds a "-u" flag to the `go get` command if it isn't present.
command "go" do
  command "get" do
    unless flags.get("-u")
      flags.add("-u")
    end
  end
end

# Adds a "https://" to the first argument in the `git clone` command
# if it isn't present.
command "git" do
  command "clone" do
    url = args.get(0)
    unless url.starts_with("https://")
      args.set(0, "https://#{url}")
    end
  end
end
```

As can be seen, configuration is written in Crystal, which is a language
similar in syntax to Ruby.

Finally, after changing the configuration file, `augment build` must be run to
build the main binary. This also creates various scripts (e.g. `go`, `git`)
which have the same name as the command, thus providing the proxy
functionality.

```bash
$ augment build
Building augments
Creating command go
Creating command git
```

The list of commands can be printed out using `augment list`.

```bash
$ augment list
go
git
```

Commands can also be tested out without the proxy. This is sometimes useful
to diagnose issues such as when an augment isn't being applied.

```bash
$ augment git clone github.com/ravernkoh/kubo.git
Cloning into 'kubo'...
```
