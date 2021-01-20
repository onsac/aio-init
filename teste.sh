#!/bin/bash
get_common()
{
   wget --no-cache --no-cookies --no-check-certificate -O /tmp/.common.lib http://raw.githubusercontent.com/onsac/aio-init/main/common.lib 2>/dev/null
   if [ "$?" -ne "0" ]; then
      return $LFALSE
   else
      return $LTRUE
   fi
}

get_common

. /tmp/.common.lib 

print_line
echo "AIO INTEGRADOR 2.0 - SETUP"
print_line

exec > >(tee ${LOG_FILE}) 2>&1

check_step
if [ "$?" -eq "0" ]; then
   echo "ENTREI" && set_step "get common" || stop_step "get common"
fi
check_step
if [ "$?" -eq "0" ]; then
   echo "SAI"  && set_step "set common" || stop_step "set common"
fi

su - aio

. ./common.lib

cont_step

check_step
if [ "$?" -eq "0" ]; then
   echo "VOLTEI"  && set_step "set common" || stop_step "set common"
fi

