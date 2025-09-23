---
layout: "default"
permalink: "/functions/10_vrjoystick/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - vrjoystick"
category: "Joystick Functions"
func_name: "vrjoystick"
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
<dt class="deftypefn def-line" id="index-vrjoystick"><span class="category-def">: </span><span><code class="def-type"><var class="var">joy</var> =</code> <strong class="def-name">vrjoystick</strong> <code class="def-code-arguments">(<var class="var">id</var>)</code><a class="copiable-link" href="#index-vrjoystick"></a></span></dt>
<dt class="deftypefnx def-cmd-deftypefn def-line" id="index-vrjoystick-1"><span class="category-def">: </span><span><code class="def-type"><var class="var">joy</var> =</code> <strong class="def-name">vrjoystick</strong> <code class="def-code-arguments">(<var class="var">id</var>, <var class="var">&quot;forcefeedback&quot;</var>)</code><a class="copiable-link" href="#index-vrjoystick-1"></a></span></dt>
<dd><p>Attempt to open a joystick.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p><var class="var">id</var> - a positive numeric id for the joystick device to use.<br>
 <var class="var">&quot;forcefeedback&quot;</var> - String constant to enable forcefeedback.<br>
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">joy</var> - a octave_joystick object.<br>
</p>
<h4 class="subsubheading" id="Joystick-Properties"><span>Joystick Properties<a class="copiable-link" href="#Joystick-Properties"></a></span></h4>
<p>A joystick object has the following properties:
 </p><dl class="table">
<dt>ID</dt>
<dd><p>The ID of the joystick as used to create the joystick
 </p></dd>
<dt>Name</dt>
<dd><p>The name of the joystick device
 </p></dd>
<dt>Status</dt>
<dd><p>Status of the joystick (&quot;Open&quot; or &quot;Closed&quot;)
 </p></dd>
<dt>ForceFeedbackSupported</dt>
<dd><p>Boolean for if the joystick was opened with forcefeedback enabled and
 supports forcefeedback.
 </p></dd>
</dl>

<h4 class="subsubheading" id="Joystick-Functions"><span>Joystick  Functions<a class="copiable-link" href="#Joystick-Functions"></a></span></h4>
<p>A joystick object provides the following functions:
 </p><dl class="table">
<dt>axis</dt>
<dd><p>Get the value of a joystick axis
 </p></dd>
<dt>buttons</dt>
<dd><p>Get the state of a joystick button
 </p></dd>
<dt>caps</dt>
<dd><p>Get the capabilities of the joystick
 </p></dd>
<dt>close</dt>
<dd><p>Close a joystick
 </p></dd>
<dt>force</dt>
<dd><p>Set the forcefeedback forces on a joystick
 </p></dd>
<dt>pov</dt>
<dd><p>Get the pov values from a joystick
 </p></dd>
<dt>read</dt>
<dd><p>Read all state values from a joystick
 </p></dd>
</dl>

<h4 class="subsubheading" id="Examples"><span>Examples<a class="copiable-link" href="#Examples"></a></span></h4>
<p>Open device 1
 </p><div class="example">
<pre class="example-preformatted"> <code class="code">
 joy = vrjoystick(1);
 </code>
 </pre></div>


<p><strong class="strong">See also:</strong> vrjoysticklist.
 </p></dd></dl>