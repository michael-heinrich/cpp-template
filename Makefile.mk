###############################################################################
#
# PROJECT DIRECTORIES
#
###############################################################################

CONFIG_NAME=release
SOURCE_ROOT=src
INCLUDE_ROOT=include
BUILD_BASE=build
BIN_BASE=bin
LIB_DIR=lib
BUILD_DIR=${BUILD_BASE}/${CONFIG_NAME}
BIN_DIR=${BIN_BASE}/${CONFIG_NAME}
BINARY_NAME=hello_world


###############################################################################
#
# BUILD TOOLS
#
###############################################################################

MKDIR=mkdir
LDLIBSOPTIONS=-lpthread -ldl
OPTIMIZATION=-O3

###############################################################################
#
# LIST SOURCE FILES
#
###############################################################################


CPP_SOURCES=$(shell find ${SOURCE_ROOT} -name "*.cpp")
C_SOURCES=$(shell find ${SOURCE_ROOT} -name "*.c")

OBJECT_FILES= $(patsubst ${SOURCE_ROOT}/%.cpp,${BUILD_DIR}/%.cpp.o,${CPP_SOURCES}) $(patsubst ${SOURCE_ROOT}/%.c,${BUILD_DIR}/%.c.o,${C_SOURCES})

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
# "${MAKE}" -C ${STREAM_MANGER_ROOT} -f Makefile.mk clean

.build-post: .list-includes .build-impl
# Add your post 'build' code here...

.list-includes:
	echo "Includes are: ${INCLUDES}"

# build
.build-impl: ${BIN_DIR}/${BINARY_NAME}

.compile-sources: ${OBJECT_FILES}
	echo "Compilation done"

clean: .clean-subproject
	echo "clean"
	${RM} -rf ${BUILD_BASE}
	${RM} -rf ${BIN_BASE}


${BUILD_DIR}/%.c.o: ${SOURCE_ROOT}/%.c
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${BUILD_DIR}/%.c.o,${SOURCE_ROOT}/%.c,$@)"
	$(COMPILE.c) ${OPTIMIZATION} -Wall ${INCLUDES} -std=c11 -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.c.o,${SOURCE_ROOT}/%.c,$@)

${BUILD_DIR}/%.cpp.o: ${SOURCE_ROOT}/%.cpp
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)"
	$(COMPILE.cc) ${OPTIMIZATION} -Wall ${INCLUDES} -std=c++17 -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)


${BIN_DIR}/${BINARY_NAME}: ${SUBPROJECT_BINARY}  .compile-sources
	${MKDIR} -p ${BIN_DIR}
	@echo $(PWD)
	${LINK.cc} -o ${BIN_DIR}/${BINARY_NAME} ${OBJECT_FILES} ${SUBPROJECT_BINARY} ${LDLIBSOPTIONS}

PHONY: run build clean build-clean .build-post .build-impl
