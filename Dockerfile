FROM postgres:latest

ENV POSTGRES_USER karmbruster
ENV POSTGRES_PASSWORD mypassword
ENV POSTGRES_DB mimic


WORKDIR /opt/workdir

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN git clone https://github.com/MIT-LCP/mimic-code.git
RUN chmod -R 775 mimic-code
RUN chown -R postgres mimic-code


COPY ./init-user-db.sh /docker-entrypoint-initdb.d/init-user-db.sh
RUN chmod -R 775 /docker-entrypoint-initdb.d/init-user-db.sh
RUN chown -R postgres /docker-entrypoint-initdb.d/init-user-db.sh


RUN chown -R postgres /opt/workdir
RUN chown -R postgres /var/lib/postgresql
RUN chmod -R 777 /var/lib/postgresql

EXPOSE 5432
# do not override original entrypoint

# SETUP INSTRUCTIONS
# docker build -t mimic-iii-postgresql .
# docker run --name mimic-iii-postgresql -p 5432:5432 -v /home/karmbruster/mimic-iii/postgresql_data:/var/lib/postgresql/data -v /home/karmbruster/mimic-iii/physionet.org:/opt/workdir/physionet.org -d mimic-iii-postgresql
