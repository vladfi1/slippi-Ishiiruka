if(NOT(USE_X11 OR ENABLE_HEADLESS))
  return()
endif()

set(DOLPHIN_NOGUI_EXE dolphin-emu-nogui)

set(NOGUI_SRCS MainNoGUI.cpp)

if(USE_X11)
  set(NOGUI_SRCS ${NOGUI_SRCS} ../DolphinWX/X11Utils.cpp)
endif()

add_executable(dolphin-nogui ${NOGUI_SRCS})
set_target_properties(dolphin-nogui PROPERTIES OUTPUT_NAME ${DOLPHIN_NOGUI_EXE})

target_link_libraries(dolphin-nogui PRIVATE
  core
  uicommon
  ${LIBS}
)

# Link SlippiRustExtensions in.
#
# (This doesn't feel perfect here, but truth be told I can't think offhand of
# a better location for it at the moment.)
set(RUST_FEATURES "")
if(DIS_PLAYBACK)
  set(RUST_FEATURES "playback")
endif()

corrosion_import_crate(MANIFEST_PATH ${CMAKE_SOURCE_DIR}/Externals/SlippiRustExtensions/Cargo.toml ${RUST_FEATURES})
target_link_libraries(dolphin-nogui PUBLIC slippi_rust_extensions)

set(CPACK_PACKAGE_EXECUTABLES ${CPACK_PACKAGE_EXECUTABLES} dolphin-nogui)
install(TARGETS dolphin-nogui RUNTIME DESTINATION ${bindir})
