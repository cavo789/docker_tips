# Docker &amp; docker-compose tips

![Banner](./banner.svg)

## Minimum PHP script

Imagine a small script like [https://github.com/cavo789/json_encode](https://github.com/cavo789/json_encode).

There is no dependencies to any services like MySQL or PostgreSQL.

Such application can be easily put in a Docker container using this `Dockerfile`:

```text
# Run this application by running the next command in a console:
# docker build --pull --rm -t appName:latest . && docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName
# (under Windows, `%cd%` means *the current directory*)
FROM php:8.0-apache
WORKDIR /var/www/html
#COPY . .
EXPOSE 80
```

1. Create a new file called `Dockerfile` in your application root and copy the lines here above in the file.
2. Build your application Docker image by running `docker build --pull --rm -t appName:latest .` where `appName` can be anything you want.
3. Run `docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName`
4. Start your browser and surf to `http://127.0.0.1` to start your application.

### Copy or using a volume?

By running `docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName` i.e. using the `-v` parameter, you'll set a volume i.e. you'll synchronize a folder on your host (`%cd` means the current directory in DOS) to a folder in your container (here, the folder `/var/www/html`).

This means that if you change a file, the change is reflected in the container or vice-versa (if you delete a file in the container, it's deleted on your host too).

If you don't want a synchronization, don't use the `-v` parameter and uncomment the `COPY . .` line in the `Dockerfile`.

The `COPY . .` statement order to make a copy of all files present in your host current directory (and sub-directories) inside the container. There will be no synchronization: you can't change a file on your host and hope the change is done in the container too. And files created, modified or even deleted in the container stays in the container; just like a *sandbox*.
