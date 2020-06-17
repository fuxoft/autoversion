# autoversion.lua

This small script is used to automatically update the version of your Lua script (or other text file). The format is compatible with the [semantic versioning](https://semver.org/) standard.

It looks for the string in your script which is formatted EXACTLY like this (including the opening and closing double brackets)...

```
[[*<= Version '1.5.99+D20201231T235959' =>*]]
```

...and updates the version string, adding 1 to the third number (99 in this case) and updating the build metadata (the datetime string after '+').

So, basically, before publishing the current version of your script anywhere, you do this:

```
autoversion.lua myscript.lua
```

...and your script's version is automatically updated.

Not that autoversion only updates the third numeric value (the PATCH number). If you need to change other values, just use your standard text editor before / after running autoversion.

If your script is in Lua, the special version string is usually preceded by "--" comment indicator but there can be other characters before and after this special string, so you can e.g. do this in your script:

```
_G.VERSION = string.match([[*<= Version '20180302a' =>*]], "'.-'")
```

...and then use the version number as a value in your script, for example printing it.

If you call autoversion with `--show-only` argument, it only shows the version of the submitted file and does not update it.
