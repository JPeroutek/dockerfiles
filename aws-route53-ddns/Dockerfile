FROM amazonlinux:latest

RUN yum install -y less jq unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

COPY ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]