set ns [new Simulator]

#-----------creating nam object---------#

set nf [open tcp2.nam w]
$ns namtrace-all $nf
 
set nt [open tcp2.tr w]
$ns trace-all $nt

set proto rlm
 
$ns color 1 red
$ns color 2 blue

#---------- creating client- router- end server node----------------#

set Client1 [$ns node]
set Router1 [$ns node]
set Endserver1 [$ns node]
set Client2 [$ns node]
set Router2 [$ns node]

#---creating duplex link---------#

$ns duplex-link $Client1 $Router1 2Mb 50ms DropTail
$ns duplex-link $Router1 $Endserver1 100Kb 100ms DropTail
$ns duplex-link $Client2 $Router2 100Kb 50ms DropTail
$ns duplex-link $Router2 $Endserver1 100Kb 100ms DropTail

#----------------creating orientation------------------#

$ns duplex-link-op $Client1 $Router1 orient right
$ns duplex-link-op $Router1 $Endserver1 orient right
$ns duplex-link-op $Endserver1 $Router2 orient right
$ns duplex-link-op $Router2 $Client2 orient right

#------------Creating Labeling----------------#

$ns at 0.0 "$Client1 label Client1"
$ns at 0.0 "$Router1 label Router1"
$ns at 0.0 "$Endserver1 label Endserver1"
$ns at 0.0 "$Router2 label Router2"
$ns at 0.0 "$Client2 label Client2"

#-----------Configuring nodes------------#

$Endserver1 shape hexagon
$Router1 shape square
$Router2 shape square
#----------------Establishing queues---------#

$ns duplex-link-op $Client1 $Router1 queuePos 0.5
$ns duplex-link-op $Router1 $Endserver1 queuePos 0.5
$ns duplex-link-op $Client2 $Router2 queuePos 0.5
$ns duplex-link-op $Router2 $Endserver1 queuePos 0.5

#---------finish procedure--------#

proc finish {} {
 
global ns nf nt
$ns flush-trace
close $nf
puts "running nam..."
exec nam tcp2.nam &
exit 0
}

#Calling finish procedure

$ns at 5.0 "finish"
$ns run

 