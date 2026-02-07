# ---------- Build Stage ----------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Clean install to avoid optional dependency issues
RUN rm -rf node_modules package-lock.json
RUN npm install

# Copy all source code
COPY . .

# Fix permissions (just in case)
RUN chmod +x ./node_modules/.bin/vite

# Build the Vite project
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
