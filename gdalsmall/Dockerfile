# Build final image
FROM alpine:latest as runner

RUN date

RUN apk add --no-cache \
        libstdc++ \
        sqlite-libs \
        libcurl \
        zlib zstd-libs\
        libjpeg-turbo libpng openjpeg libwebp expat libpq \
        java-gdal \
    # libturbojpeg.so is not used by GDAL. Only libjpeg.so*
    && rm -f /usr/lib/libturbojpeg.so* \
    # Only libwebp.so is used by GDAL
    && rm -f /usr/lib/libwebpmux.so* /usr/lib/libwebpdemux.so* /usr/lib/libwebpdecoder.so*
    
# openjdk
COPY --from=openjdk:8-alpine  /usr/lib/jvm/java-1.8-openjdk/ /usr/lib/jvm/java-1.8-openjdk/
ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=$PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION=8u212
ENV JAVA_ALPINE_VERSION=8.212.04-r0
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64:/usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/server

RUN cp /usr/share/java/*.jar /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/

# Jackcess for mdb
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/jackcess-1.2.8.jar  \
	https://repo1.maven.org/maven2/com/healthmarketscience/jackcess/jackcess/1.2.8/jackcess-1.2.8.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-lang-2.4.jar  \
    https://repo1.maven.org/maven2/commons-lang/commons-lang/2.4/commons-lang-2.4.jar
RUN wget -O /usr/lib/jvm/java-1.8-openjdk/jre/lib/ext/commons-logging-1.1.1.jar  \
    https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.1/commons-logging-1.1.1.jar

ENV CATALINA_HOME=/usr/local/tomcat
ENV TOMCAT_NATIVE_LIBDIR=/usr/local/tomcat/native-jni-lib
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/local/tomcat/native-jni-lib
ENV PATH=$PATH:$CATALINA_HOME/bin

RUN mkdir -p /usr/local/tomcat
COPY --from=tomcat:8.5-jre8-alpine  /usr/local/tomcat/ /usr/local/tomcat/
COPY --from=tomcat:8.5-jre8-alpine /usr/lib/* /usr/lib/

RUN apk add --no-cache \
                unzip \
                vim  \
                wget \
                ttf-dejavu \
                fontconfig \
                ca-certificates \           
                && rm -rf /var/cache/apk/*

ADD ./server.xml /usr/local/tomcat/conf/server.xml
ADD ./web.xml /usr/local/tomcat/conf/web.xml
ADD ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD ./host-manager-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml
ADD ./manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
ADD ./manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml
ADD ./setenv.sh /usr/local/tomcat/bin/setenv.sh

COPY ./Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone

RUN chmod +x /usr/local/tomcat/bin/catalina.sh
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

WORKDIR /usr/local/tomcat

EXPOSE 8080

CMD ["/bin/sh","/usr/local/tomcat/bin/catalina.sh","run"]
