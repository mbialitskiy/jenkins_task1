#!/bin/bash
sudo -i
yum install -y nginx net-tools vim 
sed -i "/^[' ']*location \/ {/a\\\tproxy_pass http:\/\/localhost:8080;" /etc/nginx/nginx.conf
systemctl start nginx

mkdir /home/vagrant/jenkins && cd /home/vagrant/jenkins

echo "Downloading java..."
wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u151-b12/e758a0de34e24606bca991d704f6dcbf/jdk-8u151-linux-x64.rpm > /dev/null 2>&1
rpm -Uvh /home/vagrant/jenkins/jdk-8u151-linux-x64.rpm 

echo "Downloading jenkins..."
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war >> /dev/null 2>&1

mkdir /root/.jenkins
tar -C /root/.jenkins/ -xvf /vagrant/jenkins.tar 
mkdir /root/.jenkins/plugins 
while read plugin_name
do
   echo "Downloading $plugin_name"	
   wget -q http://updates.jenkins-ci.org/latest/$plugin_name.hpi -P /root/.jenkins/plugins/
done < /vagrant/plug.txt
wget -q https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/scriptler/2.9/scriptler-2.9.hpi -P /root/.jenkins/plugins/

nohup bash -c "java -jar /home/vagrant/jenkins/jenkins.war & >> /home/vagrant/jenkins/out.log"  > /dev/null 2>&1






