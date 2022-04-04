cmake_minimum_required(VERSION 3.21)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")

# set the project name
project(test ASM)

set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/src/link.ld")
# Linker control
#set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -nostartfiles -fno-exceptions -Xlinker -T \"${LINKER_SCRIPT}\" -Wl,-Map=${TARGET}.map")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Xlinker -T ${LINKER_SCRIPT} -Wl,-Map=${TARGET}.map")

file(GLOB TESTS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.S")
foreach(TEST_FILE ${TESTS})
    get_filename_component(TEST "${TEST_FILE}" NAME_WLE)
    add_executable(${TEST}.elf ${TEST_FILE}) 
    set_target_properties(${TEST}.elf PROPERTIES LINK_DEPENDS "${LINKER_SCRIPT}")
endforeach()
