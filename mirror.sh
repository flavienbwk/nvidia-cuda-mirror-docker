#!/bin/sh

set -ex

src=https://github.com/NVIDIA
dest=/downloads

cd /downloads
for lib in "nvidia-docker" "libnvidia-container" "nvidia-container-runtime"
do
	if [ ! -d "${dest}/${lib}" ]
	then
		git clone "${src}/${lib}"
	fi
	cd "${lib}"
	git pull
	git checkout gh-pages
	cd -
done

wget -O gpgkey https://nvidia.github.io/nvidia-docker/gpgkey
