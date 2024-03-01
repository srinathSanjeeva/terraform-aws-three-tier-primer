# Use the official Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files to the working directory
COPY . .

# Expose the port that the application will run on
EXPOSE 3000

# Set environment variable for API_URL
ENV API_URL=https://jsonplaceholder.typicode.com/todos/1

# Start the application
CMD ["node", "app.js"]
