FROM nginx:stable-alpine
# support running as arbitrary user which belogs to the root group
RUN mkdir -p /var/run/nginx /var/log/nginx /var/cache/nginx
RUN chmod guo+rwx /var/cache/nginx /var/run /var/log/nginx
RUN chgrp -R root /var/cache/nginx

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log 
RUN ln -sf /dev/stderr /var/log/nginx/error.log 

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8555;/' /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN addgroup nginx root
USER nginx

EXPOSE 8555
CMD ["nginx","-g","daemon off;"]
