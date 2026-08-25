FROM nginx:alpine

# إعداد ملف التكوين لـ Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# نسخ صفحة الهبوط الافتراضية
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
