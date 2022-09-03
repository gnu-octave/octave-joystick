// Copyright (C) 2021-2022 John Donoghue <john.donoghue@ieee.org>
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
static bool warn_joystick = false;

static void process_events()
{
  if (SDL_JoystickEventState(SDL_QUERY) == SDL_IGNORE)
    {
      SDL_JoystickUpdate();
      have_joystick = true;
    }
  else
    {
      SDL_Event event;
      while (SDL_PollEvent(&event))
        {
          // do nothing with them - just flag we have something
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
}

DEFINE_OV_TYPEID_FUNCTIONS_AND_DATA (octave_joystick, "octave_joystick", "octave_joystick");

octave_joystick::octave_joystick ()
  : fieldnames(4)
{
  dev = 0;
#ifdef SDL_INIT_HAPTIC
  haptic = 0;
  fxid = -1;
#endif

  fieldnames[0] = "ID";
  fieldnames[1] = "Name";
  fieldnames[2] = "Status";
  fieldnames[3] = "ForceFeedbackSupported";
}

octave_joystick::octave_joystick (const octave_joystick &m)
{
  dev = 0;
  fieldnames = m.fieldnames;
}

octave_joystick::~octave_joystick (void)
{
  close ();
}

bool
octave_joystick::create (int id, bool force)
{
  close ();

  process_events();

  dev = SDL_JoystickOpen(id-1);
  if(dev)
    {
      joystick_dev_info d;
#if SDL_MAJOR_VER > 1
      d.name = SDL_JoystickName(dev);
#else
      d.name = SDL_JoystickName(id-1);
#endif

      d.naxis = SDL_JoystickNumAxes(dev);
      d.nbuttons = SDL_JoystickNumButtons(dev);
      d.nballs = SDL_JoystickNumBalls(dev);
      d.nhats = SDL_JoystickNumHats(dev);

      d.id = id;

      // haptic ?
#ifdef SDL_INIT_HAPTIC
      if (force)
        {
          haptic = 0;
          if(SDL_JoystickIsHaptic(dev))
            {
              haptic = SDL_HapticOpenFromJoystick(dev);
              if (haptic)
                {
                  unsigned int fx = SDL_HapticQuery(haptic);
                  d.nforce = SDL_HapticNumAxes(haptic);

		  SDL_HapticEffect *efx = &hfx;
		  SDL_zerop(efx);
                  if (fx & (SDL_HAPTIC_SINE|SDL_HAPTIC_TRIANGLE))
                    {
                      if(fx & SDL_HAPTIC_SINE) efx->type = SDL_HAPTIC_SINE;
		      else efx->type = SDL_HAPTIC_TRIANGLE;
                      efx->periodic.direction.type = SDL_HAPTIC_SPHERICAL;
                      efx->periodic.period = 1000;
                      efx->periodic.magnitude = 0x4000;
                      efx->periodic.length = 5000;
                      efx->periodic.attack_length = 0;
                      efx->periodic.fade_length = 0;

                      fxid = SDL_HapticNewEffect(haptic, efx);
                    }
                }
            }

	  if (haptic == 0)
            {
              warning_with_id("joystick:no-force-feedback", "Could not initialize forcefeedback for this joystick");
            }
        }
#else
      if (force && !warn_joystick)
        {
          warning_with_id("joystick:no-force-feedback", "Forcefeedback not available");
          // only warn about notavaiable once
          warn_joystick = true;
	}
#endif
      info = d;
    }

  return dev != 0;
}

double
octave_joystick::axis (int id)
{
  process_events();

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
  process_events();

  if(dev && info.nbuttons >= id)
    {
      int val = SDL_JoystickGetButton(dev, id-1);
      return val;
    }

  return 0;
}

int
octave_joystick::force (double forces[3])
{
  process_events();

#if SDL_INIT_HAPTIC
  if (haptic && fxid >= 0)
    {
      //x,y
      double d1 = 0;
      if (forces[1] == 0)
        d1 = 0;
      else
        d1 = std::atan(forces[0]/forces[1]);

      d1 = d1 * 180.0 / 3.14;
      d1 -= 90;
      if (d1 < 0) d1 =    d1 + 360;
      if (d1 >= 360) d1 = d1 - 360;

      double f1 = std::sqrt(forces[1]*forces[1] + forces[0]*forces[0]);
      f1 = f1 / 1.5;

      // NOTE: need work out a direction for down based on force abs(fwd) * updown
      
      double f2 = forces[2];

      SDL_HapticStopEffect(haptic, fxid);

      hfx.periodic.direction.dir[0] = d1*100;
      // TODO
      hfx.periodic.direction.dir[1] = 0;
      hfx.periodic.magnitude = (Sint16)(f1*32767.0f);
      if (SDL_HapticUpdateEffect(haptic, fxid, &hfx) < 0)
        {
          return 0;
        }

      return SDL_HapticRunEffect(haptic, fxid, 1) == 0;
    }
#endif
  return 0;
}

int
octave_joystick::pov (int id)
{
  process_events();

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
#ifdef SDL_INIT_HAPTIC
  if (haptic)
    SDL_HapticClose(haptic);
  haptic = 0;
#endif

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
            retval(0) = octave_value(info.id);
          }
	else if (propname == "Name")
          {
            retval(0) = octave_value(info.name);
          }
	else if (propname == "ForceFeedbackSupported")
          {
            retval(0) = octave_value(info.nforce > 0);
	  }
	else if (propname == "Status")
          {
            if (dev)
              retval(0) = octave_value("Open");
            else
              retval(0) = octave_value("Closed");
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
	    return retval;
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

  process_events();

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

#ifdef SDL_INIT_HAPTIC
          if (SDL_JoystickIsHaptic(joy))
            {
              SDL_Haptic * haptic = 0;
              haptic = SDL_HapticOpenFromJoystick(joy);
              if (haptic)
                {
                  // only get axis if we also support rumble
		  if (SDL_HapticRumbleSupported(haptic) == SDL_TRUE)
                    d.nforce = SDL_HapticNumAxes(haptic);
                  SDL_HapticClose(haptic);
                }
            }
#endif
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
#ifdef SDL_INIT_HAPTIC
      if(SDL_Init(SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC) != 0)
        {
	   error("error in sdl_init: %s\n", SDL_GetError() );
        }
#else
      if(SDL_Init(SDL_INIT_JOYSTICK) != 0)
        {
	   error("error in sdl_init: %s\n", SDL_GetError() );
        }
#endif
      else
        {
#if SDL_MAJOR_VER < 2
          // seems only way to make it work in sdl1 is to not use events
          SDL_JoystickEventState(SDL_IGNORE);
#endif
	}
    }
}
