# -------- Build stage --------
FROM node:20-alpine AS build
ENV NODE_OPTIONS=--max_old_space_size=4096
WORKDIR /app
COPY package*.json ./
RUN npm install --no-audit --no-fund
COPY . .
RUN npm ci --no-audit --no-fund

# -------- Runtime stage --------
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copy built frontend
COPY --from=build /app/build /usr/share/nginx/html

# Replace default nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Fix permissions for OpenShift random UID
RUN chgrp -R 0 /usr/share/nginx/html /var/cache/nginx /var/run && \
    chmod -R g=u /usr/share/nginx/html /var/cache/nginx /var/run

EXPOSE 8080

# nginx-unprivileged already runs as non-root
CMD ["nginx", "-g", "daemon off;"]
