#!/bin/sh
make clean
#ndk 目录
#NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
NDK=/home/gjy/ndk/android-ndk-r15c-linux-x86_64/android-ndk-r15c
#Android目标版本
ANDROID_VERSION=19
#编译链版本
TOOLCHAIN_VERSION=4.9
#ndk sdk 平台
BUILD_PLATFORM=linux-x86_64
#各个平台的编译优化指令
#mips
ANDROID_MIPS_CFLAGS=""
#mips_64
ANDROID_MIPS_64_CFLAGS=""
build(){
    ARCH=$1         # arm arm64 x86 x86_64
    ANDROID_ARCH_ABI=$2     # armeabi armeabi-v7a x86 mips
    HOST=$3     # arm-linux-androideabi aarch64-linux-android x86 x86_64
    CROSS=$4    #交叉编译链目录
    CFLAGS_TARGET=$5 #目标平台编译优化指令
    #CFLAGS 表示用于 C 编译器的选项
    #-I指定头文件（.h文件）的路径
    #-Os 编译时所有的错误或者警告信息,有-O0->-O3,0表示最低，3表示最高，-Os相当于2.5
    #-fPIC 作用于编译阶段，告诉编译器产生与位置无关代码(Position-Independent  Code)，则产生的代码中，没有绝对地址，全部使用相对地址，故而代码可以被加载器加载到内存的任意位置，都可以正确的执行。
    #isysroot 编译时指定逻辑目录。指定编译过程中需要引用的库，头文件目录
    CFLAGS="-Os -fpic $CFLAGS_TARGET -isysroot $NDK/sysroot -I$NDK/sysroot/usr/include/$CROSS -D__ANDROID_API__=27"
    SYSROOT=${NDK}/platforms/android-${ANDROID_VERSION}/arch-${ARCH}
    PREFIX=$(pwd)/android/$ANDROID_ARCH_ABI
    TOOLCHAIN=${NDK}/toolchains/${HOST}-${TOOLCHAIN_VERSION}/prebuilt/${BUILD_PLATFORM}
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
    --disable-mipsdsp \
    --disable-mipsdspr2 \
    --disable-mipsfpu \
    --arch=$ARCH \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="$CFLAGS " \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
    #make clean
    #make -j4
    #make install
}
#build mips
build mips mips mipsel-linux-android mipsel-linux-android "$ANDROID_MIPS_CFLAGS"

#build mips64
build mips64 mips_64 mips64el-linux-android mips64el-linux-android "$ANDROID_MIPS_64_CFLAGS"
