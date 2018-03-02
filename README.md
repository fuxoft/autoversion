# autoversion.lua

This sript is used to automatically update the version of your Lua script (or other text file).

It looks for the string in your script which is formatted EXACTLY like this...

```
[[*<= Version '20180302a' =>*]]
```

...and updates it to current date, bumping the last letter up if the date is current.

So, basically, before publishing the current version of your script, you do this:

```
autoversion.lua myscript.lua
```

...and your script's version is automatically updated.

Note that the initial version has to be exactly 9 characters, 8 numbers and a lowercase letter (so there cannot be more than 26 versions in a single day.) It updates ONLY the first occurence of this very special string in the file and ONLY if the current date isn't older than the date in the file.

Usually, the special version string is preceded by "--" comment indicator but there can be other characters before and after this special string, so you can e.g. do this in your script:

```
_G.VERSION = string.match([[*<= Version '20180302a' =>*]], "'.+'")
```

...and use the version number as a value in your script, for example printing it.
