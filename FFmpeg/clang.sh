#!/bin/bash
#已知没有接入的模块
#freetype
#fontconfig

cur_sec=`date '+%s'`
#血的教训，不能同时enable静态库和动态库,否则最终的到的只是其中的一种
#此脚本使用/bin/bash来解释执行,#!是一个特殊的表示符，其后，跟着解释此脚本的shell路径。除第一行外，脚本中所有以“#”开头的行都是注释。
#还有很多其它shell，如：sh,csh,ksh,tcsh
#PIC指的是位置无关代码，用于生成位置无关的共享库
#PIE指的是位置无关的可执行程序，用于生成位置无关的可执行程序
#遇到不存在的变量就会报错，并停止执行。默认不会
set -u
#脚本只要发生错误，就终止执行
set -e
#运行结果之前，输出执行的命令行
set -x
#export 设置环境变量
export NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
#检查NDK目录是否存在
if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
 echo "NDK variable not set or path to NDK is invalid, exiting..."
 exit 1
fi
#cpu 架构
export ARCH=$1
#android最低版本
export Android_Version=$2
#生产代码根目录
export PREFIX=$(pwd)/$3
#打包so时是否连接所有静态库
export ALL=$4
#最终生成代码的目录
FINAL_DIR=$(pwd)/final/${Android_Version}/${ARCH}
#安装一些必要依赖
sudo apt-get update
sudo apt-get -y install automake autopoint libtool gperf libssl-dev clang ragel
#ffmpeg版本号
FFMPEG_VERSION="4.1"
#pous版本号
OPUS_VERSION="1.1.5"
#freetype版本号
LIBFREETYPE_VERSION="2.9"
#fdk_acc
FDK_AAC_VERSION="0.1.6"
#X264版本号，一个开源的有损视频编码器
LIBX264_VERSION="snapshot-20180601-2245-stable"

LIBEXPAT_VERSION="2.2.5"
LIBFONTCONFIG_VERSION="2.13.0"
LIBUUID_VERSION="1.0.3"
LAME_VERSION="3.100"
LIBOGG_VERSION="1.3.2"
LIBVORBIS_VERSION="1.3.4"
ZLIB_VERSION="1.2.11"
LIBPNG12_VERSION="1.2.59"
LIBOPENSSL_VERSION="1.0.2o"
LIBTRMP_VERSION="2.3"
HARFBUZZ_VERSION="2.2.0"

#判断ffmpeg目标版本目录是否存在，没有则下载并解压
LIB="ffmpeg"
VERSION=${FFMPEG_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://www.ffmpeg.org/releases/${LIB}-${FFMPEG_VERSION}.tar.gz
 echo "extracting ${LIB}-${VERSION}.tar.gz"
 tar -zxf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi

#判断x264目标版本目录是否存在，没有则下载并解压
LIB="x264"
VERSION=${LIBX264_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -O "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-$LIBX264_VERSION.tar.bz2"
 tar -xf ${LIB}-${VERSION}.tar.bz2
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/{$LIB}"
fi

#一个音频编码器
LIB="opus"
VERSION=${OPUS_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://archive.mozilla.org/pub/opus/opus-${OPUS_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/opus-${OPUS_VERSION}"
fi
#一个字体引擎
LIB="freetype"
VERSION=${LIBFREETYPE_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://download.savannah.gnu.org/releases/freetype/freetype-${LIBFREETYPE_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi

#一个音频编码器
LIB="fdk-aac"
VERSION=${FDK_AAC_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO http://downloads.sourceforge.net/opencore-amr/fdk-aac-${FDK_AAC_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi

#一个音频编码器
LIB="lame"
LAME_MAJOR="3.100"
VERSION=${LAME_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO http://downloads.sourceforge.net/project/lame/lame/${LAME_MAJOR}/lame-${LAME_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 curl -L -o ${LIB}-${VERSION}/config.guess "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD"
 curl -L -o ${LIB}-${VERSION}/config.sub "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD"
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
#一个音频编码器
LIB="libogg"
VERSION=${LIBOGG_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO http://downloads.xiph.org/releases/ogg/libogg-${LIBOGG_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
#一种音频压缩格式编码器
LIB="libvorbis"
VERSION=${LIBVORBIS_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO http://downloads.xiph.org/releases/vorbis/libvorbis-${LIBVORBIS_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
LIB="expat"
VERSION=${LIBEXPAT_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO http://downloads.sourceforge.net/project/expat/expat/${LIBEXPAT_VERSION}/expat-${LIBEXPAT_VERSION}.tar.bz2
 tar -xjf ${LIB}-${VERSION}.tar.bz2
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
LIB="fontconfig"
VERSION=${LIBFONTCONFIG_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://www.freedesktop.org/software/fontconfig/release/fontconfig-${LIBFONTCONFIG_VERSION}.tar.gz
 tar -xzf ${LIB}-${LIBFONTCONFIG_VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
LIB="libuuid"
VERSION=${LIBUUID_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://ufpr.dl.sourceforge.net/project/libuuid/libuuid-${LIBUUID_VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi 
LIB="libpng"
VERSION=${LIBPNG12_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://ufpr.dl.sourceforge.net/project/libpng/libpng12/${VERSION}/libpng-${VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi
LIB="zlib"
VERSION=${ZLIB_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://zlib.net/zlib-${VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi 
LIB="openssl"
VERSION=${LIBOPENSSL_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://www.openssl.org/source/openssl-${VERSION}.tar.gz
 tar -xzf ${LIB}-${VERSION}.tar.gz
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi 
LIB="rtmpdump"
VERSION=${LIBTRMP_VERSION}
if [ ! -d ${LIB} ]; then
 git clone git://git.ffmpeg.org/rtmpdump
fi
LIB="harfbuzz"
VERSION=${HARFBUZZ_VERSION}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${HARFBUZZ_VERSION}.tar.bz2
 tar -xf ${LIB}-${VERSION}.tar.bz2
 mv ${LIB}-${VERSION} ${LIB}
else
 echo "Using existing `pwd`/${LIB}"
fi

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

function build_one {
TOOLCHAIN=${NDK}/toolchain/${ARCH}
SYSROOT=${TOOLCHAIN}/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/${HOST}-
#"i686"
if [ $ARCH == "i686" ]; then
$NDK/build/tools/make-standalone-toolchain.sh --use-llvm --platform=android-${Android_Version} --install-dir=${TOOLCHAIN} --arch=x86 --stl=libc++ || true
elif [ $ARCH == "native" ]; then
NDK=
TOOLCHAIN=/usr
SYSROOT=${NDK}/platforms/android-${Android_Version}/arch-${ARCH}/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/
else
$NDK/build/tools/make-standalone-toolchain.sh --use-llvm --platform=android-${Android_Version} --install-dir=${TOOLCHAIN} --arch=${ARCH} --stl=libc++ || true
fi
#"x86_64"
if [ $ARCH == "x86_64" ]; then
#递归删除
rm -R ${SYSROOT}/usr/lib
# ln [参数] [源文件或目录] [目标文件或目录]
ln -s ${SYSROOT}/usr/lib64 ${SYSROOT}/usr/lib
fi


#设置环境变量
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
export PATH="$PATH:$PREFIX/bin:$NDK/build"
export CROSS_SYSROOT="${SYSROOT}"
export __ANDROID_API__=${Android_Version}
 
# mkdir 创建一个目录，加 -p （-p, --parents）当目录的上级不存在时，创建上级目录
mkdir -p ${PREFIX}
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/include

#cp 复制 
#-p 连同档案的属性一起复制过去，而非使用预设属性 
cp -p $SYSROOT/usr/lib/libz.a $PREFIX/lib/libz.a || true
cp -p $SYSROOT/usr/include/zlib.h $PREFIX/include/zlib.h || true
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

#required by fontconfig
pushd harfbuzz
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --without-glib \
 --with-gobject=yes \
 --enable-static \
 --with-sysroot=$SYSROOT \
 --disable-shared
#make clean
#make -j8 
#make install
popd

pushd x264
#touch build.sh
#echo 'Hello World!'>build.sh
./configure \
 --cross-prefix=$CROSS_PREFIX \
 --sysroot=$SYSROOT \
 --host=$HOST \
 --enable-pic \
 --enable-static \
 --disable-shared \
 --disable-cli \
 --disable-opencl \
 --prefix=$PREFIX \
 $LIBX264_FLAGS  
 make clean 
 make -j4 
 make install V=1
popd


echo "making fdk-aac ==============================================>>>>"
pushd fdk-aac
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --disable-shared \
 --with-sysroot=$SYSROOT
 make clean
 make -j4
 make install
 echo "end making fdk-aac ==============================================>>>>"
popd
echo "0000000000000000000000000000000000000000000000000000000000000000000"
pushd lame
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --disable-shared \
 --disable-frontend \
 --with-sysroot=$SYSROOT
 make clean
 make -j4 
 make install
popd

pushd libogg
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --disable-shared \
 --with-sysroot=$SYSROOT
 make clean
 make -j4 
 make install
popd


pushd libvorbis
sed -ia.bak "s;-mno-ieee-fp;;g" configure
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --disable-shared \
 --with-sysroot=$SYSROOT \
 --with-ogg=$PREFIX
 make clean
 make -j4
 make install
popd


pushd opus
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --disable-shared \
 --disable-doc \
 --disable-extra-programs
 make clean
 make -j4
 make install V=1
popd



pushd libpng
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --with-arch=$ARCH\
 --with-sysroot=$SYSROOT \
 --disable-shared \
 --enable-static \
 --with-pic 
 make clean
 make -j4
 make install 
popd



#required by fontconfig
pushd libuuid
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --enable-static \
 --with-sysroot=$SYSROOT \
 --disable-shared 
 make clean
 make -j8 
 make install
popd

# required by fontconfig
pushd expat
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --with-pic \
 --enable-static \
 --with-sysroot=$SYSROOT \
 --without-docbook \
 --disable-docs \
 --without-xmlwf \
 --disable-shared 
 make clean 
 make -j4 
 make install
popd
#编译freetype
echo "making freetype ==================================================>>>>"
pushd freetype
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --with-pic \
 --with-zlib=yes \
 --enable-static \
 --with-sysroot=$SYSROOT \
 --without-old-mac-fonts \
 --without-fsspec \
 --without-fsref \
 --without-harfbuzz \
 --without-quickdraw-toolbox \
 --without-quickdraw-carbon \
 --without-ats \
 --with-png=no \
 --disable-shared 
 make clean
 make -j4 
 make install V=1
 echo "end making freetype ==============================================>>>>" 
popd

pushd fontconfig 
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --with-arch=$ARCH\
 --with-sysroot=$SYSROOT \
 --with-pic \
 --disable-libxml2 \
 --disable-iconv \
 --enable-static \
 --disable-shared \
 --disable-docs \
 --disable-rpath
 make clean
 make -j4 
 make install
popd

pushd openssl
#-D__ANDROID_API__=N
./Configure ${OPENSSL_ARCH} \
 --prefix=${PREFIX} \
 --with-zlib-include=${SYSROOT}/usr/include \
 --with-zlib-lib=${SYSROOT}/usr/lib \
 zlib \
    no-hw \
 no-asm \
 no-shared \
 no-unit-test \
    -I${TOOLCHAIN} \
    -fPIE
 sed -i.bak "s;-mandroid;;g" Makefile 
 make clean
 make -j4
 make install_sw
#make install_ssldirs 
popd


pushd rtmpdump
 pushd librtmp 
 set -e
 make clean
 make SYS=android prefix=${PREFIX} CROSS_COMPILE=${CROSS_PREFIX} CC=${CC}   SHARED= 
 make SYS=android prefix=${PREFIX} CROSS_COMPILE=${CROSS_PREFIX} CC=${CC} SHARED= install 
 popd 
popd
echo "end-------------------------------------------------------------end"
if [$ALL=='true'];then
LINKS="$PREFIX/lib/libavcodec.a 
$PREFIX/lib/libavfilter.a 
$PREFIX/lib/libswresample.a 
$PREFIX/lib/libavformat.a 
$PREFIX/lib/libavutil.a 
$PREFIX/lib/libswscale.a 
$PREFIX/lib/libx264.a
$PREFIX/lib/libx264.a"
dir="$PREFIX/lib"
for file in $dir/*.a; do
   LINKS=$LINKS:$file
   echo $LINKS
done
else
LINKS="$PREFIX/lib/libavcodec.a 
$PREFIX/lib/libavfilter.a 
$PREFIX/lib/libswresample.a 
$PREFIX/lib/libavformat.a 
$PREFIX/lib/libavutil.a 
$PREFIX/lib/libswscale.a 
$PREFIX/lib/libx264.a"
fi
LINK="$LTOOLCHAIN/bin/$HOST-ld -Bsymbolic -G -o libffmpeg_$ARCH.so -fPIE --whole-archive $LINKS --no-whole-archive"






#进入ffmpeg 目录
pushd ffmpeg
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
 \
 --enable-libmp3lame \
 --enable-libopus \
 --enable-libvorbis \
 --enable-libx264 \
 --enable-libfdk-aac \
 --enable-librtmp \
 --enable-zlib \
 --enable-openssl \
 \
 --disable-protocols \
 --enable-protocol="crypto,librtmp,librtmpe,librtmps,data,file,librtmpt,librtmpte,tcp,rtp,prompeg,udp,udplite,srtp" \
--disable-filters \
 --enable-filter="transpose,abitscope,acompressor,acontrast,acopy,acrossfade,acrusher,atrim,astreamselect,atadenoise,atempo,bbox,avectorscope,avgblur,deshake,displace,drawbox,hwmap,hwupload,pp,pixdesctest,pixscope,interlace,interleave,join,qp,random,psnr,inflate,drawtext,smptehdbars,pp7,pullup,split,spp" \
 --disable-parsers \
 --enable-parser="aac,aac_latm,ac3,bmp,cavsvideo,cook,dirac,flac,gsm,h261,h263,h264,hevc,mjpeg,pnm,mpeg4video,mpegaudio,mpegvideo,opus,vp3,vorbis,vp8,vp9,vc1,xma,png,rv30,rv40" \
 --disable-muxers \
 --enable-muxer="3gp,dnxhd,ac3,adts,aiff,amr,apng,ass,webm,ast,avi,webvtt,avm2,bit,null,gxf,gif,h261,h263,h264,hevc,eac3,f4v,flac,flv,gsm,hls,ico,mpeg2vob,image2,image2pipe,ipod,mjpeg,ismv,latm,m4v,matroska,mkvtimestamp_v2,matroska_audio,mmf,mov,mp2,mp3,mp4,mpjpeg,ogg,opus,mpegts,segment,stream_segment" \
 --disable-demuxers \
 --enable-demuxer="aac,ac3,acm,aiff,amr,amrnb,amrwb,apng,avi,bit,codec2,codec2raw,mkvtimestamp_v2,matroska_audio,mov,mp2,mp3,mp4,mpjpeg,ogg,opus,mpegts,flac,flic,flv,fourxm,gif,gsm,ico,h261,h263,h264,hevc,hls,eac3,ffmetadata,image_pgm_pipe,image_pgmyuv_pipe,image_svg_pipe,image_tiff_pipe,image_webp_pipe,image_psd_pipe,iv8,image_png_pipe,image2pipe,image_bmp_pipe,image2,image_jpeg_pipe,image_jpegls_pipe,m4v,matroska,mgsts,mpegvideo,mpjpeg,ogg,mov,mp3,mpegps,mpegts,mpegtsraw,svag,rawvideo,tta,tty,ty,rsd,rtp,rtsp,v210,v210x,vc1,vc1t,paf,pcm_alaw,pcm_f32be,pcm_f32le,pcm_f64be,pcm_f64le,pcm_mulaw,pcm_s16be,pcm_s16le,pcm_s24be,pcm_s24le,pcm_s32be,pcm_s32le,smjpeg,xmv,wav,webm_dash_manifest,webvtt,yop,yuv4mpegpipe,xvag,xwma,mjpeg,mjpeg_2000,pcm_s8,shorten,swf,thp" \
 --disable-encoders \
 --enable-encoder="ac3,ac3_fixed,alac,amv,apng,avui,ayuv,bmp,gif,h261,h263,h263_v4l2m2m,h263p,h264_v4l2m2m,huffyuv,jpeg2000,jpegls,mpeg4_v4l2m2m,msmpeg4v2,msmpeg4v3,msvideo1,opus,pcm_alaw,pcm_f32be,pcm_f32le,pcm_s8,pcm_s8_planar,pcm_u16be,pcm_u16le,pcm_u24be,pcm_u24le,pcm_u32be,pcm_u32le,pcm_u8,pcm_mulaw,pcm_s16be,pcm_s16be_planar,pcm_s16le,pcm_s16le_planar,r10k,pcm_s24daud,pcm_s24le,pcm_s24le_planar,pcm_s32be,rv10,pcm_s64be,r210,ra_144,text,tiff,truehd,tta,v308,v408,v410,vc2,vorbis,rawvideo,rv20,wavpack,webvtt,wmav1,wmav2,pcm_s32le,pcm_s32le_planar,mpeg2video,pcm_s64le,libfdk_aac,libmp3lame,libopus,pcm_f64be,pcm_f64le,eac3,flashsv,mpeg4,flv,flac,movtext,mp2,mp2fixed,mpeg1video,libx264,libx264rgb,ljpeg,magicyuv,mjpeg,pcm_s24be,libvorbis,pgmyuv,png,vp8_v4l2m2m,wmv2,wrapped_avframe,xwd,wmv1,yuv4,y41p,zlib" \
 --disable-decoders \
 --enable-decoder="aac,aac_fixed,aac_latm,aasc,ac3,ac3_fixed,adpcm_4xm,adpcm_adx,adpcm_afc,adpcm_aica,adpcm_ct,adpcm_dtk,adpcm_ea,adpcm_ea_maxis_xa,adpcm_ea_r1,adpcm_ea_r2,adpcm_ea_r3,adpcm_ea_xas,adpcm_g722,adpcm_g726,adpcm_g726le,adpcm_ima_amv,adpcm_ima_apc,adpcm_ima_dat4,adpcm_ima_dk3,adpcm_ima_dk4,adpcm_ima_ea_eacs,adpcm_ima_ea_sead,adpcm_ima_iss,adpcm_ima_oki,adpcm_ima_qt,adpcm_ima_rad,adpcm_ima_smjpeg,adpcm_ima_wav,adpcm_ima_ws,adpcm_ms,adpcm_mtaf,adpcm_psx,adpcm_sbpro_2,adpcm_sbpro_3,adpcm_sbpro_4,adpcm_swf,adpcm_thp,adpcm_thp_le,adpcm_vima,adpcm_xa,adpcm_yamaha,alac,alias_pix,amrnb,amrwb,amv,ansi,apng,vp9_v4l2m2m,vplayer,wavpack,webp,webvtt,wmalossless,atrac3p,atrac3pal,cdgraphics,cdxl,avui,ayuv,bmp,ffvhuff,ffwavesynth,fic,fits,flv,tta,vb,vc1_v4l2m2m,vorbis,vp6,vp6f,vp7,yuv4,zero12v,zerocodec,zlib,smvjpeg,text,theora,thp,vp8,vp3,vp5,pcm_s24le,pcm_s24le_planar,tiff,truehd,vc1,rv10,rv40,pcm_s16le_planar,pcm_s32be,pcm_s32le_planar,pcm_s8,pcm_u24be,pcx,psd,qdraw,qpeg,r10k,r210,ra_144,rv30,vp8_v4l2m2m,vp9,y41p,evrc,flac,flashsv,flashsv2,flic,gif,fourxm,h261,h263,gsm,gsm_ms,h263p,h264_v4l2m2m,h263_v4l2m2m,h263i,h264,wmapro,wmav1,wmav2,wmavoice,wmv1,wmv2,wmv3,eac3,eacmv,eamad,magicyuv,xbin,xma1,xma2,pcm_u24le,pcm_u32be,pcm_u16be,pcm_u8,pcm_s32le,pcm_s24daud,pcm_s64be,pcm_s64le,mp2float,fmvc,mp3adu,mp3float,mp3on4,mp3on4float,mpeg1video,pcm_s24be,mimic,mjpeg,mjpegb,mpeg1_v4l2m2m,mp1,movtext,mp1float,mp2,pcm_u16le,mp3,pcm_s8_planar,mp3adufloat,mpc7,mpc8,pgmyuv,mpeg2_v4l2m2m,mpeg2video,pcm_zork,pcm_u32le,msa1,mpeg4_v4l2m2m,msmpeg4v1,hevc,huffyuv,msmpeg4v2,msmpeg4v3,msrle,mpeg4,png,mpegvideo,mpl2,ra_288,rawvideo,realtext,jpeg2000,jpegls,libfdk_aac,libopus,libvorbis,paf_video,opus,paf_audio,rv20,wmv3image,mlp" \
 --enable-bsf="aac_adtstoasc,h264_metadata,h264_mp4toannexb,mpeg4_unpack_bframes,h264_redundant_pps" \
 ${ADDITIONAL_FFMPEG_CONFIGURATION}
 make clean
 make -j4
#V=1编译过程中显示详细信息
#make install V=1
 $LINK
 $LINKSTRIP
 mkdir -p ${FINAL_DIR}/
 cp $PREFIX/bin/ffmpeg ${FINAL_DIR}/
 popd

 cd ${FINAL_DIR}
 zip  ${ARCH}.zip ffmpeg
}
#一般Makefile的生成有以下几种方式：1. 采用autogen.sh、bootstrap或者configure
#如果存在前两者的话，它们就是用来辅助生成configure的，然后再由configure来生成Makefile

#将多个静态库合并成一个动态库
LTOOLCHAIN=${NDK}/toolchain/${ARCH}
LSYSROOT=${NDK}/platforms/android-${Android_Version}/arch-${ARCH}



#可极大优化动态库大小
LINKSTRIP="$LTOOLCHAIN/bin/$HOST-strip libffmpeg_$ARCH.so"

build_one

