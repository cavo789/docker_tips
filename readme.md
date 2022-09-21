<!-- This file has been generated by the concat.sh script. -->
<!-- Don't modify this file manually (you'll loose your changes) -->
<!-- but run the tool once more -->
<!-- Last refresh date: Wednesday, September 21, 2022, 15:37:59 -->

<!-- markdownlint-disable MD033 MD041 -->

# Docker &amp; docker-compose tips

![Banner](./banner.svg)

> List of tips and tricks for Docker

<!-- table-of-contents - start -->
* [Some useful bash scripts](#some-useful-bash-scripts)
  * [Healthcheck - Get the status of all running containers](#healthcheck-get-the-status-of-all-running-containers)
* [PHP](#php)
  * [Minimal Dockerfile for PHP projects](#minimal-dockerfile-for-php-projects)
    * [Copy or using a volume?](#copy-or-using-a-volume)
* [Tips](#tips)
  * [Using Dockerfile or put it in a script?](#using-dockerfile-or-put-it-in-a-script)
  * [Docker in Docker](#docker-in-docker)
  * [NPM - Folder node_modules](#npm-folder-node-modules)
  * [Add this folder in the PATH so npm can retrieve it from there](#add-this-folder-in-the-path-so-npm-can-retrieve-it-from-there)
  * [RUN ln -s /opt/node_app/node_modules node_modules](#run-ln-s-opt-node-app-node-modules-node-modules)
  * [Storing secrets](#storing-secrets)<!-- table-of-contents - end -->

## Some useful bash scripts

### Healthcheck - Get the status of all running containers

Loop all running containers and return the health status of each of them.

Idea is to have a very condensed summary with the container name and the status

```bash
clear

printf "[1;33m%s[0m\n\n" "Docker containers - Health check"

containers=$(docker ps | awk '{if(NR>1) print $NF}')

for container in $containers; do
    status=$(docker inspect --format='{{json .State.Health}}' $container | jq -r '.Status')

    if [[ "$status" == "healthy" ]]; then
        status="[1;32m${status}[0m"
    elif [[ "$status" == "null" ]]; then
        status="[1;30m${status}[0m"
    else
        status="[1;31m${status}[0m"
    fi

    printf "%-60s%s\n" "$container" "$status"
done
```

The output will be something like this:

```text
Docker containers - Health check

jovial_heisenberg                                           healthy
boring_wozniak                                              healthy
furious_einstein                                            healthy
loving_goldstine                                            healthy
agitated_darwin                                             healthy
jovial_yalow                                                healthy
ecstatic_almeida                                            healthy
furious_heisenber                                           healthy
```

Same result, another syntax:

```bash
clear

printf "[1;33m%s[0m\n\n" "Docker containers - Health check"

docker ps -a --format "{{.Names}}" | while read -r container ; do
    healthcheckStatus=$(docker inspect --format='{{json .State.Health}}' $container | jq -r '.Status')

    if [[ "$healthcheckStatus" == "healthy" ]]; then
        healthcheckStatus="[1;32m${healthcheckStatus}[0m"
    elif [[ "$healthcheckStatus" == "null" ]]; then
        healthcheckStatus="[1;30m${healthcheckStatus}[0m"
    else
        healthcheckStatus="[1;31m${healthcheckStatus}[0m"
    fi

    printf "%-60s%s\n" "$container" "$healthcheckStatus"
done
```

## PHP

### Minimal Dockerfile for PHP projects

Imagine a small script like [https://github.com/cavo789/json_encode](https://github.com/cavo789/json_encode).

There is no dependencies to any services like MySQL or PostgreSQL.

Such application can be easily put in a Docker container using this `Dockerfile`:

```text
FROM php:8.0-apache
WORKDIR /var/www/html
EXPOSE 80
```

1. Create a new file called `Dockerfile` in your application root and copy the lines here above in the file.
2. Build your application Docker image by running `docker build --pull --rm -t appName:latest .` where `appName` can be anything you want.
3. Run `docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName`
4. Start your browser and surf to `http://127.0.0.1` to start your application.

#### Copy or using a volume?

By running `docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName` i.e. using the `-v` parameter, you'll set a volume i.e. you'll synchronize a folder on your host (`%cd` means the current directory in DOS) to a folder in your container (here, the folder `/var/www/html`).

This means that if you change a file, the change is reflected in the container or vice-versa (if you delete a file in the container, it's deleted on your host too).

If you don't want a synchronization, don't use the `-v` parameter and uncomment the `COPY . .` line in the `Dockerfile`.

The `COPY . .` statement order to make a copy of all files present in your host current directory (and sub-directories) inside the container. There will be no synchronization: you can't change a file on your host and hope the change is done in the container too. And files created, modified or even deleted in the container stays in the container; just like a *sandbox*.

## Tips

### Using Dockerfile or put it in a script?

Sometimes, you can put actions directly in the Dockerfile (using the `RUN` command) or in a Bash script that you're still using as an entrypoint (f.i. `ENTRYPOINT [ "/bin/bash", "-c", "/home/node/.docker/app/entrypoint.sh" ]`).

There is a big difference! The file `Dockerfile` is only used when building the image (i.e. `docker-compose build`). The file `docker-compose.yml` is used every time you start `docker-compose up`.

Put in the `Dockerfile` any statements needed to build your image and make that image usable. Using the `RUN` command, the action will be put in a layer by Docker and if nothing change, the layer will be reused during the next built action. This will greatly increase the performance by reducing the time needed for the built.

Let's consider the `composer install` (or `yarn install`) action: did you need to run it every time the image is used or, only, when the image is built?

If you put it in the `Dockerfile` as a `RUN` command, while the `composer.json` file (or `package.json`) isn't modified, the layer is still valid so no need to run the command once more. That's the best choice.

### Docker in Docker

By sharing the `/var/run/docker.sock` file with your container, it's possible to interact with the Docker daemon on your host.

Run an Alpine image (default user: `root`) and share the file:

```bash
docker run -it --rm --name DockerInDocker -v /var/run/docker.sock:/var/run/docker.sock alpine sh
```

Then install Docker client in the container

```bash
apk update && apk add -U docker
```

Now, you can, from inside the container, run commands like:

```bash
docker container list
docker container stop <CONTAINER_ID>
docker container rm <CONTAINER_ID>

docker image list
docker run -it --rm <IMAGE_NAME> sh
```

### NPM - Folder node_modules

NPM didn't force to put that folder in the project directory, you can put it somewhere else then just add the folder's location to the PATH.

Consider this example:

```Dockerfile
WORKDIR /opt/node_app

COPY package*.json ./

RUN \
    yarn install --production=false --no-optional; \
    yarn cache clean --force; \

### Add this folder in the PATH so npm can retrieve it from there
ENV PATH="/opt/node_app/node_modules/.bin:$PATH"

WORKDIR /home/node

COPY --chown=node:node . .

### RUN ln -s /opt/node_app/node_modules node_modules

RUN yarn dev
```

We'll use the `/opt/node_app` folder and copy there the `package.json` (and `package-lock.json` if any) then run `yarn install` from there. Installing dependencies is put in a separate layer so while the `package.json` file isn't modified, the layer stay valid and shouldn't be executed again. **We'll have a better experience with less time needed for the built of the image.**

We'll update the `PATH` variable and add our `/opt/node_app` folder.

Then we'll switch to the `/home/node` folder where our application is installed, copy our project's files between the host and the container.

Finally, we start yarn. Since the `node_modules` is not there, yarn / npm will search for the modules in the `PATH` and will retrieve our files.

Note: if this doesn't work, just uncomment the `RUN ls` command.

### Storing secrets

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
