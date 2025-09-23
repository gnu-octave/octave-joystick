---
layout: "default"
permalink: "/functions/14_vrjoysticklist/"
pkg_name: "joystick"
pkg_version: "0.0.3"
pkg_description: "Provides Joystick functions for Octave"
title: "Joystick Toolkit - vrjoysticklist"
category: "Utility Functions"
func_name: "vrjoysticklist"
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
<dt class="deftypefn def-line" id="index-vrjoysticklist"><span class="category-def">: </span><span><strong class="def-name">vrjoysticklist</strong> <code class="def-code-arguments">()</code><a class="copiable-link" href="#index-vrjoysticklist"></a></span></dt>
<dt class="deftypefnx def-cmd-deftypefn def-line" id="index-vrjoysticklist-1"><span class="category-def">: </span><span><code class="def-type"><var class="var">joylist</var> =</code> <strong class="def-name">vrjoysticklist</strong> <code class="def-code-arguments">()</code><a class="copiable-link" href="#index-vrjoysticklist-1"></a></span></dt>
<dd><p>Get or print the available joystick devices.
</p>
<h4 class="subsubheading" id="Inputs"><span>Inputs<a class="copiable-link" href="#Inputs"></a></span></h4>
<p>None
</p>
<h4 class="subsubheading" id="Outputs"><span>Outputs<a class="copiable-link" href="#Outputs"></a></span></h4>
<p><var class="var">joylist</var> - a list of joystick ID, Name, ForceFeedbackSupported structures.<br>
</p>
<h4 class="subsubheading" id="Examples"><span>Examples<a class="copiable-link" href="#Examples"></a></span></h4>
<p>Display available joysticks
 </p><div class="example">
<pre class="example-preformatted"> <code class="code">
 vrjoysticklist;
 </code>
 </pre></div>

<p>Get a list available joysticks to a variable
 </p><div class="example">
<pre class="example-preformatted"> <code class="code">
 joylist = joysticklist;
 </code>
 </pre></div>

<p>The list will contain ID, Name and ForceFeedbackSupported entries for each joystick.
</p>

<p><strong class="strong">See also:</strong> vrjoystick.
 </p></dd></dl>