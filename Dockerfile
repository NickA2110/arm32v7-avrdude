FROM arm32v7/debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
	apt install -y bash bison flex git autotools-dev automake make && \
	git clone https://github.com/kcuzner/avrdude && \
	cd ./avrdude/avrdude && \
	./bootstrap && \
	./configure --prefix=/usr && \
	make && \
	make install && \
	apt -y remove bison flex autotools-dev automake make && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

WORKDIR /workdir

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "-?" ]
