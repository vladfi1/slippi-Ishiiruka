#!/bin/bash -e
# build-linux.sh

CMAKE_FLAGS='-DLINUX_LOCAL_DEV=true'
CMAKE_FLAGS+=' -DDISABLE_WX=true -DENABLE_HEADLESS=true'

# Minimize build dependencies.
CMAKE_FLAGS+=' -DENABLE_ALSA=false -DENABLE_PULSEAUDIO=false'
CMAKE_FLAGS+=' -DENABLE_EVDEV=false'

# Consider USE_EGL for framedumping
# Consider TRY_X11=false

PLAYBACK_CODES_PATH="./Data/PlaybackGeckoCodes/"

DATA_SYS_PATH="./Data/Sys/"
BINARY_PATH="./build/Binaries/"

# Build type
if [ "$1" == "playback" ]
    then
        CMAKE_FLAGS+=" -DIS_PLAYBACK=true"
        echo "Using Playback build config"
else
        echo "Using Netplay build config"
fi

# Move into the build directory, run CMake, and compile the project
mkdir -p build
pushd build
cmake ${CMAKE_FLAGS} ../
make -j$(nproc)
popd

# Rename executable for compatibility with the AppImage build script.
mv $BINARY_PATH/dolphin-emu-nogui $BINARY_PATH/dolphin-emu

# Copy the Sys folder in
rm -rf ${BINARY_PATH}/Sys
cp -r ${DATA_SYS_PATH} ${BINARY_PATH}

touch ./build/Binaries/portable.txt

# Copy playback specific codes if needed
if [ "$1" == "playback" ]
    then
        # Update Sys dir with playback codes
        echo "Copying Playback gecko codes"
		rm -rf "${BINARY_PATH}/Sys/GameSettings" # Delete netplay codes
		cp -r "${PLAYBACK_CODES_PATH}/." "${BINARY_PATH}/Sys/GameSettings/"
fi
