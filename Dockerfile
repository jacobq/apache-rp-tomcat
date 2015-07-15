FROM tomcat:8-jre7
MAINTAINER Jacob Quant <jacobq@gmail.com>

ENV APACHE_HTTPD_VERSION 2.4.12
ENV BUILD_PATH /root
ENV PREFIX /usr/local/apache2

# Install build tools  
RUN apt-get update && \
    apt-get install -yq gcc make libpcre3-dev libssl-dev file

# Download & extract apache httpd sources
# http://apache.mirrors.pair.com/httpd/httpd-${APACHE_HTTPD_VERSION}.tar.gz
RUN cd $BUILD_PATH && \
    wget -q https://archive.apache.org/dist/httpd/httpd-${APACHE_HTTPD_VERSION}.tar.gz && \
    wget -q https://archive.apache.org/dist/httpd/httpd-${APACHE_HTTPD_VERSION}-deps.tar.gz && \
    wget -qO- https://archive.apache.org/dist/httpd/httpd-${APACHE_HTTPD_VERSION}.tar.gz.md5 | md5sum -c - && \
    wget -qO- https://archive.apache.org/dist/httpd/httpd-${APACHE_HTTPD_VERSION}-deps.tar.gz.md5 | md5sum -c - && \
    for file in httpd-*.tar.gz; do tar -zxf $file; done && \
    rm httpd-*.tar.*

# Configure & compile Apache httpd
RUN cd $BUILD_PATH/httpd-${APACHE_HTTPD_VERSION} && \
    ./configure --prefix=$PREFIX \
      --enable-so \
      --enable-mods-shared="all ssl cache proxy authn_alias mem_cache file_cache charset_lite dav_lock disk_cache" && \
    make && make install

# Include customized configuration files
ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD custom-rewrite-rules.conf /usr/local/apache2/conf/custom-rewrite-rules.conf

# Include customized start-up script
ADD run_server.sh /opt/run_server.sh
RUN chmod +x /opt/run_server.sh

# Uninstall build tools, remove source code, and clean-up
RUN apt-get remove -yq gcc make libpcre3-dev libssl-dev file && \
   rm -rf $BUILD_PATH/http-${APACHE_HTTPD_VERSION} \
   rm -rf /var/lib/apt/lists/* && \
   apt-get clean autoclean && \
   apt-get autoremove -y && \
   rm -rf /var/lib/{apt,dpkg,cache,log}

WORKDIR /usr/local/apache2

EXPOSE 80
EXPOSE 443

CMD ["/opt/run_server.sh"]