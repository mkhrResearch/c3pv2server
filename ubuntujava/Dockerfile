FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:r00tr00t' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#RUN mkdir /root/.ssh

#add ssh user
ADD ./id_rsa1.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/authorized_keys

RUN useradd user1 -m
WORKDIR /home/user1/
COPY ./id_rsa1.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user1.user1 .ssh/authorized_keys

#COPY ./init.sh /usr/local/bin/init.sh
#RUN chmod u+x /usr/local/bin/init.sh

#RUN apt-get install -y rsyslog

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 22

CMD ["/sbin/init"]
#CMD ["/usr/local/bin/init.sh"]
