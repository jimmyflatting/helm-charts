# Use Python slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install curl and netstat for healthcheck and debugging
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY duckdb-image/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create a non-root user
RUN useradd -m -u 1000 duckdb && \
    chown -R duckdb:duckdb /app

# Switch to non-root user
USER duckdb

# Create a script to initialize DuckDB
COPY --chown=duckdb:duckdb duckdb-image/main.py /app/init.py

# Expose the DuckDB UI server port
EXPOSE 4213

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DOCKER_DEFAULT_IPV4=1
ENV DUCKDB_UI_HOST=0.0.0.0

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4213/ || exit 1

# Run the initialization script
CMD ["python", "/app/init.py"]