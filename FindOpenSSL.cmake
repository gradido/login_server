

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()




include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindOpenSSL.cmake")
# Global approach
set(OpenSSL_FOUND 1)
set(OpenSSL_VERSION "1.0.2o")

find_package_handle_standard_args(OpenSSL REQUIRED_VARS
                                  OpenSSL_VERSION VERSION_VAR OpenSSL_VERSION)
mark_as_advanced(OpenSSL_FOUND OpenSSL_VERSION)


set(OpenSSL_INCLUDE_DIRS "${CONAN_INCLUDE_DIRS_OPENSSL}")
set(OpenSSL_INCLUDE_DIR "${CONAN_INCLUDE_DIRS_OPENSSL}")
set(OpenSSL_INCLUDES "${CONAN_INCLUDE_DIRS_OPENSSL}")
set(OpenSSL_RES_DIRS "${CONAN_RES_DIRS_OPENSSL}")
set(OPENSSL_ROOT_DIR "${CONAN_OPENSSL_ROOT}")
set(OPENSSL_DIR "${CONAN_OPENSSL_ROOT}")
set(OpenSSL_DEFINITIONS )
set(OpenSSL_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(OpenSSL_COMPILE_DEFINITIONS )
set(OpenSSL_COMPILE_OPTIONS_LIST "" "")
set(OpenSSL_COMPILE_OPTIONS_C "")
set(OpenSSL_COMPILE_OPTIONS_CXX "")
set(OpenSSL_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(OpenSSL_LIBRARIES "") # Will be filled later
set(OpenSSL_LIBS "") # Same as OpenSSL_LIBRARIES
set(OpenSSL_FRAMEWORKS_FOUND "") # Will be filled later
set(OpenSSL_BUILD_MODULES_PATHS )


mark_as_advanced(OpenSSL_INCLUDE_DIRS
                 OpenSSL_INCLUDE_DIR
                 OpenSSL_INCLUDES
                 OpenSSL_DEFINITIONS
                 OpenSSL_LINKER_FLAGS_LIST
                 OpenSSL_COMPILE_DEFINITIONS
                 OpenSSL_COMPILE_OPTIONS_LIST
                 OpenSSL_LIBRARIES
                 OpenSSL_LIBS
                 OpenSSL_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to OpenSSL_LIBS and OpenSSL_LIBRARY_LIST
set(OpenSSL_LIBRARY_LIST ssl crypto dl pthread)
set(OpenSSL_LIB_DIRS "${CONAN_LIB_DIRS_OPENSSL}")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_OpenSSL_DEPENDENCIES "zlib::zlib")

conan_package_library_targets("${OpenSSL_LIBRARY_LIST}"  # libraries
                              "${OpenSSL_LIB_DIRS}"      # package_libdir
                              "${_OpenSSL_DEPENDENCIES}"  # deps
                              OpenSSL_LIBRARIES            # out_libraries
                              OpenSSL_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "OpenSSL")                                      # package_name

set(OpenSSL_LIBS ${OpenSSL_LIBRARIES})

# We need to add our requirements too
set(OpenSSL_LIBRARIES_TARGETS "${OpenSSL_LIBRARIES_TARGETS};zlib::zlib")
set(OpenSSL_LIBRARIES "${OpenSSL_LIBRARIES};zlib::zlib")

set(CMAKE_MODULE_PATH "/home/dario/.conan/data/OpenSSL/1.0.2o/conan/stable/package/b781af3f476d0aa5070a0a35b544db7a3c193cc8/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/dario/.conan/data/OpenSSL/1.0.2o/conan/stable/package/b781af3f476d0aa5070a0a35b544db7a3c193cc8/" ${CMAKE_PREFIX_PATH})

foreach(_BUILD_MODULE_PATH ${OpenSSL_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET OpenSSL::OpenSSL)
        add_library(OpenSSL::OpenSSL INTERFACE IMPORTED)
        if(OpenSSL_INCLUDE_DIRS)
            set_target_properties(OpenSSL::OpenSSL PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${OpenSSL_INCLUDE_DIRS}")
        endif()
        set_property(TARGET OpenSSL::OpenSSL PROPERTY INTERFACE_LINK_LIBRARIES
                     "${OpenSSL_LIBRARIES_TARGETS};${OpenSSL_LINKER_FLAGS_LIST}")
        set_property(TARGET OpenSSL::OpenSSL PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${OpenSSL_COMPILE_DEFINITIONS})
        set_property(TARGET OpenSSL::OpenSSL PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${OpenSSL_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT zlib_FOUND)
            find_dependency(zlib REQUIRED)
        else()
            message(STATUS "Dependency zlib already found")
        endif()

    endif()
endif()
