FROM centos
MAINTAINER "Eder Brendo" <eder.brendo@gmail.com>

RUN yum update -y
RUN yum install openssh net-tools wget vim ntsysv nano initscripts -y
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
RUN rpm -Uvh jdk-8u131-linux-x64.rpm
RUN alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 200000 
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000
RUN alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 200000
RUN wget http://download.jboss.org/wildfly/10.1.0.Final/wildfly-10.1.0.Final.tar.gz
RUN tar zxvf wildfly-10.1.0.Final.tar.gz
RUN mv wildfly-10.1.0.Final wildfly
RUN mv wildfly /opt
RUN groupadd wildfly
RUN adduser -g wildfly wildfly
RUN chown wildfly.wildfly -R /opt/wildfly*
RUN cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly.conf /etc/default/
RUN cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly

COPY wildfly.conf /etc/default/wildfly.conf
COPY host-slave.xml /opt/wildfly/domain/configuration/host-slave.xml

RUN mkdir -p /opt/wildfly/modules/org/postgres/main

COPY module.xml /opt/wildfly/modules/org/postgres/main/module.xml
COPY postgresql-9.4-1201-jdbc41.jar /opt/wildfly/modules/org/postgres/main/postgresql-9.4-1201-jdbc41.jar

RUN systemctl enable wildfly.service


ENTRYPOINT ["/sbin/init"]
