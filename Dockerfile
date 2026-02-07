# ---------- Build Stage ----------
FROM node:20-bullseye AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Remove old modules & lockfile to prevent esbuild/rollup mismatch
RUN rm -rf node_modules package-lock.json

# Install dependencies fresh
RUN npm install

# Copy all source code
COPY . .

# Fix Vite/esbuild permission issue
RUN chmod +x ./node_modules/.bin/vite
RUN chmod +x ./node_modules/.bin/esbuild

# Optional: check esbuild version
RUN npx esbuild --version

# Build the Vite project
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

# Copy build output
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
