FROM tomcat:latest

COPY target/app.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
