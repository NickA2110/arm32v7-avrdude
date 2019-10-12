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
	apt remove -y bison flex autotools-dev automake make && \
	apt autoremove -y && \
	rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

WORKDIR /workdir

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "-?" ]
