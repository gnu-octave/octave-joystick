---
layout: "default"
permalink: "/functions/@octave_joystick/21_octavejoystickcaps/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - @octave_joystick/caps"
category: "Joystick Functions"
func_name: "@octave_joystick/caps"
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
<dt class="deftypefn def-line" id="index-caps"><span class="category-def">: </span><span><code class="def-type"><var class="var">info</var> =</code> <strong class="def-name">caps</strong> <code class="def-code-arguments">(<var class="var">joy</var>)</code><a class="copiable-link" href="#index-caps"></a></span></dt>
<dd><p>Get the capabilities joystick <var class="var">joy</var>.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">joy</var> - a previously opened joystick object<br>
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">info</var> - A struct with fields Axis, Buttons, Force, POVs to hold the numeric count of each in joystick.<br>
</p>
<h4 class="subsubheading" id="Examples"><span>Examples<a class="copiable-link" href="#Examples"></a></span></h4>
<p>Open device 1 and capabilities
 </p><div class="example">
<pre class="example-preformatted"> <code class="code">
 joy = vrjoystick(1);
 c = caps(joy)
 </code>
 </pre></div>


<p><strong class="strong">See also:</strong> vrjoystick.
 </p></dd></dl>