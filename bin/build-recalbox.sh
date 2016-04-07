#!/bin/bash -e

build=/usr/share/recalbox/build
branch="${RECALBOX_BRANCH}"
arch="${RECALBOX_ARCH}"
builddir="${build}/${branch}/${arch}"
cleanbuild="${RECALBOX_CLEANBUILD}"

# Cleanning
if [[ "${cleanbuild}" == "1" ]];then
  echo "Cleaning last build"
  make clean || true
else
  echo "Soft clean recalbox packages"
  rm dl/recalbox-* || true
  rm output/build/recalbox-* || true
fi

# Cloning
if [[ ! -d "${builddir}" ]]; then
  mkdir -p "${builddir}"
  echo "Cloning recalbox in ${builddir}"
  git clone https://github.com/${RECALBOX_FORK}/recalbox-buildroot.git "${builddir}"
fi

# Branch selection
cd "${builddir}"
echo "Switching to branch $branch"
git checkout $branch
git pull --rebase origin $branch

# Building
echo "Build recalbox for arch ${arch} (defconfig : recalbox-${arch}_defconfig)"
make recalbox-${arch}_defconfig
if [[ -z "${RECALBOX_SINGLE_PKG}" ]];then
  make
else
   echo "Only build package ${RECALBOX_SINGLE_PKG} for arch ${arch}"
   make "${RECALBOX_SINGLE_PKG}"
fi
