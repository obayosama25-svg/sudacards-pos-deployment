FROM node:18-bullseye

# Install MongoDB, Nginx, and Supervisor
RUN apt-get update && \
    apt-get install -y gnupg wget nginx supervisor && \
    wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add - && \
    echo "deb http://repo.mongodb.org/apt/debian bullseye/mongodb-org/6.0 main" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list && \
    apt-get update && \
    apt-get install -y mongodb-org && \
    mkdir -p /data/db /var/log/mongodb && \
    chown -R mongodb:mongodb /data/db /var/log/mongodb

WORKDIR /app

# Copy Dashboard source code
COPY backend ./backend
COPY admin ./admin

# Setup Backend
RUN cd backend && npm install

# Setup Admin Frontend
RUN cd admin && npm install && npm run build
RUN cp -r admin/dist/* /var/www/html/

# Setup Nginx
RUN echo 'server { \n\
    listen 80; \n\
    server_name localhost; \n\
    root /var/www/html; \n\
    index index.html index.htm; \n\
    location / { \n\
        try_files $uri $uri/ /index.html; \n\
    } \n\
    location /api { \n\
        proxy_pass http://127.0.0.1:5000; \n\
        proxy_http_version 1.1; \n\
        proxy_set_header Upgrade $http_upgrade; \n\
        proxy_set_header Connection "upgrade"; \n\
        proxy_set_header Host $host; \n\
        proxy_cache_bypass $http_upgrade; \n\
    } \n\
}' > /etc/nginx/sites-available/default

# Setup Supervisor
RUN echo '[supervisord] \n\
nodaemon=true \n\
\n\
[program:mongod] \n\
command=/usr/bin/mongod --bind_ip_all \n\
user=mongodb \n\
autostart=true \n\
autorestart=true \n\
\n\
[program:backend] \n\
command=node server.js \n\
directory=/app/backend \n\
environment=PORT=5000,MONGO_URI="mongodb://127.0.0.1:27017/sudacards_admin",JWT_SECRET="super_secret_sudacards_key_2026",EMAIL_USER="drtasd044@gmail.com",EMAIL_PASS="wluudktpfnlksqrm" \n\
autostart=true \n\
autorestart=true \n\
\n\
[program:nginx] \n\
command=/usr/sbin/nginx -g "daemon off;" \n\
autostart=true \n\
autorestart=true' > /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 5000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
