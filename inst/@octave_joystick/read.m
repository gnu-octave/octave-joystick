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
## @deftypefn {} {[@var{axes}, @var{buttons}, @var{povs}] =} read (@var{joy})
## Get the value of all axes, buttons and povs joystick @var{joy}.
##
## @subsubheading Inputs
## @var{joy} - a previously opened joystick object@*
##
## @subsubheading Outputs
## @var{axes} - vector of the axis values.@*
## @var{buttons} - vector of the button values.@*
## @var{povs} - vector of the pov values.@*
##
## @seealso{vrjoystick, axis, pov, buttons}
## @end deftypefn

function [axes, buttons, povs] = read(joy)
  buttons = [];
  povs = [];
  axess = [];

  c = caps(joy);

  for i=1:c.Buttons
    buttons(i) = __joystick_button__(joy, i);
  endfor
  for i=1:c.Axes
    axes(i) = __joystick_axis__(joy, i);
  endfor
  for i=1:c.POVs
    povs(i) = __joystick_pov__(joy, i);
  endfor

endfunction
