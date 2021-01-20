#!/bin/bash
. ./common.lib
exec > >(tee ${LOG_FILE}) 2>&1
check_step 
if [ "$?" -eq "0" ]; then
   echo "ENTREI" && set_step "get common" || stop_step "get common"
fi
check_step 
if [ "$?" -eq "0" ]; then
   echo "SAI"  && set_step "set common" || stop_step "set common"
fi

. ./common.lib

cont_step

check_step
if [ "$?" -eq "0" ]; then
   echo "VOLTEI"  && set_step "set common" || stop_step "set common"
fi

