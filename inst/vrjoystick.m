## Copyright (C) 2021 John Donoghue <john.donoghue@ieee.org>
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
## @deftypefnx {} {@var{joy} =} vrjoystick (@var{dev}, @var{"forcefeedback"})
## Attempt to open a joystick.
##
## @subsubheading Inputs
## @var{id} - a positive numeric id for the joystick device to use.@*
## @var{"forcefeedback"} - String constant to enable forcefeedback (currently not used).@*
##
## @subsubheading Outputs
## @var{joy} - a octave_joystick object.@*
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

function obj = vrjoystick(id)
  if nargin < 1 || !isnumeric(id) || id < 1
    error ("Expected id to be a positive numeric value");
  endif
  obj = __joystick__(id);
endfunction

%!xtest
%! # may fail if no devices
%! joy = vrjoystick(1);
%! assert(!isempty(joy))

%!error <Expected id> vrjoystick ()
