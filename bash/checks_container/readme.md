# Check container

Let's imagine the `sonarqube` container.

## Check the container exists (independently of the status)

```bash
docker ps -a -f name=sonarqube
```

Will return 

```text
CONTAINER ID   IMAGE              COMMAND                  CREATED      STATUS              PORTS                    NAMES
422f62c2fc23   sonarqube:latest   "/opt/sonarqube/dock…"   4 days ago   Up About a minute   0.0.0.0:9000->9000/tcp   sonarqube
```

or

```text
CONTAINER ID   IMAGE              COMMAND                  CREATED      STATUS                       PORTS     NAMES
422f62c2fc23   sonarqube:latest   "/opt/sonarqube/dock…"   4 days ago   Exited (130) 3 seconds ago             sonarqube
```

As we can see, the `docker ps` command will return our container but, perhaps, did we make sure the container is running:

```bash
docker ps -a -f name=sonarqube -f status=running
```

## Return only the ID

The `-q` flag means `qiet` and will only return the ID:


```bash
docker ps -a -q -f name=sonarqube
```

This will return only the `ID`, like `22f62c2fc23`.
