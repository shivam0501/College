set ns [new Simulator]
$ns rtproto DV

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red

#Open the Trace files
set file1 [open out.tr w]
#set winfile [open WinFile w]
$ns trace-all $file1

#Open the NAM trace file
set file2 [open out.nam w]
$ns namtrace-all $file2

#Define a 'finish' procedure
proc finish {} {
        global ns file1 file2
        $ns flush-trace
        close $file1
        close $file2
        exec nam out.nam &
        exit 0
} 
 
for {set i 0} {$i < 7} {incr i} {
    set n($i) [$ns node]
  }
 
	 for {set i 0} {$i < 7} {incr i} {
   $ns duplex-link $n($i) $n([expr ($i+1)%7]) 1Mb 10ms DropTail
 }

 #Create a UDP agent and attach it to node n(0)
 set udp0 [new Agent/UDP]
 $ns attach-agent $n(0) $udp0
 
 # Create a CBR traffic source and attach it to udp0
 set cbr0 [new Application/Traffic/CBR]
 $cbr0 set packetSize_ 500
 $cbr0 set interval_ 0.005
 $cbr0 attach-agent $udp0

 set null0 [new Agent/Null]
  $ns attach-agent $n(3) $null0
  
  $ns connect $udp0 $null0
  
  $ns at 0.5 "$cbr0 start"
  $ns at 4.5 "$cbr0 stop"
 
 $ns rtmodel-at 1.0 down $n(1) $n(2)
 $ns rtmodel-at 2.0 up $n(1) $n(2)
 $ns rtproto DV

	$ns compute-routes
	$ns get-routelogic
        $ns dump-routelogic-distance
	$ns dump-routelogic-nh
        set f1 [open try w]
        $ns dump-routes $f1
        close $f1        

 $ns at 125.0 "finish"
        
 $ns run


