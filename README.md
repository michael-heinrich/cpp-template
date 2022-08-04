# cpp-template
A template for C++ projects in vscode with support for debugging, gtest, gtest debugging.  
Building to webassemlby is supported through emscripten, run and run-test of webassembly is implemented useing node.js  
  
Prerequesites:  
-gcc (build-essentials)  
-gdb  
-docker (for wsl 2 user docker desktop)  
  
Emscripten and node.js are used through docker, so no additional configuration is needed for those.  
  
HOW TO USE:  
clone,  
go to directory:      cd cpp-template  
remove old git repo:  rm -rf .git  
make new repo:        git init  
download gtest:       util/gtest_add  
stage changes:        git add .  
commit changes:       git commit  
