FROM ubuntu:23.04

RUN apt update

RUN apt install default-jdk default-jre -y
RUN apt install openssh-server openssh-client -y
RUN apt install sudo -y

RUN adduser hadoop
RUN usermod -aG sudo hadoop

USER hadoop
WORKDIR /home/hadoop

RUN wget https://downloads.apache.org/hadoop/common/stable/hadoop-3.3.4.tar.gz
RUN wget https://dlcdn.apache.org/flink/flink-1.16.0/flink-1.16.0-bin-scala_2.12.tgz
RUN tar -xvzf hadoop-3.3.4.tar.gz
RUN tar -xvzf flink-1.16.0-bin-scala_2.12.tgz

USER root
RUN mv hadoop-3.3.4 /usr/local/hadoop
RUN mv flink-1.16.0 /opt/
RUN mkdir /usr/local/hadoop/logs
RUN chown -R hadoop:hadoop /usr/local/hadoop
RUN chown -R hadoop:hadoop /opt/flink-1.16.0

RUN wget https://repo1.maven.org/maven2/javax/activation/javax.activation-api/1.2.0/javax.activation-api-1.2.0.jar -P /usr/local/hadoop/lib
RUN mkdir -p /home/hadoop/hdfs/{namenode,datanode}
RUN chown -R hadoop:hadoop /home/hadoop/hdfs
COPY ./script/start-hadoop.sh /home/hadoop/start-hadoop.sh
RUN chmod 777 /home/hadoop/start-hadoop.sh
RUN echo 'hadoop ALL = NOPASSWD: /etc/init.d/ssh start' >> /etc/sudoers
RUN wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-flink-runtime-1.14/0.14.1/iceberg-flink-runtime-1.14-0.14.1.jar -P /opt/flink-1.16.0/lib
RUN wget https://repo1.maven.org/maven2/com/ververica/flink-sql-connector-postgres-cdc/2.3.0/flink-sql-connector-postgres-cdc-2.3.0.jar -P /opt/flink-1.16.0/lib

USER hadoop

RUN echo 'export HADOOP_HOME=/usr/local/hadoop' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_INSTALL=$HADOOP_HOME' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >> /home/hadoop/.bashrc
RUN echo 'export YARN_HOME=$HADOOP_HOME' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >> /home/hadoop/.bashrc
RUN echo 'export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"' >> /home/hadoop/.bashrc
RUN echo 'export HADOOP_CLASSPATH=`$HADOOP_HOME/bin/hadoop classpath`' >> /home/hadoop/.bashrc

RUN echo 'export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")' >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_CLASSPATH+=" $HADOOP_HOME/lib/*.jar"' >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

COPY ./config/*.xml /usr/local/hadoop/etc/hadoop/

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "/bin/bash" ]