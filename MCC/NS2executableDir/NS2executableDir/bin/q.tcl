set ns [new Simulator]

#Define different colors for data flows
$ns color 1 Blue
$ns color 2 Red

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

set tracefd [open qmonitor.tr w]
$ns trace-all $tracefd

#We can also do an event trace, this may or may not be interesting and I do not
#think that it is included in the above trace-all, but it may be.
set eventfd [open events.tr w]
$ns eventtrace-all $eventfd

set q_f [open queue.tr w]

proc qout {} {
   global ns tracefd qmon
   set nowtime [$ns now]
   set numpack [$qmon set pkts_]
   set sizeq [$qmon set size_]
   set numdrops [$qmon set pdrops_]

   puts $tracefd "- $nowtime - Size of queue: $sizeq"
   puts $tracefd "- $nowtime - Packets in queue: $numpack"
   puts $numpack
   puts $numdrops
}

#Define a 'finish' procedure
proc finish {} {
        global ns nf tracefd qmon
        $ns flush-trace
	#Close the trace file
        close $nf
        
        #Print out queue monitor data to the trace file
        set numdrops [$qmon set pdrops_]
        set totalpackets [$qmon set parrivals_]
        set notdrop [$qmon set pdepartures_]
        puts $tracefd "Total packets: $totalpackets"
        puts $tracefd "Nondropped packets: $notdrop"
        puts $tracefd "Dropped packets: $numdrops"
        
	#Execute nam on the trace file
        #exec nam out.nam &
        exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
#$ns duplex-link $n3 $n2 1Mb 10ms SFQ
$ns duplex-link $n3 $n2 1Mb 10ms DropTail

$ns queue-limit $n2 $n3 20

set qmon [$ns monitor-queue $n2 $n3 $q_f 0.1]

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link-op $n2 $n3 queuePos 0.5

set udp0 [new Agent/UDP]
$udp0 set class_ 1
$ns attach-agent $n0 $udp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$udp1 set class_ 2
$ns attach-agent $n1 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1

set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

$ns connect $udp0 $null0  
$ns connect $udp1 $null0

$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop"
$ns at 4.5 "$cbr0 stop"

for {set i 0} {$i < 5} {set i [expr $i+.5]} {
        $ns at $i "qout"
}

$ns at 5.0 "finish"

$ns run
