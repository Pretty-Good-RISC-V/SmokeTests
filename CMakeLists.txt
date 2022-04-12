cmake_minimum_required(VERSION 3.21)

set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/riscv.cmake")

# set the project name
project(test ASM)

set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/src/link.ld")
# Linker control
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles -Xlinker -T ${LINKER_SCRIPT} -Wl,-Map=${TARGET}.map")

file(GLOB TESTS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.S")
foreach(TEST_FILE ${TESTS})
    get_filename_component(TEST "${TEST_FILE}" NAME_WLE)
    add_executable(${TEST}.elf ${TEST_FILE}) 
    set_target_properties(${TEST}.elf PROPERTIES LINK_DEPENDS "${LINKER_SCRIPT}")

    add_custom_command(TARGET ${TEST}.elf
        POST_BUILD
        COMMAND riscv32-unknown-elf-objdump -d ${CMAKE_CURRENT_BINARY_DIR}/${TEST}.elf > ${CMAKE_CURRENT_BINARY_DIR}/${TEST}.dump
        DEPENDS ${TEST}.elf
    )
endforeach()
