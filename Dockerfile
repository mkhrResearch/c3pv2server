FROM centos:7

RUN yum update -y

WORKDIR /root/
# git install
RUN yum -y install gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker autoconf wget make
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
RUN tar vfx git-2.9.5.tar.gz;cd git-2.9.5;make configure;./configure --prefix=/usr;make all;make install

RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

RUN yum install -y openssh-server rsyslog

# lsyncd install
RUN yum install -y epel-release
RUN sed -i -e "s/enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo
RUN yum --enablerepo=epel install -y lsyncd
RUN systemctl enable lsyncd.service

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

COPY ./lsyncd.conf /etc/lsyncd.conf

#sshd setting
RUN sed -i -e "s/#MaxStartups 10:30:100/MaxStartups 10:30:100/g" /etc/ssh/sshd_config
RUN sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
RUN sed -i -e "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

COPY ./history.sh /etc/profile.d/

# script command setting
RUN mkdir /var/log/script/
RUN chmod 773 /var/log/script
COPY ./script.sh /etc/profile.d/
RUN chmod 644 /etc/profile.d/script.sh

# git setting
RUN mkdir /git
RUN git -C /git init
RUN git -C /git config user.name staff
RUN git -C /git config user.email staff@softiv.info

COPY ./git-commit.sh /git/git-commit.sh
RUN chmod 755 /git/git-commit.sh

COPY ./history.sh /etc/profile.d/
RUN chmod 644 /etc/profile.d/history.sh

RUN echo "export LANG=ja_JP.UTF-8" > /etc/profile.d/setlang.sh
RUN chmod 644 /etc/profile.d/setlang.sh

COPY ./init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh

COPY ./ace /usr/local/bin/ace
RUN chmod 755 /usr/local/bin/ace


RUN yum -y reinstall glibc-common
RUN localedef -v -c -i ja_JP -f UTF-8 ja_JP.UTF-8; echo "";
ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

#add ssh user
ADD ./id_rsa1.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/authorized_keys


RUN useradd user1 -m
WORKDIR /home/user1/
COPY ./id_rsa1.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user1.user1 .ssh/authorized_keys
# RUN echo "export LANG=ja_JP.UTF-8" >> .bashrc

RUN useradd user2 -m
WORKDIR /home/user2/
COPY ./id_rsa2.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user2.user2 .ssh/authorized_keys
#RUN echo "export LANG=ja_JP.UTF-8" >> .bashrc

RUN useradd user3 -m
WORKDIR /home/user3/
COPY ./id_rsa3.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user3.user3 .ssh/authorized_keys
#RUN echo "export LANG=ja_JP.UTF-8" >> .bashrc

WORKDIR /root/data/
RUN cp -a /var/log/ /root/data/
RUN cp -a /home/ /root/data/
RUN cp -a /git/ /root/data/

CMD ["/usr/local/bin/init.sh"]
#CMD ["/sbin/init"]
