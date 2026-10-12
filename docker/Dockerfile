FROM postgres:16-alpine

ENV POSTGRES_DB=dierenverzekering
ENV POSTGRES_USER=insurance_admin
ENV POSTGRES_PASSWORD=paws2024

COPY init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 5432
