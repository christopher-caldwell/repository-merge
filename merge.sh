#!/bin/sh

# The following are coming from sourcing the file below
# REPO_NAMES <-- array of repo directory names
# NEW_REPO_DIR_NAME <-- optional: name of folder for new base git repo

# Allows RegEx blobs to be used
shopt -s extglob dotglob failglob

source ./merge-scripts/argument-parse.sh

TEMP_FILE_NAME="temp.txt"

function setup_base_repo {
  mkdir $NEW_REPO_DIR_NAME
  cd $NEW_REPO_DIR_NAME
  git init
  touch $TEMP_FILE_NAME
  git add . 
  git commit -m "temp hold on this file for merging"
  rm $TEMP_FILE_NAME
  git add .
  git commit -m "removing temp file"
}

function merge_repo {
  local REPO_NAME=$1
  mkdir $REPO_NAME
  git remote add $REPO_NAME ../$REPO_NAME
  git fetch $REPO_NAME
  git merge \
    $REPO_NAME/$BRANCH_NAME \
    --allow-unrelated-histories \
    -m "MERGE: merging repository: $REPO_NAME with $NEW_REPO_DIR_NAME"
  # Moving all files except for the dir names given of the repos
  git mv !(+($REPO_NAMES_INPUT|.git)) $REPO_NAME
  git remote remove $REPO_NAME
  git commit -m "moving $REPO_NAME into it's own directory"
}

function perform_repo_merge {
  for REPO_NAME in "${REPO_NAMES[@]}"
  do
    merge_repo $REPO_NAME
  done
}

function merge_data_load {
  local REPO_NAME="data-load"
  mkdir $REPO_NAME
  git remote add $REPO_NAME ../$REPO_NAME
  git fetch $REPO_NAME
  git merge \
    $REPO_NAME/develop \
    --allow-unrelated-histories \
    -m "MERGE: merging repository: $REPO_NAME with $NEW_REPO_DIR_NAME"
  # Moving all files except for the dir names given of the repos
  git mv !(+($REPO_NAMES_INPUT|.git|$REPO_NAME)) $REPO_NAME
  git remote remove $REPO_NAME
  git commit -m "moving $REPO_NAME into it's own directory"
}

# Initial setup of base repo
setup_base_repo

# Run the function for every name passed
perform_repo_merge

# Outlier cannot merge on master branch
merge_data_load


