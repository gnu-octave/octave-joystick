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
## Get the value of button @var{id} on joystick @var{joy}.
##
## Currently not implemented except as a stub
##
## @subsubheading Inputs
## @var{joy} - a previously opened joystick object@*
## @var{id} - a positive numeric id for the joystick button to use@*
## @var{forcevalue} - force value to use@*
##
## @subsubheading Outputs
## None
##
## @seealso{vrjoystick}
## @end deftypefn

function force(varargin)
  warning("force not implmented yet");
endfunction
