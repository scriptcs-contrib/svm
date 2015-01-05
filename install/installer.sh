#!/bin/bash

USER_SVM_PATH="$HOME/.svm"
TEMP_PATH="/tmp"

#
# helper functions
#

_svm_title_message() {
  local message="$1"
  echo -e "\n\033[1;4m $message \033[0m\n"
}
_svm_info_message() {
  local message="$1"
  echo -e " $message "
}
_svm_error_message() {
  local message="$1"
  echo -e "\033[41m $message \033[0m"
}

_svm_isinstalled() {
  type "$1" > /dev/null 2>&1
  return $?
}

_svminstaller_create_install_location() {
	local install_path="$1"

	if [ -d "$install_path" ]; then
		_svm_error_message "An existing svm installation exists at '$install_path'. Please remove this manually before re-installing."
		echo "" && exit
	fi

	_svm_info_message "Creating svm install location at '$install_path'."
	mkdir "$install_path"
}

_svminstaller_download_package() {
	local package_url="$1"
	local download_path="$2"

	_svm_info_message "Downloading svm install package from '$package_url'."

	local httpResult=$(curl -D - -L --create-dirs -o "$download_path" "$package_url" 2>/dev/null | grep "^HTTP/1.1" | tail -n 1 | sed "s/HTTP.1.1 \([0-9]*\).*/\1/")
  if [ $httpResult != "200" ];then
    _svm_error_message "The svm install package could not be downloaded from '$package_url'."
    echo "" && exit
  fi
}

_svminstaller_install_package() {
	local download_path="$1"
	local install_path="$2"

	_svm_info_message "Installing svm to '$install_path'."

	unzip -j "$download_path" "svm-0.3.5/src/bin/*" -d "$install_path/bin" > /dev/null 2>&1
	unzip -j "$download_path" "svm-0.3.5/src/shims/*" -d "$install_path/shims" > /dev/null 2>&1
	mkdir "$install_path/versions"

	# remove Windows specific resources from installed package
	find "$install_path" \( -name "*.cmd" -or -name "*.ps1" \) -exec rm -f {} \;

	# remove download folder - with safety check that path starts with temp folder
	download_folder="${download_path%/*}"
  if [[ $download_folder == $TEMP_PATH* ]]; then rm -fr $download_folder; fi
}

_svminstaller_configure_environment() {
	local install_path="$1"
	local path=""
	local path_bin=""
	local path_shims=""

	_svm_info_message "Configuring path environment variables for svm."

	path="$PATH"
	path_bin="$install_path/bin"
	path_shims="$install_path/shims"

	# remove any existing instances of svm folders from PATH
	path=":$path:"
	path=${path/:$path_bin:/:}
	path=${path/:$path_shims:/:}
	path=${path%:}
	path=${path#:}

	local startup_file=""

	# write to .bash_profile if bash is installed
	startup_file="$HOME/.bash_profile"
	if _svm_isinstalled "bash"; then
		if [[ $(grep '# scriptcs version manager' "$startup_file" -s) ]]; then
			_svm_info_message "Existing entry in .bash_profile file found at '$startup_file'. File will not be modified."
		else
			_svm_info_message "Writing entry into .bash_profile file found at '$startup_file'."
			echo '' >> "$startup_file"
			echo '# scriptcs version manager' >> "$startup_file"
			echo '. $HOME/.svm_profile' >> "$startup_file"
		fi
	fi
	# write to .zshrc if zsh is installed
	startup_file="$HOME/.zshrc"
	if _svm_isinstalled "zsh"; then
		if [[ $(grep '# scriptcs version manager' "$startup_file" -s) ]]; then
			_svm_info_message "Existing entry in .zshrc file found at '$startup_file'. File will not be modified."
		else
			_svm_info_message "Writing entry into .zshrc file found at '$startup_file'."
			echo '' >> "$startup_file"
			echo '# scriptcs version manager' >> "$startup_file"
			echo '. $HOME/.svm_profile' >> "$startup_file"
		fi
	fi
	# write to .svm_profile
	startup_file="$HOME/.svm_profile"
	if [ -f "$startup_file" ]; then
		_svm_info_message "Overwriting .svm_profile file at '$startup_file'."
	else
		_svm_info_message "Creating .svm_profile file at '$startup_file'."
	fi
	echo '# scriptcs version manager' > "$startup_file"
	echo 'export PATH="$HOME/.svm/bin:$HOME/.svm/shims:$PATH"' >> "$startup_file"

	# set execute file attribute on shell scripts
	chmod 644 "$HOME/.svm_profile"
	chmod 755 "$USER_SVM_PATH/bin/svm"
	chmod 755 "$USER_SVM_PATH/shims/scriptcs"
}

#
# installer
#

_svm_title_message "scriptcs version manager - installer"

svm_install_path="$USER_SVM_PATH"
svm_package_url="https://github.com/scriptcs-contrib/svm/archive/v0.3.5.zip"
svm_download_path="$TEMP_PATH/`uuidgen`/svm-install.zip"

_svminstaller_create_install_location "$svm_install_path"
_svminstaller_download_package "$svm_package_url" "$svm_download_path"
_svminstaller_install_package "$svm_download_path" "$svm_install_path"
_svminstaller_configure_environment "$svm_install_path"

_svm_info_message "Successfully installed!"
_svm_info_message "\nRun 'svm help' to get started."

echo ""
