FROM python:3.9-slim-bullseye

WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    unixodbc \
    unixodbc-dev

# Import Microsoft public key
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Add Microsoft SQL Server repo
RUN curl -fsSL https://packages.microsoft.com/config/debian/11/prod.list \
    -o /etc/apt/sources.list.d/mssql-release.list

# Install msodbcsql17
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt



CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
