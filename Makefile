###############################################################################
#
#   The standard targets are implemented by the native operations
#
###############################################################################

run:
	make -j -f implementation.mk CONFIG_NAME=release run

build:
	make -j -f implementation.mk CONFIG_NAME=release build

clean:
	make -j -f implementation.mk clean gtest-clean


test: .test-impl

.test-impl:
	make -j -f implementation.mk \
			CONFIG_NAME="release-test" \
			MAIN="gtest" \
			COVERAGE="true" \
			run-test

build-test:
	make -j -f implementation.mk \
			CONFIG_NAME=release-test \
			MAIN=gtest \
			COVERAGE=true \
			build-test

build-debug-test:
	make -j -f implementation.mk \
			CONFIG_NAME=debug-test \
			MAIN=gtest \
			COVERAGE=true \
			OPTIMIZATION=-g \
			LINK_OPTIMIZATION=-g \
			build-test

build-debug:
	make -j -f implementation.mk \
			CONFIG_NAME=debug \
			OPTIMIZATION=-g \
			LINK_OPTIMIZATION=-g \
			build

###############################################################################
#
#   extra targets for emscripten
#
###############################################################################

run-emscripten: build-emscripten
	util/run_emscripten

build-emscripten:
	util/make_emscripten build

test-emscripten: build-test-emscripten
	util/run_emscripten_test

build-test-emscripten:
	util/make_emscripten_test build-test




PHONY: run build clean test build-test run-emscripten build-emscripten test-emscripten build-test-emscripten