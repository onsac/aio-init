#!/bin/bash
LOG_FILE=/tmp/both.log
. ./commonv1.lib
exec > >(tee ${LOG_FILE}) 2>&1
check_step 
if [ "$?" -eq "0" ]; then
   echo "" && set_step "get common" || stop_step "get common"
fi
check_step 
if [ "$?" -eq "0" ]; then
   kxkxk  && set_step "set common" || stop_step "set common"
fi
