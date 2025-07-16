#!/bin/bash
set -e

ODOO_DB_NAME="database39"
ODOO_MODULES="VendorBid"
ODOO_COMMAND="/usr/bin/odoo"
apt install pip
# apt install python3-pydantic,python3-pydantic-core,python3-email_validator
# Check if database already exists
echo "🔍 Checking if database '$ODOO_DB_NAME' exists..."
if psql -h "$HOST" -U "$POSTGRES_USER" -lqt | cut -d \| -f 1 | grep -qw "$ODOO_DB_NAME"; then
    echo "✅ Database '$ODOO_DB_NAME' already exists. Skipping creation."
else
    echo "🚀 Creating database '$ODOO_DB_NAME' and installing modules: $ODOO_MODULES"
    $ODOO_COMMAND -d "$ODOO_DB_NAME" \
                  -i "$ODOO_MODULES" \
                  --without-demo=all \
                  --stop-after-init
fi

# Start Odoo as usual
exec $ODOO_COMMAND "$@"
