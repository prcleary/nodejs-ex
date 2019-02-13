#!/bin/bash

#set -e

unset TMOUT

echo "Generate shiny-server.conf"
$OPENSHIFT_REPO_DIR/R/generate_shiny_server_conf.sh
echo "Checking R server status" ...
$OPENSHIFT_REPO_DIR/R/deploy_R.sh
echo "Checking R libraries status" ...
$OPENSHIFT_REPO_DIR/R/deploy_libR.sh
