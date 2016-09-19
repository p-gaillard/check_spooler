#!/bin/bash

#
# author: Philippe Gaillard
# nagios check, to see which print jobs are on error on spoolers
# tested on windows server 2008 r2
#
# copy the file in /usr/lib/nagios/plugins
#
# usage
# $USER1$/check_spooler.sh $HOSTADDRESS$ $ARG1$ $ARG2$ $ARG3$ $ARG4$
# ARG1 : user
# ARG2 : passwd
# ARG3 : warning
# ARG4 : critical
#
# CLI test syntax: ./check_spooler.sh <ip> <user@toto.toto> <password> <warning value> <critical value>
# example: ./check_spooler.sh 10.10.10.10 toto@toto.toto toto 10 20
#

# Return codes:

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Arguments:

HOST=$1
USER=$2
PASS=$3
WARNLEVEL=$4
CRITLEVEL=$5

# Get current file count:
JOBERRORS=`wmic -U "$USER%$PASS" "//$HOST" "select Name,JobErrors from Win32_PerfFormattedData_Spooler_PrintQueue where Name='_Total'" | tail -1 | cut -d '|' -f 1`

if [ $JOBERRORS -lt $WARNLEVEL ]; then
	echo "OK - $JOBERRORS joberrors in $HOST spool"
	exitstatus=$STATE_OK
	exit $exitstatus 
fi
if [ $JOBERRORS -gt $CRITLEVEL ]; then
	echo "CRITICAL - $JOBERRORS joberrors in $HOST spool"
	exitstatus=$STATE_CRITICAL
	exit $exitstatus
fi 
if [ $JOBERRORS -gt $WARNLEVEL ]; then
	echo "WARNING - $JOBERRORS joberrors in $HOST spool"
	exitstatus=$STATE_WARNING
	exit $exitstatus
fi

