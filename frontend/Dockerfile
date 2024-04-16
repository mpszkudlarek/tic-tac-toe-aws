# Use Node.js v16 as the base image
FROM node:16

# Set the working directory in the container to /frontend
WORKDIR /frontend

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install -g http-server && which http-server

# Copy the rest of the application code to the working directory
COPY . .

# Build the app for production with minification
RUN npm run build

# Expose port 8080
EXPOSE 8080

# Serve the app using http-server at port 8080
CMD ["http-server", "dist"]

