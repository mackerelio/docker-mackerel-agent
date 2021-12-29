FROM debian:buster-slim

# setup tools
RUN apt-get update \
  && apt-get install -y sudo ca-certificates curl gnupg2 lsb-release \
  && rm -rf /var/lib/apt/lists/*

# setup mackerel-agent repo
RUN curl -fsSL  https://mackerel.io/file/script/setup-apt-v2.sh | sh

# setup docker repo
# ref: https://docs.docker.com/engine/install/debian/
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# setup mackerel-agent and docker
RUN apt-get update \
  && apt-get install -y mackerel-agent mackerel-agent-plugins mackerel-check-plugins \
  && apt-get install -y docker-ce docker-ce-cli containerd.io \
  && rm -rf /var/lib/apt/lists/*

COPY startup.sh /startup.sh
RUN chmod 755 /startup.sh

# boot mackerel-agent
CMD ["/startup.sh"]
