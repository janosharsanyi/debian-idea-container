#!/usr/bin/env bash

trap 'echo "Exiting..." && vncserver -kill :1 && sync && exit 0' SIGTERM

echo "Container IP address: "
ip addr show | grep inet

if [ -f /run/secrets/idea.vnc.passwd ]; then
	echo 'Using docker secret for password'
	cat /run/secrets/idea.vnc.passwd | vncpass -f > /root/.vnc/passwd
else
	echo 'Using ENV VNCPASSWD'
	printf "%s" "$VNCPASSWD" | vncpasswd -f > /root/.vnc/passwd
fi

chmod 0600 /root/.vnc/passwd


if [ -f /tmp/.X1-lock ]; then
	echo 'Found /tmp/.X1-lock, removing...'
	rm /tmp/.X1-lock
fi

vncserver -kill :1
vncserver -geometry "$VNCRESOLUTION" -localhost no :1 &
pid="${!}"
echo "VNC PID: $pid"


while true
do
  tail -f /dev/null & wait "${!}"
done
