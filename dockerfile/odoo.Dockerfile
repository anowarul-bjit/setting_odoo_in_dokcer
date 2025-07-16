# FROM odoo:18.0
# USER root
# RUN apt update
# RUN apt install curl python3-pandas nano -y
# COPY dockerfile/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh
# COPY addons-extra/VendorBid/requirements.txt /requirements.txt
# RUN apt install -y python3-pydantic python3-email-validator

# RUN pip install --break-system-packages pydantic_core
# ENTRYPOINT ["/entrypoint.sh"]


# FROM odoo:18.0

# USER root

# RUN apt update && apt install -y \
#     curl \
#     nano \
#     python3-pandas \
#     python3-pydantic \
#     python3-email-validator

# COPY dockerfile/entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# COPY addons-extra/VendorBid/requirements.txt /requirements.txt

# # ✅ Upgrade typing_extensions & install pydantic_core cleanly
# RUN pip install --break-system-packages --ignore-installed typing_extensions pydantic_core
# RUN pip install --break-system-packages --ignore-installed "pydantic>=2.0" "typing_extensions>=4.14"


# ENTRYPOINT ["/entrypoint.sh"]

FROM odoo:18.0

USER root

# Install required system tools and dependencies
RUN apt update && apt install -y \
    curl \
    nano \
    python3-pandas

# Copy and set permissions for entrypoint
COPY dockerfile/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Copy the requirements (optional, for other needs)
COPY addons-extra/VendorBid/requirements.txt /requirements.txt

# Force-install latest versions of required Python packages
RUN pip install --break-system-packages --ignore-installed \
    typing_extensions \
    pydantic \
    pydantic-core \
    email-validator

ENTRYPOINT ["/entrypoint.sh"]
