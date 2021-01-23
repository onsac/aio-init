#!/bin/bash
ID=$1
echo "$$" > /var/run/aio-setup.pid
echo "$ID" >/tmp/aio-setup.id

get_common()
{
   wget -N --level=1 --no-cache --no-cookies --no-check-certificate -O /tmp/.common.lib http://raw.githubusercontent.com/onsac/aio-init/main/common.lib 2>/dev/null
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
   echo "" && set_step "get common" || stop_step "get common"
fi
check_step
if [ "$?" -eq "0" ]; then
   echo ""  && set_step "set common" || stop_step "set common"
fi

check_step
if [ "$?" -eq "0" ]; then
   check_url=$(echo 'https://raw.githubusercontent.com/onsac/aio-init/main/subscriptions/'${ID}'.json')
   wget --no-cache --no-cookies --no-check-certificate -O /tmp/.${ID}.json ${check_url} && set_step "check customer node ID : ${ID}" || stop_step "check customer node ID : ${ID}"
fi

check_step
if [ "$?" -eq "0" ]; then
   curl https://raw.githubusercontent.com/git-ftp/git-ftp/master/git-ftp > /bin/git-ftp && set_step "download git-ftp" || stop_step "download git-ftp"
fi

check_step
if [ "$?" -eq "0" ]; then
   chmod 755 /bin/git-ftp && set_step "chmod git-ftp" || stop_step "chmod git-ftp"
fi

su - aio

#######


. /tmp/.common.lib 


######

cont_step

check_step
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop/aio-license && set_step "create aio-license" || stop_step "create aio-license"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   git init && set_step "init aio-license" || stop_step "init aio-license"
fi

echo "ID = $ID"

check_step
if [ "$?" -eq "0" ]; then
   get_license $ID && set_step "get aio-license" || stop_step "get aio-license"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   upload-setup $ID && set_step "upload aio-license" || stop_step "upload aio-license"
fi

sudo rm -rf /tmp/.common.lib /tmp/aio-setup.step /tmp/aio-setup.count /tmp/AIO-* /tmp/pm2-startup.sh

print_line
echo FIM
print_line
