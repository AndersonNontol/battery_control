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
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified"
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix"
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/tmp"
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/src/ulp_adc_modified-stamp"
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/src"
  "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/src/ulp_adc_modified-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/src/ulp_adc_modified-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/Users/Usuario/workspace/ulp_adc/build/esp-idf/main/ulp_adc_modified-prefix/src/ulp_adc_modified-stamp${cfgdir}") # cfgdir has leading slash
endif()
