cmake_minimum_required(VERSION 3.13)
project(ctlparser)
set (CMAKE_CXX_STANDARD 17)

find_package(BISON)
find_package(FLEX)
BISON_TARGET(MyParser src/rules.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(MyScanner src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

include_directories(
		${CMAKE_CURRENT_BINARY_DIR}
		src
		include
)

add_executable(demo
        src/demo.cpp
	${BISON_MyParser_OUTPUTS}
  	${FLEX_MyScanner_OUTPUTS} src/types.cpp)
