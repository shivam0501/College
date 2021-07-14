set ns [new Simulator]
$ns node
$ns color 1 Blue
$ns color 2 Red
set file1 [open out.tr w]
$ns trace-all $file1
set file2 [open out.nam w]
$ns namtrace-all $file2
proc finish {} {
        global ns file1 file2
        $ns flush-trace
        close $file1
        close $file2
        exec nam out.nam &
        exit 0
} 
for {set i 0} {$i < 4} {incr i} {
    set n($i) [$ns node]
  }
 
 for {set i 0} {$i < 4} {incr i} {
   $ns duplex-link $n($i) $n([expr ($i+1)%4]) 1Mb 10ms DropTail
 }


$ns rtproto Manual

$n(0) add-route $n(2) $n(3)
$n(0) add-route $n(1) $n(1)
$n(0) add-route $n(3) $n(3)
$n(1) add-route $n(0) $n(0)
$n(1) add-route $n(2) $n(2)
$n(2) add-route $n(1) $n(1)
$n(2) add-route $n(3) $n(3)


#$ns dump-routelogic-nh


$ns at 125.0 "finish"
	

 $ns run


