#!/bin/bash
set -u
set -e
export NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b

export AndroidVersion=$1
export ARCH=$2
export PLATFORM=$NDK/platforms/android-${AndroidVersion}/arch-${ARCH}
#根据不同目标平台，设置不同参数
if [ $ARCH == 'arm' ]; then
 #arm
 CPU=armv5te
 ARCH=arm
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 HOST=arm-linux-androideabi
 OPTIMIZE_CFLAGS="-marm -march=$CPU -Os -O3"
 LIBX264_FLAGS="--disable-asm"
 ADDITIONAL_FFMPEG_CONFIGURATION="--disable-asm"
elif [ $ARCH == 'armv7-n' ]; then
 #arm v7n
 CPU=armv7-a
 ARCH=arm
 HOST=arm-linux-androideabi
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -mtune=cortex-a8 -march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION="--enable-neon "
elif [ $ARCH == 'armv7-a' ]; then
 # armv7-a
 CPU=armv7-a
 ARCH=arm
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 HOST=arm-linux-androideabi
 OPTIMIZE_CFLAGS="-mfloat-abi=softfp -marm -march=$CPU -Os -O3 " 
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION=  
elif [ $ARCH == 'armv8-a' ]; then
 #arm64-v8a
 CPU=armv8-a
 ARCH=arm64
 OPENSSL_ARCH="linux-x86_64 shared no-ssl2 no-ssl3 no-hw"
 HOST=aarch64-linux-android
 OPTIMIZE_CFLAGS="-march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION=
elif [ $ARCH == 'x86_64' ]; then
 #x86_64
 CPU=x86-64
 ARCH=x86_64
 OPENSSL_ARCH="linux-x86_64 shared no-ssl2 no-ssl3 no-hw"
 HOST=x86_64-linux-android
 OPTIMIZE_CFLAGS="-fomit-frame-pointer -march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION=
elif [ $ARCH == 'x86' ]; then
 #x86
 CPU=i686
 ARCH=i686
 OPTIMIZE_CFLAGS="-fomit-frame-pointer -march=$CPU -Os -O3"
 HOST=i686-linux-android
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 LIBX264_FLAGS="--disable-asm "
 #due https://github.com/android-ndk/ndk/issues/693
 ADDITIONAL_FFMPEG_CONFIGURATION="--disable-asm "
else
 echo "invalid target exiting..." 
 exit 1
fi
#声明编译链安装路径，后面编译时将使用此编译链
export TOOLCHAIN=/home/gjy/ndk/build/ffmpeg/$ARCH
#sysroot选项设定gcc在编译源码的时候，寻找头文件和库文件的根目录。
#设定sysroot有两种方法
#1.使用gcc gcc --sysroot=$SYSROOT
#2.使用make-standalone-toolchain.sh，以下是使用make-standalone-toolchain.sh的示例
export PREFIX=$(pwd)/tmp
export CROSS_PREFIX=${TOOLCHAIN}/bin/${HOST}-
export SYSROOT=${TOOLCHAIN}/sysroot
export PATH=/home/gjy/ndk/build/ffmpeg/$ARCH/bin:$PATH
export PKG_CONFIG="$(which pkg-config)"
export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
export CC="${TOOLCHAIN}/bin/clang"
export CXX="${TOOLCHAIN}/bin/clang++"
export CPP="${CROSS_PREFIX}cpp"
export AR="${CROSS_PREFIX}ar"
export LD="${CROSS_PREFIX}ld"
export NM="${CROSS_PREFIX}nm"
export RANLIB="${CROSS_PREFIX}ranlib"
export STRIP="${CROSS_PREFIX}strip"
export LDFLAGS="-L${PREFIX}/lib -L${TOOLCHAIN}/lib -L${SYSROOT}/usr/lib -fPIE -pie "
export CFLAGS="${OPTIMIZE_CFLAGS} -I${PREFIX}/include -I${SYSROOT}/usr/include -fPIE " 
export CXXFLAGS="${CFLAGS} "
export CPPFLAGS="${CFLAGS} "
export CROSS_SYSROOT="${SYSROOT}"
export __ANDROID_API__=${AndroidVersion}

#安装编译链的路径
if [ ! -d ${TOOLCHAIN} ]; then
 echo "编译链不存在，安装编译链"
 $NDK/build/tools/make-standalone-toolchain.sh --use-llvm --platform=android-${AndroidVersion} --install-dir=${TOOLCHAIN} --arch=${ARCH} --stl=libc++
else
 echo "使用已安装的编译链 ${TOOLCHAIN}"
fi

build(){
	#目标系统
	OS=android
	#交叉编译参数
	CROSS_COMPILE_FLAGS="--target-os=${OS} \
	--arch=${ARCH} \
	--cpu=${CPU} \
	--cross-prefix=${CROSS_PREFIX} \
	--enable-cross-compile \
	--cc=${CC} \
	--cxx=${CXX} "
	echo "正在配置编译参数..."
	./configure --prefix=$PREFIX \
		$CROSS_COMPILE_FLAGS \
		--pkg-config=${PKG_CONFIG} \
		--pkg-config-flags="--static" \
		--enable-pic \
		--enable-gpl \
		--enable-nonfree \
		--enable-static \
		--disable-shared \
		--enable-ffmpeg \
		--disable-ffplay \
		--disable-ffprobe \
		--disable-doc \
		--disable-vfp \
		--disable-devices \
 		--disable-protocols \
 		${ADDITIONAL_FFMPEG_CONFIGURATION}
	echo "编译参数已配置，正在清除上次make产生的文件..."
	#make clean
	#make -j4
    echo "正在安装ffmpeg..."
	#V=1编译过程中显示详细信息
	#make install V=1
	LINKS=""
	dir="$PREFIX/lib"
	for file in $dir/*.a; do
    	LINKS=$LINKS\ $file
	done
    echo "正在链接多个.a文件为一个.so文件，连接的.a有：$LINKS"
	#$TOOLCHAIN/bin/$HOST-ld -G -o libffmpeg_$ARCH.so --whole-archive $LINKS --no-whole-archive
    $TOOLCHAIN/bin/$HOST-ld \
		-rpath-link=$PLATFORM/usr/lib \
		-L$PLATFORM/usr/lib \
		-L$PREFIX/lib \
		-soname libffmpeg_$ARCH.so -G -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
		$PREFIX/libffmpeg_$ARCH.so $LINKS \
		-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
	$TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9.x/libgcc.a
	echo "正在压缩so文件。"
    $TOOLCHAIN/bin/$HOST-strip $PREFIX/libffmpeg_$ARCH.so
	echo "so文件已生成。"
    #编译完成后移除编译链
	#rm -r $TOOLCHAIN
}
build

