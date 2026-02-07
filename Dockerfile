# ---------- Build Stage ----------
FROM node:20-bullseye AS builder

WORKDIR /app

COPY package*.json ./

# Install dependencies
RUN npm ci

COPY . .

# Fix Vite permission issue
RUN chmod +x ./node_modules/.bin/vite

# Build the project
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
