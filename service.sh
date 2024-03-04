# functions
lock_var() {
	[ ! -f "$2" ] && return
	umount "$2"

	chown root:root "$2"
	chmod 0666 "$2"
	echo "$1" >"$2"
	chmod 0444 "$2"

	local TIME=$(date +"%s%N")
	echo "$1" >/dev/mount_mask_$TIME
	mount --bind /dev/mount_mask_$TIME "$2"
	rm /dev/mount_mask_$TIME
}
set_var() {
	if [ -f ${2} ]; then
		chmod 0666 ${2}
		echo ${1} > ${2}
		chmod 0444 ${2}
	fi
}
thermal_xt()
{
    cpu_temp=$(cat /sys/class/thermal/thermal_zone77/temp)
    if [ "${cpu_temp}" -gt "45000" ]; then
        if [ "${cpu_temp}" -gt "50000" ]; then
            set_var "1651200" /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq
            set_var "806400" /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq
            set_var "1363200" /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
            set_var 6 /sys/class/kgsl/kgsl-3d0/max_pwrlevel
        elif [ "${cpu_temp}" -gt "55000" ]; then
            set_var "1440000" /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq
            set_var "806400" /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq
            set_var "1267200" /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
            set_var 8 /sys/class/kgsl/kgsl-3d0/max_pwrlevel
        elif [ "${cpu_temp}" -gt "59000" ]; then
            set_var "1324800" /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq
            set_var "806400" /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq
            set_var "1171200" /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
            set_var 10 /sys/class/kgsl/kgsl-3d0/max_pwrlevel
        else
            set_var "1881600" /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq
            set_var "1286400" /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq
            set_var "1478400" /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
        fi
    else
        set_var "1996800" /sys/devices/system/cpu/cpufreq/policy4/scaling_max_freq
        set_var "1401600" /sys/devices/system/cpu/cpufreq/policy7/scaling_max_freq
        set_var "1574400" /sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq
        set_var 4 /sys/class/kgsl/kgsl-3d0/max_pwrlevel
    fi
} 

# changes in kernel
lock_var 4096 /proc/sys/kernel/random/poolsize
lock_var 4096 /proc/sys/kernel/random/entropy_avail
lock_var 1024 /proc/sys/kernel/random/write_wakeup_threshold
lock_var 0 /sys/module/kfence/parameters/sample_interval
lock_var 0 /proc/sys/walt/sched_force_lb_enable
lock_var 0 /sys/devices/system/cpu/c1dcvs/enable_c1dcvs
lock_var 0 /proc/sys/kernel/sched_pelt_multiplier
for i in /sys/devices/virtual/thermal/cooling_device*/
do
    lock_var 0 $i/max_state
    lock_var 0 $i/cur_state
done

# wait mount sdcard
while [ ! -d /sdcard ]; do
    sleep 5
done

# ZRAM size 4 GB with lz4 compression
swapoff /dev/block/zram0
echo 1 > sys/block/zram0/reset
echo "3" > /proc/sys/vm/drop_caches
set_var lz4 /sys/block/zram0/comp_algorithm
set_var 4294967296 /sys/block/zram0/disksize
mkswap /dev/block/zram0 > /dev/null 2>&1
swapon /dev/block/zram0 > /dev/null 2>&1

# thermal_xt
while true; do
    sleep 10
    mWakefulness=$(dumpsys power | grep mWakefulness= | head -1 | cut -d "=" -f2)
    if [ "${mWakefulness}" == "Dozing" ] || [ "${mWakefulness}" == "Asleep" ] ; then
        continue
    fi
    thermal_xt
done
