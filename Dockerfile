FROM bitnami/minideb:bullseye

ARG DUCKDB_VERSION

RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl ca-certificates

RUN curl -L https://github.com/duckdb/duckdb/releases/download/v1.2.1/duckdb_cli-linux-amd64.zip -o duckdb.zip && \
    apt-get install -y unzip && \
    unzip duckdb.zip && \
    chmod +x duckdb && \
    mv duckdb /usr/local/bin/ && \
    rm duckdb.zip

RUN duckdb --version

CMD ["duckdb", "-ui"]