server {
    listen 80;
    listen [::]:80;
    server_name localhost;

    location / {
        proxy_pass http://$IPA:81/;
    }

    location /dns-query {
        proxy_pass http://$IPA:8053/dns-query;
    }
}
