FROM centos:6

RUN yum -y install wget
RUN wget -O /etc/yum.repos.d/home:kamailio:v4.4.x-rpms.repo http://download.opensuse.org/repositories/home:/kamailio:/v4.4.x-rpms/CentOS_6/home:kamailio:v4.4.x-rpms.repo
RUN yum -y update
RUN yum install -y kamailio kamailio-debuginfo kamailio-utils gdb kamailio-sqlite

WORKDIR /etc/kamailio/

RUN echo "DBENGINE=SQLITE" >> kamctlrc
RUN echo "DBHOST=localhost" >> kamctlrc
RUN echo "DB_PATH="/usr/local/etc/kamailio/kamailio.sqlite"" >> kamctlrc
RUN echo "INSTALL_EXTRA_TABLES=no" >> kamctlrc
RUN echo "INSTALL_PRESENCE_TABLES=no" >> kamctlrc
RUN echo "INSTALL_DBUID_TABLES=no" >> kamctlrc

RUN mkdir /usr/local/etc/kamailio
RUN touch /usr/local/etc/kamailio/kamailio.sqlite

RUN /usr/sbin/kamdbctl create

RUN kamctl add 1000@dopensource.com opensourceisneat

EXPOSE 5060/udp

CMD ["/usr/sbin/kamailio", "-m 64", "-M 8", "-D"]
