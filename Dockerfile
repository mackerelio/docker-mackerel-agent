FROM centos:7

# setup docker.repo
RUN yum -y install yum-utils \
  && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# setup mackerel-agent docker-engine
RUN curl -fsSL https://mackerel.io/file/script/amznlinux/setup-yum.sh | sed -r 's/sudo( -k)?//' | sh \
  && sed -i.bak 's/$releasever/latest/' /etc/yum.repos.d/mackerel.repo \
  && yum -y install mackerel-agent mackerel-agent-plugins mackerel-check-plugins \
  && yum -y install docker-ce docker-ce-cli containerd.io \
  && yum clean all

ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh

# boot mackerel-agent
CMD ["/startup.sh"]
