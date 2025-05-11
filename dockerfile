# Use an official Node.js LTS version with a more complete base image
FROM node:18-bullseye

# Install dependencies required for running Playwright
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # Essential dependencies
    ca-certificates \
    curl \
    wget \
    xvfb \
    xdg-utils \
    
    # Playwright dependencies
    libgtk-3.0 \
    libnotify-dev \
    libgconf-2-4 \
    libgbm-dev \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    fonts-liberation \
    libappindicator3-1 \
    
    # Additional dependencies that might be needed
    libglib2.0-0 \
    libcairo2 \
    libpango-1.0-0 \
    libatk1.0-0 \
    libdbus-1-3 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libwayland-client0 \
    libwayland-server0 \
    libgbm1 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /app

# Copy package files first to leverage Docker cache
COPY package*.json ./

# Install app dependencies
RUN npm install

# Install Playwright with browsers
RUN npx playwright install --with-deps chromium

# Copy the rest of the application code
COPY . .

# Expose the port that your app will run on
EXPOSE 10000

# Command to run the app
CMD ["node", "server.js"]
