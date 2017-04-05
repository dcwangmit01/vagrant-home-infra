
docker run --rm \
       -v /docker/letsencrypt/etc/letsencrypt:/etc/letsencrypt \
       -v /docker/letsencrypt/var/lib/letsencrypt:/var/lib/letsencrypt \
       -v /docker/letsencrypt/var/log/letsencrypt:/var/log/letsencrypt \
       -v /docker/nginx/web:/var/www \
       deliverous/certbot \
       certonly \
       --non-interactive --agree-tos --expand \
       --renew-with-new-domains \
       --rsa-key-size 4096 \
       --webroot -w /var/www \
       -m 'dcwangmit01@gmail.com' \
       -d davidwang.com -d www.davidwang.com -d s.davidwang.com -d pvr.davidwang.com \
       -d api.davidwang.com -d registry.davidwang.com -d whatismyip.davidwang.com \
       -d api.paxarm.com -d registry.paxarm.com -d s.paxarm.com -d www.paxarm.com \
       -d caliwinetrip.com -d www.caliwinetrip.com

# debug options
#
#   docker run --rm deliverous/certbot --help all
#
#    --staging --dry-run \
#    --verbose
#    --standalone \
