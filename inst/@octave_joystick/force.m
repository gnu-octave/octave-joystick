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
## @deftypefn {} {@var{joy} =} force (@var{joy}, @var{id}, @var{forcevalue})
## Apply forcefeedback on axis @var{id} on joystick @var{joy}.
##
## @subsubheading Inputs
## @var{joy} - a previously opened joystick object@*
## @var{id} - a positive numeric id for the joystick forcefeed axis to use@*
## @var{forcevalue} - force value to use, values should be between -1 .. 1@*
##
## If @var{id} is a vector of axis ids, @var{forcevalue} is expected to be a
## single value applied to all of the specified axis or a vector of the same size
## as @var{id}, with a value for  each axis.
##
## @subsubheading Outputs
## None
##
## @seealso{vrjoystick}
## @end deftypefn

function force(joy, id, f)
  if nargin != 3 || !isnumeric(id)
    print_usage();
  endif

  if isvector(id) && length(id) > 1
    fs = zeros(1,length(id));
    for i = 1:length(id)
      if isvector(f) && length(f) > 1
        fs(i) = f(i);
      else
        fs(i) = f;
      endif
      #__joystick_force__(joy, id(i), fs(i));
    endfor
    __joystick_force__(joy, id, fs);
  else
    __joystick_force__(joy, id, f);
  endif

endfunction
