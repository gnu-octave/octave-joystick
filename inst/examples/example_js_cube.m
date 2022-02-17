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
## @deftypefn {} {} example_js_cube ()
## Example function where the joystick controls rotation of a 
## cube.
##
## @seealso{vrjoystick}
## @end deftypefn
function example_js_cube ()
  # create joystick object
  joy = vrjoystick(1)

  # create a figure and add a cube in center
  f = figure();
  xlim([-1 1]);
  ylim([-1 1]);

  h1 = cube(0,0,0, 1, 'r');
  h2 = cube(0,0,.5, .1, 'b');

  # loop reading joystick controls for x,y,z rotation
  while true
    pause(.1);
    pt = axis(joy, [1 2 3]);
    xt = pt * 2;

    # if no longer valid, stop the loop
    if !ishandle(f) || !ishandle(h1)
      break
    endif

    # rotate the cube by the scaled js axis value
    rotate([h1 h2], [1 0 0], xt(2))
    rotate([h1 h2], [0 1 0], xt(1))
    rotate([h1 h2], [0 0 1], -xt(3))

    if  button(joy, 1) == 1
      # set back to 0,0,0 by deleting object and creating new cube
      delete([h1 h2])
      h1 = cube(0,0,0, 1, 'r');
      h2 = cube(0,0,.5, .1, 'b');
    endif
  endwhile
endfunction

# help function to create a cube
function h = cube(x,y,z,sz, c)
  h_sz = double(sz)/2;
  vertices = [
    -h_sz -h_sz -h_sz;
    -h_sz  h_sz -h_sz;
     h_sz  h_sz -h_sz;
     h_sz -h_sz -h_sz;
    -h_sz -h_sz  h_sz;
    -h_sz  h_sz  h_sz;
     h_sz  h_sz  h_sz;
     h_sz -h_sz  h_sz
  ];

  faces = [1 2 3 4; 2 6 7 3; 4 3 7 8; 1 5 8 4; 1 2 6 5; 5 6 7 8];
  cols = [255 0 0; 0 255 0;0 0 255; 255 255 0; 255 0 255; 0 255 255; 192 192 193; 192 192 0];
  h = patch('Vertices', vertices + [x y z], 'Faces', faces, 'FaceColor', c);
endfunction

