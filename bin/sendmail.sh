#/usr/bin/env sh
exec /usr/sbin/sendmail -H "openssl s_client -quiet -connect $EMAIL_SSL_HOST" \
  -f"$EMAIL_FROM" \
  -amLOGIN \
  -au"$EMAIL_LOGIN" \
  -ap"$EMAIL_PASSWORD" \
  "$@" || exit 1
