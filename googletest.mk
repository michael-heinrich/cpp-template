###############################################################################
#
# PROJECT DIRECTORIES
#
###############################################################################

CONFIG_NAME=release
SOURCE_ROOT=googletest/googletest/src
INCLUDE_ROOT=googletest/googletest/include
BUILD_BASE=build/googletest
BIN_BASE=lib
BUILD_DIR=${BUILD_BASE}/${CONFIG_NAME}
BIN_DIR=${BIN_BASE}/${CONFIG_NAME}
BINARY_NAME=googletest


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
# "${MAKE}" -C ${SUBPROJECT_ROOT} -f Makefile.mk clean

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
	$(COMPILE.c) ${OPTIMIZATION} -Wall ${INCLUDES} -std=${C_STANDARD} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.c.o,${SOURCE_ROOT}/%.c,$@)

${BUILD_DIR}/%.cpp.o: ${SOURCE_ROOT}/%.cpp
	${MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)"
	$(COMPILE.cc) ${OPTIMIZATION} -Wall ${INCLUDES} -std=${CPP_STANDARD} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${BUILD_DIR}/%.cpp.o,${SOURCE_ROOT}/%.cpp,$@)


${BIN_DIR}/${BINARY_NAME}: ${SUBPROJECT_BINARY}  .compile-sources
	${MKDIR} -p ${BIN_DIR}
	@echo $(PWD)
	${LINK.cc} -o ${BIN_DIR}/${BINARY_NAME} ${OBJECT_FILES} ${SUBPROJECT_BINARY} ${LDLIBSOPTIONS}

PHONY: run build clean build-clean .build-post .build-impl