cmake_minimum_required(VERSION 3.13)
project(ctlparser)
set (CMAKE_CXX_STANDARD 17)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)
BISON_TARGET(CTLParser src/rules.y ${CMAKE_CURRENT_BINARY_DIR}/parser.cpp)
FLEX_TARGET(CTLScanner src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(CTLScanner CTLParser)

include_directories(
	${CMAKE_CURRENT_BINARY_DIR}
	src
	include
)

add_library(${PROJECT_NAME}
	${BISON_CTLParser_OUTPUTS}
	${FLEX_CTLScanner_OUTPUTS}
	src/types.cpp
)

add_executable(demo
	src/demo.cpp
)

target_link_libraries(demo ${PROJECT_NAME})
