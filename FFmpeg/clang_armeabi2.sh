#!/bin/bash

## $1: target
## $2: platform
## $3: prefix
## Support targets: "arm" "armv7-a", "armv7-n", "armv8-a", "x86", "x86_64"
## ./clang_armeabi2.sh arm 21 temp
set -e
set -x

export NDK=/home/gjy/ndk/android-ndk-r16b-linux-x86_64/android-ndk-r16b
 
## Check $NDK exists
if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
 echo "NDK variable not set or path to NDK is invalid, exiting..."
 exit 1
fi


export TARGET=$1
export API_LVL=$2
export PREFIX=$(pwd)/$3
FINAL_DIR=$(pwd)/final/${API_LVL}/${TARGET}


sudo apt-get update
sudo apt-get -y install automake autopoint libtool gperf libssl-dev clang ragel

 
 

LIB=none
VERSION=0


LIBFREETYPE_VERSION="2.9"
LIBEXPAT_VERSION="2.2.5"
LIBFONTCONFIG_VERSION="2.13.0"
LIBUUID_VERSION="1.0.3"
FFMPEG_VERSION="4.1"
LIBX264_VERSION="snapshot-20180601-2245-stable"
FDK_AAC_VERSION="0.1.6"
LAME_VERSION="3.100"
OPUS_VERSION="1.1.5"
LIBOGG_VERSION="1.3.2"
LIBVORBIS_VERSION="1.3.4"
ZLIB_VERSION="1.2.11"
LIBPNG12_VERSION="1.2.59"
LIBOPENSSL_VERSION="1.0.2o"
LIBTRMP_VERSION="2.3"
HarfBuzz_Version="2.2.0"
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
#一个开源的有损视频编码器
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

LIB="harfbuzz"
VERSION=${HarfBuzz_Version}
if [ ! -d ${LIB} ]; then
 echo "Downloading ${LIB}-${VERSION}"
 curl -LO https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${HarfBuzz_Version}.tar.bz2
 tar -xf ${LIB}-${VERSION}.tar.bz2
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


 

if [ ! -e "libunistring2_0.9.9-0ubuntu1_amd64.deb" ]; then
curl -LO http://mirrors.kernel.org/ubuntu/pool/main/libu/libunistring/libunistring2_0.9.9-0ubuntu1_amd64.deb
sudo apt install ./libunistring2_0.9.9-0ubuntu1_amd64.deb
fi

if [ ! -e "gettext_0.19.8.1-6_amd64.deb" ]; then
curl -LO http://mirrors.kernel.org/ubuntu/pool/main/g/gettext/gettext_0.19.8.1-6_amd64.deb
sudo apt install ./gettext_0.19.8.1-6_amd64.deb
fi

if [ ! -e "gettext-base_0.19.8.1-6_amd64.deb" ]; then
curl -LO http://mirrors.kernel.org/ubuntu/pool/main/g/gettext/gettext-base_0.19.8.1-6_amd64.deb
sudo apt install ./gettext-base_0.19.8.1-6_amd64.deb
fi

if [ ! -e "autopoint_0.19.8.1-6_all.deb" ]; then
curl -LO http://mirrors.kernel.org/ubuntu/pool/main/g/gettext/autopoint_0.19.8.1-6_all.deb
sudo apt install ./autopoint_0.19.8.1-6_all.deb
fi

if [ ! -e "libpng12-0_1.2.54-1ubuntu1_amd64.deb" ]; then
curl -LO http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb
sudo apt install ./libpng12-0_1.2.54-1ubuntu1_amd64.deb
fi


function build_one
{

 

TOOLCHAIN=${NDK}/toolchain/${ARCH}
SYSROOT=${TOOLCHAIN}/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/${HOST}-

if [ $ARCH == "i686" ]; then
$NDK/build/tools/make-standalone-toolchain.sh --use-llvm --platform=android-${API_LVL} --install-dir=${TOOLCHAIN} --arch=x86 --stl=libc++ || true
elif [ $ARCH == "native" ]; then
NDK=
TOOLCHAIN=/usr
SYSROOT=${NDK}/platforms/android-${API_LVL}/arch-${TARGET}/sysroot
CROSS_PREFIX=${TOOLCHAIN}/bin/
else
$NDK/build/tools/make-standalone-toolchain.sh --use-llvm --platform=android-${API_LVL} --install-dir=${TOOLCHAIN} --arch=${ARCH} --stl=libc++ || true
fi
 
#sed -i.bak "s;#define __ANDROID_API__ __ANDROID_API_FUTURE__;#define __ANDROID_API__ ${API_LVL};" ${SYSROOT}/usr/include/android/api-level.h
 
if [ $ARCH == "x86_64" ]; then
rm -R ${SYSROOT}/usr/lib
ln -s ${SYSROOT}/usr/lib64 ${SYSROOT}/usr/lib
fi



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
export __ANDROID_API__=${API_LVL}
 

mkdir -p ${PREFIX}
mkdir -p ${PREFIX}/lib
mkdir -p ${PREFIX}/include

 
cp -p $SYSROOT/usr/lib/libz.a $PREFIX/lib/libz.a || true
cp -p $SYSROOT/usr/include/zlib.h $PREFIX/include/zlib.h || true
 



 
 pushd x264
 ./configure \
 --cross-prefix=$CROSS_PREFIX \
 --sysroot=$SYSROOT \
 --host=$HOST \
 --enable-pic \
 --disable-static \
 --enable-shared \
 --disable-cli \
 --disable-opencl \
 --prefix=$PREFIX \
 $LIBX264_FLAGS
   
 make clean 
 make -j8 
 make install 
 popd


 # Non-free
 pushd fdk-aac
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
 --enable-shared \
 --with-sysroot=$SYSROOT

 make clean
 make -j8
 make install
 popd

 
 
pushd lame
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
 --enable-shared \
 --disable-frontend \
 --with-sysroot=$SYSROOT
make clean
make -j8 
make install
popd
#
#pushd freetype
#./configure \
#--prefix=$PREFIX \
#--host=$HOST \
#--with-pic \
#--with-zlib=yes \
#--disable-static \
#--with-sysroot=$SYSROOT \
#--without-old-mac-fonts \
#--without-fsspec \
#--without-harfbuzz \
#--without-fsref \
#--without-quickdraw-toolbox \
#--without-quickdraw-carbon \
#--without-ats \
#--with-png=no \
#--enable-shared 
#make clean
#make -j8 
#make install
#popd
#error 64 bit GLib headers and 32 bit target platform
#pushd harfbuzz
#./configure \
#--prefix=$PREFIX \
#--host=$HOST \
#--without-glib \
#--with-gobject=yes \
#--disable-static \
#--with-sysroot=$SYSROOT \
#--enable-shared
#make clean
#make -j8 
#make install
#popd

pushd freetype
./configure \
--prefix=$PREFIX \
--host=$HOST \
--with-pic \
--with-zlib=yes \
--disable-static \
--with-sysroot=$SYSROOT \
--without-old-mac-fonts \
--without-fsspec \
--without-fsref \
--without-quickdraw-toolbox \
--without-quickdraw-carbon \
--without-ats \
--with-png=no \
--enable-shared 
make clean
make -j8 
make install
popd
pushd libogg
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
 --enable-shared \
 --with-sysroot=$SYSROOT

make clean
make -j8 
make install
popd


pushd libvorbis
sed -ia.bak "s;-mno-ieee-fp;;g" configure

./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
 --enable-shared \
 --with-sysroot=$SYSROOT \
 --with-ogg=$PREFIX
make clean


make -j8 
make install
popd



pushd opus
./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
 --enable-shared \
 --disable-doc \
 --disable-extra-programs
make clean
make -j8
make install V=1
popd



 pushd libpng
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
   --with-arch=$ARCH\
 --with-sysroot=$SYSROOT \
  --enable-shared \
  --disable-static \
  --with-pic 
 
 make clean
 make -j8
 make install 
 
 popd
 
 

 # required by fontconfig
 pushd libuuid
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --disable-static \
--with-sysroot=$SYSROOT \
 --enable-shared 
 
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
 --disable-static \
   --with-sysroot=$SYSROOT \
   --without-docbook \
   --disable-docs \
   --without-xmlwf \
 --enable-shared 

 make clean 
 make -j8 
 make install
 popd



  pushd freetype
 ./configure \
 --prefix=$PREFIX \
 --host=$HOST \
 --with-pic \
 --with-zlib=yes \
 --disable-static \
 --with-sysroot=$SYSROOT \
 --without-old-mac-fonts \
 --without-fsspec \
 --without-fsref \
 --without-quickdraw-toolbox \
 --without-quickdraw-carbon \
 --without-ats \
 --with-png=yes \
 --enable-shared 
 
 make clean
 make -j8 
 make install
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
 --disable-static \
 --enable-shared \
 --disable-docs \
 --disable-rpath
 
 make clean
 make -j8 
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
 make -j8
 make install_sw
#make install_ssldirs
 
popd





 
 
 

pushd rtmpdump

pushd librtmp 
 

set -e
make clean
make SYS=android prefix=${PREFIX} CROSS_COMPILE=${CROSS_PREFIX} CC=${CC} SHARED= 
make SYS=android prefix=${PREFIX} CROSS_COMPILE=${CROSS_PREFIX} CC=${CC} SHARED= install 
 
popd 

popd


if [$ARCH != "native" ];then
#the file /home/rafa/Desktop/m4/ndk/toolchain/arm/sysroot/usr/include/asm-generic/termbits.h has a definition also defined on lavcoded/aac.c, so we need to comment it otherwise ffmpeg wont compile
BADFILE=${SYSROOT}/usr/include/asm-generic/termbits.h
sed -e "s;#define B0 0000000;//#define B0 0000000;" ${BADFILE} > ${BADFILE}n
mv ${BADFILE} ${BADFILE}.bak
mv ${BADFILE}n ${BADFILE}
fi

 

pushd ffmpeg
 
 OS=android
 
 if [ $ARCH == "native" ]; then
 OS=linux
 fi
 
 
 CROSS_COMPILE_FLAGS="--target-os=${OS} \
 --arch=${ARCH} \
 --cpu=${CPU} \
 --cross-prefix=${CROSS_PREFIX} \
 --enable-cross-compile \
 --cc=${CC} \
 --cxx=${CXX} "


 ./configure --prefix=$PREFIX \
 $CROSS_COMPILE_FLAGS \
 --pkg-config=${PKG_CONFIG} \
 --pkg-config-flags="--static" \
 --enable-pic \
 --enable-gpl \
 --enable-nonfree \
 \
 --disable-static \
 --enable-shared \
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
 --enable-libfreetype \
 --enable-openssl \
 --enable-libfontconfig \
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
make -j8
make install V=1

mkdir -p ${FINAL_DIR}/
cp $PREFIX/bin/ffmpeg ${FINAL_DIR}/

popd

cd ${FINAL_DIR}
zip  ${TARGET}.zip ffmpeg


rm ${BADFILE}
mv ${BADFILE}.bak ${BADFILE}


}


if [ $TARGET == 'arm' ]; then
 #arm
 CPU=armv5te
 ARCH=arm
OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 HOST=arm-linux-androideabi
 OPTIMIZE_CFLAGS="-marm -march=$CPU -Os -O3"
 LIBX264_FLAGS="--disable-asm"
 ADDITIONAL_FFMPEG_CONFIGURATION="--disable-asm"

elif [ $TARGET == 'armv7-n' ]; then
 #arm v7n
 CPU=armv7-a
 ARCH=arm
 HOST=arm-linux-androideabi
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -mtune=cortex-a8 -march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION="--enable-neon "

 
elif [ $TARGET == 'armv7-a' ]; then
 # armv7-a
 CPU=armv7-a
 ARCH=arm
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 HOST=arm-linux-androideabi
 OPTIMIZE_CFLAGS="-mfloat-abi=softfp -marm -march=$CPU -Os -O3 " 
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION= 

 
elif [ $TARGET == 'armv8-a' ]; then
 #arm64-v8a
 CPU=armv8-a
 ARCH=arm64
 OPENSSL_ARCH="linux-x86_64 shared no-ssl2 no-ssl3 no-hw"
 HOST=aarch64-linux-android
 OPTIMIZE_CFLAGS="-march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION=

elif [ $TARGET == 'x86_64' ]; then
 #x86_64
 CPU=x86-64
 ARCH=x86_64
 OPENSSL_ARCH="linux-x86_64 shared no-ssl2 no-ssl3 no-hw"
 HOST=x86_64-linux-android
 OPTIMIZE_CFLAGS="-fomit-frame-pointer -march=$CPU -Os -O3"
 LIBX264_FLAGS=
 ADDITIONAL_FFMPEG_CONFIGURATION=

elif [ $TARGET == 'x86' ]; then
 #x86
 CPU=i686
 ARCH=i686
 OPTIMIZE_CFLAGS="-fomit-frame-pointer -march=$CPU -Os -O3"
 HOST=i686-linux-android
 OPENSSL_ARCH="android shared no-ssl2 no-ssl3 no-hw "
 LIBX264_FLAGS="--disable-asm "
 #due https://github.com/android-ndk/ndk/issues/693
 ADDITIONAL_FFMPEG_CONFIGURATION="--disable-asm "


 
elif [ $TARGET == 'native' ]; then
HOST=
SYSROOT=/
CROSS_PREFIX=
CPU=x86-64
ARCH=native
OPTIMIZE_CFLAGS="-O2 -pipe -march=native"
ADDITIONAL_CONFIGURE_FLAG=
LIBX264_FLAGS=
OPENSSL_ARCH=linux-x86_64
else
echo "invalid target exiting..." 
exit 1
fi



build_one
