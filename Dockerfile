# Use the official Node.js image as the base image
FROM node:22.2-alpine3.19

# Expose the port the app runs on
EXPOSE 3000

# Set the working directory in the container
WORKDIR /express-sample-app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Start the application
CMD ["node", "examples/hello-world"]
