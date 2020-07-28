FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y default-jdk 
RUN apt-get install -y git 
RUN apt-get install -y maven 
RUN apt-get install -y wget

RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /webserver/tomcat tomcat

WORKDIR /tmp/
RUN wget https://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-8/v8.5.57/bin/apache-tomcat-8.5.57.tar.gz
WORKDIR /webserver/tomcat/
RUN tar xzvf /tmp/apache-tomcat-8.5.57.tar.gz -C /webserver/tomcat --strip-components=1
WORKDIR /webserver/tomcat/
RUN chgrp -R tomcat /webserver/tomcat
RUN chmod -R g+r conf
RUN chmod g+x conf
RUN chown -R tomcat webapps/ work/ temp/ logs/

RUN mkdir -p /home/ubuntu/build
WORKDIR /home/ubuntu/build/
RUN git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
WORKDIR /home/ubuntu/build/boxfuse-sample-java-war-hello/
RUN mvn package

RUN cp /home/ubuntu/build/boxfuse-sample-java-war-hello/target/hello-1.0.war /webserver/tomcat/webapps/hello.war

EXPOSE 8080
CMD ["/webserver/tomcat/bin/catalina.sh", "run"]

