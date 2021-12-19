// Copyright (C) 2021 John Donoghue <john.donoghue@ieee.org>
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, see <http://www.gnu.org/licenses/>.

// Octave Includes
#include <octave/oct.h>
#include <octave/defun-dld.h>
#include <octave/ov.h>
#include <octave/oct-map.h>

#include <iostream>
#include <iomanip>

#if defined (HAVE_CONFIG_H)
#  include "config.h"
#endif

#include "joystick_object.h"

// PKG_ADD: autoload ("__joystick_list__", "__joystick__.oct");
DEFUN_DLD (__joystick_list__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {@var{dev} = }  __joystick_list__()\n \
private function of __joystick__\n \
@end deftypefn")
{
  if ( 0 < args.length ())
    {
      print_usage();
      return octave_value ();
    } 

  init_types ();

  std::vector<joystick_dev_info> devs = octave_joystick::listAvailableDevices(); 

  Cell name (dim_vector (1, devs.size()));
  Cell id (dim_vector (1, devs.size()));

  for(size_t i=0; i<devs.size(); i++)
    {
      joystick_dev_info dev = devs[i];

      name(i) = dev.name;
      id(i) = dev.id;
    }

  octave_map devinfo;
  devinfo.setfield("ID", id);
  devinfo.setfield("Name", name);

  return octave_value(devinfo);
}

// PKG_ADD: autoload ("__joystick_axis__", "__joystick__.oct");
DEFUN_DLD (__joystick_axis__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {} __joystick_axis__ ()\n \
Private function of __joystick__\n \
\n \
@end deftypefn")
{

  octave_value_list retval;

  if (2 != args.length())
    {
      print_usage();
      return retval;
    }

  if (args (0).type_id () != octave_joystick::static_type_id ())
    {
      error ("Expected joystick device");
      return retval;
    }

  if (!args(1).OV_ISNUMERIC())
    {
      error ("Expected joystick exes id");
      return octave_value();
    }

  int id = args(1).int_value ();

  if(id <= 0)
    {
      error ("Expected joystick axis 1 based id");
      return octave_value();
    }

  octave_joystick * dev = dynamic_cast<octave_joystick*>(args (0).internal_rep ());

  return octave_value(dev->axis(id));
}

// PKG_ADD: autoload ("__joystick_button__", "__joystick__.oct");
DEFUN_DLD (__joystick_button__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {} __joystick_button__ ()\n \
Private function of __joystick__\n \
\n \
@end deftypefn")
{

  octave_value_list retval;

  if (2 != args.length())
    {
      print_usage();
      return retval;
    }

  if (args (0).type_id () != octave_joystick::static_type_id ())
    {
      error ("Expected joystick device");
      return retval;
    }

  if (!args(1).OV_ISNUMERIC())
    {
      error ("Expected joystick button id");
      return octave_value();
    }

  int id = args(1).int_value ();

  if(id <= 0)
    {
      error ("Expected joystick button 1 based id");
      return octave_value();
    }

  octave_joystick * dev = dynamic_cast<octave_joystick*>(args (0).internal_rep ());

  return octave_value(dev->button(id));
}

// PKG_ADD: autoload ("__joystick_pov__", "__joystick__.oct");
DEFUN_DLD (__joystick_pov__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {} __joystick_pov__ ()\n \
Private function of __joystick__\n \
\n \
@end deftypefn")
{

  octave_value_list retval;

  if (2 != args.length())
    {
      print_usage();
      return retval;
    }

  if (args (0).type_id () != octave_joystick::static_type_id ())
    {
      error ("Expected joystick device");
      return retval;
    }

  if (!args(1).OV_ISNUMERIC())
    {
      error ("Expected joystick pov id");
      return octave_value();
    }

  int id = args(1).int_value ();

  if(id <= 0)
    {
      error ("Expected joystick pov 1 based id");
      return octave_value();
    }

  octave_joystick * dev = dynamic_cast<octave_joystick*>(args (0).internal_rep ());

  return octave_value(dev->pov(id));
}

// PKG_ADD: autoload ("__joystick_caps__", "__joystick__.oct");
DEFUN_DLD (__joystick_caps__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {} __joystick_caps__ ()\n \
Private function of __joystick__\n \
\n \
@end deftypefn")
{

  octave_value_list retval;

  if (1 != args.length())
    {
      print_usage();
      return retval;
    }

  if (args (0).type_id () != octave_joystick::static_type_id ())
    {
      error ("Expected joystick device");
      return retval;
    }

  octave_joystick * dev = dynamic_cast<octave_joystick*>(args (0).internal_rep ());

  joystick_dev_info info = dev->caps();

  octave_map devinfo;
  devinfo.setfield("Axes", octave_value(info.naxis));
  devinfo.setfield("Buttons", octave_value(info.nbuttons));
  devinfo.setfield("POVs", octave_value(info.nhats));
  devinfo.setfield("Forces", octave_value(0));

  return octave_value(devinfo);
}

// PKG_ADD: autoload ("__joystick_close__", "__joystick__.oct");
DEFUN_DLD (__joystick_close__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {} __joystick_close__ ()\n \
Private function of __joystick__\n \
\n \
@end deftypefn")
{

  octave_value_list retval;

  if (1 != args.length())
    {
      print_usage();
      return retval;
    }

  if (args (0).type_id () != octave_joystick::static_type_id ())
    {
      error ("Expected joystick device");
      return retval;
    }

  octave_joystick * dev = dynamic_cast<octave_joystick*>(args (0).internal_rep ());

  dev->close();

  return octave_value(1);
}

// PKG_ADD: autoload ("__joystick__", "__joystick__.oct");
DEFUN_DLD (__joystick__, args, nargout,
"-*- texinfo -*-\n\
@deftypefn {Package} {@var{dev} = }  __joystick__()\n \
Private function of __joystick__\n \
\n \
@seealso{vrjoystick}\n \
@end deftypefn")
{

  if ( 1 != args.length ())
    {
      print_usage();
      return octave_value ();
    } 


  if (!args(0).OV_ISNUMERIC())
    {
      error ("Expected joystick id");
      return octave_value();
    }

  int id = args(0).int_value ();

  if(id <= 0)
    {
      error ("Expected joystick 1 based id");
      return octave_value();
    }

  init_types ();
  
  octave_joystick * retvalue = new octave_joystick ();

  if ( retvalue->create (id)  == false )
    {
      error ("creating joystick: %s\n", SDL_GetError());
      delete retvalue;
      return octave_value ();
    }

  return octave_value (retvalue);
}
