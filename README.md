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

Expected size : **1.5 Go**

## Serving

Run the server :

```bash
docker-compose up -d server
```

Server will run on [`localhost:8080`](http://localhost:8080)  

## Client configuration

_If you use another distro than the one below, you'll have to configure your package configuration accordingly._

### Ubuntu 18.04

Create the `/etc/apt/sources.list.d/nvidia-cuda-docker-mirror.list` file :

```bash
sudo bash -c "{
    echo 'deb http://localhost:8080/libnvidia-container/stable/ubuntu18.04/amd64 /'
    echo 'deb http://localhost:8080/nvidia-container-runtime/stable/ubuntu18.04/amd64 /'
    echo 'deb http://localhost:8080/nvidia-docker/stable/ubuntu18.04/amd64 /'
} >> /etc/apt/sources.list.d/nvidia-cuda-docker-mirror.list"
```

> You may just want to copy past the content to some other file :
> ```txt
> deb http://localhost:8080/libnvidia-container/stable/ubuntu18.04/amd64 /
> deb http://localhost:8080/nvidia-container-runtime/stable/ubuntu18.04/amd64 /
> deb http://localhost:8080/nvidia-docker/stable/ubuntu18.04/amd64 /
> ```

You'll have to import the `gpgkey` available at the root of the mirror :

```bash
curl -s -L http://localhost:8080/gpgkey | sudo apt-key add -
```

You can now :

```bash
sudo apt-get update
sudo apt-get install -y nvidia-docker2
```

## Docker configuration annexe

After installing nvidia-docker2, configure your `daemon.json` conf file to use the NVIDIA container runtime :

```json
{
    "runtimes": {
        "nvidia": {
            "path": "nvidia-container-runtime",
            "runtimeArgs": []
        }
    },
    "default-runtime": "nvidia"
}
```

You'll probably need a **reboot**. You can try your install by running :

```bash
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

## Notes

:point_right: Please cite my work if you're using it !  
:point_right: Feel free to send **pull requests** !
