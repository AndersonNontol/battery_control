# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "C:/Espressif/frameworks/esp-idf-v5.4/components/ulp/cmake")
  file(MAKE_DIRECTORY "C:/Espressif/frameworks/esp-idf-v5.4/components/ulp/cmake")
endif()
file(MAKE_DIRECTORY
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp"
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix"
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/tmp"
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/src/example_ulp-stamp"
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/src"
  "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/src/example_ulp-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/src/example_ulp-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/Usuario/workspace/basic_ulp/build/esp-idf/main/example_ulp-prefix/src/example_ulp-stamp${cfgdir}") # cfgdir has leading slash
endif()
