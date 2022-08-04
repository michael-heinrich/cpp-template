###############################################################################
#
# PROJECT DIRECTORIES
#
###############################################################################

CONFIG_NAME=release
GTEST_SRC=googletest/googletest/src
GTEST_INCLUDE=googletest/googletest/include
GTEST_BUILD_BASE=build/googletest
GTEST_BIN_BASE=lib
GTEST_BUILD_DIR=${GTEST_BUILD_BASE}/${CONFIG_NAME}
GTEST_BIN_DIR=${GTEST_BIN_BASE}/${CONFIG_NAME}
GTEST_LIB_NAME=libgtest.a
GTEST_LIB_MAIN_NAME=libgtest_main.a


###############################################################################
#
# BUILD TOOLS
#
###############################################################################

GTEST_MKDIR=mkdir
GTEST_AR_OPTIONS=rcs
GTEST_OPTIMIZATION=-Og
GTEST_CPP_STANDARD=c++17

###############################################################################
#
# LIST SOURCE FILES
#
###############################################################################

LIB_GTEST_MAIN_SOURCES= ${GTEST_SRC}/gtest_main.cc
LIB_GTEST_SOURCES= \
    ${GTEST_SRC}/gtest-assertion-result.cc \
	${GTEST_SRC}/gtest-death-test.cc \
	${GTEST_SRC}/gtest-filepath.cc \
	${GTEST_SRC}/gtest-matchers.cc \
	${GTEST_SRC}/gtest-port.cc \
	${GTEST_SRC}/gtest-printers.cc \
	${GTEST_SRC}/gtest-test-part.cc \
	${GTEST_SRC}/gtest-typed-test.cc \
	${GTEST_SRC}/gtest.cc \

LIB_GTEST_MAIN_OBJECTS = $(patsubst ${GTEST_SRC}/%.cc,${GTEST_BUILD_DIR}/%.cc.o,${LIB_GTEST_MAIN_SOURCES})
LIB_GTEST_OBJECTS = $(patsubst ${GTEST_SRC}/%.cc,${GTEST_BUILD_DIR}/%.cc.o,${LIB_GTEST_SOURCES})
GTEST_OBJECT_FILES= ${LIB_GTEST_MAIN_OBJECTS} ${LIB_GTEST_OBJECTS}

GTEST_H_DIRS= ${GTEST_INCLUDE} googletest/googletest
GTEST_INCLUDES=$(patsubst %,-I%,${GTEST_H_DIRS})

###############################################################################
#
# TARGETS
#
###############################################################################

# build
gtest-build: .gtest-build-post
	echo "build succeeded"

.gtest-build-post: .gtest-list-includes .gtest-build-impl
# Add your post 'build' code here...

.gtest-list-includes:
	echo "Includes are: ${GTEST_INCLUDES}"

# build
.gtest-build-impl: ${GTEST_BIN_DIR}/${GTEST_LIB_NAME} ${GTEST_BIN_DIR}/${GTEST_LIB_MAIN_NAME}

.gtest-compile-sources: ${GTEST_OBJECT_FILES}
	echo "Compilation done"

gtest-clean:
	echo "gtest-clean"
	${RM} -rf ${GTEST_BUILD_BASE}
	${RM} -rf ${GTEST_BIN_BASE}

${GTEST_BUILD_DIR}/%.cc.o: ${GTEST_SRC}/%.cc
	${GTEST_MKDIR} -p $(dir $@)
	${RM} "$@.d"
	@echo $(PWD)
	echo "compile $(patsubst ${GTEST_BUILD_DIR}/%.cc.o,${GTEST_SRC}/%.cc,$@)"
	$(COMPILE.cc) ${GTEST_OPTIMIZATION} -Wall ${GTEST_INCLUDES} -std=${GTEST_CPP_STANDARD} -MMD -MP -MF "$@.d" -o $@ $(patsubst ${GTEST_BUILD_DIR}/%.cc.o,${GTEST_SRC}/%.cc,$@)


# libgtest.a
${GTEST_BIN_DIR}/${GTEST_LIB_NAME}: .gtest-compile-sources
	${GTEST_MKDIR} -p ${GTEST_BIN_DIR}
	@echo $(PWD)
	ar ${GTEST_AR_OPTIONS} ${GTEST_BIN_DIR}/${GTEST_LIB_NAME} ${LIB_GTEST_OBJECTS}
	ranlib ${GTEST_BIN_DIR}/${GTEST_LIB_NAME}

# libgtest_main.a
${GTEST_BIN_DIR}/${GTEST_LIB_MAIN_NAME}: .gtest-compile-sources
	${GTEST_MKDIR} -p ${GTEST_BIN_DIR}
	@echo $(PWD)
	ar ${GTEST_AR_OPTIONS} ${GTEST_BIN_DIR}/${GTEST_LIB_MAIN_NAME} ${LIB_GTEST_MAIN_OBJECTS}
	ranlib ${GTEST_BIN_DIR}/${GTEST_LIB_MAIN_NAME}

PHONY: gtest-build gtest-clean gtest-build-clean .gtest-build-post .gtest-build-impl
