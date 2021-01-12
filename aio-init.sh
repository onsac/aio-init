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

get_common && echo "0.1 - get common OK" || echo "0.1 - get common failed" | exit 1

. /tmp/.common.lib && echo "0.2 - set common OK" || echo "0.2 - set common failed" | exit 1

check_step 0
if [ "$?" -eq "0" ]; then
   is_root_user && set_step 0 "Usuário root OK" || echo "0 - Usuário root failed" | exit 1
fi

check_step 1
if [ "$?" -eq "0" ]; then
   yum update -y 2>/dev/null && set_step 1 "update OK" || echo "1 - update failed" | exit 1
fi

check_step 2
if [ "$?" -eq "0" ]; then
   yum install -y git 2>/dev/null && set_step 2 "Install git OK" || echo "2 - Install git failed" | exit 1
fi

check_step 3
if [ "$?" -eq "0" ]; then
   git --version 2>/dev/null && set_step 3 "git version OK" || echo "3 - git version failed" | exit 1
fi

check_step 4
if [ "$?" -eq "0" ]; then
   sudo useradd -d /$USER -m -c "AIO Integrador" -s /bin/bash $USER && set_step 4 "Useradd OK" || echo "4 - Useradd failed" | exit 1
fi

check_step 5
if [ "$?" -eq "0" ]; then
   echo $USER:$(pw2) | chpasswd && set_step 5 "chpasswd OK" || echo "5 - chpasswd failed" | exit 1
fi

check_step 6
if [ "$?" -eq "0" ]; then
   usermod -aG wheel $USER && set_step 6 "usermod OK" || echo "6 - usermod failed" | exit 1
fi

check_step 7
if [ "$?" -eq "0" ]; then
   sudo su - $USER && set_step 7 "sudo su OK" || echo "7 - sudo su failed" | exit 1
else
   sudo su - $USER 
fi

. /tmp/.common.lib && echo "7.1 - set common OK" || echo "7.1 - set common failed" | exit 1

check_step 8
if [ "$?" -eq "0" ]; then
   wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && set_step 8 "install nvm OK" || echo "8 - install nvm failed" | exit 1
fi

check_step 9
if [ "$?" -eq "0" ]; then
   source ~/.bash_profile && set_step 9 "set nvm OK" || echo "9 - set nvm failed" | exit 1
fi

check_step 10
if [ "$?" -eq "0" ]; then
   nvm install 11 2>/dev/null && set_step 10 "install nodejs OK" || echo "10 - install nodejs failed" | exit 1
fi

check_step 11
if [ "$?" -eq "0" ]; then
   nvm alias default 11 2>/dev/null && set_step 11 "set alias OK" || echo "11 - set alias failed" | exit 1
fi

check_step 12
if [ "$?" -eq "0" ]; then
   nvm use 11 && set_step 12 "set use OK" || echo "12 - set use failed" | exit 1
fi

check_step 131
if [ "$?" -eq "0" ]; then
   git init && set_step 131 "git config OK" || echo "131 - git config failed" | exit 1
fi

check_step 132
if [ "$?" -eq "0" ]; then
   git config --global credential.helper store && set_step 132 "git config OK" || echo "132 - git config failed" | exit 1
fi

check_step 14
if [ "$?" -eq "0" ]; then
   echo "http://onsac@bitbucket.org" > ~/.git-credentials  && set_step 14 "set git config OK" || echo "14 - set git config failed" | exit 1
fi

check_step 15
if [ "$?" -eq "0" ]; then
   GIT_ASKPASS=$(pw1) && set_step 15 "git config ASK OK" || echo "15 - git config ASK failed" | exit 1
fi

check_step 16
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop && set_step 16 "aiop OK" || echo "16 - aiop failed" | exit 1
fi

check_step 17
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-setup.git && set_step 17 "git clone aio-setup OK" || echo "17 - git clone aio-setup failed" | exit 1
fi

check_step 18
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup | npm install  && set_step 18 "npm install aio-setup OK" || echo "18 - npm install aio-setup failed" | exit 1
fi

check_step 19
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-ansible.git && set_step 19 "git clone aio-ansible OK" || echo "19 - git clone aio-ansible failed" | exit 1
fi

check_step 20
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-ansible | npm install  && set_step 20 "npm install aio-ansible OK" || echo "20 - npm install aio-ansible failed" | exit 1
fi

check_step 21
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-node-logs.git && set_step 21 "git clone aio-node-logs OK" || echo "21 - git clone aio-node-logs failed" | exit 1
fi

check_step 22
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-logs | npm install  && set_step 22 "npm install aio-node-logs OK" || echo "22 - npm install aio-node-logs failed" | exit 1
fi

check_step 23
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-node-api.git && set_step 23 "git clone aio-node-api OK" || echo "23 - git clone aio-node-api failed" | exit 1
fi

check_step 24
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-node-api | npm install  && set_step 24 "npm install aio-node-api OK" || echo "24 - npm install aio-node-api failed" | exit 1
fi

check_step 25
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-app.git && set_step 25 "git clone aio-app OK" || echo "25 - git clone aio-app failed" | exit 1
fi

check_step 26
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-app | npm install  && set_step 26 "npm install aio-app OK" || echo "26 - npm install aio-app failed" | exit 1
fi

check_step 27
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-api.git && set_step 27 "git clone aio-api OK" || echo "27 - git clone aio-api failed" | exit 1
fi

check_step 28
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-api | npm install  && set_step 28 "npm install aio-api OK" || echo "28 - npm install aio-api failed" | exit 1
fi

check_step 29
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | git clone http://onsac@bitbucket.org/onsac-aio/aio-node-snmp.git && set_step 29 "git clone aio-node-snmp OK" || echo "29 - git clone aio-node-snmp failed" | exit 1
fi

check_step 30
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-api | npm install  && set_step 30 "npm install aio-node-snmp OK" || echo "30 - npm install aio-node-snmp failed" | exit 1
fi

check_step 31
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml .production-aio-config-geral.yml && set_step 31 "ln geral OK" || echo "31 - ln geral failed" | exit 1
fi

check_step 32
if [ "$?" -eq "0" ]; then
   cd /aio/aiop | ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-regra.yml .production-aio-config-regra.yml && set_step 32 "ln regra OK" || echo "32 - ln regra failed" | exit 1
fi

check_step 33
if [ "$?" -eq "0" ]; then
   npm install -g pm2 2>/dev/null && set_step 33 "install pm2 OK" || echo "33 - install pm2 failed" | exit 1
fi

check_step 34
if [ "$?" -eq "0" ]; then
   pm2 install pm2-logrotate 2>/dev/null && set_step 34 "install pm2-logrotate OK" || echo "34 - install pm2-logrotate failed" | exit 1
fi

check_step 35
if [ "$?" -eq "0" ]; then
   pm2 link svnfgywh46k3e51 dlrucnwgh2w7bzs 2>/dev/null && set_step 35 "install pm2-link OK" || echo "35 - install pm2-link failed" | exit 1
fi

check_step 36
if [ "$?" -eq "0" ]; then
   STARTUP=$(pm2 startup | grep sudo | cut -c5-) && set_step 36 "install pm2-startup OK" || echo "36 - install pm2-startup failed" | exit 1
fi

check_step 37
if [ "$?" -eq "0" ]; then
   pw2 | sudo -S $STARTUP 2>/dev/null && set_step 37 "set pm2-startup OK" || echo "37 - set pm2-startup failed" | exit 1
fi


