# This file is a template, and might need editing before it works on your project.
# This file is a template, and might need editing before it works on your project.
FROM tomcat:8.5-jre8-alpine

RUN apk add --no-cache \
                unzip \
                vim  \
                mkfontscale \
               mkfontdir \
               fontconfig  

RUN mkdir /usr/local/tomcat/dump/
RUN touch /usr/local/tomcat/dump/oom.hprof
    
ADD ./catalina.sh /usr/local/tomcat/bin/catalina.sh
ADD ./server.xml /usr/local/tomcat/conf/server.xml
ADD ./web.xml /usr/local/tomcat/conf/web.xml

ADD ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD ./host-manager-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml 
ADD ./manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
ADD ./manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

COPY ./Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
RUN chmod +x /usr/local/tomcat/bin/catalina.sh

EXPOSE 8080

CMD ["catalina.sh","run"]
