# Set the base image to Ubuntu
####FROM ubuntu
FROM ubuntu:14.04


# Update the repository sources list
RUN apt-get update  && apt-get install -y apt-transport-https net-tools inetutils-traceroute iputils-ping xinetd telnetd

################## BEGIN INSTALLATION ######################
# Install opejdk
##RUN apt-get install -y default-jdk
RUN apt-get install -y  openjdk-7-jdk

# install git and maven
RUN  apt-get install -y  git maven


# Create the default data directory
RUN rm -rf /data/
RUN mkdir -p /data/

# switch to new directory

WORKDIR /data

# perform git clone
RUN git clone https://github.com/vikram-sardeshpande/tomcatwebapp.git

# switch to tomcatwebapp directory
WORKDIR /data/tomcatwebapp/tomcatwebapp

# use maven to compile 
#RUN mvn compile
# use maven to package
RUN mvn package


# install tomcat7

####RUN apt-get update 
RUN apt-get install -y tomcat7 tomcat7-docs tomcat7-examples tomcat7-admin

# switch to cloudenabledwebapp directory
WORKDIR /data/tomcatwebapp/tomcatwebapp/target/

# copy war file
#ADD tomcatwebapp.war /var/lib/tomcat7/webapps/
RUN  /etc/init.d/tomcat7 stop 
RUN rm -f /var/lib/tomcat7/webapps/tomcatwebapp.war
RUN rm -rf /var/lib/tomcat7/webapps/tomcatwebapp
RUN cp /data/tomcatwebapp/tomcatwebapp/target/tomcatwebapp.war /var/lib/tomcat7/webapps/



# Expose the default port
EXPOSE 8080

# Default port to execute the entrypoint
CMD ["--port 8080"]

# Set default container command
#ENTRYPOINT /bin/bash
ENV CATALINA_BASE /var/lib/tomcat7
ENTRYPOINT [ "/usr/share/tomcat7/bin/catalina.sh", "run" ]
# Start Tomcat, after starting Tomcat the container will stop. So use a 'trick' to keep it running.
#CMD service tomcat7 start && tail -f /var/lib/tomcat7/logs/catalina.out
#CMD ["/etc/init.d/tomcat7 start"]


##################### INSTALLATION END #####################
