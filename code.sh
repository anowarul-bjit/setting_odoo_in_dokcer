#!/bin/bash

set -e

CERT_DIR="./nginx-ssl"
CERT_NAME="selfsigned"
CERT_PATH="$CERT_DIR/$CERT_NAME.crt"
KEY_PATH="$CERT_DIR/$CERT_NAME.key"
TRUSTED_CA_DIR="/usr/local/share/ca-certificates"
NGINX_CONF_DIR="./nginx-config"
NGINX_SSL_CONF="$NGINX_CONF_DIR/default.conf"

echo "==> Creating cert directory..."
mkdir -p "$CERT_DIR"
mkdir -p "$NGINX_CONF_DIR"

echo "==> Generating new self-signed certificate for localhost..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CERT_PATH" \
  -subj "/CN=localhost"

echo "==> Setting permissions for key and cert..."
chmod 600 "$KEY_PATH"
chmod 644 "$CERT_PATH"

echo "==> Copying certificate to trusted CA directory..."
sudo cp "$CERT_PATH" "$TRUSTED_CA_DIR/"

echo "==> Updating system CA certificates..."
sudo update-ca-certificates

echo "==> Writing basic Nginx SSL config to $NGINX_SSL_CONF"
cat > "$NGINX_SSL_CONF" <<EOF
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate /etc/nginx/ssl/$CERT_NAME.crt;
    ssl_certificate_key /etc/nginx/ssl/$CERT_NAME.key;

    location / {
        proxy_pass http://odoo-stack:8069;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Let's Encrypt ACME challenge (optional)
    location ~ /.well-known/acme-challenge {
        allow all;
        root /usr/share/nginx/html;
    }
}
EOF

echo "==> Please make sure your docker-compose mounts:"
echo "    - $CERT_DIR to /etc/nginx/ssl"
echo "    - $NGINX_CONF_DIR to /etc/nginx/conf.d"
echo ""
echo "==> Restart your nginx container:"
echo "    docker restart nginx-stack"
echo "==> Restart your browser"
echo "==> Then visit https://localhost and accept the certificate if needed."

echo "All done! 🎉"
