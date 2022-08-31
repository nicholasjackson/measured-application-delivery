FROM nicholasjackson/fake-service:vm-v1.12.2-v0.23.1

ARG TARGETARCH

COPY supervisor.conf /etc/supervisor/conf.d/fake-service.conf

RUN apt update && apt install -y zip nginx dnsutils nano

# remove init.d
RUN rm -rf /etc/init.d/nginx && rm -rf /usr/lib/systemd/system/nginx.service

RUN mkdir -p /usr/share/nginx/logs/

RUN cd /tmp && \
  curl  https://releases.hashicorp.com/consul-template/0.29.1/consul-template_0.29.1_linux_${TARGETARCH}.zip --output consul-template.zip && \
  unzip consul-template.zip && \
  mv ./consul-template /usr/local/bin
