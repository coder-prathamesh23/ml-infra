FROM python:3.9-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gdal-bin \
        libgdal-dev \
        libspatialindex-dev \
        libpq-dev \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ml/code

COPY requirements39.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements39.txt


ENV SAGEMAKER_SUBMIT_DIRECTORY=/opt/ml/code

CMD ["python3"]
