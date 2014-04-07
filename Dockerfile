# Postgresql (http://www.postgresql.org/)

FROM phusion/baseimage
MAINTAINER Ryan Seto <ryanseto@yak.net>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > \
        /etc/apt/sources.list

# Ensure UTF-8
RUN locale-gen        en_US.UTF-8
ENV LANG              en_US.UTF-8
ENV LC_ALL            en_US.UTF-8
ENV DEBIAN_FRONTEND   noninteractive

# Add the PostgreSQL PGP key to verify their Debian packages.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8

# Install the latest postgresql
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > \
        /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y --force-yes postgresql-9.3 postgresql-client-9.3 \
        postgresql-contrib-9.3 pwgen inotify-tools

RUN apt-get install -y pwgen

VOLUME ["/data"]

# Cofigure the database to use our data dir.
RUN sed -i -e "s/data_directory =.*$/data_directory = '\/data'/" \
        /etc/postgresql/9.3/main/postgresql.conf

# Allow connections from anywhere.
# Allow connections from anywhere.
RUN sed -i -e"s/^#listen_addresses =.*$/listen_addresses = '*'/" /etc/postgresql/9.3/main/postgresql.conf
RUN echo "host    all    all    0.0.0.0/0    md5" >> /etc/postgresql/9.3/main/pg_hba.conf

EXPOSE 5432
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun

ENTRYPOINT ["/scripts/start.sh"]
