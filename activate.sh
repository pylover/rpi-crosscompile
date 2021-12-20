
if [ $0 = $BASH_SOURCE ]; then
	echo "Can not run this script, try to source it"
	exit 1
fi

if [ ! -z $BACKUP_PATH ]; then
	echo "Already sourced, run deactivate to allow source again."
	return 1
fi


XTOOL=$(readlink -f build/xtool)
XBUILD=$(readlink -f build/xbuild)


HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
export DEB_TARGET_MULTIARCH=arm-linux-gnueabihf
export BACKUP_PATH=$PATH
export BACKUP_PS1=$PS1
export ENV_TITLE="rpi-xtool"
export PATH="$XBUILD/armv8-rpi3-linux-gnueabihf/bin:$PATH"
export PATH="$XBUILD/armv8-rpi3-linux-gnueabihf/armv8-rpi3-linux-gnueabihf/bin:$PATH"
export PATH="$XTOOL/bin:$PATH"
export PS1="($ENV_TITLE) $PS1"

copy_function() {
  test -n "$(declare -f "$1")" || return 
  eval "${_/$1/$2}"
}

rename_function() {
  copy_function "$@" || return
  unset -f "$1"
}

if [[ $(type -t deactivate) == function ]]; then
  rename_function deactivate xtool_backup_deactivate
fi

function deactivate {
  export PATH=$BACKUP_PATH
  export PS1=$BACKUP_PS1
  unset DEB_TARGET_MULTIARCH
  unset BACKUP_PATH
  unset BACKUP_PS1
  unset ENV_TITLE
  unset -f deactivate
  if [[ $(type -t xtool_backup_deactivate) == function ]]; then
    rename_function xtool_backup_deactivate deactivate
  fi
}


