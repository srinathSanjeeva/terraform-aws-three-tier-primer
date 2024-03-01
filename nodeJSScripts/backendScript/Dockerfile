# Use an official Node.js runtime as a base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the application code to the working directory
COPY . .

# Expose a port that the app will listen on
EXPOSE 3000

# Define environment variable with a default value
ENV DB_HOST=production
ENV DB_USER=user
ENV DB_PASSWORD=adc6308831d
ENV DB_NAME=default

# Define the command to run your app
CMD ["node", "app.js"]
