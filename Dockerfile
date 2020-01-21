FROM debian as debian-vnc-base
RUN apt-get update \
	&& apt-get install -y \
		curl \
		default-jdk \
		dnsutils \
		firefox-esr \
		git \
		htop \
		icewm \
		maven \
		mc \
		nano \
		ncdu \
		net-tools \
		procps \
		screen \
		telnet \
		tmux \
		vim \
		vnc4server \
		wget \
		xterm \
	&& apt-get clean autoclean

RUN mkdir -p /root/.vnc \
	&& mkdir -p /root/.icewm \
	&& touch /root/.icewm/keys \
	&& cp /usr/share/icewm/menu /root/.icewm/menu \
	&& echo 'prog vncconfig vncconfig vncconfig' >> /root/.icewm/menu \
	&& echo 'Theme="win95/default.theme"' > /root/.icewm/theme

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENV VNCPASSWD almafa
ENV VNCRESOLUTION 1920x1080

EXPOSE 5901
CMD ["/startup.sh"]

FROM debian-vnc-base as debian-idea
COPY ideaIU-2019.3.1.tar.gz /root/
RUN tar -xzvf /root/ideaIU-2019.3.1.tar.gz --directory /root \
	&& rm /root/ideaIU-2019.3.1.tar.gz \
	&& echo 'prog ideaIU-2019.3.1 /root/idea-IU-193.5662.53/bin/idea.png /root/idea-IU-193.5662.53/bin/idea.sh' \
		>> /root/.icewm/menu
		