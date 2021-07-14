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

$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

set sendudp [new Agent/UDP]

$ns attach-agent $n0 $sendudp
set rec_udp [new Agent/Null]
$ns attach-agent $n2 $rec_udp
$ns connect $sendudp $rec_udp

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $sendudp
$cbr set packetsize_ 1000
$cbr set rate_ 1Mb

$ns at 0.05 "$cbr start"
$ns at 3.5 "$cbr stop"

$ns at 4.0 "finish"

$ns run