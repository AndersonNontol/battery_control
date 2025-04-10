# See the build system documentation in IDF programming guide
# for more information about component CMakeLists.txt files.

idf_component_register(
    SRCS main.c         	# list the source files of this component
    INCLUDE_DIRS .	    	# optional, add here public include directories
    PRIV_INCLUDE_DIRS   	# optional, add here private include directories
    REQUIRES ulp            	# optional, list the public requirements (component names)
    PRIV_REQUIRES       	# optional, list the private requirements
)


set(ulp_app_name ulp_main)
set(ulp_s_sources ulp/main.S)
set(ulp_exp_dep_srcs "main.c")

ulp_embed_binary(${ulp_app_name} "${ulp_s_sources}" "${ulp_exp_dep_srcs}")
#target_add_binary_data(${CMAKE_PROJECT_NAME} "${ulp_s_sources}" TEXT)