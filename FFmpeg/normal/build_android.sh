#!/bin/bash
make clean
NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
#armv5te
#ARCH=arm
#CPU=armeabi
#TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64
#SYSROOT=$NDK/platforms/android-27/arch-$ARCH/
#CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
#A=/arm-linux-androideabi
#PREFIX=$(pwd)/android/$CPU
#OPTIMIZE_CFLAGS="-march=$CPU"

#x86_64
#ARCH=x86_64
#CPU=x86-64
#TOOLCHAIN=$NDK/toolchains/x86_64-4.9/prebuilt/linux-x86_64
#SYSROOT=$NDK/platforms/android-27/arch-$ARCH/
#A=/x86_64-linux-android
#CROSS_PREFIX=$TOOLCHAIN/bin/x86_64-linux-android-
#PREFIX=$(pwd)/android/$CPU
#OPTIMIZE_CFLAGS="-march=$CPU -msse4.2 -mpopcnt -m64 -mtune=intel"

#armv8-a
#ARCH=arm64
#CPU=armv8-a
#TOOLCHAIN=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64
#SYSROOT=$NDK/platforms/android-27/arch-$ARCH/
#CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
#A=/aarch64-linux-android
#PREFIX=$(pwd)/android/$CPU
#OPTIMIZE_CFLAGS="-march=$CPU"

#armv7-a
#ARCH=arm
#CPU=armv7-a
#A=/arm-linux-androideabi
#TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64
#SYSROOT=$NDK/platforms/android-27/arch-$ARCH/
#CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
#PREFIX=$(pwd)/android/$CPU
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "

build_android(){

echo "Compiling FFmpeg for $CPU"
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
    --cpu=$CPU \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS -isysroot $NDK/sysroot -I$NDK/sysroot/usr/include/$A -D__ANDROID_API__=27" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
#    make clean

#    make -j4

#    make install

    echo "The Compilation of FFmpeg for $CPU is completed"

}




#build_android

#x86
#ARCH=x86
#CPU=x86
#TOOLCHAIN=$NDK/toolchains/x86-4.9/prebuilt/linux-x86_64
#SYSROOT=$NDK/platforms/android-27/arch-$ARCH/
#CROSS_PREFIX=$TOOLCHAIN/bin/i686-linux-android-
#A=/i686-linux-android
#PREFIX=$(pwd)/android/$CPU
#OPTIMIZE_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
#build_android

build_android
