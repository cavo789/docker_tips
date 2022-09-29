# Docker inspect and filter the output

The `docker inspect` command will display a big list of settings. If you want to filter the output, use the `-f` argument followed by `{{json XXX}}` where `XXX` is a node; using the dot-notation.

For instance, in order to show all environment variables:

```bash
❯ docker inspect <IMAGE_NAME> -f "{{json .Config.Env}}" | jq
[
  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  "PHPIZE_DEPS=autoconf \t\tdpkg-dev \t\tfile \t\tg++ \t\tgcc \t\tlibc-dev \t\tmake \t\tpkg-config \t\tre2c",
  "PHP_INI_DIR=/usr/local/etc/php",
  "PHP_CFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64",
  "PHP_CPPFLAGS=-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64",
  "PHP_LDFLAGS=-Wl,-O1 -pie",
  "PHP_VERSION=8.1.10",
  "PHP_URL=https://www.php.net/distributions/php-8.1.10.tar.xz",
  "PHP_ASC_URL=https://www.php.net/distributions/php-8.1.10.tar.xz.asc",
  "PHP_SHA256=90e7120c77ee83630e6ac928d23bc6396603d62d83a3cf5df8a450d2e3070162",
  "TZ=Europe/Brussels",
  "APP_HOME=/var/www"
]
```
