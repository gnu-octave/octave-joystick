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

#ifdef HAVE_CONFIG_H
#  include "config.h"
#endif

#include "joystick_object.h"

#include <SDL.h>


static bool have_joystick = false;
static void process_events()
{
    SDL_Event event;
    while (SDL_PollEvent(&event)) {
        // do nothing withem them ?
	switch(event.type)
	  {
            case SDL_JOYAXISMOTION:
            case SDL_JOYBUTTONDOWN:
            case SDL_JOYBUTTONUP:
            case SDL_JOYHATMOTION:
            case SDL_JOYBALLMOTION:
              have_joystick = true;
	    default:
              break;
          }
    }

}

DEFINE_OV_TYPEID_FUNCTIONS_AND_DATA (octave_joystick, "octave_joystick", "octave_joystick");

octave_joystick::octave_joystick ()
{
  dev = 0;
}

octave_joystick::octave_joystick (const octave_joystick &m)
{
  dev = 0;
}

octave_joystick::~octave_joystick (void)
{
  close ();
}

bool
octave_joystick::create (int id)
{
  close ();

  process_events(); //SDL_JoystickUpdate();

  dev = SDL_JoystickOpen(id-1);
  if(dev)
    {
      joystick_dev_info d;
#if SDL_MAJOR_VER > 1
      d.name = SDL_JoystickName(dev);
#else
      d.name = SDL_JoystickName(id);
#endif

      d.naxis = SDL_JoystickNumAxes(dev);
      d.nbuttons = SDL_JoystickNumButtons(dev);
      d.nballs = SDL_JoystickNumBalls(dev);
      d.nhats = SDL_JoystickNumHats(dev);

      d.id = id;

      info = d;
    }

  return dev != 0;
}

double
octave_joystick::axis (int id)
{
  process_events(); //SDL_JoystickUpdate();

  if(dev && info.naxis >= id)
    {
      Sint16 val = 0;
      if(have_joystick)
        val = SDL_JoystickGetAxis(dev, id-1);
      return double(val)/32767;
    }

  return 0;
}

int
octave_joystick::button (int id)
{
  process_events(); //SDL_JoystickUpdate();

  if(dev && info.nbuttons >= id)
    {
      int val = SDL_JoystickGetButton(dev, id-1);
      return val;
    }

  return 0;
}

int
octave_joystick::pov (int id)
{
  process_events(); //SDL_JoystickUpdate();

  if(dev && info.nhats >= id)
    {
      int val = SDL_JoystickGetHat(dev, id-1);
    
      switch(val)
        {
          case SDL_HAT_CENTERED: val = -1; break;
          case SDL_HAT_UP: val = 0; break;
          case SDL_HAT_RIGHTUP: val =45; break;
          case SDL_HAT_RIGHT: val = 90; break;
          case SDL_HAT_RIGHTDOWN: val = 135;
          case SDL_HAT_DOWN: val = 180; break;
          case SDL_HAT_LEFTDOWN: val = 225; break;
          case SDL_HAT_LEFT: val = 270; break;
          case SDL_HAT_LEFTUP: val = 315; break;
          default: val = -1; break;
        }

      return val;
    }

  return -1;
}

joystick_dev_info
octave_joystick::caps () const
{
  return info;
}

void
octave_joystick::close ()
{
 if (dev)
   SDL_JoystickClose(dev);
 dev = 0;
 info.id = 0;
}

octave_base_value *
octave_joystick::empty_clone (void) const
{
  return new octave_joystick();
}

octave_base_value *
octave_joystick::clone (void) const
{
  return new octave_joystick (*this);
}

octave_base_value *
octave_joystick::unique_clone (void)
{
  count++;
  return this;
}

void
octave_joystick::print (std::ostream& os, bool pr_as_read_syntax) const
{
  print_raw (os, pr_as_read_syntax);
  newline (os);
}

void
octave_joystick::print (std::ostream& os, bool pr_as_read_syntax)
{
  print_raw (os, pr_as_read_syntax);
  newline (os);
}

void
octave_joystick::print_raw (std::ostream& os, bool pr_as_read_syntax) const
{
  os << "  Joystick object"; newline (os);
  if(dev)
    {
      os << "      ID: " << info.id; newline(os);
      os << "    Name: " << info.name; newline(os);
    }
  else
    {
      os << "      (closed)"; newline(os);
    }
}

octave_value_list
octave_joystick::subsref (const std::string& type, const std::list<octave_value_list>& idx, int nargout)
{
  octave_value_list retval;

  int skip = 1;

  switch (type[0])
    {
    default:
      error ("octave_joystick object cannot be indexed with %c", type[0]);
      break;
    case '.':
      {
        std::string propname = (((idx.front()) (0)).string_value ());

	if (propname == "ID")
          {
            retval = octave_value(info.id);
          }
	else if (propname == "Name")
          {
            retval = octave_value(info.name);
          }
	else if (propname == "Status")
          {
            if (dev)
              retval = octave_value("Open");
            else
              retval = octave_value("Closed");
          }
	else if (type.length() > 1 && type[1] == '(')
          {
            octave_value_list ovl;
            count++;
            ovl(0) = octave_value (this);
            std::list<octave_value_list>::const_iterator it = idx.begin ();
            if (it != idx.end())
              ovl.append (*++it);
            retval = OCTAVE__FEVAL (propname, ovl, 1);
            skip++;
          }
	else
	  {
            error ("octave_joystick object unknown property '%s'", propname.c_str());
	  }
      }
      break;
    }

  if (idx.size () > 1 && type.length () > 1)
    retval = retval (0).next_subsref (nargout, type, idx, skip);

  return retval;
}

std::vector<joystick_dev_info> octave_joystick::listAvailableDevices()
{
  std::vector<joystick_dev_info> devs;

  process_events(); //SDL_JoystickUpdate();

  int jcount = SDL_NumJoysticks();
  SDL_Joystick * joy = 0;

  for(int i=0;i<jcount; i++)
    {
      joy = SDL_JoystickOpen(i);
      if (joy)
        {
          joystick_dev_info d;
#if SDL_MAJOR_VER > 1
          d.name = SDL_JoystickName(joy);
#else
          d.name = SDL_JoystickName(i);
#endif

          d.naxis = SDL_JoystickNumAxes(joy);
          d.nbuttons = SDL_JoystickNumButtons(joy);
          d.nballs = SDL_JoystickNumBalls(joy);
          d.nhats = SDL_JoystickNumHats(joy);

          d.id = 1+i;

          devs.push_back(d);

          SDL_JoystickClose(joy);
        }
    }

  return devs;
}

static bool type_loaded = false;

void init_types(void)
{
  if (!type_loaded)
    {
      type_loaded = true;
      octave_joystick::register_type ();

      if(SDL_Init(SDL_INIT_JOYSTICK) != 0)
        {
	   error("error in sdl_init: %s\n", SDL_GetError() );
        }
      else
        {
          //SDL_JoystickEventState(SDL_IGNORE);
	  //SDL_SetEventFilter()
	}
    }
}
