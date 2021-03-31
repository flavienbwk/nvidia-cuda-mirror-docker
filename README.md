# nvidia-cuda-mirror-docker

<p align="center">
    <a href="https://travis-ci.com/github/flavienbwk/nvidia-cuda-mirror-docker" target="_blank">
        <img src="https://travis-ci.com/flavienbwk/nvidia-cuda-mirror-docker.svg?branch=main"/>
    </a>
</p>

Want to have fun with NVIDIA Docker ? This repository allows you to easily setup an NVIDIA Docker mirror that retrieves the following libraries :

- [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
- [libnvidia-container](https://github.com/NVIDIA/libnvidia-container)
- [nvidia-container-runtime](https://github.com/NVIDIA/nvidia-container-runtime)

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

**You must have Docker >= 18 installed on your system before starting.**

_If you use another distro than the one below, you'll have to configure your package configuration accordingly._

### Ubuntu 18.04

Download [the appropriate NVIDIA drivers for your card](https://www.nvidia.com/Download/index.aspx) and execute it with `sh`

Create the `/etc/apt/sources.list.d/nvidia-cuda-docker-mirror.list` file :

```bash
sudo bash -c "{
    echo 'deb http://localhost:8080/libnvidia-container/ubuntu18.04/amd64 /'
    echo 'deb http://localhost:8080/nvidia-container-runtime/ubuntu18.04/amd64 /'
    echo 'deb http://localhost:8080/nvidia-docker/ubuntu18.04/amd64 /'
} >> /etc/apt/sources.list.d/nvidia-cuda-docker-mirror.list"
```

> You may just want to copy past the content to some other file :
> ```txt
> deb http://localhost:8080/libnvidia-container/ubuntu18.04/amd64 /
> deb http://localhost:8080/nvidia-container-runtime/ubuntu18.04/amd64 /
> deb http://localhost:8080/nvidia-docker/ubuntu18.04/amd64 /
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

### CentOS 7

<details>
<summary>You may want to follow [cyberciti.biz's tutorial](https://www.cyberciti.biz/faq/how-to-install-nvidia-driver-on-centos-7-linux) to install `nvidia-smi` or as a TL;DR :</summary>

```bash
# After configuring your ElRepo and EPEL repositories
sudo yum group install "Development Tools"
sudo yum install kernel-devel
sudo yum -y install epel-release
sudo yum -y install dkms
```

In the `/etc/default/grub` file, append the following line to the `GRUB_CMDLINE_LINUX` property :

```txt
rd.driver.blacklist=nouveau nouveau.modeset=0
```

And then run :

```bash
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo bash -c "echo 'blacklist nouveau' > /etc/modprobe.d/blacklist-nouveau.conf" 
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r)-nouveau.img
dracut /boot/initramfs-$(uname -r).img $(uname -r)
sudo reboot
```

Once rebooted :

Download [the appropriate NVIDIA drivers for your card](https://www.nvidia.com/Download/index.aspx) and execute it with `sh`

```bash
sudo systemctl isolate multi-user.target
sh NVIDIA-Linux-x86_64-*.run
sudo reboot
```

</details>

Retrieve and add the GPG key :

```bash
wget -O RPM-GPG-KEY-NVIDIA http://localhost:8080/gpgkey
sudo rpm --import RPM-GPG-KEY-NVIDIA
```

Create a `/etc/yum.repos.d/nvidia-cuda-docker-mirror.repo` file :

```conf
[mymirror-nvidia-libnvidia-container]
name=My Centos libnvidia-container Nvidia local mirror
baseurl=http://localhost:8080/libnvidia-container/centos7/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA
enabled=1

[mymirror-nvidia-container-runtime]
name=My Centos Nvidia container runtime local mirror
baseurl=http://localhost:8080/nvidia-container-runtime/centos7/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA
enabled=1

[mymirror-nvidia-docker]
name=My Centos Nvidia Docker local mirror
baseurl=http://localhost:8080/nvidia-docker/centos7/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NVIDIA
enabled=1
```

You can now :

```bash
sudo yum update
sudo yum install nvidia-docker2
```

## Docker configuration annexe

After installing nvidia-docker2, configure your `/etc/docker/daemon.json` conf file to use the NVIDIA container runtime :

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
