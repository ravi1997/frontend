FROM node:20-slim

WORKDIR /app

# Copy package files first to leverage Docker layer caching
COPY package.json package-lock.json* ./

# Install dependencies during build
RUN npm install

# Copy the rest of the application code
COPY . .

EXPOSE 3000

# Default command to run the development server
CMD ["npm", "run", "dev", "--", "-H", "0.0.0.0", "--port", "3000"]
