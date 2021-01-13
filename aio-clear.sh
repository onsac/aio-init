#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Clear SO"
echo "======================================================================================"

declare -r LTRUE=0
declare -r LFALSE=1

get_common(){
   wget -O /tmp/.common.lib http://raw.githubusercontent.com/onsac/aio-init/main/common.lib 2>/dev/null
   if [ "$?" -ne "0" ]; then
      return $LFALSE
   else
      return $LTRUE
   fi
}

check_step C001
if [ "$?" -eq "0" ]; then
   get_common && set_step C001  "get common OK" || echo "C001 - get common failed"; exit 1
else
   get_common
fi

check_step C002
if [ "$?" -eq "0" ]; then
   . /tmp/.common.lib && set_step C002 "set common OK" || echo "C002 - set common failed"; exit 1
else
   . /tmp/.common.lib
fi

check_step C003
if [ "$?" -eq "0" ]; then
   is_root_user && set_step C003 "Usuário root OK" || echo "C003 - Usuário root failed"; exit 1
fi

check_step C004
if [ "$?" -eq "0" ]; then
   sudo su - $USER && set_step C004 "sudo su OK" || echo "C004 - sudo su failed"; exit 1
else
   sudo su - $USER
fi

. /tmp/.common.lib

check_step C005
if [ "$?" -eq "0" ]; then
   pm2 kill && set_step C005 "pm2 kill OK" || echo "C005 - pm2 kill failed"; exit 1
fi

ASKPASS=$(pw2)

check_step C006
if [ "$?" -eq "0" ]; then
   echo $ASKPASS | sudo -kS "userdel -r aio" && set_step C006 "userdel OK" || echo "C006 - userdel failed"; exit 1
fi

echo $ASKPASS | sudo -kS "rm /tmp/steps.txt;rm /tmp/.common.lib"

echo "Clear concluido com sucesso !!!"
