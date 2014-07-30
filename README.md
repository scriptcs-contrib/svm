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
	    > svm install mybuild-0.10.1 -from C:\scriptcs\bin\Debug\
	    > svm install 0.10.1 -from C:\Downloads\ScriptCs.0.10.1.nupkg
	
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

This work and implementation was inspired by [rbenv](https://github.com/sstephenson/rbenv), [kvm](https://github.com/aspnet/KRuntime/tree/dev/setup) and [nvm](https://github.com/creationix/nvm).

Manual install of svm for now ...

## Windows ##

This version is close to complete now.

### Install and configure svm ###

Create the following folder:

`mkdir %userprofile%\.svm`

Copy the `src` folder of the git repo to the `.svm` folder.

You should have something like the following folder structure:


    bin\
      svm.cmd
      svm.ps1

    shims\
      scriptcs.cmd
      scriptcs.ps1

    versions\

    version

Set the PATH as follows:

	Path=%userprofile%\.svm\bin;%userprofile%\.svm\shims;%Path%

### Start using ###

Start a command prompt and type the following:

	svm help


## *nix ##

This should work on OS X and Linux. I have tested on Ubuntu so far. You will need mono installed.

### Building mono 3.4.0 from a tarball on Ubuntu 14.04 ###

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
	-- CTL D --

	$ sudo apt-get -y install autoconf make gcc g++ gettext
	$ ./configure --prefix=/usr/local
	$ make
	$ sudo make install


### Install and configure svm ###

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

Download `0.9.0` version of nupkg from:

	https://chocolateypackages.s3.amazonaws.com/ScriptCs.0.9.0.nupkg

And `0.10.0-alpha.140612` from:

	https://www.myget.org/F/scriptcsnightly/api/v2/package/scriptcs/0.10.0-alpha-140612

Change `.nupkg` extensions to`.zip`, unzip files and place contents of `tools\scriptcs` folder into the `.svm\versions\` folder. It should look something like the following now:

	versions\
		0.9.0\
		0.10.0-alpha-140612\

### Start using ###

Type the following in a terminal:

	svm help

The *nix version is a proof of concept currently and not implemented beyond an assumed `svm use <version>` implementation.
