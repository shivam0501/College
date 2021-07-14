set ns [new Simulator]
$ns rtproto Manual
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

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n1 $n2 10Mb 100ms DropTail
$ns duplex-link $n2 $n3 10Mb 100ms DropTail
$ns duplex-link $n3 $n4 10Mb 100ms DropTail
$ns duplex-link $n4 $n1 10Mb 100ms DropTail

$ns cost $n1 $n2 10 
$ns cost $n2 $n1 5 
[$ns link $n1 $n2] cost? 
[$ns link $n2 $n1] cost?

[$n1 get-module "Manual"] add-route-to-adj-node -default $n4
[$n1 get-module "Manual"] add-route-to-adj-node -default $n2
[$n2 get-module "Manual"] add-route-to-adj-node -default $n3
[$n3 get-module "Manual"] add-route-to-adj-node -default $n4
[$n4 get-module "Manual"] add-route-to-adj-node -default $n1



#Create a UDP agent and attach it to node n(0)
 set udp1 [new Agent/UDP]
 $ns attach-agent $n1 $udp1
 
 # Create a CBR traffic source and attach it to udp0
 set cbr1 [new Application/Traffic/CBR]
 $cbr1 set packetSize_ 500
 $cbr1 set interval_ 0.05
 $cbr1 attach-agent $udp1

 set null1 [new Agent/Null]
  $ns attach-agent $n4 $null1
  
  $ns connect $udp1 $null1
  
  $ns at 0.5 "$cbr1 start"
  $ns at 4.5 "$cbr1 stop"
$ns rtmodel-at 1.0 down $n1 $n2
 
puts "testing"

$ns at 25.0 "finish"
$ns run