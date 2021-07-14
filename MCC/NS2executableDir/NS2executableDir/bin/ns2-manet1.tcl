#Filename: sample14.tcl

#*********************** MOBILIE ADHOC NETWORK *****************#
#****************** MOBILITY MODEL ***************************#

#**************************Multiple node Creation and communication model using UDP (User Datagram Protocol)and CBR (Constant Bit Rate)*******************#
# Simulator Instance Creation
set ns [new Simulator]

#Fixing the co-ordinate of simulation area
set val(x) 500
set val(y) 500
# Define options
set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 2 ;# number of mobilenodes
set val(rp) AODV ;# routing protocol
set val(x) 500 ;# X dimension of topography
set val(y) 500 ;# Y dimension of topography
set val(stop) 10.0 ;# time of simulation end

# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

# Node Creation

for {set i 0} {$i < 10} {incr i} {

set node_($i) [$ns node]
$node_($i) color black

}

#******************************Defining Communication Between node0 and all nodes ****************************
for {set i 1} {$i < 10} {incr i} {

# Defining a transport agent for sending
set udp [new Agent/UDP]

# Attaching transport agent to sender node
$ns attach-agent $node_($i) $udp

# Defining a transport agent for receiving
set null [new Agent/Null]

# Attaching transport agent to receiver node
$ns attach-agent $node_(0) $null

#Connecting sending and receiving transport agents
$ns connect $udp $null

#Defining Application instance
set cbr [new Application/Traffic/CBR]

# Attaching transport agent to application agent
$cbr attach-agent $udp

#Packet size in bytes and interval in seconds definition
$cbr set packetSize_ 512
$cbr set interval_ 0.1

# data packet generation starting time
$ns at 1.0 "$cbr start"

# data packet generation ending time
#$ns at 6.0 "$cbr stop"
}