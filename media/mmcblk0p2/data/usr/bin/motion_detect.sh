#!/usr/bin/env bash

lifeTime=60

stopServer()
{
    /media/mmcblk0p2/data/etc/scripts/20-rtsp-server stop
}

startServer()
{
    /media/mmcblk0p2/data/etc/scripts/20-rtsp-server start
}

finish()
{
    stopServer
    kill -9 `pidof snx_isp_ctl`
}

trap finish EXIT
trap finish TERM

snx_isp_ctl --mdset-thre 1000 # YMMV

snx_isp_md 2>&1 | {
  while IFS= read -r line
  do
	current_time=$(date +"%s")
	if [ "$server" == "1" ]; then
		if [ "$time" -lt "$current_time" ]; then
			time=0
			server=0
			stopServer
		else
		    time=$((time + $lifeTime))
			continue
		fi
	fi
	if [ -z "${line##*ving*}" ]; then
		server=1
		time=$(date +"%s")
		time=$((time + $lifeTime))
		startServer
	fi
  done
}
