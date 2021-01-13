#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Clear SO"
echo "======================================================================================"

declare -r LTRUE=0
declare -r LFALSE=1

get_common(){
   wget --no-cache -O /tmp/.common.lib http://raw.githubusercontent.com/onsac/aio-init/main/common.lib 2>/dev/null
   if [ "$?" -ne "0" ]; then
      return $LFALSE
   else
      return $LTRUE
   fi
}

get_common
. /tmp/.common.lib

check_step C001
if [ "$?" -eq "0" ]; then
   echo "" && set_step C001  "get common OK" || echo "C001 - get common failed"
fi

check_step C002
if [ "$?" -eq "0" ]; then
   echo "" && set_step C002 "set common OK" || echo "C002 - set common failed"
fi

check_step C003
if [ "$?" -eq "0" ]; then
   is_root_user && set_step C003 "Usuário root OK" || echo "C003 - Usuário root failed"
fi

check_step C004
if [ "$?" -eq "0" ]; then
   pkill -u $USER && set_step C004 "kill OK" || echo "C004 - pm2 kill failed"
fi

check_step C005
if [ "$?" -eq "0" ]; then
   userdel -r $USER && set_step C005 "userdel OK" || echo "C005 - userdel failed"
fi

#echo $ASKPASS | sudo -kS "rm /tmp/steps.txt;rm /tmp/.common.lib"

echo "Clear concluido com sucesso !!!"

