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
## @deftypefn {} {@var{joy} =} pov (@var{joy}, @var{id})
## Get the value of pov @var{id} on joystick @var{joy}.
##
## @subsubheading Inputs
## @var{joy} - a previously opened joystick object@*
## @var{id} - a positive numeric id for the joystick pov to use@*
##
## @var{id} can be a vector of ids to allow getting multiple povs.
##
## @subsubheading Outputs
## @var{value} - value of the pov as an angle in degrees, or -1 if not pressed.@*
##
## @var{value} will be a vector of values when getting multiple buttons.
##
## @subsubheading Examples
## Open device 1 and get value of pov 1
## @example
## @code {
## joy = vrjoystick(1);
## val = pov(joy, 1)
## }
## @end example
##
## @seealso{vrjoystick}
## @end deftypefn

function val = pov(joy, id)

  if nargin != 2 || !isnumeric(id)
    print_usage();
  endif

  if isvector(id) && length(id) > 1
    val = [];
    for i = 1:length(id)
      val(end+1) = __joystick_pov__(joy, id(i));
    endfor
  else
    val = __joystick_pov__(joy, id);
  endif
endfunction
