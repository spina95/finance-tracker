FROM python:3.9
ENV PYTHONUNBUFFERED 1
# Set the working directory to /app

WORKDIR /app

# copy the requirements file used for dependencies
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
    
# Copy the rest of the working directory contents into the container at /app
COPY . .

# Install cockroach db certificate
RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales curl \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN curl --create-dirs -o /home/.postgresql/root.crt -O https://cockroachlabs.cloud/clusters/e710e5ea-2848-4254-b178-00069b47d975/cert

# Run app.py when the container launches
CMD python manage.py runserver 0.0.0.0:80