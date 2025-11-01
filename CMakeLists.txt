cmake_minimum_required(VERSION 4.1.2)
project(Zephyr)

set(CMAKE_POLICY_VERSION_MINIMUM 3.5)
set(CMAKE_BUILD_TYPE RELEASE)
set(WITH_DEMO FALSE)

set(ANTLR_VERSION 4.13.2)
find_package(Java REQUIRED)

set(THIRD_PARTY_DIR "${CMAKE_SOURCE_DIR}/third-party")
file(MAKE_DIRECTORY ${THIRD_PARTY_DIR})

include(FetchContent)
FetchContent_Declare(
  antlr-tool
  URL "https://www.antlr.org/download/antlr-${ANTLR_VERSION}-complete.jar"
  DOWNLOAD_NO_EXTRACT TRUE
  SOURCE_DIR "${THIRD_PARTY_DIR}/antlr-tool"
)
FetchContent_Declare(
  antlr-cpp-runtime
  URL "https://www.antlr.org/download/antlr4-cpp-runtime-${ANTLR_VERSION}-source.zip"
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  SOURCE_DIR "${THIRD_PARTY_DIR}/antlr-cpp-runtime"
)
message(STATUS "Downloading ANTLR tool...")
FetchContent_MakeAvailable(antlr-tool)
message(STATUS "Downloading ANTLR C++ runtime...")
FetchContent_MakeAvailable(antlr-cpp-runtime)

set(ANTLR_JAR_PATH "${antlr-tool_SOURCE_DIR}/antlr-${ANTLR_VERSION}-complete.jar")
message(STATUS ${ANTLR_JAR_PATH})

set(GENERATED_DIR "${CMAKE_BINARY_DIR}/generated")
file(MAKE_DIRECTORY ${GENERATED_DIR})

set(ANTLR_GENERATED_DIR "${GENERATED_DIR}/antlr")
file(MAKE_DIRECTORY ${ANTLR_GENERATED_DIR})

set(GRAMMAR_NAME ${PROJECT_NAME})
set(GRAMMAR_FILE_PATH "${CMAKE_SOURCE_DIR}/grammar/${GRAMMAR_NAME}.g4")
set(ANTLR_GENERATED_SOURCES
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Lexer.cpp"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Parser.cpp"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Listener.cpp"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}BaseListener.cpp"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Visitor.cpp"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}BaseVisitor.cpp"
)
set(ANTLR_GENERATED_HEADERS
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Lexer.h"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Parser.h"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Listener.h"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}BaseListener.h"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}Visitor.h"
  "${ANTLR_GENERATED_DIR}/${GRAMMAR_NAME}BaseVisitor.h"
)
set(ANTLR_GENERATED_FILES
  ${ANTLR_GENERATED_SOURCES}
  ${ANTLR_GENERATED_HEADERS}
)

add_custom_command(
  OUTPUT ${ANTLR_GENERATED_FILES}
  COMMAND
    java
    -jar
    ${ANTLR_JAR_PATH}
    -Dlanguage=Cpp
    -listener
    -visitor
    -o ${ANTLR_GENERATED_DIR}
    ${GRAMMAR_FILE_PATH}
  DEPENDS ${GRAMMAR_FILE_PATH}
  COMMENT "Generating ANTLR C++ Files..."
)

set(EXECUTABLE_NAME "zephyr")
add_executable(${EXECUTABLE_NAME})

target_sources(${EXECUTABLE_NAME}
  PRIVATE
    "src/main.cpp"
    ${ANTLR_GENERATED_SOURCES}
)

target_include_directories(${EXECUTABLE_NAME}
  PRIVATE
    "${CMAKE_SOURCE_DIR}/include"
)

target_link_libraries(${EXECUTABLE_NAME}
  PRIVATE
    antlr4_static
)
