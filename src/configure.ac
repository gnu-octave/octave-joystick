#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#
### Copyright (C) 2021 John Donoghue <john.donoghue@ieee.org>
###
### This program is free software; you can redistribute it and/or
### modify it under the terms of the GNU General Public License as
### published by the Free Software Foundation; either version 3 of the
### License, or (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
### General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program; if not, see
### <http://www.gnu.org/licenses/>.

AC_PREREQ([2.67])
AC_INIT([octave joystick package], [0.0.1])
AC_CONFIG_HEADERS([config.h])

# Avoid warnings for redefining AH-generated preprocessor symbols of
# Octave.
AH_TOP([#include "undef-ah-octave.h"])

AC_CONFIG_MACRO_DIRS([m4])

# Checks for programs.
AC_PROG_CXX
AC_LANG(C++)

# Define macros needed
#AC_DEFINE(__STDC_CONSTANT_MACROS, [], [workaround for C++ programs to use C99 macros])

AC_CHECK_PROG([MKOCTFILE], [mkoctfile], [mkoctfile], [none])
if [test "$MKOCTFILE" = "none"]; then
  AC_MSG_ERROR([mkoctfile required to install $PACKAGE_NAME])
fi

AC_CHECK_PROG(OCTAVE_CONFIG,octave-config,octave-config)
test -z "$OCTAVE_CONFIG" && OCTAVE_CONFIG=$MKOCTFILE

AC_PROG_GREP
AC_PROG_SED

## Simple symbol alternatives of different Octave versions.
save_altsyms_CXX="$CXX"
save_altsyms_CXXFLAGS="$CXXFLAGS"
save_altsyms_LDFLAGS="$LDFLAGS"
save_altsyms_LIBS="$LIBS"
OCTINCLUDEDIR=${OCTINCLUDEDIR:-`$MKOCTFILE -p INCFLAGS`}
OCTLIBDIR=${OCTLIBDIR:-`$MKOCTFILE -p OCTLIBDIR`}
CXX=`${MKOCTFILE} -p CXX`
CXXFLAGS="$OCTINCLUDEDIR $CXXFLAGS"
LDFLAGS="-L$OCTLIBDIR $LDFLAGS"
LIBS="-loctinterp $LIBS"

# includes
AC_CHECK_HEADERS([octave/interpreter.h],
  [],
  [],
  [#include <octave/oct.h>]
)

AC_CHECK_HEADERS([octave/lo-sysdep.h],
  [],
  [],
  [#include <octave/oct.h>]
)

OF_OCTAVE_LIST_ALT_SYMS([
[dnl
  [feval],
  [octave::feval],
  [[octave::feval ("date");]],
  [OCTAVE__FEVAL],
  [[#include <octave/parse.h>]],
  [[#include <octave/parse.h>]]
],

[dnl
  [is_float_type],
  [isfloat],
  [[octave_value ().isfloat ();]],
  [OV_ISFLOAT],
  [],
  []
],

[dnl
  [is_integer_type],
  [isinteger],
  [[octave_value ().isinteger ();]],
  [OV_ISINTEGER],
  [],
  []
],

[dnl
  [is_bool_type],
  [islogical],
  [[octave_value ().islogical ();]],
  [OV_ISLOGICAL],
  [],
  []
],

[dnl
  [is_numeric_type],
  [isnumeric],
  [[octave_value ().isnumeric ();]],
  [OV_ISNUMERIC],
  [],
  []
],

[dnl
  [unwind_protect],
  [octave::unwind_protect],
  [[octave::unwind_protect frame;]],
  [OCTAVE__UNWIND_PROTECT],
  [[#include <octave/unwind-prot.h>]
   [#include <octave/octave.h>]
  ],
  [[#include <octave/unwind-prot.h>]
   [#include <octave/octave.h>]
  ]
]

],[oct-alt-includes.h])

CXX=$save_altsyms_CXX
CXXFLAGS=$save_altsyms_CXXFLAGS
LDFLAGS=$save_altsyms_LDFLAGS
LIBS=$save_altsyms_LIBS


# SDL/SDL2
AC_PATH_PROG(SDL_CONFIG, sdl2-config, no)
if test "$SDL_CONFIG" == "no" ; then
  AC_PATH_PROG(SDL_CONFIG, sdl-config, no)

  if test "$SDL_CONFIG" == "no" ; then
    AC_MSG_ERROR("*** No sdl-config or sdl2-config found")
  fi
fi

SDL_CFLAGS=`$SDL_CONFIG --cflags`
SDL_LIBS=`$SDL_CONFIG --libs`
SDL_PREFIX=`$SDL_CONFIG --prefix`

AC_SUBST(SDL_PREFIX)
AC_SUBST(SDL_CFLAGS)
AC_SUBST(SDL_LIBS)

SDL_MAJOR_VER=`$SDL_CONFIG --version | $SED -n 's/^\([[0-9\]]\).*/\1/p'`
AC_DEFINE_UNQUOTED([SDL_MAJOR_VER],[$SDL_MAJOR_VER],[Major version number of SDL])

# check sanity for what detected
save_sdl_CPPFLAGS="$CPPFLAGS"
save_sdl_LIBS="$LIBS"
CPPFLAGS="$CPPFLAGS $SDL_CFLAGS"
LIBS="$LIBS $SDL_LIBS"
AC_CHECK_HEADERS([SDL.h], [], AC_MSG_ERROR([SDL.h is required]))
AC_CHECK_FUNC([SDL_Quit], [], [AC_MSG_ERROR([Could not find SDL_Quit])])
LIBS=$save_sdl_LIBS
CPPFLAGS=$save_sdl_CPPFLAGS

# all done

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

AC_MSG_NOTICE([

$PACKAGE_NAME is now configured with
   SDL LIBS:         $SDL_LIBS
   SDL CFLAGS:       $SDL_CFLAGS

])
