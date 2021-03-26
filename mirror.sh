#!/bin/sh

set -ex

src=https://github.com/NVIDIA
dest=/downloads

cd /downloads
for lib in "nvidia-docker" "libnvidia-container" "nvidia-container-toolkit" "nvidia-container-runtime"
do
	if [ ! -d "${dest}/${lib}" ]
	then
		git clone "${src}/${lib}"
	fi
	cd "${lib}"
	git pull
	git checkout gh-pages || true # some repos don't have gh-pages
	cd -
done
