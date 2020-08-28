FROM tomcat:9.0.19-jre8-alpine

RUN apk add --no-cache \               
                unzip \
                vim  \
                wget \
               ttf-dejavu \
               fontconfig \
              && rm -rf /var/cache/apk/*

ADD ./server.xml /usr/local/tomcat/conf/server.xml
ADD ./web.xml /usr/local/tomcat/conf/web.xml

ADD ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD ./host-manager-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml 
ADD ./manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
ADD ./manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

COPY ./Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone


EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
