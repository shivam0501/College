set ns [new Simulator]

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

$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 3Mb 10ms DropTail
$ns duplex-link $n2 $n3 4Mb 10ms DropTail
$ns duplex-link $n3 $n4 5Mb 10ms DropTail
$ns simplex-link $n0 $n7 6Mb 10ms DropTail
$ns simplex-link $n7 $n4 7Mb 10ms DropTail
$ns duplex-link $n0 $n5 8Mb 10ms DropTail
$ns duplex-link $n5 $n6 9Mb 10ms DropTail
$ns duplex-link $n6 $n4 1Mb 10ms DropTail

set sendudp [new Agent/UDP]

$ns attach-agent $n0 $sendudp
set rec_udp [new Agent/Null]
$ns attach-agent $n4 $rec_udp
$ns connect $sendudp $rec_udp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $sendudp
$cbr set packetsize_ 10000
$cbr set rate_ 1Mb

$ns at 0.02 "$cbr start"
$ns at 3.0 "$cbr stop"

$ns at 3.5 "finish"

$ns run