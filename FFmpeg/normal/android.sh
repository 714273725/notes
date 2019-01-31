#!/bin/sh
make clean
#------------NDK-------------#
#ndk 目录
#r16b min support android-14  max android-8.1
NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
#NDK=/home/gjy/ndk/android-ndk-r14b-linux-x86_64/android-ndk-r14b
#r15c min support android-14  max android-8.0
#NDK=/home/gjy/ndk/android-ndk-r15c-linux-x86_64/android-ndk-r15c
#------------NDK-------------#
#Android目标版本(没有20，19不支持64位)
ANDROID_VERSION=19
#编译链版本
TOOLCHAIN_VERSION=4.9
#ndk sdk 平台
BUILD_PLATFORM=linux-x86_64
#------------LDFLAGS-------------#
#ANDROID_19需要添加-nostdlib，否则会报crtbegin_dynamic.o crtend_android.o not found
#LDFLAGS_FOR_ANDROID_19="-nostdlib $ADDI_LDFLAGS"
#LDFLAGS="$ADDI_LDFLAGS"
#------------LDFLAGS-------------#
#-----------------各个平台的编译优化指令--------------------#
#armeabi
ANDROID_ARMV5_CFLAGS="-march=armv5te"
#armeabi-v7a
#ANDROID_ARMV7_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
ANDROID_ARMV7_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfp"
#arm64-v8a
ANDROID_ARMV8_CFLAGS="-march=armv8-a"
#X86
ANDROID_X86_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
#X86_64
ANDROID_X86_64_CFLAGS="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
#-----------------各个平台的编译优化指令--------------------#
build(){
    ARCH=$1         # arm arm64 x86 x86_64
    ANDROID_ARCH_ABI=$2     # armeabi armeabi-v7a x86 mips
    HOST=$3     # arm-linux-androideabi aarch64-linux-android x86 x86_64
    CROSS=$4    #交叉编译链目录
    CFLAGS_TARGET=$5 #目标平台编译优化指令
    NOSTDLIB=$6
    SYSROOT=${NDK}/platforms/android-${ANDROID_VERSION}/arch-${ARCH}/
    PREFIX=$(pwd)/android_${ANDROID_VERSION}/$ANDROID_ARCH_ABI
    TOOLCHAIN=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
    #CFLAGS 表示用于 C 编译器的选项
    #-I指定头文件（.h文件）的路径
    #-Os 编译时所有的错误或者警告信息,有-O0->-O3,0表示最低，3表示最高，-Os相当于2.5
    #-fPIC 作用于编译阶段，告诉编译器产生与位置无关代码(Position-Independent  Code)，则产生的代码中，没有绝对地址，全部使用相对地址，故而代码可以被加载器加载到内存的任意位置，都可以正确的执行。
    #isysroot 编译时指定逻辑目录。指定编译过程中需要引用的库，头文件目录
    CFLAGS="-Os -fpic $CFLAGS_TARGET -isysroot $NDK/sysroot -I$NDK/sysroot/usr/include/$CROSS -D__ANDROID_API__=$ANDROID_VERSION"
    CROSS_PREFIX=${TOOLCHAIN}/bin/${CROSS}-
    echo "ARCH = $ARCH PREFIX= $PREFIX"
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
}
#build armeabi
build arm armeabi arm-linux-androideabi arm-linux-androideabi "$ANDROID_ARMV5_CFLAGS"
#build armeabi-v7a
build arm armeabi-v7a arm-linux-androideabi arm-linux-androideabi "$ANDROID_ARMV7_CFLAGS"
#build arm64-v8a
#build arm64 arm64-v8a aarch64-linux-android aarch64-linux-android "$ANDROID_ARMV8_CFLAGS"
#build x86
build x86 x86 x86 i686-linux-android "$ANDROID_X86_CFLAGS"
#build x86_64
#build x86_64 x86_64 x86_64 x86_64-linux-android "$ANDROID_X86_64_CFLAGS"
