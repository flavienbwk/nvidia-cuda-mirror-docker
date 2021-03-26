# nvidia-cuda-mirror-docker

<p align="center">
    <a href="https://travis-ci.com/github/flavienbwk/nvidia-cuda-mirror-docker" target="_blank">
        <img src="https://travis-ci.com/flavienbwk/nvidia-cuda-mirror-docker.svg?branch=main&status=passed"/>
    </a>
</p>

Want to have fun with NVIDIA Docker ? This repository allows you to easily setup an NVIDIA Docker mirror that retrieves the following libraries :

- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [libnvidia-container](https://github.com/NVIDIA/libnvidia-container)
- [nvidia-container-runtime](https://github.com/NVIDIA/nvidia-container-runtime)

**You still have to [download the appropriate NVIDIA drivers for your card](https://www.nvidia.com/Download/index.aspx) first !**

## Downloading & updating

Run the `mirror` container :

```bash
docker-compose build
docker-compose up mirror
```

Expected size : 1.5 Go

> Tips: We recommend you downloading the mirror from [a cloud provider](https://www.scaleway.com/en/) and then transfer the files to your computer.

## Serving

1. Check your mirroring succeeded in `./mirror/*` or typing `du -sh ./mirror` to check the volume

    The default configuration should make you download _1.5 G_

2. Run the server :

    ```bash
    docker-compose up -d server
    ```

    Server will run on [`localhost:8080`](http://localhost:8080)  

## Client configuration

Here is an example of configuration for `Ubuntu` (create the following file : `/etc/apt/sources.list.d/nvidia-cuda-docker-mirror.list`) :

```bash
deb http://localhost:8080/libnvidia-container/stable/ubuntu18.04/amd64 /
deb http://localhost:8080/nvidia-container-runtime/stable/ubuntu18.04/amd64 /
deb http://localhost:8080/nvidia-docker/stable/ubuntu18.04/amd64 /
```

If you use another distro, you'll have to configure your package configuration accordingly.

:point_right: Please cite my work if you're using it !
:point_right: Feel free to send **pull requests** !
