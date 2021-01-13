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
   echo "" && set_step C001 "get common OK" || stop_step C001 "get common failed"
fi

check_step C002
if [ "$?" -eq "0" ]; then
   echo "" && set_step C002 "set common OK" || stop_step C002 "set common failed"
fi

check_step C003
if [ "$?" -eq "0" ]; then
   is_root_user && set_step C003 "Usuário root OK" || stop_step C003 "Usuário root failed"
fi

check_step C004
if [ "$?" -eq "0" ]; then
   CONTKILL=$(pkill -c -i pm2)
   if [ "$CONTKILL" -gt "0" ]; then
      pkill -u $USER && set_step C004 "kill OK" || stop_step C004 "kill failed"
   else
      set_step C004 "kill OK"
   fi
fi

check_step C005
if [ "$?" -eq "0" ]; then
   userdel -r $USER && set_step C005 "userdel OK" || stop_step C005 "userdel failed"
fi

check_step C006
if [ "$?" -eq "0" ]; then
   FILE1="/tmp/steps.txt"
   if [ -f "$FILE1" ]; then
      rm -f /tmp/steps.txt
   fi
   set_step C006 "clear steps"
fi

check_step C007
if [ "$?" -eq "0" ]; then
   FILE2="/tmp/.common.lib"
   if [ -f "$FILE2" ]; then
      rm -f /tmp/.common.lib
   fi
   set_step C007 "clear common"
fi

echo "Clear concluido com sucesso !!!"

