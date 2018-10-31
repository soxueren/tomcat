# This file is a template, and might need editing before it works on your project.
FROM tomcat:8.5-jre8-slim

# 安装gdal相关库
RUN  apt-get update && apt-get install -y --no-install-recommends \  
         vim  \        
         unzip \
	 wget  \	
         gdal-bin \	
         libgdal-dev \
	 netcdf-bin \
         libnetcdf-dev \         
         python-gdal  \	 
	&& rm -rf /var/lib/apt/lists/*
	
RUN wget http://ftp.debian.org/debian/pool/main/f/fontconfig/fontconfig_2.11.0-6.3+deb8u1_amd64.deb  -O ~/fontconfig_2.11.0-6.3+deb8u1_amd64.deb && \
    dpkg -i ~/fontconfig_2.11.0-6.3+deb8u1_amd64.deb && \
    rm ~/fontconfig_2.11.0-6.3+deb8u1_amd64.deb

# add fonts
#ADD fontxp.zip /usr/share/fonts/

# cache fonts
RUN dpkg-reconfigure fontconfig-config && \
        dpkg-reconfigure fontconfig && \
        fc-cache -fv
    
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
