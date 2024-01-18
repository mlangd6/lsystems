Project Functionnal Programming 2020: L-systems
===========================
This project was undertaken as part of my final year, in Licence 3 (equivalent to the last year of Bachelor in France) at University Paris Diderot within the scope of a functional programming course.

## Submission and Evaluation Guidelines

See [CONSIGNES.md](CONSIGNES.md)

## Prerequisites to Install

See [INSTALL.md](../INSTALL.md)

  - ocaml, of course
  - dune and make are highly recommended
  - graphics library if not already included with ocaml

## Compilation and Execution

By default, `make` is used to abbreviate the `dune` commands (see `Makefile` for more details):

  - `make` without arguments will compile `main.exe` using `dune`,
    which is your program in native code.

  - `make byte` will compile to bytecode if necessary, useful for
    running your code in an OCaml toplevel, see `lsystems.top`.

  - `make clean` to remove the temporary `_build` directory
    produced by `dune` during its compilations.

Finally, to run your program: `./run arg1 arg2 ...`

## Interactive Testing in emacs

Your program must have been compiled using `make byte`. You should have `emacs` installed,
as well as an OCaml mode for `emacs`, such as `tuareg-mode`.
  
  - In an external file `start.ml` outside the project directory, for example
    above the `projet` directory, copy the contents of `lsystems.top`
    without its first directive (`#ocaml init`). Add to the `#directory` directives
    the necessary prefixes to access the same directories (for example `projet/`
    if you are above `projet`).

  - In the same directory, open your test file under `emacs`. Start it with `#use "start.ml;;"`.
    Simply evaluate this directive, which will launch the interpreter: you can then perform your tests.

If the program is recompiled (always using `make byte`), you
will need to interrupt the interpreter with the `#quit;;` directive and then restart it
by reevaluating `#use "start.ml;;"`.
  
