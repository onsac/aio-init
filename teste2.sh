#!/bin/bash
print_line()
{
i=1
LINE=""
columns=$(tput cols)
while [ "$i" -lt "$columns" ]
do
  LINE=$LINE"="
  ((i=i+1))
done
echo $LINE
}

print_line
echo "AIO INTEGRADOR 2.0 - Setup SO"
print_line
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


print_line
