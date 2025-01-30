#-------------------------------------------------------------------
# Flags for Wasi (WebAssembly target)
#-------------------------------------------------------------------

# Warning flags
set(NORMAL_WARNINGS
    -Wall -Wextra
    -Wno-extra-semi-stmt
    -Wno-unused-command-line-argument
    -Wno-reserved-identifier
    -Wno-format
    -Wno-unused-comparison
    -Wno-reserved-identifier
    -Wno-c++98-compat-pedantic
    -Wno-unused-but-set-variable
)

set(FULL_WARNINGS
    -Weverything
    -Wno-disabled-macro-expansion # else we got a warning each time cout is used
    -Wno-padded # Disable generating a message each time padding is used
    -Wno-float-equal # Sometimes we compare floats (against 0.0 or 1.0 mainly)
    -Wno-global-constructors
    -Wno-exit-time-destructors
    -Wno-old-style-cast # Yes, old-style cast is sometime more legible...
    -Wno-format-nonliteral # Todo: use Laurent Alonso's trick
    -Wno-extra-semi-stmt # geo_assert() in release mode creates empty stmt
    -Wno-unused-command-line-argument
    -Wno-atomic-implicit-seq-cst
    -Wno-alloca
    -Wno-reserved-identifier
    -Wno-c++98-compat-pedantic
    -Wno-unused-but-set-variable
)

# Activate c++ 20
add_flags(CMAKE_CXX_FLAGS -D_WASI_EMULATED_PROCESS_CLOCKS -D_WASI_EMULATED_SIGNAL -std=c++20 -Wno-c++98-compat -Wno-gnu-zero-variadic-macro-arguments)
add_flags(CMAKE_EXE_LINKER_FLAGS -lwasi-emulated-process-clocks -lwasi-emulated-signal)

# Compile with full warnings by default
add_definitions(${FULL_WARNINGS})

# Run the static analyzer
if(VORPALINE_WITH_CLANGSA)
    add_definitions(--analyze)
endif()

# Profiler compilation flags
if(VORPALINE_WITH_GPROF)
  message(FATAL_ERROR "Profiling is not (yet) available with Wasi")
endif()

# Code coverage compilation flags
if(VORPALINE_WITH_GCOV)
  message(FATAL_ERROR "Coverage analysis not supported with Wasi")
endif()

# Compilation flags for Google's AddressSanitizer
# These flags can only be specified for dynamic builds
if(VORPALINE_WITH_ASAN)
  message(FATAL_ERROR "Address sanitizer not supported with Wasi")
endif()

if(NOT VORPALINE_WITH_ASAN)
  # Use native GCC stack smash Protection
  # and buffer overflow detection (debug only)
# stack protector causes undefined symbols at link time (deactivated for now).  
#    add_flags(CMAKE_CXX_FLAGS_DEBUG -fstack-protector-all)
#    add_flags(CMAKE_C_FLAGS_DEBUG -fstack-protector-all)
endif()


# Compilation flags for Google's ThreadSanitizer
if(VORPALINE_WITH_TSAN)
  message(FATAL_ERROR "Thread sanitizer not supported with Wasi")
endif()

# Compilation flags for ALinea DDT
if(VORPALINE_WITH_DDT)
  message(FATAL_ERROR "Alinea DDT not supported with Wasi")  
endif()  

# Reset the warning level for third parties
function(vor_reset_warning_level)
    remove_definitions(${FULL_WARNINGS})
    add_definitions(${NORMAL_WARNINGS})
endfunction()

macro(vor_add_executable)
    add_executable(${ARGN})
endmacro()

