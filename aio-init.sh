#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Setup SO"
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

check_step 001
if [ "$?" -eq "0" ]; then
   get_common && set_step 001  "get common OK" || echo "001 - get common failed"; exit 1
else 
   get_common
fi

check_step 002
if [ "$?" -eq "0" ]; then
   . /tmp/.common.lib && set_step 002 "set common OK" || echo "002 - set common failed"; exit 1
else
   . /tmp/.common.lib
fi

check_step 003
if [ "$?" -eq "0" ]; then
   is_root_user && set_step 003 "Usuário root OK" || echo "003 - Usuário root failed"; exit 1
fi

check_step 004
if [ "$?" -eq "0" ]; then
   yum update -y 2>/dev/null && set_step 004 "update OK" || echo "004 - update failed"; exit 1
fi

check_step 005
if [ "$?" -eq "0" ]; then
   yum install -y git 2>/dev/null && set_step 005 "Install git OK" || echo "005 - Install git failed"; exit 1
fi

check_step 006
if [ "$?" -eq "0" ]; then
   git --version 2>/dev/null && set_step 006 "git version OK" || echo "006 - git version failed"; exit 1
fi

check_step 007
if [ "$?" -eq "0" ]; then
   sudo useradd -d /$USER -m -c "AIO Integrador" -s /bin/bash $USER && set_step 007 "Useradd OK" || echo "007 - Useradd failed"; exit 1
fi

check_step 008
if [ "$?" -eq "0" ]; then
   echo $USER:$(pw2) | chpasswd && set_step 008 "chpasswd OK" || echo "008 - chpasswd failed"; exit 1
fi

check_step 009
if [ "$?" -eq "0" ]; then
   usermod -aG wheel $USER && set_step 009 "usermod OK" || echo "009 - usermod failed"; exit 1
fi

check_step 010
if [ "$?" -eq "0" ]; then
   sudo su - $USER && set_step 010 "sudo su OK" || echo "010 - sudo su failed"; exit 1
else
   sudo su - $USER 
fi

check_step 011
if [ "$?" -eq "0" ]; then
   . /tmp/.common.lib && set_step 011 "set common OK" || echo "011 - set common failed"; exit 1
else
   . /tmp/.common.lib
fi

check_step 012
if [ "$?" -eq "0" ]; then
   wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && set_step 012 "install nvm OK" || echo "012 - install nvm failed"; exit 1
fi

check_step 013
if [ "$?" -eq "0" ]; then
   source ~/.bash_profile && set_step 013 "set nvm OK" || echo "013 - set nvm failed"; exit 1
fi

check_step 014
if [ "$?" -eq "0" ]; then
   nvm install 11 2>/dev/null && set_step 014 "install nodejs OK" || echo "014 - install nodejs failed"; exit 1
fi

check_step 015
if [ "$?" -eq "0" ]; then
   nvm alias default 11 2>/dev/null && set_step 015 "set alias OK" || echo "015 - set alias failed"; exit 1
fi

check_step 016
if [ "$?" -eq "0" ]; then
   nvm use 11 && set_step 016 "set use OK" || echo "016 - set use failed"; exit 1
fi

check_step 017
if [ "$?" -eq "0" ]; then
   git init && set_step 017 "git config OK" || echo "017 - git config failed"; exit 1
fi

check_step 018
if [ "$?" -eq "0" ]; then
   git config --global credential.helper store && set_step 018 "git config OK" || echo "018 - git config failed"; exit 1
fi

check_step 019
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop && set_step 019 "aiop OK" || echo "019 - aiop failed"; exit 1
fi

check_step 020
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-setup.git && set_step 020 "git clone aio-setup OK" || echo "020 - git clone aio-setup failed"; exit 1
fi

check_step 021
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 021 "npm install aio-setup OK" || echo "021 - npm install aio-setup failed"; exit 1
fi

check_step 022
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-ansible.git && set_step 022 "git clone aio-ansible OK" || echo "022 - git clone aio-ansible failed"; exit 1
fi

check_step 023
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-ansible
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 023 "npm install aio-ansible OK" || echo "023 - npm install aio-ansible failed"; exit 1
fi

check_step 024
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-logs.git && set_step 024 "git clone aio-node-logs OK" || echo "024 - git clone aio-node-logs failed"; exit 1
fi

check_step 025
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-logs
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 025 "npm install aio-node-logs OK" || echo "025 - npm install aio-node-logs failed"; exit 1
fi

check_step 026
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-api.git && set_step 026 "git clone aio-node-api OK" || echo "026 - git clone aio-node-api failed"; exit 1
fi

check_step 027
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-api
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 027 "npm install aio-node-api OK" || echo "027 - npm install aio-node-api failed"; exit 1
fi

check_step 028
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-app.git && set_step 028 "git clone aio-app OK" || echo "028 - git clone aio-app failed"; exit 1
fi

check_step 029
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-app
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 029 "npm install aio-app OK" || echo "029 - npm install aio-app failed"; exit 1
fi

check_step 030
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-api.git && set_step 030 "git clone aio-api OK" || echo "030 - git clone aio-api failed"; exit 1
fi

check_step 031
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-api
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 031 "npm install aio-api OK" || echo "031 - npm install aio-api failed"; exit 1
fi

check_step 032
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aio/aio-node-snmp.git && set_step 032 "git clone aio-node-snmp OK" || echo "032 - git clone aio-node-snmp failed"; exit 1
fi

check_step 033
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-api
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step 033 "npm install aio-node-snmp OK" || echo "033 - npm install aio-node-snmp failed"; exit 1
fi

check_step 034
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml .production-aio-config-geral.yml && set_step 034 "ln geral OK" || echo "034 - ln geral failed"; exit 1
fi

check_step 035
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-regra.yml .production-aio-config-regra.yml && set_step 035 "ln regra OK" || echo "035 - ln regra failed"; exit 1
fi

check_step 036
if [ "$?" -eq "0" ]; then
   npm install -g pm2 2>/dev/null && set_step 036 "install pm2 OK" || echo "036 - install pm2 failed"; exit 1
fi

check_step 037
if [ "$?" -eq "0" ]; then
   pm2 install pm2-logrotate 2>/dev/null && set_step 037 "install pm2-logrotate OK" || echo "037 - install pm2-logrotate failed"; exit 1
fi

check_step 038
if [ "$?" -eq "0" ]; then
   pm2 link svnfgywh46k3e51 dlrucnwgh2w7bzs 2>/dev/null && set_step 038 "install pm2-link OK" || echo "038 - install pm2-link failed"; exit 1
fi

check_step 039
if [ "$?" -eq "0" ]; then
   STARTUP=$(pm2 startup | grep sudo | cut -c5-) && set_step 039 "install pm2-startup OK" || echo "039 - install pm2-startup failed"; exit 1
else 
   STARTUP=$(pm2 startup | grep sudo | cut -c5-) 
fi

check_step 040
if [ "$?" -eq "0" ]; then
   ASKPASS=$(pw2)
   echo $ASKPASS | sudo -kS "${STARTUP}" && set_step 040 "set pm2-startup OK" || echo "040 - set pm2-startup failed"; exit 1
fi


