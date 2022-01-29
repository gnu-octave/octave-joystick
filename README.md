Introduction
============

The Octave joystick package provides basic joystick read/write functions

Requirements
============

* Octave >= 3.6.0+

* SDL >= 1.2

*NOTE: in fedora, the joysick drivers must be enabled so that it will load them:
dnf install joystick-support*

sudo usermod -a -G input username


Installing
==========

To install, run the octave package manager:

1. If running Windows, the package may already be installed:

   pkg list joystick

2. To install from source forge:
   pkg install -forge joystick

3. To install from a local tarball.
   pkg install joystick-XXXXXXX.tar.gz
   Where XXXXXXX is the version of the the downloaded tarball.

Usage:
======

1. Load the package.
   pkg load joystick
   (Required each time Octave is started)

2. List available joystickes
   vrjoysticklist

3. Get a joystick to manipulate using the id
   joy = vrjoystick(1)

Documentation
==============

Known limitations and bugs
==========================

