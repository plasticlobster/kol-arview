This relay script will add an "AR Mode" to your mall sales screen, which will automatically number sales in order by item per-KoL day.
Days are broken down into KoL days because rollover is what dictates if someone is able to buy a new ticket, not a new day.

Guide
=====

To install, type:
----------------------
<pre>
svn checkout https://github.com/plasticlobster/kol-arview/branches/Release
</pre>

in your KoLMafia CLI.

Now when you go to your mall store and look at your sales, you will see a checkbox for AR View (And a much-needed refresh button).

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

