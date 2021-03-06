#!/bin/bash
#########################################################
# SCOUT 2.0  - SETUP                                    #
# OnSAC - 10/01/2020                                    #
#########################################################
declare -r LTRUE=0
declare -r LFALSE=1
declare -r ID=$1
echo "$$" > /var/run/aio-setup.pid
echo "$ID" >/tmp/aio-setup.id

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

exec > >(tee ${LOG_FILE}) 2>&1

print_line
echo "SCOUT 2.0 - SETUP"
print_line

check_step
if [ "$?" -eq "0" ]; then
   echo "" && set_step "get common" || stop_step "get common"
fi

check_step
if [ "$?" -eq "0" ]; then
   echo "" && set_step "set common" || stop_step "set common"
fi

check_step
if [ "$?" -eq "0" ]; then
   is_root_user && set_step "check root user" || stop_step "check root user"
fi

check_step
if [ "$?" -eq "0" ]; then
   check_url=$(echo 'https://raw.githubusercontent.com/onsac/aio-init/main/subscriptions/'${ID}'.json')
   wget --no-cache --no-cookies --no-check-certificate -O /tmp/.${ID}.json ${check_url} && set_step "check customer node ID : ${ID}" || stop_step "check customer node ID : ${ID}"
fi

check_step
if [ "$?" -eq "0" ]; then
   yum update -y 2>/dev/null && set_step "yum update" || stop_step "yum update"
fi

check_step
if [ "$?" -eq "0" ]; then
   yum install -y git python27 2>/dev/null && set_step "Install git and python" || stop_step "Install git and python"
fi

check_step
if [ "$?" -eq "0" ]; then
   git --version 2>/dev/null && set_step "git version" || stop_step "git version"
fi

check_step
if [ "$?" -eq "0" ]; then
   curl https://raw.githubusercontent.com/git-ftp/git-ftp/master/git-ftp > /bin/git-ftp && set_step "download git-ftp" || stop_step "download git-ftp"
fi

check_step
if [ "$?" -eq "0" ]; then
   chmod 755 /bin/git-ftp && set_step "chmod git-ftp" || stop_step "chmod git-ftp"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo useradd -d /$USER -m -c "AIO Integrador" -s /bin/bash $USER && set_step "Useradd" || stop_step "Useradd"
fi

check_step
if [ "$?" -eq "0" ]; then
   echo "$USER ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers && set_step "set sudo" || stop_step "set sudo"
   echo "NODE_NO_WARNINGS=1" >>/etc/environment
fi

check_step
if [ "$?" -eq "0" ]; then
   echo $USER:$(pw2) | chpasswd && set_step "chpasswd" || stop_step "chpasswd"
fi

check_step 
if [ "$?" -eq "0" ]; then
   usermod -aG wheel $USER && set_step "usermod" || stop_step "usermod"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo su - $USER && set_step "sudo su" || stop_step "sudo su"
else
   sudo su - $USER 
fi

. /tmp/.common.lib

cont_step

check_step
if [ "$?" -eq "0" ]; then
   wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash && set_step "install nvm" || stop_step "install nvm"
fi

check_step
if [ "$?" -eq "0" ]; then
   source ~/.bash_profile && set_step "set bash_profile" || stop_step "set bash_profile"
fi

check_step
if [ "$?" -eq "0" ]; then
   nvm install 11 2>/dev/null && set_step "install nodejs" || stop_step "install nodejs"
fi

check_step
if [ "$?" -eq "0" ]; then
   nvm alias default 11 2>/dev/null && set_step "nvm alias" || stop_step "nvm alias"
fi

check_step
if [ "$?" -eq "0" ]; then
   nvm use 11 && set_step "nvm use" || stop_step "nvm use"
fi

check_step
if [ "$?" -eq "0" ]; then
   git init && set_step "git init" || stop_step "git init"
fi

check_step
if [ "$?" -eq "0" ]; then
   git config --global credential.helper store && set_step "git config" || stop_step "git config"
fi

check_step
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop && set_step "mkdir aiop" || stop_step "mkdir aiop"
fi

check_step
if [ "$?" -eq "0" ]; then
   npm config set python /usr/bin/python2.7  && set_step "npm config set python" || stop_step "npm config set python"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aioc/aio-setup.git && set_step "git clone aio-setup" || stop_step "git clone aio-setup"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step "npm install aio-setup" || stop_step "npm install aio-setup"
fi

if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   git clone http://${TOKEN}@bitbucket.org/onsac-aioc/scout-app.git && set_step "git clone scout-app" || stop_step "git clone scout-app"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/scout-app
   npm --loglevel=error audit fix --force; npm --loglevel=error install && set_step "npm install scout-app" || stop_step "npm install scout-app"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-geral.yml .production-aio-config-geral.yml && set_step "ln config geral" || stop_step "ln config geral"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
   ln -s /aio/aiop/aio-setup/.aio/aio-prd-config-regra.yml .production-aio-config-regra.yml && set_step "ln config regra" || stop_step "ln config regra"
fi

check_step
if [ "$?" -eq "0" ]; then
   npm install -g pm2 2>/dev/null && set_step "install pm2" || stop_step "npm install pm2"
fi

check_step
if [ "$?" -eq "0" ]; then
   pm2 install pm2-logrotate 2>/dev/null && set_step "install pm2-logrotate" || stop_step "pm2 install pm2-logrotate"
fi

check_step
if [ "$?" -eq "0" ]; then
   pm2 link svnfgywh46k3e51 dlrucnwgh2w7bzs 2>/dev/null && set_step "install pm2-link" || stop_step "pm2 install pm2-link"
fi

check_step
if [ "$?" -eq "0" ]; then
   pm2 startup | grep sudo | cut -b 6- >/tmp/pm2-startup.sh && set_step "install pm2-startup" || stop_step "pm2 install pm2-startup"
fi

check_step
if [ "$?" -eq "0" ]; then
   chmod 777 /tmp/pm2-startup.sh | sudo bash /tmp/pm2-startup.sh  && set_step "pm2-startup" || stop_step "pm2-startup"
fi

check_step
if [ "$?" -eq "0" ]; then
   CMD1="wget --no-cache -O /etc/security/limits.conf  http://raw.githubusercontent.com/onsac/aio-init/main/limits.conf"
   sudo -s $CMD1 && set_step "set so limits" || stop_step "set so limits"
fi

check_step
if [ "$?" -eq "0" ]; then
   CMD2="systemctl stop firewalld"
   sudo -s $CMD2 && set_step "stop firewalld" || stop_step "stop firewalld"
fi

check_step
if [ "$?" -eq "0" ]; then
   CMD3="systemctl disable firewalld"
   sudo -s $CMD3 && set_step "disable firewalld" || stop_step "disable firewalld"
fi

check_step 
if [ "$?" -eq "0" ]; then
   CMD4="wget --no-cache -O /etc/yum.repos.d/mongodb-org-4.0.repo  http://raw.githubusercontent.com/onsac/aio-init/main/mongodb-org-4.0.repo"
   sudo -s $CMD4 && set_step "mongodb-org-4.0.repo" || stop_step "mongodb-org-4.0.repo"
fi

check_step 
if [ "$?" -eq "0" ]; then
   CMD5="sudo yum install -y mongodb-org"
   sudo -s $CMD5 && set_step "install mongodb-org" || stop_step "install mongodb-org"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf && set_step "set bindIp" || stop_step "set bindIp"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/=-f/=--quiet -f/' /usr/lib/systemd/system/mongod.service && set_step "set mongod service" || stop_step "set mongod service"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo systemctl daemon-reload && set_step "daemon-reload" || stop_step "service daemon-reload"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo systemctl start mongod && set_step "start mongod" || stop_step "service start mongod"
fi

check_step 
if [ "$?" -eq "0" ]; then
   sudo systemctl enable mongod && set_step "enable mongod" || stop_step "service enable mongod"
fi

check_step 
if [ "$?" -eq "0" ]; then
   sudo echo -e "use admin \ndb.createUser({user:'admin',pwd:'$(pw2)',roles:[{role:'userAdminAnyDatabase',db:'admin'}]})" >/tmp/.db.js && set_step "set admin user" || stop_step "set admin user"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo echo -e "use aio \ndb.createUser({user:'aiouser',pwd:'$(pw2)',roles:[{role:'readWrite',db:'aio'},{role:'userAdmin',db:'admin'},{role:'userAdminAnyDatabase',db:'admin'}]})" >>/tmp/.db.js && set_step  "set aiouser user" || stop_step "set aiouser user"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo echo -e "use scout \ndb.createUser({user:'scoutuser',pwd:'$(pw2)',roles:[{role:'readWrite',db:'scout'},{role:'userAdmin',db:'admin'},{role:'userAdminAnyDatabase',db:'admin'}]})" >>/tmp/.db.js && set_step  "set scoutuser user" || stop_step "set scoutuser user"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo mongo < /tmp/.db.js && set_step "create admin users" || stop_step "create admin users"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo rm -f /tmp/.db.js && set_step "clear db temp" || stop_step "clear db temp"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo sed -i -e 's/#security:/#security: \nsecurity: \n  authorization: enabled /' /etc/mongod.conf && set_step "set mongodb security" || stop_step "set mongodb security"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo systemctl restart mongod && set_step "service restart mongod" || stop_step "service restart mongod"
fi

check_step
if [ "$?" -eq "0" ]; then
   PWDB=$(pw2)
   CMDDB=$(echo -e "use aio \ndb.auth('aiouser', '$PWDB')")
   sudo mongo <<< """$CMDDB"""  && set_step "test mongodb login" || stop_step "test mongodb login"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node setupUsers admin $(pw2) true n && set_step "cread aio admin user" || stop_step "cread aio admin user"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node setupUsers aiointegrador $(pw2) true s && set_step "cread aio api user" || stop_step "cread aio api user"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-setup
   node scout-start.js && set_step "start scout modules" || stop_step "start scout modules"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
    pm2 save --force && set_step "pm2 save" || stop_step "pm2 save"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop
    pm2 list && set_step "scout status" || stop_step "scout status"
fi

check_step
if [ "$?" -eq "0" ]; then
   mkdir /aio/aiop/aio-license && set_step "create aio-license" || stop_step "create aio-license"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   git init && set_step "init aio-license" || stop_step "init aio-license"
fi

cont_step

check_step
if [ "$?" -eq "0" ]; then
   get_license $ID && set_step "get aio-license" || stop_step "get aio-license"
else 
   get_license $ID 
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   set_upload && set_step "set upload aio-license" || stop_step "set upload aio-license"
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   reg_setup $ID && set_step "reg-setup" || stop_step "reg-setup"
else 
   reg_setup $ID
fi

check_step
if [ "$?" -eq "0" ]; then
   cd /aio/aiop/aio-license
   upload_setup $ID && set_step "upload aio-license" || stop_step "upload aio-license"
fi

check_step
if [ "$?" -eq "0" ]; then
   sudo rm -rf /tmp/.*.lib /tmp/*.step /tmp/*.count /tmp/*.id /tmp/.*.json /tmp/pm2*.sh && echo "clear all temp files" || echo "clear all temp files"
fi

print_line
echo "Instalação concluida com sucesso !!!"
print_line



