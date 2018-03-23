# This file is a template, and might need editing before it works on your project.
FROM tomcat:8.5-jre8-alpine

RUN apk add --no-cache \               
                vim  \
                mkfontscale \
                mkfontdir
         
                

RUN mkdir /usr/local/tomcat/dump/
RUN touch /usr/local/tomcat/dump/oom.hprof

RUN rm -rf /usr/local/tomcat/webapps/host-manager/META-INF/context.xml \
    && rm -f /usr/local/tomcat/webapps/manager/META-INF/context.xml \
    && rm -f /usr/local/tomcat/conf/tomcat-users.xml \
    && rm -f /usr/local/tomcat/conf/server.xml \
    && rm -f /usr/local/tomcat/bin/catalina.sh
    
ADD ./catalina.sh /usr/local/tomcat/bin/catalina.sh
ADD ./server.xml /usr/local/tomcat/conf/server.xml
ADD ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
ADD ./host-manager-context.xml /usr/local/tomcat/webapps/host-manager/META-INF/context.xml 
ADD ./manager-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
ADD ./manager-web.xml /usr/local/tomcat/webapps/manager/WEB-INF/web.xml

COPY ./Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone
RUN chmod +x /usr/local/tomcat/bin/catalina.sh
EXPOSE 8080

CMD ["/usr/local/tomcat/bin/catalina.sh","run"]
