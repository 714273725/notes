#!/bin/sh
NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
ANDROID_VERSION=21
TOOLCHAIN_VERSION=4.9
BUILD_PLATFORM=linux-x86_64
ARCH=x86_64
ANDROID_ARCH_ABI=x86_64
HOST=x86_64
CROSS=x86_64-linux-android
SYSROOT=${NDK}/platforms/android-${ANDROID_VERSION}/arch-${ARCH}/
PREFIX=$(pwd)/android/${ANDROID_VERSION}/$ANDROID_ARCH_ABI
TOOLCHAIN=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
CFLAGS="-Os -fpic -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel -isysroot $NDK/sysroot -I$NDK/sysroot/usr/include/$CROSS -D__ANDROID_API__=$ANDROID_VERSION"
CROSS_PREFIX=${TOOLCHAIN}/bin/${CROSS}-
build(){
echo "configuring $ANDROID_ARCH_ABI ANDROID_VERSION=$ANDROID_VERSION"
./configure \
    --prefix=$PREFIX \
    --enable-neon \
    --enable-hwaccels \
    --enable-gpl \
    --enable-postproc \
    --enable-shared \
    --enable-jni \
    --enable-mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-hwaccel=h264_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --enable-decoder=mpeg4_mediacodec \
    --enable-decoder=vp8_mediacodec \
    --enable-decoder=vp9_mediacodec \
    --disable-static \
    --disable-doc \
    --enable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --enable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$CROSS_PREFIX \
    --target-os=android \
    --arch=$ARCH \
    --disable-yasm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="$CFLAGS " \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
    make clean
    make -j4
    make install
    echo "$ANDROID_ARCH_ABI installed"
}
build
