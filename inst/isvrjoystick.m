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
## @deftypefn {} {@var{retval} =} isvrjoystick (@var{obj})
## Check if input value is a vrjoystick object
##
## Function is essentially just a call of
## @code {
## retval = isa(obj, "octave_joystick");
## }
##
## @subsubheading Inputs
## @var{obj} - The object to check
##
## @subsubheading Outputs
## @var{retval} is true, if obj is an vrjoystick object, false otherwise.
##
## @seealso{vrjoystick}
## @end deftypefn

function retval = isvrjoystick (obj)
  retval = false;
  if nargin > 0 && isa(obj, "octave_joystick")
    retval = true;
  endif
endfunction

%!xtest
%! joy = vrjoystick(1);
%! assert(isvrjoystick(joy), true)

%!assert(isvrjoystick(0), false)
%!assert(isvrjoystick({}), false)
%!assert(isvrjoystick([]), false)
%!assert(isvrjoystick(), false)
