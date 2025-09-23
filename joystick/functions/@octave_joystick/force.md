---
layout: "default"
permalink: "/functions/@octave_joystick/22_octavejoystickforce/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - @octave_joystick/force"
category: "Joystick Functions"
func_name: "@octave_joystick/force"
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
<dt class="deftypefn def-line" id="index-force"><span class="category-def">: </span><span><code class="def-type"><var class="var">joy</var> =</code> <strong class="def-name">force</strong> <code class="def-code-arguments">(<var class="var">joy</var>, <var class="var">id</var>, <var class="var">forcevalue</var>)</code><a class="copiable-link" href="#index-force"></a></span></dt>
<dd><p>Apply forcefeedback on axis <var class="var">id</var> on joystick <var class="var">joy</var>.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">joy</var> - a previously opened joystick object<br>
 <var class="var">id</var> - a positive numeric id for the joystick forcefeed axis to use<br>
 <var class="var">forcevalue</var> - force value to use, values should be between -1 .. 1<br>
</p>
<p>If <var class="var">id</var> is a vector of axis ids, <var class="var">forcevalue</var> is expected to be a
 single value applied to all of the specified axis or a vector of the same size
 as <var class="var">id</var>, with a value for  each axis.
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p>None
</p>

<p><strong class="strong">See also:</strong> vrjoystick.
 </p></dd></dl>