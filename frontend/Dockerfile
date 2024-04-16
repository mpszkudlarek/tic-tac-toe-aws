FROM node:16

RUN npm install -g http-server

# Set the working directory in the container
WORKDIR /frontend

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

RUN npm run build
# Expose port 8080
EXPOSE 8080

# Run the start script defined in package.json
CMD [ "http-server", "dist" ]

