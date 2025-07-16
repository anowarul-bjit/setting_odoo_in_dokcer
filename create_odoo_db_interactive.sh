#!/bin/bash

# read -p "Do you want to create a new Odoo database? (y/n): " CREATE
# if [[ "$CREATE" != "y" ]]; then
#     echo "Skipping DB creation."
#     exit 0
# fi

read -p "Enter new Odoo database name: " DB_NAME
# read -p "Enter module name to install (default: base): " MODULE_NAME

DB_NAME="database1"
ODOO_CONTAINER=odoo-stack
DEFAULT_MODULE="VendorBid"

# Fallback to base if module not specified
if [ -z "$MODULE_NAME" ]; then
  MODULE_NAME=$DEFAULT_MODULE
fi

echo "Creating Odoo database '$DB_NAME' and installing module '$MODULE_NAME'..."

docker exec $ODOO_CONTAINER \
  odoo -d "$DB_NAME" \
        -i "$MODULE_NAME" \
        --without-demo=all \
        --stop-after-init

echo "✅ Odoo database '$DB_NAME' created with module VendorBid"
echo "👉 You can now log in to http://localhost:8069 and select '$DB_NAME'"
