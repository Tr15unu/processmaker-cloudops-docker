# Base Image
FROM amazonlinux:2018.03
CMD ["/bin/bash"]

# Maintainer
MAINTAINER ProcessMaker CloudOps <cloudops@processmaker.com>

# Extra
LABEL version="3.3.8"
LABEL description="ProcessMaker 3.3.8 Docker Container."

# Initial steps
RUN yum clean all && yum install epel-release -y && yum update -y
RUN cp /etc/hosts ~/hosts.new && sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new && cp -f ~/hosts.new /etc/hosts

# Required packages
RUN yum install \
  wget \
  nano \
  sendmail \
  nginx \
  php71-fpm \
  php71-opcache \
  php71-gd \
  php71-mysqlnd \
  php71-soap \
  php71-mbstring \
  php71-ldap \
  php71-mcrypt \
  -y
  
# Download ProcessMaker Enterprise Edition
RUN wget -O "/tmp/processmaker-3.3.8.tar.gz" \
      "https://artifacts.processmaker.net/official/processmaker-3.3.8.tar.gz"
	  
# Copy configuration files
COPY processmaker-fpm.conf /etc/php-fpm.d
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bk
COPY nginx.conf /etc/nginx
COPY processmaker.conf /etc/nginx/conf.d

# NGINX Ports
EXPOSE 80

# Docker entrypoint
COPY docker-entrypoint.sh /bin/
RUN chmod a+x /bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
