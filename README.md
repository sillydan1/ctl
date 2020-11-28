# CTLParser
A simple parser for Computation Tree Logic. Use it in your C/C++ projects. 

_Please note that the parser is not thread safe yet_

## Usage

Compile and link with your own project

### Compile

Make sure you have `flex` and `bison` installed.

```
mkdir build && cd build
cmake ..
make
```

### How to use in a CMake project

Download the files (or git submoule it) and add it as a subdirectory in your CMakeLists.txt file like so: (Make sure add the correct paths)

```
include_directories(local/path/to/CTLParser/include) # Not technically needed
add_subdirectory(local/path/to/CTLParser)

target_link_libraries(yourprojectname ctlparser)
```
