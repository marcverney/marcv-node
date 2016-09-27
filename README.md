# Node + Grunt + JSPM Docker Image

## Usage

### Build the image

```shell
cd marcv-node
docker build -t marcv/node .
```

### Run a Grunt task

```shell
docker run --rm -v /srv/www/blabla:/project marcv/node grunt --gruntfile=/project/nodejs/Gruntfile.js taskname
```

### Run a command as a specific user (and group, optionally)

```shell
docker run --rm -v `pwd`:/project -e USERID=1000 -e GROUPID=1000 marcv/node npm install
```