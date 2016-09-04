FROM centos:centos7
MAINTAINER Nick Travers <n.e.travers@gmail.com>

RUN yum update -y \
  && yum install -y git ant openjdk-8-jdk net-tools \
  && yum clean all

RUN mkdir /tmp/zookeeper
WORKDIR /tmp/zookeeper

RUN git clone https://github.com/apache/zookeeper.git .
RUN git checkout release-3.5.2
RUN ant jar

RUN cp /tmp/zookeeper/conf/zoo_sample.cfg /tmp/zookeeper/conf/zoo.cfg
RUN echo "standaloneEnabled=false" >> /tmp/zookeeper/conf/zoo.cfg
RUN echo "dynamicConfigFile=/tmp/zookeeper/conf/zoo.cfg.dynamic" >> /tmp/zookeeper/conf/zoo.cfg

ADD zk-init.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/zk-init.sh"]

EXPOSE 2181 2888 3888
