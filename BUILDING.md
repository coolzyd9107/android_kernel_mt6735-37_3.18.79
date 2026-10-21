# PA03 Kernel Build

This tree builds Linux 3.18.79 for ARM64 with BakaSU. The `KernelSU` submodule is pinned to BakaSU commit `dac2d186406a0d2b0ce3c67cad5a1fa1adbf9f4d`.

## Host requirements

The cross compiler, device-tree tools, and AnyKernel3 installer are included in this repository. The bundled GCC requires an x86_64 Linux host with Bash and a supported package manager. `envsetup.sh` installs host build dependencies with `apt`, `dnf`, or `pacman`; `build.sh` invokes it when required commands are missing. Run it manually with:

```sh
bash envsetup.sh
```

The script installs the host compiler, kernel utility dependencies, Python 3, Git, and `zip`. `libncurses-dev` is only needed for `menuconfig`.

## Toolchain

The AArch64 Android GCC 4.9 toolchain is included at `toolchains/gcc4.9-aarch64` (Google prebuilts commit `1182d9bbb6902eb7a5650143dc2d56f520bcc2a2`). The build uses `bin/aarch64-linux-android-gcc-4.9.x` directly. DTC, DrvGen, and device-tree image scripts are included in the kernel tree. AnyKernel3 is included at `AnyKernel3` from upstream commit `020dfeccf9d7e962a48400fc94d3e451df92eead`.

## Build

From the kernel directory, run:

```sh
bash build.sh
```

The script initializes the BakaSU submodule on first use, writes build files to `out/`, and packages a flashable ZIP as `out/PA03-BakaSU-<timestamp>.zip` after the kernel build succeeds. The ZIP contains `Image.gz-dtb` and the AnyKernel3 installer. Set `BUILD_JOBS` to change the parallel job count, for example `BUILD_JOBS=4 bash build.sh`.

To run the build manually instead:

```sh
git submodule update --init --recursive KernelSU
TOOLCHAIN="$PWD/toolchains/gcc4.9-aarch64"
CROSS_COMPILE="$TOOLCHAIN/bin/aarch64-linux-android-"
CC="$TOOLCHAIN/bin/aarch64-linux-android-gcc-4.9.x"

make ARCH=arm64 SUBARCH=arm64 O=out CROSS_COMPILE="$CROSS_COMPILE" CC="$CC" HOSTCFLAGS=-fcommon pa03_defconfig
make ARCH=arm64 SUBARCH=arm64 O=out CROSS_COMPILE="$CROSS_COMPILE" CC="$CC" HOSTCFLAGS=-fcommon -j"$(nproc)"
```

The build log is `out/build.log`. Manual `make` commands compile the kernel image only; use `bash build.sh` to also create the flashable ZIP.
