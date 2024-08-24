write() {
	if test -f "$1"; then
		chmod +w "$1"
		echo "$2" > "$1"
		chmod 0444 "$1"
	fi
}

test_file=/sdcard/Android/.test

while test ! -f "$test_file"; do
	touch "$test_file"
	sleep 1
done

rm $test_file

sysctl -q kernel.sched_util_clamp_min_rt_default=96
sysctl -q kernel.sched_util_clamp_min=128

for d in $(find /dev/cpuctl /dev/cpuset -type d -mindepth 1 -maxdepth 1); do
	case $(basename $d) in
		top-app)
			write $d/cpu.uclamp.max max
			write $d/cpu.uclamp.min 10
			write $d/sched_load_balance 0
			write $d/uclamp.latency_sensitive 1
		;;
		foreground)
			write $d/cpu.uclamp.max 50
			write $d/cpu.uclamp.min 0
			write $d/uclamp.latency_sensitive 0
		;;
		background)
			write $d/cpu.uclamp.max max
			write $d/cpu.uclamp.min 20
			write $d/uclamp.latency_sensitive 0
		;;
		system-background)
			write $d/cpu.uclamp.max 40
			write $d/cpu.uclamp.min 0
			write $d/uclamp.latency_sensitive 0
		;;
		*)
			for task in $(); do
				echo $task > $(dirname $d)/cgroup.procs
			done
			
			chmod 0444 $d/tasks
		;;
	esac
done

write /sys/devices/platform/soc/soc:oplus-ormg/oplus-ormg0/ruler_enable 0

for n in $(seq 0 7); do
	cpu_core=/sys/devices/system/cpu/cpu$n
	max_freq=$(cat $cpu_core/cpufreq/cpuinfo_max_freq)
	write /sys/kernel/msm_perfomance/parameters/cpu_max_freq $n:$max_freq
	echo $max_freq > $cpu_core/cpufreq/scaling_max_freq
	write $cpu_core/online 1
done
