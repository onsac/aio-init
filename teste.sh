#!/bin/bash
echo "You are running script : $@"
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

#filename=$($0)

#echo "You are running novo $0"

#echo "You are running novo $filename"

#steps=$(grep print_line $0 | wc -l)
#echo "qtd funcoes = $steps"

