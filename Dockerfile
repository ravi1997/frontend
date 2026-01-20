FROM node:20-slim

WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package.json package-lock.json* ./

# Install dependencies during build
RUN npm install

# Copy the rest of the application code
COPY . .

# Change ownership to the non-root 'node' user defined in the base image
# This ensures the user has permission to write to /app (needed for next.js)
RUN chown -R node:node /app

# Switch to non-root user
USER node

EXPOSE 3000

# Default command to run the development server
CMD ["npm", "run", "dev", "--", "-H", "0.0.0.0", "--port", "3000"]
