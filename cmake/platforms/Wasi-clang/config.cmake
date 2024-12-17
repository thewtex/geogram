set(VORPALINE_ARCH_64 FALSE)

if(VORPALINE_ARCH_64)
  add_flags(CMAKE_CXX_FLAGS -m64)
  add_flags(CMAKE_C_FLAGS -m64)
endif()
