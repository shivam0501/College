set ns [new Simulator]
#distance vector protocol
$ns rtproto DV

$ns color 1 Red
$ns color 2 Blue
$ns color 3 Green

set namfile [open out.nam w]
$ns namtrace-all $namfile


proc finish {} {
global ns namfile
$ns flush-trace
close $namfile
exec nam out.nam &
exit 0
}
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


$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n3 $n1 2Mb 10ms DropTail
$ns duplex-link $n3 $n2 2Mb 10ms DropTail
$ns duplex-link $n3 $n4 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n4 $n6 2Mb 10ms DropTail
$ns duplex-link $n4 $n7 2Mb 10ms DropTail
$ns duplex-link $n4 $n9 2Mb 10ms DropTail
$ns duplex-link $n7 $n8 2Mb 10ms DropTail
$ns duplex-link $n7 $n9 2Mb 10ms DropTail
$ns duplex-link $n9 $n10 2Mb 10ms DropTail
$ns duplex-link $n9 $n15 2Mb 10ms DropTail
$ns duplex-link $n10 $n11 2Mb 10ms DropTail
$ns duplex-link $n10 $n12 2Mb 10ms DropTail
$ns duplex-link $n12 $n13 2Mb 10ms DropTail
$ns duplex-link $n12 $n14 2Mb 10ms DropTail
$ns duplex-link $n12 $n16 2Mb 10ms DropTail
$ns duplex-link $n16 $n17 2Mb 10ms DropTail
$ns duplex-link $n16 $n18 2Mb 10ms DropTail
$ns duplex-link $n16 $n19 2Mb 10ms DropTail
$ns duplex-link $n19 $n20 2Mb 10ms DropTail
$ns duplex-link $n20 $n22 2Mb 10ms DropTail
$ns duplex-link $n20 $n21 2Mb 10ms DropTail
$ns duplex-link $n20 $n3 2Mb 10ms DropTail
$ns duplex-link $n4 $n20 2Mb 10ms DropTail
$ns duplex-link $n20 $n9 2Mb 10ms DropTail
$ns duplex-link $n9 $n15 2Mb 10ms DropTail
$ns duplex-link $n15 $n10 2Mb 10ms DropTail
$ns duplex-link $n15 $n19 2Mb 10ms DropTail
$ns duplex-link $n15 $n16 2Mb 10ms DropTail
$ns duplex-link $n4 $n20 2Mb 10ms DropTail

set sendudp1 [new Agent/UDP]

$ns attach-agent $n0 $sendudp1
set rec_udp1 [new Agent/Null]
$ns attach-agent $n19 $rec_udp1
$ns connect $sendudp1 $rec_udp1
$sendudp1 set class_ 1

set sendudp2 [new Agent/UDP]

$ns attach-agent $n7 $sendudp2
set rec_udp2 [new Agent/Null]
$ns attach-agent $n14 $rec_udp2
$ns connect $sendudp2 $rec_udp2
$sendudp2 set class_ 2

set sendudp3 [new Agent/UDP]

$ns attach-agent $n5 $sendudp3
set rec_udp3 [new Agent/Null]
$ns attach-agent $n21 $rec_udp3
$ns connect $sendudp3 $rec_udp3
$sendudp3 set class_ 3

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $sendudp1
$cbr1 set packetsize_ 1000
$cbr1 set rate_ 1Mb

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $sendudp2
$cbr2 set packetsize_ 1000
$cbr2 set rate_ 1Mb

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $sendudp3
$cbr3 set packetsize_ 1000
$cbr3 set rate_ 1Mb


#disabling & enabling the link between nodes 3 & 20 (CBR1)
$ns rtmodel-at 0.5 down $n3 $n20
$ns rtmodel-at 1.5 up $n3 $n20
$ns at 0.05 "$cbr1 start"
$ns at 3.5 "$cbr1 stop"

$ns at 0.05 "$cbr2 start"
$ns at 3.5 "$cbr2 stop"

$ns at 0.05 "$cbr3 start"
$ns at 3.5 "$cbr3 stop"

$ns at 4.0 "finish"

$ns run