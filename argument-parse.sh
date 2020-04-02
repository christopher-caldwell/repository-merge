
#!/bin/bash

# Default values of arguments
NEW_REPO_DIR_NAME="merge-repo"
BRANCH_NAME="master"
REPO_NAMES_INPUT=()

# Loop through arguments and process them
for arg in "$@"; do
	case $arg in
	# Must be | separated
	--additional-repo-names)
		REPO_NAMES_INPUT="$2"
		shift
		shift
		;;
	--merge-repo-name)
		NEW_REPO_DIR_NAME="$2"
		shift
		shift
		;;
	--branch-name)
		BRANCH_NAME="$2"
		shift
		shift
		;;
	esac
done


IFS='|' read -r -a REPO_NAMES <<< "$REPO_NAMES_INPUT"

