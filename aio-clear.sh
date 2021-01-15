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
   systemctl stop mongod && set_step C006 "stop mongod OK" || stop_step C006 "stop mongod failed"
fi

check_step C007
if [ "$?" -eq "0" ]; then
   yum remove -y mongodb-org git python36 && set_step C007 "remove Packages OK" || stop_step C007 "remove Packages failed"
fi

check_step C008
if [ "$?" -eq "0" ]; then
   FILE3="/etc/yum.repos.d/mongodb-org-4.0.repo"
   if [ -f "$FILE3" ]; then
      rm -f /etc/yum.repos.d/mongodb-org-4.0.repo && set_step C008 "remove Packages 1 OK" || stop_step C008 "remove Packages failed"
   fi
fi

check_step C009
if [ "$?" -eq "0" ]; then
   FILE4="/etc/mongod.conf"
   if [ -f "$FILE4" ]; then
      rm -f /etc/mongod.conf && set_step C009 "remove Packages OK" || stop_step C009 "remove Packages 2 failed"
   fi
fi

check_step C010
if [ "$?" -eq "0" ]; then
   FILE5="/usr/lib/systemd/system/mongod.service"
   if [ -f "$FILE5" ]; then
      rm -f /usr/lib/systemd/system/mongod.service && set_step C010 "remove Packages OK" || stop_step C010 "remove Packages 3 failed"
   fi
fi

check_step C011
if [ "$?" -eq "0" ]; then
   FILE2="/tmp/.common.lib"
   if [ -f "$FILE2" ]; then
      rm -f /tmp/.common.lib
   fi
   set_step C011 "clear common"
fi

FILE1="/tmp/steps.txt"
if [ -f "$FILE1" ]; then
   rm -f /tmp/steps.txt
fi

echo "Clear concluido com sucesso !!!"

