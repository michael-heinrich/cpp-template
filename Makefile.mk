###############################################################################
#
# PROJECT DIRECTORIES
#
###############################################################################

CONFIG_NAME=release
SOURCE_ROOT=src
TEST_ROOT=test
INCLUDE_ROOT=include
BUILD_BASE=build
BIN_BASE=bin
LIB_DIR=lib
BUILD_DIR=${BUILD_BASE}/${CONFIG_NAME}
TEST_BUILD_DIR=${BUILD_BASE}/${CONFIG_NAME}_tests
BIN_DIR=${BIN_BASE}/${CONFIG_NAME}
MAIN=application
BINARY_NAME=binary
TEST_BINARY_NAME=test-binary

###############################################################################
#
# gtest
#
###############################################################################

ifeq ($(MAIN),gtest)
IGNORE_MAIN=-Dmain=ignore_main
PROFILE_COMPILER= -ftest-coverage -fprofile-arcs
PROFILE_LINKER= -fprofile-arcs
else
PROFILE_COMPILER=
PROFILE_LINKER=
endif

include googletest.mk

GTEST_LIB_PATH= -L${GTEST_BIN_DIR}
GTEST_LIBS= -lgtest -lgtest_main
GTEST_LINKER_OPTIONS= ${GTEST_LIB_PATH} ${GTEST_LIBS}

###############################################################################
#
# BUILD TOOLS
#
###############################################################################

MKDIR=mkdir
LDLIBSOPTIONS=-lpthread -ldl
OPTIMIZATION=-O3
C_STANDARD=c11
CPP_STANDARD=c++17

###############################################################################
#
# LIST SOURCE FILES
#
###############################################################################


CPP_SOURCES=$(shell find ${SOURCE_ROOT} -name "*.cpp")
C_SOURCES=$(shell find ${SOURCE_ROOT} -name "*.c")
TEST_SOURCES=$(shell find ${TEST_ROOT} -name "*.cpp")



OBJECT_FILES= $(patsubst ${SOURCE_ROOT}/%.cpp,${BUILD_DIR}/%.cpp.o,${CPP_SOURCES}) $(patsubst ${SOURCE_ROOT}/%.c,${BUILD_DIR}/%.c.o,${C_SOURCES})
TEST_OBJECT_FILES= $(patsubst ${TEST_ROOT}/%.cpp,${TEST_BUILD_DIR}/%.cpp.o,${TEST_SOURCES})

H_SOURCES=$(shell find ${INCLUDE_ROOT} -name "*.h") $(shell find ${INCLUDE_ROOT} -name "*.hpp")

H_DIRS= $(sort $(dir ${H_SOURCES} ${C_SOURCES} ${CPP_SOURCES}))
INCLUDES=$(patsubst %,-I%,${H_DIRS})

###############################################################################
#
# TARGETS
#
###############################################################################

run: build
	${BIN_DIR}/${BINARY_NAME}

# build
build: .build-post
	echo "build succeeded"

build-clean: clean build

.clean-subproject:
# "${MAKE}" -C ${SUBPROJECT_ROOT} -f Makefile.mk clean

.build-post: .list-includes .build-impl
# Add your post 'build' code here...

.list-includes:
	echo "Includes are: ${INCLUDES}"

# build
.build-impl: ${BIN_DIR}/${BINARY_NAME}

.compile-sources: ${OBJECT_FILES}
	echo "Source compilation done"

run-test: build-test
	${BIN_DIR}/${TEST_BINARY_NAME}

build-test: .build-test-post
	echo "build-test succeeded"

.build-test-post: .list-includes .build-test-impl

.build-test-impl: ${BIN_DIR}/${TEST_BINARY_NAME}

.compile-tests:  ${TEST_OBJECT_FILES} gtest-build
	echo "Test compilation done"


clean: .clean-subproject
	echo "clean"
	${RM} -rf ${BUILD_BASE}
	${RM} -rf ${BIN_BASE}

# create object files from c sources
${BUILD_DIR}/%.c.o: ${SOURCE_ROOT}/%.c
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${BUILD_DIR}/%.c.o,${SOURCE_ROOT}/%.c,$@)"
	$(COMPILE.c) ${OPTIMIZATION} ${IGNORE_MAIN} -Wall ${INCLUDES} -std=${C_STANDARD} ${PROFILE_COMPILER} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.c.o,${SOURCE_ROOT}/%.c,$@)

# create object files from c++ sources
${BUILD_DIR}/%.cpp.o: ${SOURCE_ROOT}/%.cpp
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)"
	$(COMPILE.cc) ${OPTIMIZATION} ${IGNORE_MAIN} -Wall ${INCLUDES} -std=${CPP_STANDARD} ${PROFILE_COMPILER} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)

# create object files from c++ tests
${TEST_BUILD_DIR}/%.cpp.o: ${TEST_ROOT}/%.cpp
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${TEST_BUILD_DIR}/%.cpp.o,${TEST_ROOT}/%.cpp,$@)"
	$(COMPILE.cc) ${OPTIMIZATION} -Wall ${INCLUDES} ${GTEST_INCLUDES} -std=${CPP_STANDARD} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${TEST_BUILD_DIR}/%.cpp.o,${TEST_ROOT}/%.cpp,$@)

# create target binary from object files
${BIN_DIR}/${BINARY_NAME}: ${SUBPROJECT_BINARY} .compile-sources
	${MKDIR} -p ${BIN_DIR}
	@echo $(PWD)
	${LINK.cc} -o ${BIN_DIR}/${BINARY_NAME} ${OBJECT_FILES} ${SUBPROJECT_BINARY} ${LDLIBSOPTIONS} ${PROFILE_LINKER}

# create test binary from object files and test libraries
${BIN_DIR}/${TEST_BINARY_NAME}: ${SUBPROJECT_BINARY} .compile-sources .compile-tests
	${MKDIR} -p ${BIN_DIR}
	@echo $(PWD)
	${LINK.cc} -o ${BIN_DIR}/${TEST_BINARY_NAME} ${OBJECT_FILES} ${TEST_OBJECT_FILES} ${SUBPROJECT_BINARY} ${GTEST_LINKER_OPTIONS} ${LDLIBSOPTIONS} ${PROFILE_LINKER}


PHONY: run build clean build-clean .build-post .build-impl
