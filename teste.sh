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

declare -r LTRUE=0
declare -r LFALSE=1

echo "You are running novo $0"

filename=$($0)

echo "You are running novo $0"

echo "You are running novo $filename"

#steps=$(grep print_line $0 | wc -l)
#echo "qtd funcoes = $steps"

