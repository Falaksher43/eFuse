FROM node:4.4.6

RUN  apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

 
RUN wget -qO - https://www.mongodb.org/static/pgp/server-3.2.asc | apt-key add - && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list &&\
    apt-get update && \
    apt-get install -y mongodb
   

RUN apt-get install -y redis-server
RUN npm install -y grunt -g
# mkdir project && \
RUN	mkdir data && \
	cd data && \
	mkdir db

RUN service redis-server start
	
# VOLUME /project


EXPOSE 27017 3000

CMD ["/bin/bash"]


