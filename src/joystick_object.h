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

#ifndef JOYSTICKOBJECT_H
#define JOYSTICKOBJECT_H

// Octave Includes
#include <octave/oct.h>

#include <string>
#include <iostream>
#include <errno.h>

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

void init_types(void);

#include <SDL.h>

class joystick_dev_info
{
public:
  int id;
  std::string name;
  int naxis;
  int nhats;
  int nbuttons;
  int nballs;

  joystick_dev_info() { id=0; name=""; naxis=nhats=nbuttons=nballs=0;};
  virtual ~joystick_dev_info() {}
};

class octave_joystick : public OCTAVE_BASE_CLASS
{
public:
  octave_joystick();
  ~octave_joystick();

  bool create(int id);
  void close();

  /**
   * Various properties of the octave_base_value datatype.
   */
  bool is_constant (void) const { return true;}
  bool is_defined (void) const { return true;}
  bool is_object (void) const { return true; }
  bool isobject (void) const { return true; }

  string_vector map_keys (void) const { return fieldnames; }
  dim_vector dims (void) const { static dim_vector dv(1, 1); return dv; }

  octave_base_value * clone (void) const;
  octave_base_value * empty_clone (void) const;
  octave_base_value * unique_clone (void);

 /**
  * Overloaded methods to print object
  */
  void print (std::ostream& os, bool pr_as_read_syntax = false) const;
  void print (std::ostream& os, bool pr_as_read_syntax = false);
  void print_raw (std::ostream& os, bool pr_as_read_syntax) const;

 /**
  * overloaded methods to get properties
  */
  octave_value_list subsref (const std::string& type, const std::list<octave_value_list>& idx, int nargout);

  octave_value subsref (const std::string& type, const std::list<octave_value_list>& idx)
  {
    octave_value_list retval = subsref (type, idx, 1);
    return (retval.length () > 0 ? retval(0) : octave_value ());
  }

  double axis(int id);
  int button(int id);
  int pov(int id);
  //int force(int id, double f);
  joystick_dev_info caps() const;

  static std::vector<joystick_dev_info> listAvailableDevices();
private:
  octave_joystick(const octave_joystick &);

  string_vector fieldnames;

  joystick_dev_info info;
  SDL_Joystick *dev;

  DECLARE_OV_TYPEID_FUNCTIONS_AND_DATA
};

#endif // JOYSTICKOBJECT_H
