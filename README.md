# quarkus-lab

Just simple image to provide development environment.

## Build image

```sh
# using docker :
docker build -t quarkus-lab .
```
```sh
# using docker compose :
docker compose build
```

## Launching quarkus lab

```sh
# using docker :

# remove MSYS_NO_PATHCONV=1 if not using MINGW64
MSYS_NO_PATHCONV=1 \
docker run -it --rm \
        -v $PWD/workspace:/workspace \
        -v $PWD/.m2:/root/.m2 \
        -e QUARKUS_HTTP_HOST=0.0.0.0 \
        -e QUARKUS_HTTP_port=8080 \
        -p 8080:8080 quarkus-lab bash

```
```sh
# using docker compose (advantage, start only once the container :
docker compose up -d
# remove MSYS_NO_PATHCONV=1 if not using MINGW64
MSYS_NO_PATHCONV=1 \
docker compose exec quarkus-lab /bin/bash
```

## Usefull links
[Quarkus main site](https://quarkus.io/)

[Quarkus application bootstrap](https://code.quarkus.io/), work like Spring Initializr, very usefull to start a project with some dependencies.

[My first Quarkus project](https://medium.com/javarevisited/my-first-quarkus-project-c6e1449617e)

[A Very Simple CRUD with Quarkus](https://medium.com/javarevisited/a-very-simple-crud-with-quarkus-7b066c9c44e8)
