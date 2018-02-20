FROM centos:7
MAINTAINER dmnava@gmail.com

ARG HADOOP_VERSION=2.9.0

RUN yum update -y && yum clean all && \
 yum install -y java-1.8.0-openjdk \
 wget \
 net-tools \
 which

ENV JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk

RUN wget --quiet http://apache.rediris.es/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /tmp/hadoop.tgz \
 && tar xfz /tmp/hadoop.tgz -C /opt \
 && rm /tmp/hadoop.tgz

RUN ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
 && cp -R /opt/hadoop/etc/hadoop /etc 

COPY files/conf/* /etc/hadoop/
COPY files/env/hadoop.sh /etc/profile.d
COPY files/entrypoint.sh /
RUN mkdir -p /data/hadoop/dfs/name /data/hadoop/dfs/data /data/hadoop/mr-history/tmp /data/hadoop/mr-history/done \
 && chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

EXPOSE 8088 50010 50020 50070
VOLUME /data/hadoop /opt/hadoop/logs
