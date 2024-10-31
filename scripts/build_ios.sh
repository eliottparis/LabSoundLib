#!/bin/bash

##############################################################################
# PATHS
##############################################################################

PATH_THIS=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

PATH_ROOT=$PATH_THIS/..
PATH_LABSOUND=$PATH_ROOT/LabSound
PATH_ARTIFACTS=$PATH_ROOT/artifacts

PATH_IOS_TOOLCHAIN=$PATH_ROOT/cmake/ios-toolchain.cmake

PATH_BUILD_ROOT=$PATH_ARTIFACTS/build
PATH_BUILD_IPHONEOS=$PATH_BUILD_ROOT/iphoneos
PATH_BUILD_IPHONESIMULATOR=$PATH_BUILD_ROOT/iphonesimulator

PATH_INSTALL_ROOT=$PATH_ARTIFACTS/install
PATH_INSTALL_IPHONEOS=$PATH_INSTALL_ROOT/iphoneos
PATH_INSTALL_IPHONESIMULATOR=$PATH_INSTALL_ROOT/iphonesimulator

PATH_FRAMEWORKS=$PATH_ROOT/Frameworks



##############################################################################
# Clean artifacts
##############################################################################

rm -rf $PATH_ARTIFACTS



##############################################################################
# Build: iphonesimulator (arm64, x86_64)
##############################################################################

PLATFORM=OS64COMBINED
PATH_BUILD=$PATH_BUILD_IPHONESIMULATOR
PATH_INSTALL=$PATH_INSTALL_IPHONESIMULATOR

cmake -S $PATH_LABSOUND -B $PATH_BUILD -G "Xcode" -DPLATFORM=$PLATFORM -DDEPLOYMENT_TARGET=13 -DCMAKE_TOOLCHAIN_FILE=$PATH_IOS_TOOLCHAIN -DCMAKE_INSTALL_PREFIX=$PATH_INSTALL

xcodebuild -project $PATH_BUILD/LabSound.xcodeproj \
  -configuration Release \
  -scheme install \
  -destination "generic/platform=iOS Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES



##############################################################################
# Build: iphoneos (arm64)
##############################################################################

PLATFORM=OS64
PATH_BUILD=$PATH_BUILD_IPHONEOS
PATH_INSTALL=$PATH_INSTALL_IPHONEOS

cmake -S $PATH_LABSOUND -B $PATH_BUILD -G "Xcode" -DPLATFORM=$PLATFORM -DDEPLOYMENT_TARGET=13 -DCMAKE_TOOLCHAIN_FILE=$PATH_IOS_TOOLCHAIN -DCMAKE_INSTALL_PREFIX=$PATH_INSTALL

xcodebuild -project $PATH_BUILD/LabSound.xcodeproj \
  -configuration Release \
  -scheme install \
  -destination "generic/platform=iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES



##############################################################################
# Clean Frameworks
##############################################################################

rm -rf $PATH_FRAMEWORKS



##############################################################################
# Frameworks
##############################################################################

xcodebuild -create-xcframework \
    -framework $PATH_INSTALL_IPHONESIMULATOR/lib/LabSound.framework \
    -framework $PATH_INSTALL_IPHONEOS/lib/LabSound.framework \
    -output "$PATH_FRAMEWORKS/LabSound.xcframework"

xcodebuild -create-xcframework \
    -library $PATH_INSTALL_IPHONESIMULATOR/lib/libLabSoundMiniAudio.a \
    -library $PATH_INSTALL_IPHONEOS/lib/libLabSoundMiniAudio.a \
    -output "$PATH_FRAMEWORKS/LabSoundMiniAudio.xcframework"

# Rename libnyquist.a to labnyquist.a for cocoapods
mv $PATH_INSTALL_IPHONESIMULATOR/lib/liblibnyquist.a $PATH_INSTALL_IPHONESIMULATOR/lib/liblabnyquist.a
mv $PATH_INSTALL_IPHONEOS/lib/liblibnyquist.a $PATH_INSTALL_IPHONEOS/lib/liblabnyquist.a

xcodebuild -create-xcframework \
    -library $PATH_INSTALL_IPHONESIMULATOR/lib/liblabnyquist.a \
    -library $PATH_INSTALL_IPHONEOS/lib/liblabnyquist.a \
    -output "$PATH_FRAMEWORKS/labnyquist.xcframework"
