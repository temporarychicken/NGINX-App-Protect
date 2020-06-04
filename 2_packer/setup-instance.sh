#!/bin/sh
#sudo wget https://github.com/nginxinc/nginx-asg-sync/releases/download/v0.4-1/nginx-asg-sync-0.4-1.amzn2.x86_64.rpm
#sudo yum install nginx-asg-sync-0.4-1.amzn2.x86_64.rpm -y
#sudo rm nginx-asg-sync-0.4-1.amzn2.x86_64.rpm

cat > /tmp/appdemo.conf <<EOF

server {
  listen 8080;
  location /api {
    api write=on;
  }
  location /dashboard.html {
    root /usr/share/nginx/html;
  }
}
EOF

sudo mv /tmp/appdemo.conf /etc/nginx/conf.d/appdemo.conf
sudo nginx -s reload

