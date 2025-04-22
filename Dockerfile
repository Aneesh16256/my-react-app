# ---- Build Stage ----
    FROM node:18 AS builder
    WORKDIR /app
    
    # Copy package files first for better caching
    COPY package*.json ./
    
    # Install dependencies with clean cache
    RUN npm install --unsafe-perm && \
        npm cache clean --force
    
    # Copy all files (except those in .dockerignore)
    COPY . .
    
    # Build the application
    RUN npm run build
    
    # ---- Production Stage ----
    FROM nginx:alpine
    
    # Remove default nginx content
    RUN rm -rf /usr/share/nginx/html/*
    
    # Copy built files from builder stage
    COPY --from=builder /app/build /usr/share/nginx/html
    
    # Expose port and run nginx
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]