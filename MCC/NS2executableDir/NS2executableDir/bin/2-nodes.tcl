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


$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail


$ns at 4.0 "finish"

$ns run