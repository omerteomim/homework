FROM nginx:alpine
RUN echo "prod-app" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]