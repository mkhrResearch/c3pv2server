FROM centos:6

RUN yum update -y
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-devel

RUN yum install -y openssh-server rsyslog
#sshd setting
RUN sed -i -e "s/#MaxStartups 10:30:100/MaxStartups 10:30:100/g" /etc/ssh/sshd_config
RUN sed -i -e "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
RUN sed -i -e "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

#add ssh user
ADD ./id_rsa1.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/authorized_keys


RUN useradd user1 -m
WORKDIR /home/user1/
COPY ./id_rsa1.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user1.user1 .ssh/authorized_keys

RUN useradd user2 -m
WORKDIR /home/user2/
COPY ./id_rsa2.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user2.user2 .ssh/authorized_keys

RUN useradd user3 -m
WORKDIR /home/user3/
COPY ./id_rsa3.pub .ssh/authorized_keys
RUN chmod 600 .ssh/authorized_keys
RUN chown user3.user3 .ssh/authorized_keys

COPY ./history.sh /etc/profile.d/

# script command setting
RUN mkdir /var/log/script/
RUN chmod 773 /var/log/script
COPY ./script.sh /etc/profile.d/
RUN chmod 644 /etc/profile.d/script.sh

WORKDIR /root/
# git install
RUN yum install -y wget gcc curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker
RUN wget https://www.kernel.org/pub/software/scm/git/git-2.2.0.tar.gz && tar -zxf git-2.2.0.tar.gz && cd git-2.2.0 && make prefix=/usr/local all && make prefix=/usr/local install

# lsyncd setting
RUN wget ftp://ftp.riken.jp/Linux/fedora/epel/6/x86_64/Packages/e/epel-release-6-8.noarch.rpm
RUN rpm -ivh ./epel-release-6-8.noarch.rpm
RUN yum install --enablerepo=epel lsyncd -y
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

COPY ./init.sh /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/init.sh

COPY ./ace /usr/local/bin/ace
RUN chmod 755 /usr/local/bin/ace

WORKDIR /root/data/
RUN cp -a /var/log/ /root/data/
RUN cp -a /home/ /root/data/
RUN cp -a /git/ /root/data/

CMD ["/usr/local/bin/init.sh"]
