#!/bin/sh
#ndk 目录
#r16b min support android-14  max android-8.1
NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
#Android目标版本(没有20，19不支持64位)
ANDROID_VERSION=19
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
TOOLCHAIN=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
#CFLAGS 表示用于 C 编译器的选项
#-I指定头文件（.h文件）的路径
#-Os 编译时所有的错误或者警告信息,有-O0->-O3,0表示最低，3表示最高，-Os相当于2.5
#-fPIC 作用于编译阶段，告诉编译器产生与位置无关代码(Position-Independent  Code)，则产生的代码中，没有绝对地址，全部使用相对地址，故而代码可以被加载器加载到内存的任意位置，都可以正确的执行。
#isysroot 编译时指定逻辑目录。指定编译过程中需要引用的库，头文件目录
CFLAGS="-Os -fpic -march=armv5te -isysroot $NDK/sysroot -I$NDK/sysroot/usr/include/$CROSS -D__ANDROID_API__=$ANDROID_VERSION -U_FILE_OFFSET_BITS"
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
    #make clean
    #make -j4
    #make install
    echo "$ANDROID_ARCH_ABI installed"
}
build
