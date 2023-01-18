# How to generate a graph from docker-compose.yml

> [https://github.com/compose-viz/compose-viz](https://github.com/compose-viz/compose-viz)

There is a nice tool for this: [compose-viz](https://github.com/compose-viz/compose-viz)

Just run the command `docker run --rm -it --name dcv -v ${PWD}:/input pmsipilot/docker-compose-viz render -m image docker-compose.yml --force` in the folder where you've the `docker-compose.yml` file and tadaa, a graph is generated with all your services, exposed ports, used volumes and much more.

The graph here below has been generated based on this file:

```yaml
version: "3"
services:

  redis:
    image: redis:alpine
    ports:
      - "6379"
    networks:
      - frontend
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure
  db:
    image: postgres:9.4
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend
    deploy:
      placement:
        constraints: [ node.role == manager ]
  vote:
    image: dockersamples/examplevotingapp_vote:before
    ports:
      - 5000:80
    networks:
      - frontend
    depends_on:
      - redis
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
      restart_policy:
        condition: on-failure
  result:
    image: dockersamples/examplevotingapp_result:before
    ports:
      - 5001:80
    networks:
      - backend
    depends_on:
      - db
    deploy:
      replicas: 1
      update_config:
        parallelism: 2
        delay: 10s
      restart_policy:
        condition: on-failure

  worker:
    image: dockersamples/examplevotingapp_worker
    networks:
      - frontend
      - backend
    deploy:
      mode: replicated
      replicas: 1
      labels: [ APP=VOTING ]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
        window: 120s
      placement:
        constraints: [ node.role == manager ]

  visualizer:
    image: dockersamples/visualizer
    ports:
      - "8080:8080"
    stop_grace_period: 1m30s
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    deploy:
      placement:
        constraints: [ node.role == manager ]

networks:
  frontend:
  backend:


volumes:
  db-data:
```

![Docker compose as graph](./images/docker-compose.png)

So we quickly see that we've four exposed ports: `5001`, `5000`, `6379` and `8080`. 

We see that `6379` is linked to the `redis` container and `8080` to a visualizer interface.

We've two networks, `backend` and `frontend` and the exposed port for the frontend is port `5000`. So, the root entry seems to be `http://127.0.0.1:5000`.

We have two volumes, one called `db-data`, seems intern because the second one is called `/var/run/docker.sock` and is a linked to our computer.
