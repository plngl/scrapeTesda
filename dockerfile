# Use an official Node.js LTS version
FROM node:18

# Install dependencies required for running Playwright in a headless environment
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  # Playwright dependencies
  libgtk-4-1 \
  libgraphene-1.0-0 \
  libgstgl-1.0-0 \
  libgstcodecparsers-1.0-0 \
  libavif15 \
  libenchant-2-2 \
  libsecret-1-0 \
  libmanette-0.2-0 \
  libgles2 \
  
  # Browser dependencies
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libnspr4 \
  libnss3 \
  libxss1 \
  libxtst6 \
  libdrm2 \
  libgbm1 \
  
  # System tools
  wget \
  curl \
  ca-certificates \
  xvfb \
  xdg-utils \
  
  # Clean up
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install app dependencies
RUN npm install

# Install Playwright with browsers (add --with-deps if needed)
RUN npx playwright install --with-deps chromium

# Copy the rest of the application code
COPY . .

# Expose the port that your app will run on
EXPOSE 10000

# Command to run the app
CMD ["node", "server.js"]
