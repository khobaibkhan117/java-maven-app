FROM tomcat:9.0-jdk11

EXPOSE 8080

COPY target/maven-cloudaseem-app.war /usr/local/tomcat/webapps
