FROM odoo:18.0
USER root
RUN apt update
RUN apt install curl python3-pandas nano -y