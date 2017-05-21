FROM lsiobase/alpine:3.5
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG MEDIAINF_VER="0.7.94"

# copy patches
COPY patches/ /defaults/patches/

# install runtime packages
RUN \
curl -o \
 /etc/apk/repositories -L \
	"https://github.com/drice82/docker-rutorrent/raw/master/files/repositories" && \
 apk add --no-cache \
	ca-certificates \
	curl \
	fcgi \
	ffmpeg \
	geoip \
	gzip \
	logrotate \
	nginx \
	php7 \
	php7-cgi \
	php7-session \
	php7-gd \
	php7-fpm \
	php7-json  \
	php7-mbstring \
	php7-pear \
	php7-mysqli \
	rtorrent==0.9.4-r1 \
	screen \
	tar \
	unrar \
	unzip \
	wget \
	findutils \
	zip && \
	
 ln -sf /usr/bin/php7 /usr/bin/php && \
 
# install build packages
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	cppunit-dev \
	curl-dev \
	file \
	g++ \
	gcc \
	libressl-dev \
	libtool \
	make \
	ncurses-dev && \

# install webui
 mkdir -p \
	/usr/share/webapps/rutorrent \
	/defaults/rutorrent-conf && \
 curl -o \
 /tmp/rutorrent.tar.gz -L \
	"https://github.com/Novik/ruTorrent/archive/master.tar.gz" && \
 tar xf \
 /tmp/rutorrent.tar.gz -C \
	/usr/share/webapps/rutorrent --strip-components=1 && \
 mv /usr/share/webapps/rutorrent/conf/* \
	/defaults/rutorrent-conf/ && \
 rm -rf \
	/defaults/rutorrent-conf/users && \
	
# install filemanager
 curl -o \
 /tmp/filemanager.tar.gz -L \
	"https://github.com/drice82/docker-rutorrent/raw/master/files/filemanager.tar.gz" && \
tar xf \
/tmp/filemanager.tar.gz -L \
	/usr/share/webapps/rutorrent/plugins --strip-components=1 && \

# install h5ai
 curl -o \
 /tmp/ -L \
	"https://release.larsjung.de/h5ai/h5ai-0.29.0.zip" && \
unzip \
/tmp/h5ai-0.29.0.zip && \
mv /tmp/_h5ai /usr/share/webapps && \

# patch snoopy.inc for rss fix
 cd /usr/share/webapps/rutorrent/php && \
 patch < /defaults/patches/snoopy.patch && \

# compile mediainfo packages
 curl -o \
 /tmp/libmediainfo.tar.gz -L \
	"http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINF_VER}/MediaInfo_DLL_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 curl -o \
 /tmp/mediainfo.tar.gz -L \
	"http://mediaarea.net/download/binary/mediainfo/${MEDIAINF_VER}/MediaInfo_CLI_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 mkdir -p \
	/tmp/libmediainfo \
	/tmp/mediainfo && \
 tar xf /tmp/libmediainfo.tar.gz -C \
	/tmp/libmediainfo --strip-components=1 && \
 tar xf /tmp/mediainfo.tar.gz -C \
	/tmp/mediainfo --strip-components=1 && \

 cd /tmp/libmediainfo && \
	./SO_Compile.sh && \
 cd /tmp/libmediainfo/ZenLib/Project/GNU/Library && \
	make install && \
 cd /tmp/libmediainfo/MediaInfoLib/Project/GNU/Library && \
	make install && \
 cd /tmp/mediainfo && \
	./CLI_Compile.sh && \
 cd /tmp/mediainfo/MediaInfo/Project/GNU/CLI && \
	make install && \
	
ln -sv /downloads /var/www/localhost && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/etc/nginx/conf.d/default.conf \
	/tmp/* && \

# fix logrotate
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf

# add local files
COPY root/ /
COPY web/ /var/www/localhost
# ports and volumes
EXPOSE 80
VOLUME /config /downloads
