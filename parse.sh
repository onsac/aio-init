#!/bin/bash
string=$(cat /tmp/AIO-74A077XZ.json)
IFS=',' read -r -a array <<< "$string"
subscription=$(echo ${array[0]} | sed 's/{subscription://')
cnpj=$(echo ${array[1]} | sed 's/cnpj://')
customer=$(echo ${array[2]} | sed 's/customer://')
sponsorName=$(echo ${array[3]} | sed 's/sponsorName://')
sponsorEmail=$(echo ${array[4]} | sed 's/sponsorEmail://')
contact=$(echo ${array[5]} | sed 's/contact://')
type=$(echo ${array[6]} | sed 's/type://')
customerNodeId=$(echo ${array[7]} | sed 's/customerNodeId://')
license=$(echo ${array[8]} | sed 's/license://' | sed 's/.$//')


echo $subscription
echo $cnpj
echo $customer
echo $sponsorName
echo $sponsorEmail
echo $contact
echo $type
echo $customerNodeId
echo $license
