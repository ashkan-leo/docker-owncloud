#!/bin/bash
set -e

OWNCLOUD_FQDN=${OWNCLOUD_FQDN:-localhost}

# fix ownership and create required links
chown -R ${OWNCLOUD_USER}:${OWNCLOUD_USER} ${OWNCLOUD_DATA_DIR}/
ln -sf ${OWNCLOUD_DATA_DIR} ${OWNCLOUD_INSTALL_DIR}/data
ln -sf ${OWNCLOUD_DATA_DIR}/config.php ${OWNCLOUD_INSTALL_DIR}/config/config.php

# create VERSION file, not used at the moment but might be required in the future
CURRENT_VERSION=
[ -f ${OWNCLOUD_DATA_DIR}/VERSION ] && CURRENT_VERSION=$(cat -f ${OWNCLOUD_DATA_DIR}/VERSION)
[ "${OWNCLOUD_VERSION}" != "${CURRENT_VERSION}" ] && echo -n "${OWNCLOUD_VERSION}" > ${OWNCLOUD_DATA_DIR}/VERSION

# install nginx configuration, if not exists
if [ -d /etc/nginx/sites-enabled -a ! -f /etc/nginx/sites-enabled/ownCloud ]; then
  cp /conf/nginx/ownCloud /etc/nginx/sites-enabled/ownCloud
  sed -i 's/{{OWNCLOUD_FQDN}}/'"${OWNCLOUD_FQDN}"'/' /etc/nginx/sites-enabled/ownCloud
fi

exec $@
