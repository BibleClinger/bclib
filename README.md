# bclib
A library for Mini Micro written in MiniScript

## Installation

The easy way:

1. Mount a directory to `/usr`
2. Create a directory inside that one called `lib`
3. Download `bclib.ms` and the `bclib` directory from this GitHub repo and place them in the `lib` directory mentioned above.

## Using the Library

There are two ways of importing the library.

1. Importing bclib via `import "bclib"`. This will work if you followed the easy installation above.
2. Executing the script `bclib.ms`.

`bclib.ms` attempts to load all other classes, libraries, and modules of this library under the `bclib` module. It does this by adding `/usr/lib/bclib` and `/usr2/lib/bclib` to `env.importPaths`, importing all of the bclib modules, libraries, and classes, and then removing those import paths.

## Library in /usr2

If you wish to use this library in `/usr2`, do the following:

1. Mount a directory to `/usr2`
2. Create a directory inside that one called `lib`
3. Download `bclib.ms` and the `bclib` directory from this GitHub repo and place them in the `lib` directory mentioned above.
4. Run the script `bclib.ms`. Do NOT attempt to import it.
5. Everything should be loaded in `globals.bclib`.
