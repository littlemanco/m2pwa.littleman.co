FROM littleman/nginx

# HTTP 1.1 version
ADD build/unbundled /var/www/unbundled

# HTTP 2 version
ADD build/bundled /var/www/bundled

ADD /etc/nginx/sites-enabled/m2pwa.littleman.co.conf
