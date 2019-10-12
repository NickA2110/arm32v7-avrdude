Avrdude
=======

avrdude with a Linux SPI programmer type

Install
=======

1. Armbian 5.91
2. armbian-config
System / Hardware / spi-spidev <- enable and exit with reboot
and edit
/boot/armbianEnv.txt
add strings
```
param_spidev_spi_bus=0
param_spidev_spi_cs=0
param_spidev_max_freq=1000000
```
3. install docker https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/debian/#install-using-the-repository

Usage - Docker
==============

List of programmer type

```sh
docker run -it --rm \
	nicka2110/arm32v7-avrdude \
	-c ?type
```

dump.hex - flash file

arduino/avdude.conf - with changed reset pin in line 1067 (linuxspi programmer)

For select reset pin used ```docker run -it --rm --privileged twhtanghk/arm-wiringop``` (gpio readall) BCM number of pin

dump hex
--------
```sh
CPATH="$(PWD=$(pwd); echo $(cd $(dirname "$0"); pwd); cd $PWD)"
docker run -it --rm --privileged \
	-v "$CPATH:/workdir" \
	-v "$CPATH/arduino/avrdude.conf:/usr/etc/avrdude.conf" \
	nicka2110/arm32v7-avrdude \
	-v -p atmega328p -c linuxspi -P /dev/spidev0.0 -U flash:r:dump.hex:r
```

write hex
---------
```sh
CPATH="$(PWD=$(pwd); echo $(cd $(dirname "$0"); pwd); cd $PWD)"
docker run -it --rm --privileged \
	-v "$CPATH:/workdir" \
	-v "$CPATH/arduino/avrdude.conf:/usr/etc/avrdude.conf" \
	nicka2110/arm32v7-avrdude \
	-v -p atmega328p -c linuxspi -P /dev/spidev0.0 -U flash:w:dump.hex
```

verify hex
---------
```sh
CPATH="$(PWD=$(pwd); echo $(cd $(dirname "$0"); pwd); cd $PWD)"
docker run -it --rm --privileged \
	-v "$CPATH:/workdir" \
	-v "$CPATH/arduino/avrdude.conf:/usr/etc/avrdude.conf" \
	nicka2110/arm32v7-avrdude \
	-v -p atmega328p -c linuxspi -P /dev/spidev0.0 -U flash:v:dump.hex
```

Customize
=========
default avrdude.conf - https://github.com/kcuzner/avrdude/blob/master/avrdude/avrdude.conf.in

```sh
docker run -it --rm \
	-v avrdude.conf:/usr/etc/avrdude.conf \
	nicka2110/arm32v7-avrdude \
	-c ?type
```

Credits
=======
entrypoint.sh - https://github.com/akshmakov/avrdude-docker/blob/master/entrypoint.sh

avrdude with a Linux SPI programmer type

Kevin Cuzner Jun 2013 kevin@kevincuzner.com

Using baud-rate to control SPI frequency

Rui Azevedo (neu-rah) Jun 2013 ruihfazevedo[arroba]gmail.com
