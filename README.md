svm (scriptcs version manager)
===

** *This is a work in progress* **


     scriptcs version manager - 0.1.0

      USAGE: svm <command> [options]

	  svm install <version>
	    Install scriptcs version indicated by <version>.
	    examples:
	    > svm install 0.10.0
	    > svm install 0.10.1
	
	  svm install <version> -from <path>
	    Install scriptcs version from path <path> as version <version>. Path may be a local folder or a local NuGet package.
	    examples:
	    > svm install mybuild-0.10.1 -from 'C:\scriptcs\bin\Debug'
    	> svm install 0.10.1 -from 'C:\Downloads\ScriptCs.0.10.1.nupkg'
	
	  svm install <-l|-list>
	    List the scriptcs versions avaiable to install.
	    examples:
	    > svm install -l
	
	  svm remove <version>
	    Remove installed scriptcs version indicated by <version>.
	    examples:
	    > svm remove 0.9.0
	
	  svm list [-a|-active]
	    List the installed scriptcs versions.
	    -a|-active       list the active version
	    examples:
	    > svm list
	    > svm list -a
	
	  svm use <version>
	    Use the installed scriptcs version indicated by <version>.
	    examples:
	    > svm use 0.10.0

This work and implementation was inspired by [rbenv](https://github.com/sstephenson/rbenv), [rvm](https://github.com/wayneeseguin/rvm), [kvm](https://github.com/aspnet/KRuntime/tree/dev/setup) and [nvm](https://github.com/creationix/nvm).

## Windows ##

### Install ###

The easiest way to obtain `svm` is to run the following command in a command prompt:

	@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/paulbouwer/svm/master/install/installer.ps1'))"

### Start using ###

Start a new command prompt after installing and type the following to get started:

	svm help


## *nix ##

This should work on OS X and Linux. I have tested on Ubuntu so far. You will need mono installed.

### Prerequisites ###

#### mono ####

Building mono 3.4.0 from a tarball on Ubuntu 14.04

	$ mkdir /tmp/scriptcs
	$ cd /tmp/scriptcs
	$ wget http://download.mono-project.com/sources/mono/mono-3.4.0.tar.bz2
	$ tar -xjvf mono-3.4.0.tar.bz2
	$ cd mono-3.4.0

	$ cat > mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets

	-- PASTE --
	<Project xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
	  <Import Project=".\Microsoft.Portable.Core.props" />
	  <Import Project=".\Microsoft.Portable.Core.targets" />
	</Project>
	-- CTRL + D --

	$ sudo apt-get -y install autoconf make gcc g++ gettext
	$ ./configure --prefix=/usr/local
	$ make
	$ sudo make install

#### packages ####

**unzip**

	sudo apt-get -y install unzip
 
### Install and configure svm ###

This is manual for now ...

Create the following folder:

`mkdir ~\.svm`

Copy the `src` folder of the git repo to the `.svm` folder.

You should have something like the following folder structure:


    bin\
      svm

    shims\
      scriptcs

    versions\

    version

Set the PATH as follows:

	export PATH="$HOME/.svm/bin:$HOME/.svm/shims/:$PATH"

You could instead add the following to your `.bashrc`:

	# scriptcs version manager
	export PATH="$HOME/.svm/bin:$HOME/.svm/shims/:$PATH"

Set correct file attributes as follows:

	chmod 755 ~/.svm/bin/svm
	chmod 755 ~/.svm/shims/scriptcs


### Install scriptcs versions manually for now. ###

Download `0.10.2` version of nupkg:

	curl http://chocolatey.org/api/v2/package/ScriptCs/0.10.2 -L -o ScriptCs.0.10.2.nupkg

Change `.nupkg` extensions to`.zip`, unzip files and place contents of `tools\scriptcs` folder into the `.svm\versions\` folder. It should look something like the following now:

	versions\
		0.10.2

### Start using ###

Type the following in a terminal:

	svm help

The *nix version currently implements the following commands:

	svm use <version>
	svm list [-a|-active]
	svm remove <version>
