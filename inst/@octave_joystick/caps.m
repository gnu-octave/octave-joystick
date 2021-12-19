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
## @deftypefn {} {@var{info} =} caps (@var{joy})
## Get the capabilites joystick @var{joy}.
##
## @subsubheading Inputs
## @var{joy} - a previously opened joystick object@*
##
## @subsubheading Outputs
## @var{info} - A struct with fields Axis, Buttons, Force, POVs to hold the numeric count of each in joystick.@*
##
## @subsubheading Examples
## Open device 1 and capabilities
## @example
## @code {
## joy = vrjoystick(1);
## c = caps(joy)
## }
## @end example
##
## @seealso{vrjoystick}
## @end deftypefn

function val = caps(joy)
  if nargin != 1
    print_usage();
  endif

  val = __joystick_caps__(joy);
endfunction
