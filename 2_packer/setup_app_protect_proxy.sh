
cat > /tmp/app-protext-proxy.conf <<EOF

    upstream cheese-backends {
		zone cheeses 64k;
	    server 127.0.0.1:8088;
	}

    server {
    listen       8089;
        server_name  appprotect;

        app_protect_enable on;
        app_protect_policy_file "/etc/nginx/NginxDefaultPolicy.json";
        app_protect_security_log_enable on;
        app_protect_security_log "/etc/nginx/log-default.json" syslog:server=localhost:514;

        location / {
		
		    health_check uri=/cheddar;
     		#client_max_body_size 0;
            default_type text/html;
            proxy_pass http://cheese-backends;
        }
    }

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


sudo mv /tmp/app-protext-proxy.conf /etc/nginx/conf.d/app-protext-proxy.conf


cat > /tmp/log-default.json <<EOF

{
    "filter": {
        "request_type": "all"
    },
    "content": {
        "format": "default",
        "max_request_size": "any",
        "max_message_size": "5k"
    }
}
EOF

sudo mv /tmp/log-default.json /etc/nginx/log-default.json
sudo nginx -s reload
