# autoversion.janet

This small script (written in [Janet](https://janet-lang.org/)) is used to automatically update the version of your source files, scripts or any other text file. The version format is compatible with the [semantic versioning](https://semver.org/) standard.

This script (`autoversion.janet`) looks for the **first occurence** of the string in your text file which is formatted like this (including spaces and the opening and closing double brackets)...

`[[*<= Version '1.5.99+D20201231T235959' =>*]]`

...and updates the version number and the build metadata (the datetime string after '+').

This seemingly bizarre format was chosen so that there is zero chance of this string appearing elsewhere in your file.

The version string between the single quote is always:

`<integer> "." <integer> "." <integer> "+D" <8 digits> "T" <6 digits>`

So, basically, before publishing the current version of your script anywhere (e.g. on GitHub), you invoke `autoversion` on it and your script's version is automatically updated (the version number is incremented and timestamp is updated).

The invocation is:

```autoversion.janet <options> <file name>```

The possible options are:

* `-v3` - Increment the third number, i.e. patch version. This is the **default behavior** if no option is provided.
* `-v2` - Increment the second number, i.e. minor version, and set the third number to zero.
* `-v1` - Increment the first number, i.e. major version, and set the second and third numbers to zero.

Of course you are also free to edit the version string in your file manually at any time.

The version string can be included in your script as a comment but it can also be used inside your script programmatically for whatever purpose because there can be any characters (i.e. program statements) immediately before and after it, even on the same line! See the examples below.

## Specific usage examples:

### Lua

If your script is in Lua, you can e.g. do this:

`_G.MY_VERSION = string.match([[*<= Version '1.5.99+D20201231T235959' =>*]], "'.-'")`

And then use the version number as a value in your script, for example printing it.

### Janet

In Janet, you could achieve the similar effect like this:

`(def my-version (first (peg/match ~(* (thru "'") (<- (to "'")))
                                 "[[*<= Version '1.5.99+D20201231T235959' =>*]]")))`
