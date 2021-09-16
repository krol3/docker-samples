#FROM ubuntu
FROM ubuntu:20.04
WORKDIR /root
RUN apt update && apt install -y net-tools netcat ncat
ADD entrypoint.sh .
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["/root/entrypoint.sh"]