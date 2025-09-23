---
layout: "default"
permalink: "/functions/@octave_joystick/21_octavejoystickaxis/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - @octave_joystick/axis"
category: "Joystick Functions"
func_name: "@octave_joystick/axis"
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
<dt class="deftypefn def-line" id="index-axis"><span class="category-def">: </span><span><code class="def-type"><var class="var">joy</var> =</code> <strong class="def-name">axis</strong> <code class="def-code-arguments">(<var class="var">joy</var>, <var class="var">id</var>)</code><a class="copiable-link" href="#index-axis"></a></span></dt>
<dd><p>Get the value of axis <var class="var">id</var> on joystick <var class="var">joy</var>.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">joy</var> - a previously opened joystick object<br>
 <var class="var">id</var> - a positive numeric id for the joystick axis to use<br>
</p>
<p><var class="var">id</var> can be a vector of ids to allow getting multiple axis.
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">value</var> - value of the axis between -1 .. 1.<br>
</p>
<p><var class="var">value</var> will be a vector of values when getting multiple axis.
</p>
<h4 class="subsubheading" id="Examples"><span>Examples<a class="copiable-link" href="#Examples"></a></span></h4>
<p>Open device 1 and get value of axis 1
 </p><div class="example">
<pre class="example-preformatted"> <code class="code">
 joy = vrjoystick(1);
 val = axis(joy, 1)
 </code>
 </pre></div>


<p><strong class="strong">See also:</strong> vrjoystick.
 </p></dd></dl>