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
## @deftypefn {} {} vrjoysticklist ()
## @deftypefnx {} {@var{joylist} =} vrjoysticklist ()
## Get or print the available joystick devices.
##
## @subsubheading Inputs
## None
##
## @subsubheading Outputs
## @var{joylist} - a list of joystick ID, Name structures..@*
##
## @subsubheading Examples
## Display available joysticks
## @example
## @code {
## vrjoysticklist;
## }
## @end example
##
## Get a list available joysticks to a variable
## @example
## @code {
## joylist = joysticklist;
## }
## @end example
##
## The list will contain ID and Name entries for each joystick.
##
## @seealso{vrjoystick}
## @end deftypefn

function obj = vrjoysticklist()

  if nargin > 0
    show_usage();
  endif

  tmp = __joystick_list__();
  if nargout > 0
    obj = tmp;
  else
    # display
    printf("ID Name\n");
    for i=1:length(tmp)
      printf("%2d %s\n", tmp(i).ID, tmp(i).Name);
    endfor
  endif
endfunction

%!test
%! joy = vrjoysticklist;


