#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
	#Close the trace file
        close $nf
	#Execute nam on the trace file
        exec nam out.nam &
        exit 0
}

#Create four nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]
set n12 [$ns node]
set n13 [$ns node]
set n14 [$ns node]
set n15 [$ns node]
set n16 [$ns node]
set n17 [$ns node]
set n18 [$ns node]
set n19 [$ns node]
set n20 [$ns node]
set n21 [$ns node]
set n22 [$ns node]

#Create links between the nodes
$ns duplex-link $n0 $n3 1Mb 10ms DropTail
$ns duplex-link $n1 $n3 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n20 1Mb 10ms DropTail
$ns duplex-link $n4 $n6 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n4 $n7 1Mb 10ms DropTail
$ns duplex-link $n4 $n20 1Mb 10ms DropTail
$ns duplex-link $n4 $n9 1Mb 10ms DropTail
$ns duplex-link $n7 $n9 1Mb 10ms DropTail
$ns duplex-link $n7 $n8 1Mb 10ms DropTail
$ns duplex-link $n9 $n10 1Mb 10ms DropTail
$ns duplex-link $n9 $n15 1Mb 10ms DropTail
$ns duplex-link $n9 $n20 1Mb 10ms DropTail
$ns duplex-link $n10 $n11 1Mb 10ms DropTail
$ns duplex-link $n12 $n10 1Mb 10ms DropTail
$ns duplex-link $n15 $n10 1Mb 10ms DropTail
$ns duplex-link $n12 $n13 1Mb 10ms DropTail
$ns duplex-link $n12 $n14 1Mb 10ms DropTail
$ns duplex-link $n12 $n16 1Mb 10ms DropTail
$ns duplex-link $n15 $n16 1Mb 10ms DropTail
$ns duplex-link $n15 $n19 1Mb 10ms DropTail
$ns duplex-link $n16 $n17 1Mb 10ms DropTail
$ns duplex-link $n16 $n18 1Mb 10ms DropTail
$ns duplex-link $n16 $n19 1Mb 10ms DropTail
$ns duplex-link $n19 $n20 1Mb 10ms DropTail
$ns duplex-link $n20 $n21 1Mb 10ms DropTail
$ns duplex-link $n20 $n22 1Mb 10ms DropTail

#Create a UDP agent and attach it to nodes
set udp0 [new Agent/UDP]
$udp0 set class_ 1
$ns attach-agent $n0 $udp0
set udp19 [new Agent/Null]
ns attach-agent $n19 $udp19
set udp7 [new Agent/UDP]
$ns attach-agent $n7 $udp7
$udp7 set class_ 2
set udp14 [new Agent/Null]
$ns attach-agent $n14 $udp14
set udp5 [new Agent/UDP]
$ns attach-agent $n5 $udp5
#$udp5 set class_ 3
set udp21 [new Agent/Null]
$ns attach-agent $n21 $udp21

#connection
$ns connect $udp0 $udp19
$ns connect $udp7 $udp14
$ns connect $udp5 $udp21

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp5
$cbr2 set packetSize_ 500
$cbr2 set interval_ 0.005
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp7
$cbr3 set packetSize_ 500
$cbr3 set interval_ 0.005

#disabling & enabling the link between nodes 3 & 20 (CBR1)
$ns rtmodel-at 0.5 down $n3 $n20
$ns rtmodel-at 1.5 up $n3 $n20
#Schedule events for the CBR agents
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 4.0 "$cbr2 stop"
$ns at 0.5 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run


