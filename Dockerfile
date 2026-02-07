# ---------- Build Stage ----------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Clean install to avoid esbuild/rollup issues
RUN rm -rf node_modules package-lock.json
RUN npm install

# Copy source code
COPY . .

# Ensure Vite & esbuild binaries are executable
RUN chmod +x ./node_modules/.bin/vite
RUN chmod +x ./node_modules/.bin/esbuild

# Build the project
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy build output
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy Nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
