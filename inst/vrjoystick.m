## Copyright (C) 2021-2022 John Donoghue <john.donoghue@ieee.org>
##
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{joy} =} vrjoystick (@var{id})
## @deftypefnx {} {@var{joy} =} vrjoystick (@var{id}, @var{"forcefeedback"})
## Attempt to open a joystick.
##
## @subsubheading Inputs
## @var{id} - a positive numeric id for the joystick device to use.@*
## @var{"forcefeedback"} - String constant to enable forcefeedback.@*
##
## @subsubheading Outputs
## @var{joy} - a octave_joystick object.@*
##
## @subsubheading Joystick Properties
## A joystick object has the following properties:
## @table @asis
## @item ID
## The ID of the joystick as used to create the joystick
## @item Name
## The name of the joystick device
## @item Status
## Status of the joystick ("Open" or "Closed")
## @item ForceFeedbackSupported
## Boolean for if the joystick was opened with forcefeedback enabled and
## supports forcefeedback.
## @end table
##
## @subsubheading Joystick  Functions
## A joystick object provides the following functions:
## @table @asis
## @item axis
## Get the value of a joystick axis
## @item buttons
## Get the state of a joystick button
## @item caps
## Get the capabilities of the joystick
## @item close
## Close a joystick
## @item force
## Set the forcefeedback forces on a joystick
## @item pov
## Get the pov values from a joystick
## @item read
## Read all state values from a joystick
## @end table
##
## @subsubheading Examples
## Open device 1
## @example
## @code {
## joy = vrjoystick(1);
## }
## @end example
##
## @seealso{vrjoysticklist}
## @end deftypefn

function obj = vrjoystick(id, forcefeed="")
  if nargin < 1 || !isnumeric(id) || id < 1
    error ("Expected id to be a positive numeric value");
  endif
  if nargin > 1
    if !ischar(forcefeed) || !strcmp(forcefeed, "forcefeedback")
      error ("Expected second argument if specified to be 'forcefeedback'");
    endif
  endif
  obj = __joystick__(id, strcmp(forcefeed, "forcefeedback"));
endfunction

%!xtest
%! # may fail if no devices
%! joy = vrjoystick(1);
%! assert(!isempty(joy));
%! assert(joy.ID, 1);
%! assert(!isempty(joy.Name));
%! assert(joy.Status, "Open");
%! assert(joy.ForceFeedbackSupported, false);
%! close(joy);
%! assert(joy.Status, "Closed");

%!xtest
%! # may fail if no devices
%! joy = vrjoystick(1, 'forcefeedback');
%! assert(!isempty(joy));

%!error <Expected id> vrjoystick ();
