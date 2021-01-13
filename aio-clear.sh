#!/bin/bash
echo "======================================================================================"
echo "AIO INTEGRADOR 2.0 - Clear SO"
echo "======================================================================================"
rm /tmp/steps.txt
rm /tmp/.common.lib
su aio -c 'pm2 kill'
userdel -r aio
