#! /system/bin/sh

# Copyright (c) 2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

TYPE=$1

if [ ${TYPE} = "enroll" ]; then
	INDEX=`getprop vendor.oem.enroll.index`
elif [ ${TYPE} = "pass" ]; then
	INDEX=`getprop vendor.oem.verify.pass.index`
elif [ ${TYPE} = "fail" ]; then
	INDEX=`getprop vendor.oem.verify.fail.index`
else
	exit 0
fi
echo "init: back up type [$TYPE:$INDEX]" > /dev/kmsg

if [ -d "/mnt/vendor/op2" ];then
	sleep 1
	# Record log start
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}
	/system/bin/date > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/date_start.txt
	#/system/bin/logcat -f /mnt/vendor/op2/sec/${TYPE}/${INDEX}/logcat.txt -t 1024
	#/system/bin/gzip -9 /mnt/vendor/op2/sec/${TYPE}/${INDEX}/logcat.txt
	/system/bin/dumpsys lock_settings > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/dumpsys_lock_settings.txt
	#/system/bin/dmesg > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/dmesg.txt
	#/system/bin/gzip -9 /mnt/vendor/op2/sec/${TYPE}/${INDEX}/dmesg.txt
	/system/bin/cat /proc/tzdbg/qsee_log | /system/bin/tee /mnt/vendor/op2/sec/${TYPE}/${INDEX}/qsee_log.txt &
	/system/bin/getprop > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/getprop.txt

	# Record log end
	/system/bin/kill -9 `pidof cat /proc/tzdbg/qsee_log | tee qsee_log.txt`
	/system/bin/gzip -9 /mnt/vendor/op2/sec/${TYPE}/${INDEX}/qsee_log.txt
	/system/bin/date > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/date_end.txt
fi
