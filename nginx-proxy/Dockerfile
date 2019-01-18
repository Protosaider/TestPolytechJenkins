FROM nginx:latest

# WORKDIR ./nginx/

# если в .conf написать: server_name	bankz.com www.bankz.com;
# 
# После этого нужно добавить домен www.bankz.com в DNS сервер с IP машины, которая запускает nginx контейнер.
# Если вы хотите протестировать контейнер в вашем локальном окружении (без DNS), добавьте запись хоста в файл /etc/hosts как показано снизу:
# 192.168.59.103 www.bankz.com

# Cleanup the default NGINX configuration file we don’t need
RUN rm /etc/nginx/conf.d/default.conf
# Copy the configuration file from the current directory and paste 
# it inside the container to use it as Nginx's default config.

COPY jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Port 8080 of the container will be exposed and then mapped to port
# 8080 of our host machine via Compose. This way we'll be able to 
# access the server via localhost:8080 on our host.
# EXPOSE 8080
# Listen on Port 80
# EXPOSE 80

# same as -p 8080:80
# docker run --name some-nginx -d -p 8080:80 some-content-nginx
# 
# Complex conf
# docker run --name my-custom-nginx-container -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx

# Remove write access from config files to protect from accidental damage
RUN chmod -v 0444 /etc/nginx/conf.d/jenkins.conf && chmod -v 0444 /etc/nginx/nginx.conf

# EXPOSE 8000
EXPOSE 80

# Create volume to persist SSL data
VOLUME /etc/ssl/certs/nginx

# We do this because by default calling nginx at the command line has NGINX run as a background daemon. 
# That returns exit 0 which causes Docker to think the process has stopped, so it shuts down the container. 
# You’ll find this happens a lot with applications not designed to run in containers. Thankfully for NGINX, this simple change solves the problem without a complex workaround.
# 
# If you add a custom CMD in the Dockerfile, be sure to include -g daemon off; in the CMD in order for nginx to stay in the foreground, so that Docker can track the process properly 
# (otherwise your container will stop immediately after starting)!
# 
# Start Nginx when the container has provisioned.
# # CMD nginx -g "daemon off;"
CMD ["nginx", "-g", "daemon off;"] 
# CMD ["nginx"]
