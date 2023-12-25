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

# Run app.py when the container launches
CMD python manage.py runserver 0.0.0.0:80