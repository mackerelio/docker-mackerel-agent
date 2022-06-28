FROM debian:buster-slim

# setup tools
RUN apt-get update \
  && apt-get install -y sudo ca-certificates curl gnupg2 lsb-release net-tools \
  && rm -rf /var/lib/apt/lists/*

# setup mackerel-agent repo
RUN curl -fsSL  https://mackerel.io/file/script/setup-apt-v2.sh | sh

# setup mackerel-agent
RUN apt-get update \
  && apt-get install -y mackerel-agent mackerel-agent-plugins mackerel-check-plugins \
  && rm -rf /var/lib/apt/lists/*

COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

# boot mackerel-agent
CMD ["/startup.sh"]
