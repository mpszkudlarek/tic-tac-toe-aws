# Use an official Node.js runtime as a parent image
FROM node:16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json into the container at /app
COPY package*.json ./

# Install all dependencies
RUN npm install

# Copy the current directory contents into the current directory in the container
COPY . .

# Expose port 8080 to the world outside this container
EXPOSE 8080

# Command to run the app
CMD ["npm", "run", "serve"]
