while true
do
	# Date and clock.
	_date=$(date +'%d')
	date_clock="$(date +'%D') | $(date +'%H:%M:%S') | $(date +'%a')"
	#Battery level and AC status
	bat_level="BAT: $(cat /sys/class/power_supply/BAT0/capacity)%"
	#AC status
	ac_online="$(cat /sys/class/power_supply/AC/online)"
	# Audio.
	audio_volume="$(pamixer --get-volume)"
	if pamixer --get-mute > == true; then mute_status="M"; else mute_status=""; fi
	# Memory
	mem_used="$(free -m | awk '/Mem:/' | awk '{print $3}')"
	# Disk available
	disk_avail="$(df -h | awk '/nvme0n1p5/' | awk '{print $4}')"
	# Focused proc
	focused_proc="> $(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .name' | cut -d '"' -f 2 | cut -c -50) <"
	# CPU usage
	cpu_usage="$(top -bn1 | grep '%Cpu(s)' | awk '{print 100-$8}')"
	# Network
	net_interface="$(ip route get 1.1.1.1 | awk '{print $5}' | cut -c -3)"
	ping="$(ping 8.8.8.8 -c 1 | awk 'BEGIN{FS="time="} {print $2}' | grep ms)"
	# LANG
	current_lang="$(swaymsg -r -t get_inputs | jq '.[] | select(.identifier=="1:1:AT_Translated_Set_2_keyboard") | .xkb_active_layout_name' | cut -d '"' -f 2 | cut -c -3)"
	# Brightness
	brightness="$(expr $(cat /sys/class/backlight/intel_backlight/brightness) / 240)"
	echo " $focused_proc | NET: $net_interface($ping) | CPU: $cpu_usage% | DISK: $disk_avail | MEM: $mem_used MB | $current_lang | VOL: $audio_volume%$mute_status | BRT: $brightness% | $bat_level($ac_online) | $date_clock"
	sleep 1
done
