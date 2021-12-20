# RPI cross compilation on ubuntu 20.04

This is a simple guide and set of shell scripts to create a cross-compile
environment for rpi3 and rpi1 on Ubuntu-20 using croostool-ng.

**Warning**: These stuff was made for advanced linux users, (who knows what
they doing).

This is an automated version of `Ston Preston`'s [guide](https://medium.com/@stonepreston/how-to-cross-compile-a-cmake-c-application-for-the-raspberry-pi-4-on-ubuntu-20-04-bac6735d36df)

First of all clone the repo:

```bash
git clone git@github.com:pylover/rpi-crosscompile.git
cd rpi-crosscompile
```

## Prepare RPI

Download and install the latest RasoberryPi OS (raspbian) from 
[here](https://www.raspberrypi.com/software/operating-systems).

Mount the mmc boot volume and add `enable_uart` into /boot/config.txt
(optional).

Boot rpi and use `raspi-config` to:

- Configure Wifi connection using.
- Enable `ssh`.
- Extend filesystem


Disable [wifi power
saving](https://raspberrypi.stackexchange.com/a/96644/24752)


Fix the locale file: /etc/default/locale

```bash
# File generated by update-locale
LANG=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_ALL=en_US.UTF-8
```

Install some packages:

```bash
apt update
apt dist-upgrade
rpi-update
apt install vim git python3-pip python3-dev \
  build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev \
  libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev \
  libexpat1-dev liblzma-dev zlib1g-dev libffi-dev \
  binutils-source symlinks
```

Make all symlinks relative

```bash
sudo symlinks -rc /.
```

Edit the ubuntu machine's ssh config file (`~/.ssh/config`) to access you rpi 
by name instead of ip address.

```bash
Host myrpi
  HostName 192.168.1.2  # Your rpi's IP address
```

Enable password-less authentication by copying your SSH public key into
the rpi.

```bash
ssh-copy-id myrpi
ssh-copy-id root@myrpi
```

Finally, save this information for the later:

```bash
uname -a            # Linux pinky 5.10.83+ #1499 Tue Dec 7 14:04:21 GMT 2021 armv6l GNU/Linux
ld --version        # 2.31.1
gcc --version       # 8.3.0
ldd --version		    # 2.28
```

## Install, configure and build the crosstool-ng

Then run it
```bash
./install.sh myrpi rpi3   # Or rpi1
```

Now activate your env by 
```bash
source activate.sh
```

You may run `deativate` any time to get back to normal shell.


Before build the toolchain, you need to enter some versions mannualy:
```bash
cd build/xbuild
ct-ng menuconfig
cd ../..
```

At the main menu, select the operating system option and change the version 
of Linux to the closest version to what you found on the Pi earlier. In my 
case I selected 5.10.79. 

Exit back to the main menu and select the Binary utilties submenu. Change 
the version of binary utils to whatever was on your Pi, 2.31.1 for me.

Exit back to the main menu again and select the C-library submenu. Change the 
version of glibc to the version from your Pi (2.28 for me.)

Now exit back to the main menu for the last time and select the C-compiler 
settings. Change the version of gcc to the version on your 
Pi (8.3.0 in my case.) 

Now, build the toolchain using:

```bash
./build.sh -j4    # The number of processors(cores)
```

### fsroot

```bash
./fsroot.sh myrpi
```

### Test it

```bash
armv8-rpi3-linux-gnueabihf-gcc -o hello hello.c
scp hello myrpi:
ssh myrpi ./hello
```

## CPython

```bash
./cpython.sh 3.8  # Change 3.8 by any cpython version.
```

You may find the Python's install files at `build/cpython/install`.

Use ssh to copy files into target rpi:
```bash
scp -r build/cpython/install/* myrpi:/usr/local
ssh root@myrpi ldconfig
```
