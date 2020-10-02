
cat > /tmp/app-protext-proxy.conf <<EOF
    upstream cheese-backend {
        zone cheeses1 64k;
        server 127.0.0.1:8088;
    }
    upstream apipolicy-cheese-backends {
        zone cheeses1 64k;
        server 127.0.0.1:8090;
    }
    upstream defaultpolicy-cheese-backends {
        zone cheeses2 64k;
        server 127.0.0.1:8091;
    }
    upstream strictpolicy-cheese-backends {
        zone cheeses3 64k;
        server 127.0.0.1:8092;
    }


    server {
    listen       8089;
        server_name  appprotect;
        location /apipolicy/ {  
          proxy_pass http://apipolicy-cheese-backends/;
        }
        location /defaultpolicy/ {
            proxy_pass http://defaultpolicy-cheese-backends/;
        }
        location /strictpolicy/ {
            proxy_pass http://strictpolicy-cheese-backends/;
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

    server {
        listen 8090;

        location  / {

            app_protect_enable on;
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/nginx/log-default.json" syslog:server=localhost:514;
            app_protect_policy_file "/etc/nginx/NginxApiSecurityPolicy.json";

            default_type application/json;

            proxy_pass http://cheese-backend;
        }
    }
            

    server {
        listen 8091;

        location  / {

            app_protect_enable on;
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/nginx/log-default.json" syslog:server=localhost:514;
            app_protect_policy_file "/etc/nginx/NginxDefaultPolicy.json";

            default_type application/json;

            proxy_pass http://cheese-backend;
        }
    }

    server {
        listen 8092;

        location  / {

            app_protect_enable on;
            app_protect_security_log_enable on;
            app_protect_security_log "/etc/nginx/log-default.json" syslog:server=localhost:514;
            app_protect_policy_file "/etc/nginx/NginxStrictPolicy.json";

            default_type application/json;

            proxy_pass http://cheese-backend;
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
