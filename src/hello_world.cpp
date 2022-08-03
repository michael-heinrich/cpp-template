/*
 * Copyright 2011 The Emscripten Authors.  All rights reserved.
 * Emscripten is available under two separate licenses, the MIT license and the
 * University of Illinois/NCSA Open Source License.  Both these licenses can be
 * found in the LICENSE file.
 */

#include <stdio.h>
#include "hello_world.hpp"

int main()
{
  print_hello_world();
  return 0;
}

int print_hello_world()
{
  printf("hello, world!\n");
  return 0;
}

// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) emscripten/emsdk emcc hello_world.c -o hello_world.js

// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) node node hello_world.js