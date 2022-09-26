# Docker outside of Docker (aka DooD)

By sharing the `/var/run/docker.sock` file with your container, it's possible to interact with the Docker daemon on your host. This technique is called *Docker outside of Docker (aka DooD)*.

Run an Alpine image (default user: `root`) and share the file:

```bash
docker run -it --rm --name DockerOutsideOfDocker -v /var/run/docker.sock:/var/run/docker.sock alpine sh
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

## Tips for Dood

You can mount the `docker.sock` file directly from your `docker-compose.yml` file:

```yml
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
```
