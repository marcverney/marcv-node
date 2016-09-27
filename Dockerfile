FROM node

MAINTAINER Marc Verney <marc@marcverney.net>

RUN apt-get update && apt-get install -y \
    wget

# Install Grunt
RUN npm install -g grunt-cli jspm

# Install Gosu
RUN GOSU_VERSION=1.9 \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Define run-as-user.sh as entrypoint
COPY run-as-user.sh /usr/local/bin/run-as-user.sh
RUN chmod +x /usr/local/bin/run-as-user.sh
ENTRYPOINT ["/usr/local/bin/run-as-user.sh"]

# Create the working directory
RUN mkdir /project \
    && chmod 777 /project
WORKDIR /project

# Command
CMD ["--version"]