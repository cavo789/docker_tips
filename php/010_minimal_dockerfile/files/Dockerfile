# Run this application by running the next command in a console:
# docker build --pull --rm -t appName:latest . && docker run -p 80:80 -d -v %cd%:/var/www/html --name appName appName
# (under Windows, `%cd%` means *the current directory*)
FROM php:8.0-apache
WORKDIR /var/www/html
#COPY . .
EXPOSE 80
