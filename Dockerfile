FROM python:3.9-slim

WORKDIR /app

COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

# Add Microsoft GPG key (modern way)
RUN curl https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor > /usr/share/keyrings/microsoft.gpg

# Add Microsoft SQL Server repo (Debian 11)
RUN curl https://packages.microsoft.com/config/debian/11/prod.list \
    | tee /etc/apt/sources.list.d/mssql-release.list

# Install MS ODBC Driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Python deps (better caching)

RUN pip install --no-cache-dir -r requirements.txt



CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
