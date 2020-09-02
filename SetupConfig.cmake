set(SM_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}/CMake")

include(CheckIncludeFiles)
check_include_files(alloca.h HAVE_ALLOCA_H)
check_include_files(assert.h HAVE_ASSERT_H)
check_include_files(dlfcn.h HAVE_DLFCN_H)
check_include_files(dirent.h HAVE_DIRENT_H)
check_include_files(errno.h HAVE_ERRNO_H)
check_include_files(fcntl.h HAVE_FCNTL_H)
check_include_files(float.h HAVE_FLOAT_H)
check_include_files(inttypes.h HAVE_INTTYPES_H)
check_include_files(limits.h HAVE_LIMITS_H)
check_include_files(math.h HAVE_MATH_H)
check_include_files(memory.h HAVE_MEMORY_H)
check_include_files(stdarg.h HAVE_STDARG_H)
check_include_files(stddef.h HAVE_STDDEF_H)
check_include_files(stdint.h HAVE_STDINT_H)
check_include_files(stdlib.h HAVE_STDLIB_H)
check_include_files(strings.h HAVE_STRINGS_H)
check_include_files(string.h HAVE_STRING_H)
check_include_files(unistd.h HAVE_UNISTD_H)
check_include_files(sys/param.h HAVE_SYS_PARAM_H)
check_include_files(sys/stat.h HAVE_SYS_STAT_H)
check_include_files(sys/types.h HAVE_SYS_TYPES_H)
check_include_files(sys/utsname.h HAVE_SYS_UTSNAME_H)
check_include_files(sys/wait.h HAVE_SYS_WAIT_H)

check_include_files(endian.h HAVE_ENDIAN_H)
check_include_files(sys/endian.h HAVE_SYS_ENDIAN_H)
check_include_files(machine/endian.h HAVE_MACHINE_ENDIAN_H)

if(HAVE_STDLIB_H AND HAVE_STDARG_H AND HAVE_STRING_H AND HAVE_FLOAT_H)
  set(STDC_HEADERS 1)
endif()

include(CheckFunctionExists)
include(CheckSymbolExists)
include(CheckCXXSymbolExists)

# Mostly Windows functions.
check_function_exists(_mkdir HAVE__MKDIR)
check_cxx_symbol_exists(_snprintf cstdio HAVE__SNPRINTF)
check_cxx_symbol_exists(stricmp cstring HAVE_STRICMP)
check_cxx_symbol_exists(_stricmp cstring HAVE__STRICMP)

# Mostly non-Windows functions.
check_function_exists(fcntl HAVE_FCNTL)
check_function_exists(fork HAVE_FORK)
check_function_exists(mkdir HAVE_MKDIR)
check_cxx_symbol_exists(snprintf cstdio HAVE_SNPRINTF)
check_cxx_symbol_exists(strcasecmp cstring HAVE_STRCASECMP)
check_function_exists(waitpid HAVE_WAITPID)

# Mostly universal symbols.
check_cxx_symbol_exists(powf cmath HAVE_POWF)
check_cxx_symbol_exists(sqrtf cmath HAVE_SQRTF)
check_cxx_symbol_exists(sinf cmath HAVE_SINF)
check_cxx_symbol_exists(tanf cmath HAVE_TANF)
check_cxx_symbol_exists(cosf cmath HAVE_COSF)
check_cxx_symbol_exists(acosf cmath HAVE_ACOSF)
check_cxx_symbol_exists(truncf cmath HAVE_TRUNCF)
check_cxx_symbol_exists(roundf cmath HAVE_ROUNDF)
check_cxx_symbol_exists(lrintf cmath HAVE_LRINTF)
check_cxx_symbol_exists(strtof cstdlib HAVE_STRTOF)
check_symbol_exists(M_PI math.h HAVE_M_PI)
check_symbol_exists(size_t stddef.h HAVE_SIZE_T_STDDEF)
check_symbol_exists(size_t stdlib.h HAVE_SIZE_T_STDLIB)
check_symbol_exists(size_t stdio.h HAVE_SIZE_T_STDIO)
check_symbol_exists(posix_fadvise fcntl.h HAVE_POSIX_FADVISE)

if(MINGW)
  set(NEED_WINDOWS_LOADING_WINDOW TRUE)
  check_symbol_exists(PBS_MARQUEE commctrl.h HAVE_PBS_MARQUEE)
  check_symbol_exists(PBM_SETMARQUEE commctrl.h HAVE_PBM_SETMARQUEE)
endif()

# Checks to make it easier to work with 32-bit/64-bit builds if required.
include(CheckTypeSize)
check_type_size(int16_t SIZEOF_INT16_T)
check_type_size(uint16_t SIZEOF_UINT16_T)
check_type_size(u_int16_t SIZEOF_U_INT16_T)
check_type_size(int32_t SIZEOF_INT32_T)
check_type_size(uint32_t SIZEOF_UINT32_T)
check_type_size(u_int32_t SIZEOF_U_INT32_T)
check_type_size(int64_t SIZEOF_INT64_T)
check_type_size(char SIZEOF_CHAR)
check_type_size("unsigned char" SIZEOF_UNSIGNED_CHAR)
check_type_size(short SIZEOF_SHORT)
check_type_size("unsigned short" SIZEOF_UNSIGNED_SHORT)
check_type_size(int SIZEOF_INT)
check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)
check_type_size(long SIZEOF_LONG)
check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)
check_type_size("long long" SIZEOF_LONG_LONG)
check_type_size(float SIZEOF_FLOAT)
check_type_size(double SIZEOF_DOUBLE)
check_type_size(intptr_t SIZEOF_INTPTR_T)
check_type_size(pid_t SIZEOF_PID_T)
check_type_size(size_t SIZEOF_SIZE_T)
check_type_size(ssize_t SIZEOF_SSIZE_T)

include(TestBigEndian)
test_big_endian(BIGENDIAN)
if(${BIGENDIAN})
  set(ENDIAN_BIG 1)
else()
  set(ENDIAN_LITTLE 1)
endif()

check_compile_features("${SM_CMAKE_DIR}/TestCode"
                       "${SM_CMAKE_DIR}/TestCode/test_prototype.c"
                       "Checking for function prototype capabilities"
                       "found"
                       "not found"
                       SM_IGNORED_PROTOTYPE_CALL
                       FALSE)

if(NOT SM_IGNORED_PROTOTYPE_CALL)
  set(HAVE_PROTOTYPES TRUE)
endif()

check_compile_features("${SM_CMAKE_DIR}/TestCode"
                       "${SM_CMAKE_DIR}/TestCode/test_external.c"
                       "Checking for external name shortening requirements"
                       "not needed"
                       "needed"
                       SM_BUILT_LONG_NAME
                       TRUE)

if(NOT SM_BUILT_LONG_NAME)
  set(NEED_SHORT_EXTERNAL_NAMES 1)
endif()

check_compile_features("${SM_CMAKE_DIR}/TestCode"
                       "${SM_CMAKE_DIR}/TestCode/test_broken.c"
                       "Checking if incomplete types are broken."
                       "not broken"
                       "broken"
                       SM_BUILT_INCOMPLETE_TYPE
                       FALSE)

if(SM_BUILT_INCOMPLETE_TYPE)
  set(INCOMPLETE_TYPES_BROKEN 1)
endif()