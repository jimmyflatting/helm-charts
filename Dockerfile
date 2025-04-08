FROM bitnami/minideb:bullseye

ARG DUCKDB_VERSION

RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl ca-certificates

RUN curl -L https://github.com/duckdb/duckdb/releases/download/v1.2.1/duckdb_cli-linux-amd64.zip -o duckdb.zip && \
    apt-get install -y unzip xdg-utils && \
    unzip duckdb.zip && \
    chmod +x duckdb && \
    mv duckdb /usr/local/bin/ && \
    rm duckdb.zip

# Create an entrypoint script that starts the UI server without browser opening
RUN echo '#!/bin/bash\n\
echo "Starting DuckDB UI server..."\n\
duckdb -c "CALL start_ui_server();"\n\
# Keep container running\n\
tail -f /dev/null' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

RUN duckdb --version

# Use the entrypoint script for container start
ENTRYPOINT ["/entrypoint.sh"]