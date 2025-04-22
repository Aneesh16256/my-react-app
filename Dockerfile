# ---- Build Stage ----
FROM node:18 AS builder
WORKDIR /app

COPY package*.json ./
RUN npm install --unsafe-perm && \
    npm cache clean --force

# Fix permissions for node_modules
RUN chmod -R 755 /app/node_modules/.bin

COPY . .
RUN npm run build

# ---- Production Stage ----
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
