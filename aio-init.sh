#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Setup SO"
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

check_step 001
if [ "$?" -eq "0" ]; then
   echo "" && set_step 001  "get common OK" || stop_step 001 "get common failed"
fi

check_step 002
if [ "$?" -eq "0" ]; then
   echo "" && set_step 002 "set common OK" || stop_step 002 "set common failed"
fi

check_step 003
if [ "$?" -eq "0" ]; then
   is_root_user && set_step 003 "Usuário root OK" || stop_step 003 "Usuário root failed"
fi

check_step 004
if [ "$?" -eq "0" ]; then
   yum update -y 2>/dev/null && set_step 004 "update OK" || stop_step 004 "update failed"
fi

check_step 005
if [ "$?" -eq "0" ]; then
   yum install -y git python36 2>/dev/null && set_step 005 "Install git OK" || stop_step 005 "Install git failed"
fi

check_step 006
if [ "$?" -eq "0" ]; then
   git --version 2>/dev/null && set_step 006 "git version OK" || stop_step 006 "git version failed"
fi

check_step 007
if [ "$?" -eq "0" ]; then
   sudo useradd -d /$USER -m -c "AIO Integrador" -s /bin/bash $USER && set_step 007 "Useradd OK" || stop_step 007 "Useradd failed"
fi

check_step 040
if [ "$?" -eq "0" ]; then
   echo "$USER ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers && set_step 040 "set sudo OK" || stop_step 040 "set sudo failed"
   echo "NODE_NO_WARNINGS=1" >>/etc/environment
fi

check_step 008
if [ "$?" -eq "0" ]; then
   echo $USER:$(pw2) | chpasswd && set_step 008 "chpasswd OK" || stop_step 008 "chpasswd failed"
fi

check_step 009
if [ "$?" -eq "0" ]; then
   usermod -aG wheel $USER && set_step 009 "usermod OK" || stop_step 009 "usermod failed"
fi

check_step 010
if [ "$?" -eq "0" ]; then
   sudo su - $USER && set_step 010 "sudo su OK" || stop_step 010 "sudo su failed"
else
   sudo su - $USER 
fi

. /tmp/.common.lib

check_step 011
if [ "$?" -eq "0" ]; then
   echo "" && set_step 011 "set common OK" || stop_step 011 "set common failed"
fi

check_step 012
if [ "$?" -eq "0" ]; then
   wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && set_step 012 "install nvm OK" || stop_step 012 "install nvm failed"
fi

check_step 013
if [ "$?" -eq "0" ]; then
   source ~/.bash_profile && set_step 013 "set nvm OK" || stop_step 013 "set nvm failed"
fi

check_step 014
if [ "$?" -eq "0" ]; then
   nvm install 11 2>/dev/null && set_step 014 "install nodejs OK" || stop_step 014 "install nodejs failed"
fi

check_step 015
if [ "$?" -eq "0" ]; then
   nvm alias default 11 2>/dev/null && set_step 015 "set alias OK" || stop_step 015 "set alias failed"
fi

check_step 016
if [ "$?" -eq "0" ]; then
   nvm use 11 && set_step 016 "set use OK" || stop_step 016 "set use failed"
fi

check_step 017
if [ "$?" -eq "0" ]; then
   git init && set_step 017 "git config OK" || stop_step 017 "git config failed"
fi

check_step 018
if [ "$?" -eq "0" ]; then
   git config --global credential.helper store && set_step 018 "git config OK" || stop_step 018 "git config failed"
fi

check_step 019
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop && set_step 019 "aiop OK" || stop_step 019 "aiop failed"
fi

check_step 020
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-setup.git && set_step 020 "git clone aio-setup OK" || stop_step 020 "git clone aio-setup failed"
fi

check_step 021
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 021 "npm install aio-setup OK" || stop_step 021 "npm install aio-setup failed"
fi

check_step 022
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-ansible.git && set_step 022 "git clone aio-ansible OK" || stop_step 022 "git clone aio-ansible failed"
fi

check_step 023
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-ansible
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 023 "npm install aio-ansible OK" || stop_step 023 "npm install aio-ansible failed"
fi

check_step 024
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-logs.git && set_step 024 "git clone aio-node-logs OK" || stop_step 024 "git clone aio-node-logs failed"
fi

check_step 025
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-logs
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 025 "npm install aio-node-logs OK" || stop_step 025 "npm install aio-node-logs failed"
fi

check_step 026
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-api.git && set_step 026 "git clone aio-node-api OK" || stop_step 026 "git clone aio-node-api failed"
fi

check_step 027
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-api
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 027 "npm install aio-node-api OK" || stop_step 027 "npm install aio-node-api failed"
fi

check_step 028
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-app.git && set_step 028 "git clone aio-app OK" || stop_step 028 "git clone aio-app failed"
fi

check_step 029
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-app
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 029 "npm install aio-app OK" || stop_step 029 "npm install aio-app failed"
fi

check_step 030
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-api.git && set_step 030 "git clone aio-api OK" || stop_step 030 "git clone aio-api failed"
fi

check_step 031
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-api
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 031 "npm install aio-api OK" || stop_step 031 "npm install aio-api failed"
fi

check_step 032
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-snmp.git && set_step 032 "git clone aio-node-snmp OK" || stop_step 032 "git clone aio-node-snmp failed"
fi

check_step 033
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-snmp
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 033 "npm install aio-node-snmp OK" || stop_step 033 "npm install aio-node-snmp failed"
fi

check_step 034
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml .production-aio-config-geral.yml && set_step 034 "ln geral OK" || stop_step 034 "ln geral failed"
fi

check_step 035
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-regra.yml .production-aio-config-regra.yml && set_step 035 "ln regra OK" || stop_step 035 "ln regra failed"
fi

check_step 036
if [ "$?" -eq "0" ]; then
   npm install -g pm2 2>/dev/null && set_step 036 "install pm2 OK" || stop_step 036 "install pm2 failed"
fi

check_step 037
if [ "$?" -eq "0" ]; then
   pm2 install pm2-logrotate 2>/dev/null && set_step 037 "install pm2-logrotate OK" || stop_step 037 "install pm2-logrotate failed"
fi

check_step 038
if [ "$?" -eq "0" ]; then
   pm2 link svnfgywh46k3e51 dlrucnwgh2w7bzs 2>/dev/null && set_step 038 "install pm2-link OK" || stop_step 038 "install pm2-link failed"
fi

check_step 039
if [ "$?" -eq "0" ]; then
   STARTUP=$(pm2 startup | grep sudo | cut -b 6-) && set_step 039 "install pm2-startup OK" || stop_step 039 "install pm2-startup failed"
else 
   STARTUP=$(pm2 startup | grep sudo | cut -b 6-) 
fi

#check_step 041
#if [ "$?" -eq "0" ]; then
#   sudo -s $STARTUP && set_step 041 "set pm2-startup OK" || stop_step 041 "set pm2-startup failed"
#fi

check_step 042
if [ "$?" -eq "0" ]; then
   CMD1="wget --no-cache -O /etc/security/limits.conf  http://raw.githubusercontent.com/onsac/aio-init/main/limits.conf"
   sudo -s $CMD1 && set_step 042 "set limits OK" || stop_step 042 "set limits failed"
fi

check_step 043
if [ "$?" -eq "0" ]; then
   CMD2="systemctl stop firewalld"
   sudo -s $CMD2 && set_step 043 "stop firewalld OK" || stop_step 043 "stop firewalld failed"
fi

check_step 044
if [ "$?" -eq "0" ]; then
   CMD3="systemctl disable firewalld"
   sudo -s $CMD3 && set_step 044 "disable firewalld OK" || stop_step 044 "disable firewalld failed"
fi

check_step 045
if [ "$?" -eq "0" ]; then
   CMD4="wget --no-cache -O /etc/yum.repos.d/mongodb-org-4.0.repo  http://raw.githubusercontent.com/onsac/aio-init/main/mongodb-org-4.0.repo"
   sudo -s $CMD4 && set_step 045 "mongodb-org-4.0.repo OK" || stop_step 045 "mongodb-org-4.0.repo failed"
fi

check_step 046
if [ "$?" -eq "0" ]; then
   CMD5="sudo yum install -y mongodb-org"
   sudo -s $CMD5 && set_step 046 "install mongodb-org OK" || stop_step 046 "install mongodb-org failed"
fi

check_step 047
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf && set_step 047 "set bindIp OK" || stop_step 047 "set bindIp failed"
fi

check_step 048
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/=-f/=--quiet -f/' /usr/lib/systemd/system/mongod.service && set_step 048 "set mongod conf OK" || stop_step 048 "set mongod conf failed"
fi

check_step 049
if [ "$?" -eq "0" ]; then
   sudo systemctl daemon-reload && set_step 049 "daemon-reload OK" || stop_step 049 "daemon-reload failed"
fi

check_step 050
if [ "$?" -eq "0" ]; then
   sudo systemctl start mongod && set_step 050 "start mongod OK" || stop_step 050 "start mongod failed"
fi

check_step 051
if [ "$?" -eq "0" ]; then
   sudo systemctl enable mongod && set_step 051 "enable mongod OK" || stop_step 051 "enable mongod failed"
fi

check_step 052
if [ "$?" -eq "0" ]; then
   sudo echo -e "use admin \ndb.createUser({user:'admin',pwd:'$(pw2)',roles:[{role:'userAdminAnyDatabase',db:'admin'}]})" >/tmp/.db.js && set_step 052 "set admin OK" || stop_step 052 "set admin failed"
fi

check_step 053
if [ "$?" -eq "0" ]; then
   sudo echo -e "use aio \ndb.createUser({user:'aiouser',pwd:'$(pw2)',roles:[{role:'readWrite',db:'aio'},{role:'userAdmin',db:'admin'},{role:'userAdminAnyDatabase',db:'admin'}]})" >>/tmp/.db.js && set_step 053 "set aiouser OK" || stop_step 053 "set aiouser failed"
fi

check_step 054
if [ "$?" -eq "0" ]; then
   sudo mongo < /tmp/.db.js && set_step 054 "create admin users OK" || stop_step 054 "create admin users failed"
fi

check_step 055
if [ "$?" -eq "0" ]; then
   sudo rm -f /tmp/.db.js && set_step 055 "clear temp OK" || stop_step 055 "clear temp failed"
fi

check_step 056
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/#security:/#security: \nsecurity: \n  authorization: enabled /' /etc/mongod.conf && set_step 056 "set security OK" || stop_step 056 "set security failed"
fi

check_step 057
if [ "$?" -eq "0" ]; then
   sudo systemctl restart mongod && set_step 057 "restart mongod OK" || stop_step 057 "restart mongod failed"
fi

check_step 058
if [ "$?" -eq "0" ]; then
   PWDB=$(pw2)
   CMDDB=$(echo -e "use aio \ndb.auth('aiouser', '$PWDB')")
   sudo mongo <<< """$CMDDB"""  && set_step 058 "test login OK" || stop_step 058 "test login failed"
fi

check_step 059
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node setupUsers admin $(pw2) true n && set_step 059 "cread admin user OK" || stop_step 059 "cread admin user failed"
fi

check_step 060
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node setupUsers aiointegrador $(pw2) true s && set_step 060 "cread aioapi user OK" || stop_step 060 "cread aioapi user failed"
fi

check_step 061
if [ "$?" -eq "0" ]; then
   HOST=$(hostname)
   sed -i -e "s/aio.onsac.com/$HOST/g" /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml && set_step 061 "set hostname OK" || stop_step 061 "set hostname failed"
fi

check_step 062
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   PWAIO=$(pw2)
   HASH=$(node set_hash.js $PWAIO)
   sed -i -e "s/<hash senha ansible>/$HASH/g" /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml && set_step 062 "set hash ansible OK" || stop_step 062 "set hash ansible failed"
fi

check_step 063
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   PWAIO=$(pw2)
   HASH=$(node set_hash.js $PWAIO)
   sed -i -e "s/<hash senha control-m>/$HASH/g" /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml && set_step 063 "set hash control-m OK" || stop_step 063 "set hash control-m failed"
fi

check_step 064
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   PWAIO=$(pw2)
   HASH=$(node set_hash.js $PWAIO)
   sed -i -e "s/<hash senha integrador>/$HASH/g" /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml && set_step 064 "set hash aio OK" || stop_step 064 "set hash aio failed"
fi

check_step 065
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node aio-start.js && set_step 065 "start aio modules OK" || stop_step 065 "start aio modules failed"
fi

check_step 066
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
    pm2 save --force && set_step 066 "pm2 save OK" || stop_step 066 "pm2 save failed"
fi

check_step 067
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
    pm2 list && set_step 067 "aio integrador status OK" || stop_step 067 "aio integrador status failed"
fi

echo "Instalação concluida com sucesso !!!"

