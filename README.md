# bclib
A module for Mini Micro written in MiniScript

This module assumes knowledge of the Mini Micro basics, such as mounting folders/directories and minidisk files. Please see [the official Mini Micro wiki](https://miniscript.org/wiki/How_to_get_started_with_Mini_Micro) if you need assistance with these things.

*Note: This module is actively being updated. Its API is not considered stable.*

## Installation in /usr (Recommended)

1. Download `bclib.ms` and the `bclib` directory from this GitHub repo and place them both in `/usr/lib`. The tree should look like this:

```
- /usr/lib/bclib.ms
- /usr/lib/bclib
```

2. Execute `import "bclib"`. The module is now set up in `globals["bclib"]`.

Note: You can include the import in `startup.ms` if you wish to ensure the module is always loaded on startup/reboot.

## Module Loader

`bclib.ms` adds `/usr/lib/bclib` and `/usr2/lib/bclib` to `env.importPaths`, attempts to import all of the bclib modules, libraries, and classes, and then removes the import paths.

This module loader can be either executed or imported, and it will do the same thing.

## Installation in /usr2 (Advanced)

If you wish to use this module from `/usr2` instead of `/usr`, then it is important to note that Mini Micro does NOT look inside `/usr2/lib` for importing. Executing `import "bclib"` therefore won't work unless you modify `env.importPaths` yourself. Because this is an inconvenience, the loader has been programmed to work the same if it is executed directly.

If your `/usr2` tree looks like the following, then executing `run "/usr2/lib/bclib"` will be how you load the module in `globals["bclib"]`:

```
- /usr2/lib/bclib.ms
- /usr2/lib/bclib
```

## Documentation

See the Wiki at Github for API documentation.
