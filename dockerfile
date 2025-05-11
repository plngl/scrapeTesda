# Use an official Node.js runtime as a parent image
FROM node:16

# Install dependencies required for running Playwright in a headless environment
RUN apt-get update && apt-get install -y \
  libgtk-4-1 \
  libgraphene-1.0-0 \
  libgstgl-1.0-0 \
  libgstcodecparsers-1.0-0 \
  libavif.so.15 \
  libenchant-2-2 \
  libsecret-1-0 \
  libmanette-0.2-0 \
  libgles2 \
  wget \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libnspr4 \
  libnss3 \
  xdg-utils \
  && apt-get clean

# Create and set working directory
WORKDIR /app

# Copy the package.json and package-lock.json (if exists)
COPY package*.json ./

# Install app dependencies
RUN npm install

# Install Playwright dependencies
RUN npx playwright install

# Copy the rest of the application code
COPY . .

# Expose the port that your app will run on
EXPOSE 10000

# Command to run the app
CMD ["node", "server.js"]
