#!/bin/bash
ARCH=`uname -m `
rm -Rf ffmpeg-build-temp
mkdir ffmpeg-build-temp
cd ffmpeg-build-temp

echo "--- Install Development tools ---"
yum -y groupinstall "Development Tools" >> devtools-install.log
echo "--- Install Utilities ---"
yum -y install git wget epel-release >> utilities-install.log
echo "--- Add ATRPMS repository ---"
rpm --import http://packages.atrpms.net/RPM-GPG-KEY.atrpms
if [ $ARCH='x86_64' ];
then
	rpm --install http://dl.atrpms.net/all/atrpms-repo-6-5.el6.x86_64.rpm
else
	rpm --install http://dl.atrpms.net/all/atrpms-repo-6-5.el6.i686.rpm
fi
echo "--- Install dependencies ---"
yum -y install yasm dirac-devel schroedinger-devel faac-devel freetype-devel gsm-devel lame-devel openjpeg-devel pulseaudio-libs-devel rtmpdump-devel speex-devel libtheora-devel libvorbis x264-devel xavs-devel xvidcore-devel openal-soft-devel openssl-devel zlib-devel libopencore-amrnb0 libopencore-amrwb0 opencore-amr-devel libvorbis-devel >> dependencies-install.log
echo "Remove ffmpeg-build-temp for clean build"
echo "--- Install libaacplus ---"
wget http://217.20.164.161/~tipok/aacplus/libaacplus-2.0.2.tar.gz >> libaacplus-install.log
tar -xzf libaacplus-2.0.2.tar.gz
cd libaacplus-2.0.2
./autogen.sh  >> ../libaacplus-install.log
./configure  >> ../libaacplus-install.log
make >> ../libaacplus-install.log
make install >> ../libaacplus-install.log
cd ..

echo "--- Install libvpx WebM support ---"
git clone http://git.chromium.org/webm/libvpx.git >> libvpx-install.log
cd libvpx
./configure --enable-shared --enable-pic  >> ../libvpx-install.log
make >> ../libvpx-install.log
make install >> ../libvpx-install.log
cd ..
echo "--- Install ffmpeg ---"
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg >> ffmpeg-install.log

cd ffmpeg
./configure --enable-shared --enable-gpl --enable-nonfree --enable-version3 --enable-bzlib --enable-libaacplus --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libdirac --enable-libfaac --enable-libfreetype --enable-libgsm --enable-libmp3lame --enable-libopenjpeg --enable-libpulse --enable-librtmp --enable-libschroedinger --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxavs --enable-libxvid --enable-openal --enable-openssl --enable-zlib >> ../ffmpeg-install.log
make >> ../ffmpeg-install.log
make install >> ../ffmpeg-install.log
echo "/usr/local/lib" > /etc/ld.so.conf.d/ffmpeg-build.conf
ldconfig
