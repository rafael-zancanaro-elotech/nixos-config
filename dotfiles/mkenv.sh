#!/bin/bash

if [[ "$#" -ne 1 ]]; then
	echo "Usage: mkenv <ENVFOLDER>"
	exit 1
fi

SHELL_FULL_PATH="$HOME/.devenvs/$1"

if [ ! -d "$SHELL_FULL_PATH" ]; then
	echo "Directory $SHELL_FULL_PATH does not exist."
	exit 1
fi

cd $SHELL_FULL_PATH

devenv shell
