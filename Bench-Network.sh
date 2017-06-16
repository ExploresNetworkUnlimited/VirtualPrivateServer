#!/bin/bash
#####################################################################
# Benchmark Script 2 by Hidden Refuge from FreeVPS                  #
# Copyright(C) 2015 - Hidden Refuge                                 #
# License: GNU General Public License 3.0                           #
# Github: https://github.com/hidden-refuge/bench-sh-2               #
#####################################################################
# Original script by akamaras/camarg                                #
# Original: http://www.akamaras.com/linux/linux-server-info-script/ #
# Original Copyright (C) 2011 by akamaras/camarg                    #
#####################################################################
# The speed test was added by dmmcintyre3 from FreeVPS.us as a      #
# modification to the original script.                              #
# Modded Script: https://freevps.us/thread-2252.html                # 
# Copyright (C) 2011 by dmmcintyre3 for the modification            #
#####################################################################
sysinfo () {
	# Removing existing bench.log
	rm -rf $HOME/bench.log
	# Reading out system information...
	# Reading CPU model
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading amount of CPU cores
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	# Reading CPU frequency in MHz
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading total memory in MB
	tram=$( free -m | awk 'NR==2 {print $2}' )
	# Reading Swap in MB
	vram=$( free -m | awk 'NR==4 {print $2}' )
	# Reading system uptime
	up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Reading operating system and version (simple, didn't filter the strings at the end...)
	opsy=$( cat /etc/issue.net | awk 'NR==1 {print}' ) # Operating System & Version
	arch=$( uname -m ) # Architecture
	lbit=$( getconf LONG_BIT ) # Architecture in Bit
	hn=$( hostname ) # Hostname
	kern=$( uname -r )
	# Date of benchmark
	bdates=$( date )
	echo "Benchmark started on $bdates" | tee -a $HOME/bench.log
	echo "Full benchmark log: $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	# Output of results
	echo "System Info" | tee -a $HOME/bench.log
	echo "-----------" | tee -a $HOME/bench.log
	echo "Processor	: $cname" | tee -a $HOME/bench.log
	echo "CPU Cores	: $cores" | tee -a $HOME/bench.log
	echo "Frequency	: $freq MHz" | tee -a $HOME/bench.log
	echo "Memory		: $tram MB" | tee -a $HOME/bench.log
	echo "Swap		: $vram MB" | tee -a $HOME/bench.log
	echo "Uptime		: $up" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "OS		: $opsy" | tee -a $HOME/bench.log
	echo "Arch		: $arch ($lbit Bit)" | tee -a $HOME/bench.log
	echo "Kernel		: $kern" | tee -a $HOME/bench.log
	echo "Hostname	: $hn" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
iotest () {
	echo "Disk Speed" | tee -a $HOME/bench.log
	echo "----------" | tee -a $HOME/bench.log
	# Measuring disk speed with DD
	io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
	# Calculating avg I/O (better approach with awk for non int values)
	ioraw=$( echo $io | awk 'NR==1 {print $1}' )
	ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
	ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
	ioall=$( awk 'BEGIN{print '$ioraw' + '$ioraw2' + '$ioraw3'}' )
	ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
	# Output of DD result
	echo "I/O (1st run)	: $io" | tee -a $HOME/bench.log
	echo "I/O (2nd run)	: $io2" | tee -a $HOME/bench.log
	echo "I/O (3rd run)	: $io3" | tee -a $HOME/bench.log
	echo "Average I/O	: $ioavg MB/s" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
gbench () {
	# Improved version of my code by thirthy_speed https://freevps.us/thread-16943-post-191398.html#pid191398
	echo "" | tee -a $HOME/bench.log
	echo "System Benchmark (Experimental)" | tee -a $HOME/bench.log
	echo "-------------------------------" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
	echo "Note: The benchmark might not always work (eg: missing dependencies)." | tee -a $HOME/bench.log
	echo "Failures are highly possible. We're using Geekbench for this test." | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
        gb_page=http://www.primatelabs.com/geekbench/download/linux/
        gb_dl=$(wget -qO - $gb_page | \
                 sed -n 's/.*\(https\?:[^:]*\.tar\.gz\).*/\1/p')
        gb_noext=${gb_dl##*/}
        gb_noext=${gb_noext%.tar.gz} 
        gb_name=${gb_noext//-/ }
	echo "File is located at $gb_dl" | tee -a $HOME/bench.log
	echo "Downloading and extracting $gb_name" | tee -a $HOME/bench.log
        wget -qO - "$gb_dl" | tar xzv 2>&1 >/dev/null
	echo "" | tee -a $HOME/bench.log
	echo "Starting $gb_name" | tee -a $HOME/bench.log
	echo "The system benchmark may take a while." | tee -a $HOME/bench.log
	echo "Don't close your terminal/SSH session!" | tee -a $HOME/bench.log
	echo "All output is redirected into a result file." | tee -a $HOME/bench.log
	echo "" >> $HOME/bench.log
	echo "--- Geekbench Results ---" >> $HOME/bench.log
	sleep 2
	$HOME/dist/$gb_noext/geekbench_x86_32 >> $HOME/bench.log
	echo "--- Geekbench Results End ---" >> $HOME/bench.log
	echo "" >> $HOME/bench.log
	echo "Finished. Removing Geekbench files" | tee -a $HOME/bench.log
	sleep 1
	rm -rf $HOME/dist/
	echo "" | tee -a $HOME/bench.log
        gbl=$(sed -n '/following link/,/following link/ {/following link\|^$/b; p}' $HOME/bench.log | sed 's/^[ \t]*//;s/[ \t]*$//' )
	echo "Benchmark Results: $gbl" | tee -a $HOME/bench.log
	echo "Full report available at $HOME/bench.log" | tee -a $HOME/bench.log
	echo "" | tee -a $HOME/bench.log
}
hlp () {
	echo ""
	echo "(C) Bench.sh 2 by Hidden Refuge <me at hiddenrefuge got eu dot org>"
	echo ""
	echo "Usage: bench.sh <option>"
	echo ""
	echo "Available options:"
	echo "No option	: System information, IPv4 only speedtest and disk speed & IOPing benchmark will be run."
	echo "-sys		: Displays system information such as CPU, amount CPU cores, RAM and more."
	echo "-io		: Runs a disk speed test and a IOPing benchmark and displays the results."
	echo "-iops		: Runs a extended IOPing test for latency, reading and et cetera."
	echo "-b		: Normal benchmark with IPv4 only speedtest, I/O test and Geekbench system benchmark."
	echo "-b6		: Normal benchmark with IPv6 only speedtest, I/O test and Geekbench system benchmark."
	echo "-b46		: Normal benchmark with IPv4 and IPv6 speedtest, I/O test and Geekbench system benchmark."
	echo "-b64		: Same as above."
	echo "-h		: This help page."
	echo ""
	echo "The Geekbench system benchmark is experimental. So beware of failure!"
	echo ""
}
case $1 in
	'-sys')
		sysinfo;;
	'-io')
		iotest;;
	'-6' )
		sysinfo; speedtest6; iotest;;
	'-46' )
		sysinfo; speedtest4; speedtest6; iotest;;
	'-64' )
		sysinfo; speedtest4; speedtest6; iotest;;
	'-b' )
		sysinfo; speedtest4; iotest; gbench;;
	'-b6' )
		sysinfo; speedtest6; iotest; gbench;;
	'-h' )
		hlp;;
	*)
		sysinfo; otest;;
esac
#################################################################################
# Contributors:									#
# thirthy_speed https://freevps.us/thread-16943-post-191398.html#pid191398 	#
#################################################################################
