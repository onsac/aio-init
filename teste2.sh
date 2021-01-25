#!/bin/bash
. ./common.lib
exec > >(tee ${LOG_FILE}) 2>&1
ID="AIO-92O099DF"
check_step
if [ "$?" -eq "0" ]; then
   get_license $ID && set_step "get license" || stop_step "get license"
else
   get_license $ID 
fi
if [ "$?" -eq "0" ]; then
   reg_setup $ID && set_step "reg setup" || stop_step "reg setup"
else
   get_license $ID
fi

