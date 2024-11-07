#! /bin/bash

flagfile="/var/www/trax2/storage/.initialized"

if [ ! -f ${flagfile} ]; then
  echo "INIT LAX-LRS"
  if [ "${ADMIN_MAIL}" == "" ] || [ "${ADMIN_PASSWORD}" == "" ]; then
    echo "Missing mandatory environement variables ADMIN_MAIL or ADMIN_PASSWORD" >&2
    exit 1
  fi
  php artisan key:generate \
  && php artisan migrate \
  && (echo -ne "${ADMIN_MAIL}\n${ADMIN_PASSWORD}\n" | php artisan admin:create) \
  && touch ${flagfile}

  if [ $? -ne 0 ]; then
    echo "Initialisation error" >&2
    exit 1
  fi
fi

apache2-foreground
exit $?