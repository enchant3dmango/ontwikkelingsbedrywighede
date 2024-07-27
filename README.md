# Ontwikkelingsbedrywighede

## Background
Ontwikkelingsbedrywighede is Afrikaans which means Development Operations (DevOps), I randomly chose Afrikaans, the purpose only to make the repository name unique but also to tell others that I'm learning DevOps, even though none of my friends understand it. I'll document what I've learned at the end of this document after I'm done with this project.

## Setup

### Prerequisites
...

### Steps
#### Build and Run Dockerfile in Local
```sh
# Build 
docker build -t <image-name>:<tag> --no-cache --progress=plain . 2>&1 | tee docker-build.log

# Run and write log to a file
docker run --name <container-name> -d <image-name>:<tag> && docker logs -f <container-name> > docker-output.log 2>&1
```
Here is the `docker-output.log` snippet:
```log
2024-07-26T15:57:03Z Loading addresses from DNS seed dnsseed.koin-project.com
2024-07-26T15:57:13Z Loading addresses from DNS seed seed-a.litecoin.loshan.co.uk
2024-07-26T15:57:13Z Loading addresses from DNS seed dnsseed.thrasher.io
2024-07-26T15:57:23Z Loading addresses from DNS seed dnsseed.litecointools.com
2024-07-26T15:57:23Z Loading addresses from DNS seed dnsseed.litecoinpool.org
2024-07-26T15:57:23Z 47 addresses found from DNS seeds
2024-07-26T15:57:23Z dnsseed thread exit
2024-07-26T15:57:23Z New outbound peer connected: version: 70017, blocks=2727152, peer=0 (full-relay)
2024-07-26T15:57:24Z Synchronizing blockheaders, height: 2000 (~0.07%)
2024-07-26T15:57:34Z New outbound peer connected: version: 70017, blocks=2727152, peer=1 (full-relay)
2024-07-26T15:57:35Z New outbound peer connected: version: 70017, blocks=2727152, peer=2 (full-relay)
2024-07-26T15:57:36Z Synchronizing blockheaders, height: 3999 (~0.15%)
2024-07-26T15:57:37Z Synchronizing blockheaders, height: 5999 (~0.22%)
```

Read more in the `docker-output.log` file, or you can just generate it yourself by following the steps above.

## Learning References
- https://docs.docker.com/build/building/best-practices/
- https://www.speedguide.net/port.php?port=9333
- https://security.stackexchange.com/questions/1687/
- https://medium.com/@arif.rahman.rhm/choosing-the-right-python-docker-image-slim-buster-vs-alpine-vs-slim-bullseye-5586bac8b4c9
- https://docs.docker.com/build/ci/github-actions/
