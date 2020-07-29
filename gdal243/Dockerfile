FROM soxueren/busybox-gdal:2.4.3

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
