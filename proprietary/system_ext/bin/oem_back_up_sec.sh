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
echo "init: back up [$TYPE:$INDEX]" > /dev/kmsg

if [ -d "/mnt/vendor/op2" ];then
	sleep 1
	# Backup key files
	# Locksettings
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system/
	/system/bin/cp /data/system/locksettings.db /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system/
	/system/bin/cp /data/system/gatekeeper.password.key /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system/
	/system/bin/cp /data/system/gatekeeper.pattern.key /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system/
	# SP
	# mkdir -p /op2/sec/${TYPE}/${INDEX}/data/misc/keystore/user_0
	# /system/bin/cp -r /data/misc/keystore/user_0 /op2/sec/${TYPE}/${INDEX}/data/misc/keystore/
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system_de/0/spblob
	/system/bin/cp -r /data/system_de/0/spblob /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system_de/0/
	# ME
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/metadata/vold/metadata_encryption/key
	/system/bin/cp -r /metadata/vold/metadata_encryption/key /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/system_de/0/
	# FBE
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/misc/vold/user_keys/ce/0/current
	/system/bin/cp -r /data/misc/vold/user_keys/ce/0/current /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/misc/vold/user_keys/ce/0/
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/misc/vold/user_keys/de/0
	/system/bin/cp -r /data/misc/vold/user_keys/de/0 /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/misc/vold/user_keys/de/
	mkdir -p /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/unencrypted/key
	/system/bin/cp -r /data/unencrypted/key /mnt/vendor/op2/sec/${TYPE}/${INDEX}/data/unencrypted/

	# Record the file size and date
	/system/bin/ls -al /data/system > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/ls_data_system.txt
	/system/bin/ls -al /data/misc > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/ls_data_misc.txt
	#/system/bin/ls -al /data/misc/keystore/user_0 > /op2/sec/${TYPE}/${INDEX}/ls_data_misc_keystore_user0.txt
	/system/bin/ls -al /data/misc/vold/user_keys/ce/0/current > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/ls_user_0_ce.txt
	/system/bin/ls -al /data/system_de/0/spblob > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/ls_data_system_de_0_spblob.txt
	/system/bin/df -h > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/df.txt
	/system/bin/date > /mnt/vendor/op2/sec/${TYPE}/${INDEX}/date_backup.txt
fi
