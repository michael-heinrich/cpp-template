/*
 * Copyright 2011 The Emscripten Authors.  All rights reserved.
 * Emscripten is available under two separate licenses, the MIT license and the
 * University of Illinois/NCSA Open Source License.  Both these licenses can be
 * found in the LICENSE file.
 */

#include <string>
#include <stdio.h>
#include "hello_world.hpp"
#include "rec_source.hpp"

int main()
{
    print_hello_world();
    return 0;
}

int print_hello_world()
{
    std::string text = getText();
    printf(text.c_str());
    return 0;
}

// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) emscripten/emsdk emmake make -j -f Makefile.mk CONFIG_NAME="emscripten" build
// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) node node /src/bin/emscripten/hello_world




// make -f Makefile.mk CONFIG_NAME="emscripten" build-clean

// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) emscripten/emsdk emcc hello_world.c -o hello_world.js

// docker run --rm -v $(pwd):/src -u $(id -u):$(id -g) node node /src/hello_world.js