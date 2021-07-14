remove-all-packet-headers       ; # removes all except common
add-packet-header Flags IP RTP TCP MPLS LDP ; # hdrs reqd for validation test
#Create a simulator object
set ns [new Simulator]
#Open the nam trace file
set nf [open erlspout.nam w]
$ns namtrace-all $nf
set f0 [open bwidth0.tr w]
set f1 [open bwidth1.tr w]
#set f2 [open erlspbwidth2.tr w]
#Define a 'finish' procedure
proc finish {} {
global ns nf f0 f1
$ns flush-trace
#Close the trace file
close $nf
#Execute nam on the trace file
exec nam erlspout.nam &
#exec xgraph bwidth0.tr bwidth1.tr -geometry 800x400 &
exit 0
}
# Insert your own code for topology creation
# and agent definitions, etc. here

Classifier/Addr/MPLS set control_driven_ 1
# Turn on all traces to stdout
Agent/LDP set trace_ldp_ 1
Classifier/Addr/MPLS set trace_mpls_ 1
#Node Definitions
set Node0 [$ns node]
set Node1 [$ns node]
#$ns node-config -MPLS ON
set LSR2 [$ns mpls-node]
set LSR3 [$ns mpls-node]
set LSR4 [$ns mpls-node]
set LSR5 [$ns mpls-node]
set LSR6 [$ns mpls-node]
set Node7 [$ns node]
set Node8 [$ns node]
#set Node9 [$ns node]
#set Node10 [$ns node]
#Link Definitions
$ns duplex-link $Node0 $LSR2 1.5Mb 10ms DropTail
$ns duplex-link $Node1 $LSR2 1Mb 10ms DropTail
$ns duplex-link $LSR2 $LSR3 1.5Mb 10ms DropTail
$ns duplex-link $LSR3 $LSR6 1.5Mb 10ms DropTail
$ns duplex-link $LSR2 $LSR4 1Mb 10ms DropTail
$ns duplex-link $LSR4 $LSR5 1Mb 10ms DropTail
$ns duplex-link $LSR5 $LSR6 1Mb 10ms DropTail
$ns duplex-link $LSR6 $Node7 1.5Mb 10ms DropTail
$ns duplex-link $LSR6 $Node8 1Mb 10ms DropTail
#$ns duplex-link $Node9 $LSR2 1Mb 10ms DropTail
#$ns duplex-link $Node10 $LSR6 1Mb 10ms DropTail
$ns duplex-link-op $Node0 $LSR2 orient right-down
$ns duplex-link-op $Node1 $LSR2 orient right
#$ns duplex-link-op $Node9 $LSR2 orient right-up
$ns duplex-link-op $LSR2 $LSR3 orient right-up
$ns duplex-link-op $LSR3 $LSR6 orient right-down
$ns duplex-link-op $LSR2 $LSR4 orient down
$ns duplex-link-op $LSR4 $LSR5 orient right
$ns duplex-link-op $LSR5 $LSR6 orient up
$ns duplex-link-op $LSR6 $Node7 orient right-up
$ns duplex-link-op $LSR6 $Node8 orient right
#$ns duplex-link-op $Node10 $LSR6 orient right-down
#creating agents and attaching them to the nodes
#Between Node0 ------------ Node7 4mbps traffic
set udp0 [new Agent/UDP]
$ns attach-agent $Node0 $udp0
set Src0 [new Application/Traffic/CBR]
#$Src0 set packetSize_ 5000
#$Src0 set interval 0.0
$Src0 attach-agent $udp0
set Src3 [new Application/Traffic/CBR]
#$Src3 set packetSize_ 5000
#$Src3 set interval 0.0
$Src3 attach-agent $udp0
set Dst0 [new Agent/LossMonitor]
$ns attach-agent $Node7 $Dst0
$ns connect $udp0 $Dst0
#Between Node1 ------------ Node8 3mbps traffic
set udp1 [new Agent/UDP]
$ns attach-agent $Node1 $udp1
set Src1 [new Application/Traffic/CBR]
#$Src1 set packetSize_ 5000
#$Src1 set interval 0.0000167
$Src1 attach-agent $udp1
set Src4 [new Application/Traffic/CBR]
#$Src4 set packetSize_ 5000
#$Src4 set interval 0.0
$Src4 attach-agent $udp0
set Dst1 [new Agent/LossMonitor]
$ns attach-agent $Node8 $Dst1
$ns connect $udp1 $Dst1
#Between Node9 ------------ Node10 4mbps traffic
#set udp2 [new Agent/UDP]
#$ns attach-agent $Node9 $udp2
#set Src2 [new Application/Traffic/CBR]
#$Src2 set packetSize_ 5000
#$Src2 set interval 0.0000125
#$Src2 attach-agent $udp2
#set Dst2 [new Agent/LossMonitor]
#$ns attach-agent $Node10 $Dst2
#$ns connect $udp2 $Dst2
$ns color 1 Green
$ns color 2 Pink
$udp0 set fid_ 1
$udp1 set fid_ 2
proc record {} {
global Dst0 Dst1 nf f0 f1
set ns [Simulator instance]
#Set the time after which the procedure should be called again
set time 0.5
#How many bytes have been received by the traffic sinks?
set bw0 [$Dst0 set bytes_]
set bw1 [$Dst1 set bytes_]
#Get the current time
set now [$ns now]
#Calculate the bandwidth (in MBit/s) and write it to the files
puts $f0 "$now [expr $bw0/$time*8/1000000]"
puts $f1 "$now [expr $bw1/$time*8/1000000]"
#Reset the bytes_ values on the traffic sinks
$Dst0 set bytes_ 0
$Dst1 set bytes_ 0
#Re-schedule the procedure
$ns at [expr $now+$time] "record"
}
# Creating Ldp Agent on all the MPLSnodes
for {set i 2} {$i < 7} {incr i} {
		for {set j [expr $i+1]} {$j < 7} {incr j} {
			set a LSR$i
			set b LSR$j
			eval $ns LDP-peer $$a $$b
		}
	}
#$ns configure-ldp-on-all-mpls-nodes
[$LSR2 get-module "MPLS"] enable-control-driven
[$LSR3 get-module "MPLS"] enable-control-driven
[$LSR4 get-module "MPLS"] enable-control-driven
[$LSR5 get-module "MPLS"] enable-control-driven
[$LSR6 get-module "MPLS"] enable-control-driven
#[$LSR7 get-module "MPLS"] enable-control-driven
#[$LSR8 get-module "MPLS"] enable-control-driven

# setting colors to different msg type
$ns ldp-request-color blue
$ns ldp-mapping-color red
$ns ldp-withdraw-color gray80
$ns ldp-release-color orange
$ns ldp-notification-color yellow

Classifier/Addr/MPLS enable-on-demand
Classifier/Addr/MPLS enable-ordered-control

# Setting trigger Scheme
$ns mpls-node enable-data-driven
#$ns LDP-peer $LSR2 $LSR3
#$ns LDP-peer $LSR3 $LSR6
#$ns LDP-peer $LSR2 $LSR4
#$ns LDP-peer $LSR4 $LSR5
#$ns LDP-peer $LSR5 $LSR6
for {set i 2} {$i < 7} {incr i} {
set a LSR$i
set m [eval $$a get-module "MPLS"]
eval set LSR$i $m
}
$ns at 0.0 "record"
$ns at 0.1 "$Src0 start"
$ns at 0.1 "$Src1 start"
#$ns at 0.1 "$Src2 start"
$ns at 0.1 "$Src3 start"
$ns at 0.1 "$Src4 start"
$ns at 0.2 "$LSR6 ldp-trigger-by-withdraw 7 -1"
$ns at 0.2 "$LSR6 ldp-trigger-by-withdraw 8 -1"
$ns at 0.3 "$LSR2 flow-aggregation 7 -1 6 -1"
$ns at 0.3 "$LSR2 flow-aggregation 8 -1 6 -1"
#$ns at 0.5 "$LSR6 send-ldp-withdraw-msg 6"
$ns at 0.3 "$LSR2 make-explicit-route 6 2_4_5_6 3600 -1"
$ns at 0.4 "$LSR2 flow-erlsp-install 8 -1 3600"
$ns at 3.1 "$LSR2 ldp-trigger-by-release 6 3600"
$ns at 0.4 "$LSR2 make-explicit-route 6 2_4_5_6 3700 -1"
$ns at 3.2 "$LSR2 flow-erlsp-install 7 -1 3700"
$ns at 4.5 "$LSR2 ldp-trigger-by-release 7 3700"
#Call the finish procedure after 5 seconds simulation time
$ns at 5.0 "finish"
#Run the simulation
$ns run
