# Using regex in conditional statements

Sometimes, we wish to be able to check some variables and have a `if ... else` statement.

Real use case is when we're using xDebug. Settings in the `docker-php-ext-xdebug.ini` are not the same for version 2 or greater.

For v2, we'll use f.i. `xdebug.remote_enable=1` while it'll be `xdebug.mode=debug` (f.i.) for v3 or above.

So, we need to check the major version. This can be done like this:

```dockerfile
ARG XDEBUG_VERSION=2.9.8

RUN if [ "$XDEBUG_VERSION" = "2.9.8" ]; then \
        echo "perfect match, it's 2.9.8"; \
    fi

RUN if  [ $(expr "$XDEBUG_VERSION" : "2.*" ) -eq 0 ]; then \
        echo "VERSION 3 or greater"; \ 
    else \
        echo "VERSION 2"; \ 
    fi
```
