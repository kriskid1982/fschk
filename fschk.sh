#!/bin/bash
#Script made by Moksha
#Purpose: To monitor all the mount points mentioned in fstab and their status. except the ones that are bind mounts.
#

count=1
hstname=`hostname`
for i in `cat /etc/fstab|grep -v bind|awk '{print $1 " " $2}'|egrep -v "^#|swap"|awk '{print $2}'`;
do
	status="NA"
	roinfstab=0
	mountpoint=$i
	lastchar="`echo $mountpoint|awk '{print substr($0,length($0),1)}'`"

	if [ $mountpoint ==  "/" ]
	then
		roinfstab=1
	else
		        cat /etc/fstab|grep -v "^#"|awk '{print $2 " " $4}'| egrep "(^| )$mountpoint( |$)" |grep -q ro
			        if [ $? -eq 0 ]
					        then
							        roinfstab=0
								        else
										        roinfstab=1
											        fi
											fi

											if [ $mountpoint ==  "/" ]
											then
												#echo "its root"
												just=1
											else
												        if [ $lastchar == "/" ]
														        then
																        mountpoint=`echo $mountpoint|awk '{print substr($1, 1, length($1)-1)}'`
																	        fi
																	fi

																	if [ $roinfstab -eq  1 ]
																	then
																		for x in `cat /proc/mounts|egrep "(^| )$mountpoint( |$)"|awk '{print substr($4,1,2)}'`;
																		do
																			status=$x
																		done
																	fi

																	cat /proc/mounts|egrep -q "(^| )$mountpoint( |$)"
																	if [ $? -eq 0 ]
																		       then
																			              mp="MOUNTED"
																			      else
																				             mp="NOTMOUNTED"
																				     fi

																				     echo "$count|$mountpoint|$status|$mp|$hstname"
																				     ((count++))
																			     done

