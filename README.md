guard
=====

`guard` is a little utlity for re-running important programs if they happen to crash. It was built to with deploying [https://gitlab.com/zshipko/yurt/](yurt) in mind, but can be used for anything.

## Build requirements

    - Ocaml

## Building

    make
    [sudo] make install

## Usage

    guard -watch "do_something"

Run `guard -help` for more command line options
