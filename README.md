# bclib
A module for Mini Micro written in MiniScript

## Installation

The easy way:

1. Mount a directory to `/usr`
2. Create a directory inside that one called `lib`
3. Download `bclib.ms` and the `bclib` directory from this GitHub repo and place them in the `lib` directory mentioned above.

## Using the Library

There are two ways of importing the this module. Either one will work if you are using `/usr`

* Importing bclib via `import "bclib"`. This will only work if you followed the easy installation above.
* Executing the script `bclib.ms`. This will work if used either `/usr` or `/usr2` and followed the correct directory layout.

`bclib.ms` adds `/usr/lib/bclib` and `/usr2/lib/bclib` to `env.importPaths`, attempts to import all of the bclib modules, libraries, and classes, and then removes the import paths.

## Library in /usr2

If you wish to load this library from `/usr2`, do the following:

1. Mount a directory to `/usr2`
2. Create a directory inside that one called `lib`
3. Download `bclib.ms` and the `bclib` directory from this GitHub repo and place them in the `lib` directory mentioned above.
4. Run the script `bclib.ms`. Do NOT attempt to import it.
5. Everything should be loaded in `globals.bclib`
