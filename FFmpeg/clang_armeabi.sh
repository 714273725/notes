#!/bin/sh
#ndk 目录
#r16b min support android-14  max android-8.1
NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
#Android目标版本(没有20，19不支持64位)
ANDROID_VERSION=21
#编译链版本
TOOLCHAIN_VERSION=4.9
#ndk sdk 平台
BUILD_PLATFORM=linux-x86_64
ARCH=arm
ANDROID_ARCH_ABI=armeabi
HOST=arm-linux-androideabi
CROSS=arm-linux-androideabi
SYSROOT=${NDK}/platforms/android-${ANDROID_VERSION}/arch-${ARCH}/
PREFIX=$(pwd)/android/${ANDROID_VERSION}/$ANDROID_ARCH_ABI
#指定编译链目录
TOOLCHAIN=${NDK}/toolchains/llvm/prebuilt/${BUILD_PLATFORM}/bin
#LD
LD=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/bin/${CROSS}-ld
#AS
AS=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/bin/${CROSS}-as
#AR
AR=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/bin/${CROSS}-ar
#ranlib
RANLIB=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/bin/${CROSS}-ranlib
CFLAGS="-mcpu=$ARCH -I$NDK/sysroot/usr/include/$CROSS -D__ANDROID_API__=$ANDROID_VERSION"
CROSS_PREFIX=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/bin/${CROSS}-
build(){
echo "configuring $ANDROID_ARCH_ABI ANDROID_VERSION=$ANDROID_VERSION"
./configure \
    --prefix=$PREFIX \
    --toolchain=clang-usan \
    --cross-prefix=$CROSS_PREFIX \
    --enable-neon \
    --enable-hwaccels \
    --enable-gpl \
    --enable-postproc \
    --enable-shared \
    --disable-static \
    --enable-jni \
    --enable-mediacodec \
    --enable-decoder=h264_mediacodec \
    --enable-hwaccel=h264_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --enable-decoder=mpeg4_mediacodec \
    --enable-decoder=vp8_mediacodec \
    --enable-decoder=vp9_mediacodec \
    --disable-doc \
    --enable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --enable-avdevice \
    --disable-doc \
    --disable-symver \
    --target-os=android \
    --extra-ldflags="-shared" \
    --arch=$ARCH \
    --cpu=$ANDROID_ARCH_ABI \
    --extra-cflags="-fPIE -fPIC -ffast-math -funroll-loops -mfloat-abi=softfp -mfpu=vfpv3-d16" \
    --enable-x86asm \
    --enable-cross-compile \
    --cc=$TOOLCHAIN/clang \
    --cxx=$TOOLCHAIN/clang++ \
    --ld=$LD \
    --as=$AS \
    --ar=$AR \
    --strip=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}/${CROSS}-strip \
    $ADDITIONAL_CONFIGURE_FLAG
    #make clean
    #make -j4
    #make install
    echo "$ANDROID_ARCH_ABI installed"
}
build
