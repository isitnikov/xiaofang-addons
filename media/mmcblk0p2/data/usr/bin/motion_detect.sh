#!/bin/sh

# Copyright 2018 Vladimir Dronnikov
# GPL
/media/mmcblk0p2/data/etc/scripts/20-rtsp-server stop

snx_isp_ctl --mdset-thre 1000 # YMMV
#CTL_PID=$!

#finish()
#{
	#kill -9 $MD_PID
	#kill -9 $CTL_PID
#	echo 'Finshed!'
#}

#snx_isp_md 2>&1 | awk '
#/^Detected Moving!$/ {
#  if (alarm == 0) {
#    alarm = 1
#	system("./motion_action.sh &")
#  }
#}
#/(have no motion status = 0)/ {
#  if (alarm != 0) {
#    alarm = 0
#	system("./motion_noaction.sh &")
#  }
#}
#'
time=0
server=0
snx_isp_md 2>&1 | {
  while IFS= read -r line
  do
	current_time=$(date +"%s")
	if [ "$server" == "1" ]; then
		if [ "$time" -lt "$current_time" ]; then
			time=0
			server=0
			/media/mmcblk0p2/data/etc/scripts/20-rtsp-server stop
		else
			continue
		fi
	fi
	if [ -z "${line##*ving*}" ]; then
		server=1
		time=$(date +"%s")
		time=$((time + 20))
		/media/mmcblk0p2/data/etc/scripts/20-rtsp-server start	
	fi
  done

  # This won't work without the braces.
  echo "The last line was: $lastline"
}
#MD_PID=$!

#trap finish EXIT

#!/bin/bash

trap_with_arg() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

func_trap() {
    /media/mmcblk0p2/data/etc/scripts/20-rtsp-server stop
}

trap_with_arg func_trap INT TERM EXIT
