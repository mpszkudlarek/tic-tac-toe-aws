# Use Python 3.8 slim image from Docker Hub as the base image
FROM python:3.8-slim

# Set the working directory to /backend
WORKDIR /backend

# Copy the application's requirements file and install dependencies
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Copy the rest of your application's code
COPY . .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# The command to run the application using Gunicorn
CMD ["gunicorn", "-w", "4", "-b", ":5000", "wsgi:app"]
