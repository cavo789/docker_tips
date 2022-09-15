# Healthcheck - Get the status of all running containers

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
