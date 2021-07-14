#Create a simulator object
set ns [new Simulator]

$ns color 1 Red
$ns color 2 Blue

set namfile [open out.nam w]
$ns namtrace-all $namfile


#Define a 'finish' procedure
proc finish {} {
        global ns namfile
        $ns flush-trace
	#Close $namfile
	#Execute nam on the trace file
        exec nam out.nam &
        exit 0
}

#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail Mac/Csma/cs Channel]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 300Kb 100ms DropTail
$ns simplex-link $n3 $n2 300Kb 100ms DropTail

#Create a UDP agent and attach it to nodes
set sendn0 [new Agent/UDP]
$ns attach-agent $n0 $sendn0
set recn5 [new Agent/Null]
$ns attach-agent $n5 $recn5

$ns connect $sendn0 $recn5
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $sendn0
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 2Mb
$sendn0 set class_ 1

set sendn1 [new Agent/UDP]
$ns attach-agent $n1 $sendn1
set recn4 [new Agent/Null]
$ns attach-agent $n4 $recn4

$ns connect $sendn1 $recn4
set cbr2 [new Application/Traffic/CBR]
$cbr1 attach-agent $sendn1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 2Mb
$sendn0 set class_ 2

$ns at 0.5 "$cbr1 start"
$ns at 0.7 "$cbr2 start"
$ns at 2.5 "$cbr1 stop"
$ns at 2.7 "$cbr2 stop"
$ns at 3.0 "finish"
$ns run