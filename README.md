# apache-rp-tomcat

## Introduction

This is simple Apache httpd + tomcat setup that may be useful when requests may need to be modified or directed to different applications/servers based on their URL.
https://registry.hub.docker.com/u/jacobq/apache-rp-tomcat/

## Usage

    docker pull jacobq/apache-rp-tomcat
    docker run -p 8000:80 -p 4443:443 jacobq/apache-rp-tomcat

## Notes
This image is intended to be modified/customized before use.
* `mod_ssl` is present but the https server has not been configured (obviously it wouldn't make sense to publish private keys for certificates, etc.)
* The `custom-rewrite-rules.conf` contains some `mod_rewrite` rules to demonstrate [reverse proxy](https://en.wikipedia.org/wiki/Reverse_proxy) capabilities, but should obviously be tailored to the needs of the particular application(s) being provided

## Further reading
Learn more about Docker [here](https://docs.docker.com/)
