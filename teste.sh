#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Setup SO"
echo "======================================================================================"
declare -r LTRUE=0
declare -r LFALSE=1
get_common(){
   wget --no-cache --no-cookies --no-check-certificate -O /tmp/.common.lib http://raw.githubusercontent.com/onsac/aio-init/main/common.lib 2>/dev/null
   if [ "$?" -ne "0" ]; then
      return $LFALSE
   else
      return $LTRUE
   fi
}

get_common && echo "0.1 - get common OK" || echo "0.1 - get common failed" | exit 1

. /tmp/.common.lib && echo "0.2 - set common OK" || echo "0.2 - set common failed" | exit 1

echo "print line"
print_line
