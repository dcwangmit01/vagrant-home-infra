
docker run --rm \
       -v /docker/letsencrypt/etc/letsencrypt:/etc/letsencrypt \
       -v /docker/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt \
       -v /docker/letsencrypt/var/log/letsencrypt:/var/log/letsencrypt \
       -v /docker/nginx/web:/var/www \
       deliverous/certbot \
       certonly \
       --non-interactive --agree-tos \
       --renew-with-new-domains \
       --rsa-key-size 4096 \
       --webroot -w /var/www \
       -m 'dcwangmit01@gmail.com' \
       -d davidwang.com -d www.davidwang.com -d s.davidwang.com -d pvr.davidwang.com \
       -d whatismyip.davidwang.com -d registry.davidwang.com

# debug options
#
#   docker run --rm deliverous/certbot --help all
#
#    --staging --dry-run \
#    --verbose
#    --standalone \
