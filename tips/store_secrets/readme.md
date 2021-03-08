# Storing secrets

> [https://davidwalsh.name/docker-compose-override](https://davidwalsh.name/docker-compose-override)

Just use a `docker-compose.override.yml` file and add that file in your `.gitignore` file.

```yaml
version: '3.9'
services:
  myservice:
    environment:
      - APP_KEY=32xlkjwe9sd9x8jx9we8sd9sdad
```

Docker-compose will automatically merge `docker-compose.yml` and `docker-compose.override.yml`. Nothing to do for this.
