FROM centos:centos7

ENV NGINX_RPM=http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

COPY root /

# Install required packages and MariaDB Vendor Repo
RUN PACKAGES="epel-release python-setuptools MariaDB-server MariaDB-client" && \
    yum -y update && \
    yum -y install $PACKAGES && \
    yum clean all

# install nginx
RUN INSTALL_PKGS="nginx" && \
    rpm -ivh ${NGINX_RPM} && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

# set up supervisor
RUN easy_install supervisor && \
    chmod 666 /etc/supervisord.conf && \
    chmod +x /docker-entrypoint.sh

# MariaDB volume and go
VOLUME /var/lib/mysql
EXPOSE 3306 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld"]
