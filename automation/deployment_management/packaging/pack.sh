#!/bin/bash

# DB objects packaging tool 

database=${1:-DEV} # first argument of the script, target database, default = DEV

echo target database $database

declare -A SL # db environment dictionary for SL database
declare -A IL # db environment dictionary for IL database
declare -A AL # db environment dictionary for AL database
declare -A ML # db environment dictionary for ML database
declare -a ORDERS # defines the execution order of all package elements
declare -A DEPLOYMENT # output directory
declare -A COUNTER # monitors the access to files in the output directory

. ./pack.config # reads configuration

mkdir -p _deployment/script # creates output execution directory if not exists

for K in "${!ORDERS[@]}"; do  # loop trough the directories of development repository tracked in pack.config

  COUNTER[${DEPLOYMENT[${ORDERS["$K"]}]}]+=1
    
    if [ ${COUNTER[${DEPLOYMENT[${ORDERS["$K"]}]}]} -eq 1 ]
    then
      > _deployment/script/${DEPLOYMENT[${ORDERS["$K"]}]} # erases the file before first round
    fi

    for f in $ORIGIN${ORDERS["$K"]}; do  # loops trough all sql files of the directory
      cat "$f"; echo; # adds empty line at the end of each file and merge the files
    done >> _deployment/script/${DEPLOYMENT[${ORDERS["$K"]}]} # adds new content to the file
    
    # replaces db environment
    sed -i -e "s/${ML[DEV]}/${ML[$database]}/g; \
               s/${AL[DEV]}/${AL[$database]}/g; \
               s/${IL[DEV]}/${IL[$database]}/g; \
               s/${SL[DEV]}/${SL[$database]}/g" _deployment/script/${DEPLOYMENT[${ORDERS["$K"]}]} 

done