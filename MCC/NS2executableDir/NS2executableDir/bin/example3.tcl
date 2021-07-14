set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}
# Create nodes
set mn [$ns node]
set ns_drv [$ns node]
set eth0 [$ns node]
set eth1 [$ns node]
set router0 [$ns node]
set router1 [$ns node]
set ns_gw [$ns node]
set correspondent [$ns node]

#Create a duplex link between the nodes
$ns duplex-link $mn $ns_drv 100Mb 10ms DropTail
$ns duplex-link $ns_drv $eth0 36Kbps 10ms DropTail # GPRS 
$ns duplex-link $ns_drv $eth1 11Mb 10ms DropTail # WiFi
$ns duplex-link $eth0 $router0 1Mb 10ms DropTail
$ns duplex-link $eth1 $router1 1Mb 10ms DropTail
$ns duplex-link $router0 $ns_gw 1Mb 10ms DropTail
$ns duplex-link $router1 $ns_gw 1Mb 10ms DropTail
$ns duplex-link $ns_gw $correspondent 100Mb 10ms DropTail

# Setup a FTP session between Mobile 
#Correspondent Nodes

# Attach TCP agent to Mobile Node
set tcp [new Agent/TCP]
$ns attach-agent $mn $tcp

# Attach FTP agent to Mobile Node?s TCP agent
set FTP [new Application/FTP]
$FTP attach-agent $tcp
$FTP set type_ FTP

# Attach a FTP sink to the correspondent node
set correspondent_agent [new Agent/TCPSink]
$ns attach-agent $correspondent $correspondent_agent

# Connect Mobile Node?s TCP and Correspondents Sink agents
$ns connect $tcp $correspondent_agent

# Schedule FTP Events ? passing commands to agents
$ns at 0.00 "$FTP start"
# take link down for eth0 (WiFi)
$ns rtmodel-at 1.00 down $eth0 $router0
$ns rtmodel-at 1.00 down $eth0 $ns_drv
$ns at 3.00 "$FTP stop"




$ns at 3.1 "finish"

$ns run
$ns dump-routelogic-nh"

