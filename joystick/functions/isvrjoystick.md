---
layout: "default"
permalink: "/functions/12_isvrjoystick/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - isvrjoystick"
category: "Utility Functions"
func_name: "isvrjoystick"
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
<dt class="deftypefn def-line" id="index-isvrjoystick"><span class="category-def">: </span><span><code class="def-type"><var class="var">retval</var> =</code> <strong class="def-name">isvrjoystick</strong> <code class="def-code-arguments">(<var class="var">obj</var>)</code><a class="copiable-link" href="#index-isvrjoystick"></a></span></dt>
<dd><p>Check if input value is a vrjoystick object
</p>
<p>Function is essentially just a call of
 <code class="code">
 retval = isa(obj, &quot;octave_joystick&quot;);
 </code>
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">obj</var> - The object to check
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">retval</var> is true, if obj is an vrjoystick object, false otherwise.
</p>

<p><strong class="strong">See also:</strong> vrjoystick.
 </p></dd></dl>