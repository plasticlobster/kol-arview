This relay script will add an "AR Mode" to your mall sales screen, which will automatically number sales in order by item per-KoL day. This is particularly useful for anti-raffles (AR's) and other mall store buying games.
Days are broken down into KoL days because rollover is what dictates if someone is able to buy a new ticket, not a new day.

This script also:
- Separates purchases by day, with a configuration you can set (below) that will toggle between KoL days and real-life days.
- Adds a refresh button to your sales (Whether in AR mode or not)
- Lets you click on a ticket number to copy the purchase message to your clipboard (for easy pasting in /games)
- Lets you click on the winner and will take you to send them a message or gift depending on if the user is in HC/Ronin or not.

To change day separation on regular mode to be by KoL day (not real-life day), type:
<pre>
set PL_ARView_Use_KoL_Dates = true
</pre>
into your KoLMafia CLI.

To change it back to real-life days, type:
<pre>
set PL_ARView_Use_KoL_Dates = false
</pre>
into your KoLMafia CLI.

Guide
=====

To install, type:
----------------------
<pre>
svn checkout https://github.com/plasticlobster/kol-arview/branches/Release
</pre>

in your KoLMafia CLI.

Now when you go to your mall store and look at your sales, you will see a checkbox for AR View (And a much-needed refresh button).

Also, when you click on the ticket number(s), it will automatically copy the "Person bought X of (Item) for Z Meat." message to your clipboard for posting into /games chat.

To update, type:
----------------------
<pre>
svn update plasticlobster-kol-arview-branches-Release
</pre>

To remove:
----------------------
<pre>
svn delete plasticlobster-kol-arview-branches-Release
</pre>

THIS SCRIPT INCLUDES THIRD-PARTY JAVASCRIPT LIBRARIES:
- jQuery https://jquery.com/
- Moment.js https://momentjs.com/
- Moment Timezone https://momentjs.com/timezone/
Because DOM manipulation sucks without jQuery and figuring out a KoL date is surprisingly hard when mall sale times come through in your local timezone.

They are bundled within the project for installing ease.

License for jQuery (As required to be bundled with this software):
<pre>

Copyright JS Foundation and other contributors, https://js.foundation/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</pre>

License for Moment.js and Moment Timezone (As required to be bundled with this software):
<pre>
Copyright (c) JS Foundation and other contributors

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
</pre>
