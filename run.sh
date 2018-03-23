#!/bin/bash

now=`date --date='0 days ago' "+%Y%m%d%H%M%S"`

echo "=====Step1 jmeter"
cmd2="/jmeter/apache-jmeter-3.3/bin/jmeter -n -t ${ENV_JMX_FILE_NAME}.jmx -l ${ENV_JMX_FILE_NAME}_${now}.jtl -e -o ${ENV_JMX_FILE_NAME}_${now} -R${ENV_SLAVES}"
eval ${cmd2}

echo "=====Step2 scp"

#scp jtl
chmod 600 hostkey
tjtl="/home/core/nginx/html/jmetertest/jtl"
cmd3="ssh -i hostkey -o \"StrictHostKeyChecking no\" core@${ENV_PROXY_IP} \"[ -d ${tjtl}/ ] && echo ok || mkdir -p ${tjtl}/\""
eval ${cmd3}

cmd4="scp -i hostkey -o \"StrictHostKeyChecking no\" ${ENV_JMX_FILE_NAME}_${now}.jtl core@${ENV_PROXY_IP}:${tjtl}/"
eval ${cmd4}

#scp report
treport="/home/core/nginx/html/jmetertest/report"
cmd5="ssh -i hostkey -o \"StrictHostKeyChecking no\"  core@${ENV_PROXY_IP} \"[ -d ${treport}/ ] && echo ok || mkdir -p ${treport}/\""
eval ${cmd5}

cmd7="scp -r ${ENV_JMX_FILE_NAME}_${now} -i hostkey -o \"StrictHostKeyChecking no\"  core@${ENV_PROXY_IP}:${treport}/"
eval ${cmd6}

echo "=====End JMeter Test ${ENV_JMX_FILE_NAME} on $now"
