# ---------- Build Stage ----------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app
COPY . .

# Make vite executable (fix permission issue on Alpine)
RUN chmod +x ./node_modules/.bin/vite

# Build the project using npm exec
RUN npm exec vite build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy the build output from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
