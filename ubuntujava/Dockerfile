FROM ubuntu:18.04

RUN apt-get update -y;apt-get install -y gnupg;echo deb http://ubuntu.adiscon.com/v7-devel precise/ >> /etc/apt/sources.list;echo deb-src http://ubuntu.adiscon.com/v7-devel precise/ >> /etc/apt/sources.list;apt-key adv --recv-keys --keyserver keyserver.ubuntu.com AEF0CF8E;apt-get update -y;apt-get upgrade -y;apt-get install -y rsyslog

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

RUN useradd user1 -m -s /bin/bash
WORKDIR /home/user1/
COPY ./id_rsa1.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user1.user1 .ssh/authorized_keys
RUN echo 'user1:r00tr00t' |chpasswd

#COPY ./init.sh /usr/local/bin/init.sh
#RUN chmod u+x /usr/local/bin/init.sh

#RUN apt-get install -y rsyslog

RUN apt-get install -y lsyncd git
COPY ./lsyncd.conf /etc/lsyncd.conf

# git setting
RUN mkdir /git
RUN git -C /git init
RUN git -C /git config user.name staff
RUN git -C /git config user.email staff@softiv.info

COPY ./git-commit.sh /git/git-commit.sh
RUN chmod 755 /git/git-commit.sh

COPY ./history.sh /etc/profile.d/
RUN chmod 644 /etc/profile.d/history.sh

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 22

CMD ["/sbin/init"]
#CMD ["/usr/local/bin/init.sh"]
