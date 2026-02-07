# ---------- Build Stage ----------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Clean install to prevent esbuild/rollup errors
RUN rm -rf node_modules package-lock.json
RUN npm install

# Copy all source code
COPY . .

# Ensure Vite & esbuild binaries are executable
RUN chmod +x ./node_modules/.bin/vite
RUN chmod +x ./node_modules/.bin/esbuild

# Build the project
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy build output from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom Nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
