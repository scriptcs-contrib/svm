svm (scriptcs version manager)
===

svm is a cross platform version manager for [scriptcs](http://scriptcs.net/ "scriptcs makes it easy to write and execute C# with a simple text editor."). It is available on Windows, Mac OS X and Linux.

     scriptcs version manager - 0.3.0

      USAGE: svm <command> [options]

	  svm install <version>
	    Install scriptcs version indicated by <version>.
	    examples:
	    > svm install 0.10.0
	    > svm install 0.10.1
	
	  svm install <version> <-f|-from> <path> [-s|-snapshot]
	    Install scriptcs version from path <path> as version <version>. Path may be a local folder or a local NuGet 
		package. If Path is a local folder, then a soft link to the local folder is created. Use the -snapshot option
		to create a snapshot of the local folder instead of a soft link. 
	    examples:
	    > svm install mybuild-0.10.1 -f 'C:\scriptcs\artifacts\Release\bin'
	    > svm install mybuild-0.10.1 -from '/tmp/scriptcs/artifacts/Release/bin' -snapshot
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

	@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/paulbouwer/svm/master/install/installer.ps1'))" && SET PATH=%HOME%\.svm\bin\;%HOME%\.svm\shims\;%PATH%

### Start using ###

Type the following in the command prompt to get started:

	svm help


## Mac OS X ##

### Prerequisites ###

#### mono ####

Mono 3.10.0 for Mac OS X is available as a Mac Package (.pkg)

	http://www.mono-project.com/download/#download-mac

### Install ###

The easiest way to obtain `svm` is to run the following command in a terminal:

	 bash <(curl -s https://raw.githubusercontent.com/paulbouwer/svm/master/install/installer.sh) && export PATH="$HOME/.svm/bin:$HOME/.svm/shims/:$PATH"

### Start using ###

Type the following in a terminal to get started:

	svm help


## Linux ##

This has been tested on Ubuntu 14.04 so far.

### Prerequisites ###

#### mono ####

Building mono 3.10.0 from a tarball on Ubuntu 14.04

	$ mkdir /tmp/scriptcs
	$ cd /tmp/scriptcs
	$ wget http://origin-download.mono-project.com/sources/mono/mono-3.10.0.tar.bz2 
	$ tar -xjvf mono-3.10.0.tar.bz2
	$ cd mono-3.10.0
	$ sudo apt-get -y install git autoconf libtool automake build-essential mono-devel gettext
	$ ./configure --prefix=/usr/local
	$ make
	$ sudo make install


#### packages ####

The following packages are required: unzip, curl

	sudo apt-get -y install unzip curl

### Install ###

The easiest way to obtain `svm` is to run the following command in a terminal:

	 bash <(curl -s https://raw.githubusercontent.com/paulbouwer/svm/master/install/installer.sh) && export PATH="$HOME/.svm/bin:$HOME/.svm/shims/:$PATH"

### Start using ###

Type the following in a terminal to get started:

	svm help