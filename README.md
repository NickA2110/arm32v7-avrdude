Avrdude
=======

avrdude with a Linux SPI programmer type

Install
=======

1. Armbian 5.91
2. ```armbian-config```
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
4. connect handware
```
OrangePiPC+  	   | Arduino Atmega328 Pro
---------------------------------------
MOSI SPI (pin19)   | MOSI (pin11)
MISO SPI (pin21)   | MISO (pin12)
SCLK SPI (pin23)   | SCK (pin13 with LED)
Reset (configured) | RST (Reset)
```

Reset configured in /usr/etc/avrdude.conf
```
programmer
  id = "linuxspi";
  desc = "Use Linux SPI device in /dev/spidev*";
  type = "linuxspi";
  reset = 2;
  baudrate=400000;
;
```
reset = 2, this is BCM number of pin

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

Select reset pin
----------------

For select reset pin used (gpio readall) BCM number of pin
```
# docker run -it --rm --privileged twhtanghk/arm-wiringop
 +-----+-----+----------+------+---+-Orange Pi+---+---+------+---------+-----+--+
 | BCM | wPi |   Name   | Mode | V | Physical | V | Mode | Name     | wPi | BCM |
 +-----+-----+----------+------+---+----++----+---+------+----------+-----+-----+
 |     |     |     3.3v |      |   |  1 || 2  |   |      | 5v       |     |     |
 |  12 |   8 |    SDA.0 | ALT3 | 0 |  3 || 4  |   |      | 5V       |     |     |
 |  11 |   9 |    SCL.0 | ALT3 | 0 |  5 || 6  |   |      | 0v       |     |     |
 |   6 |   7 |   GPIO.7 | ALT3 | 0 |  7 || 8  | 0 | ALT4 | TxD3     | 15  | 13  |
 |     |     |       0v |      |   |  9 || 10 | 0 | ALT4 | RxD3     | 16  | 14  |
 |   1 |   0 |     RxD2 | ALT3 | 0 | 11 || 12 | 0 | ALT3 | GPIO.1   | 1   | 110 |
 |   0 |   2 |     TxD2 | ALT3 | 0 | 13 || 14 |   |      | 0v       |     |     |
 |   3 |   3 |     CTS2 | ALT3 | 0 | 15 || 16 | 0 | ALT3 | GPIO.4   | 4   | 68  |
 |     |     |     3.3v |      |   | 17 || 18 | 0 | ALT3 | GPIO.5   | 5   | 71  |
 |  64 |  12 |     MOSI | ALT4 | 0 | 19 || 20 |   |      | 0v       |     |     |
 |  65 |  13 |     MISO | ALT4 | 0 | 21 || 22 | 0 | ALT3 | RTS2     | 6   | 2   |
 |  66 |  14 |     SCLK | ALT4 | 0 | 23 || 24 | 0 | ALT4 | CE0      | 10  | 67  |
 |     |     |       0v |      |   | 25 || 26 | 0 | ALT3 | GPIO.11  | 11  | 21  |
 |  19 |  30 |    SDA.1 | ALT3 | 0 | 27 || 28 | 0 | ALT3 | SCL.1    | 31  | 18  |
 |   7 |  21 |  GPIO.21 | ALT3 | 0 | 29 || 30 |   |      | 0v       |     |     |
 |   8 |  22 |  GPIO.22 | ALT3 | 0 | 31 || 32 | 0 | ALT3 | RTS1     | 26  | 200 |
 |   9 |  23 |  GPIO.23 | ALT3 | 0 | 33 || 34 |   |      | 0v       |     |     |
 |  10 |  24 |  GPIO.24 | ALT3 | 0 | 35 || 36 | 0 | ALT3 | CTS1     | 27  | 201 |
 |  20 |  25 |  GPIO.25 | ALT3 | 0 | 37 || 38 | 0 | ALT3 | TxD1     | 28  | 198 |
 |     |     |       0v |      |   | 39 || 40 | 0 | ALT3 | RxD1     | 29  | 199 |
 +-----+-----+----------+------+---+----++----+---+------+----------+-----+-----+
 | BCM | wPi |   Name   | Mode | V | Physical | V | Mode | Name     | wPi | BCM |
 +-----+-----+----------+------+---+-Orange Pi+---+------+----------+-----+-----+
```
BCM = 2, wPi = 6, Physical = 22

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
