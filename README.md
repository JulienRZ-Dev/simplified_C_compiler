# simplified_C_compiler

## Description

This project is a simplified C compiler that handle basics operations (Add, Sub, Mul, Div), if and while loop.
It also handle variables management, like variable depth and temporary variables.
This programme takes a simplied C code, parse it and generate the ASM file.

## Usage

To compile your own C code, edit the file input.c and open a terminal in the project's folder.

```
make
./compiler < input.c
```

The ASM will be generated under out.asm file if input.c follow our simplified C syntax.

## License

MIT
