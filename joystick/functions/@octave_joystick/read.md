---
layout: "default"
permalink: "/functions/@octave_joystick/21_octavejoystickread/"
pkg_name: "joystick"
pkg_version: "0.0.4"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - @octave_joystick/read"
category: "Joystick Functions"
func_name: "@octave_joystick/read"
navigation:
- id: "overview"
  name: "Overview"
  url: "/index"
- id: "Functions"
  name: "Function Reference"
  url: "/functions"
- id: "17_UtilityFunctions"
  name: "&nbsp;&nbsp;Utility Functions"
  url: "/functions/#17_UtilityFunctions"
- id: "18_JoystickFunctions"
  name: "&nbsp;&nbsp;Joystick Functions"
  url: "/functions/#18_JoystickFunctions"
- id: "news"
  name: "News"
  url: "/news"
- id: "manual"
  name: "Manual"
  url: "/manual"
---
<dl class="first-deftypefn def-block">
<dt class="deftypefn def-line" id="index-read"><span class="category-def">: </span><span><code class="def-type">[<var class="var">axes</var>, <var class="var">buttons</var>, <var class="var">povs</var>] =</code> <strong class="def-name">read</strong> <code class="def-code-arguments">(<var class="var">joy</var>)</code><a class="copiable-link" href="#index-read"></a></span></dt>
<dd><p>Get the value of all axes, buttons and povs joystick <var class="var">joy</var>.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">joy</var> - a previously opened joystick object<br>
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">axes</var> - vector of the axis values.<br>
 <var class="var">buttons</var> - vector of the button values.<br>
 <var class="var">povs</var> - vector of the pov values.<br>
</p>

<p><strong class="strong">See also:</strong> vrjoystick, axis, pov, buttons.
 </p></dd></dl>