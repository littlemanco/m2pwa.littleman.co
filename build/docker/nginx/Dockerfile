FROM littleman/nginx

# HTTP 1.1 version
ADD frontend/build/unbundled /var/www/unbundled

# HTTP 2 version
ADD frontend/build/bundled /var/www/bundled

ADD frontend/etc/nginx/sites-enabled/m2pwa.littleman.co.conf frontend/etc/nginx/sites-enabled/m2pwa.littleman.co.conf
