set ns [new Simulator]
$ns rtproto Manual
set n1 [$ns node]
set n2 [$ns node]
$ns duplex-link $n1 $n2 10Mb 100ms DropTail
#$ns get-routelogic
[$n1 get-module "Manual"] add-route-to-adj-node -default $n2
[$n2 get-module "Manual"] add-route-to-adj-node -default $n1
$ns compute-routes
$ns dump-routelogic-nh
$ns run