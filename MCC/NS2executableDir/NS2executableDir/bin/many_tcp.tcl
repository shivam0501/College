 # many_tcp.tcl
 # $Id: many_tcp.tcl,v 1.18 2000/09/14 18:19:26 haoboy Exp $
00005 #
00006 # Copyright (c) 1998 University of Southern California.
00007 # All rights reserved.                                            
00008 #                                                                
00009 # Redistribution and use in source and binary forms are permitted
00010 # provided that the above copyright notice and this paragraph are
00011 # duplicated in all such forms and that any documentation, advertising
00012 # materials, and other materials related to such distribution and use
00013 # acknowledge that the software was developed by the University of
00014 # Southern California, Information Sciences Institute.  The name of the
00015 # University may not be used to endorse or promote products derived from
00016 # this software without specific prior written permission.
00017 # 
00018 # THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
00019 # WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
00020 # MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
00021 # 
00022 
00023 proc usage {} {
00024         puts stderr {usage: ns rbp_simulation.tcl [options]
00025 
00026 This simulation demonstrates large numbers of TCP flows.
00027 Comments/bugs to John Heidemann <johnh@isi.edu>.
00028 
00029 Currently this simulation appears to be memory limited for most
00030 practical purposes.  Each active flow consumes ~100KB of memory (very
00031 roughly).
00032 
00033 Why is a flow so expensive?  Primarly because We allocate a separate
00034 pair of nodes and links per flow.  (I don't know how to do otherwise
00035 and preserve some reasonable statement about the independence of
00036 randomly selected client RTTs).
00037 
00038 How can performance be improved?
00039 
00040 - use multiple concurrent flows per node (should give much better
00041 memory performance at the cost of node RTT independence)
00042 
00043 - use session-level simulation techniques (see ``Enabling Large-scale
00044 simulations: selective abstraction approach to the study of multicast
00045 protocols'' by Huang, Estrin, and Heidemann in MASCOTS '98).
00046 
00047 - improve the efficiency of the underlying representations (there are
00048 some ways to optimize some otcl common cases)  (this work is in progress)
00049 
00050 - use higher level representations of TCP (in progress)
00051 
00052 
00053 Options (specify with -OPTIONNAME OPTIONVALUE):
00054 }
00055         global raw_opt_info
00056         puts stderr $raw_opt_info
00057         exit 1
00058 }
00059 
00060 global raw_opt_info
00061 set raw_opt_info {
00062         # how long to run the sim?
00063         duration 30
00064 
00065         # initilization: just start n clients at time 0
00066         # NEEDSWORK:  a more realistic ramp-up model
00067         # or some kind of autodetection on when we've reached
00068         # steady state would be nice.
00069         initial-client-count 10
00070 
00071         #
00072         # BASIC TOPOLOGY:
00073         #
00074         # (The basic n clients on the left and right going through a
00075         # bottleneck.)
00076         #
00077         # cl_1                                                     cr_1
00078         # ...     ---- bottleneck_left ---- bottleneck_right ---   ...
00079         # cl_n                                                     cr_n
00080         #
00081         # node-number 0 specifies a new pair of nodes
00082         # on the left and right for each new client
00083         node-number 0
00084         # NEEDSWORK:
00085         # The number of agents attached to a node cannot exceed
00086         # the port-field length (255 bits).  There is currently
00087         # no check or warning message for this.
00088         #
00089         # Currently all data traffic flows left-to-right.
00090         # NEEDSWORK: relax this assumption (but Poduri and Nichols
00091         # I-D suggests that relaxing it won't change things much).
00092         #
00093 
00094         #
00095         # CLIENT TRAFFIC MODEL:
00096         #
00097         # arrival rate per second (arrival is poisson)
00098         client-arrival-rate 1
00099         # Currently clients are either mice or elephants.
00100         # NEEDSWORK:  should better model http-like traffic patterns.
00101         # In particular, netscape's 4-connection model makes
00102         # a *big* difference in traffic patterns
00103         # and is not currently modeled at all.
00104         client-mouse-chance 90
00105         client-mouse-packets 10
00106         client-elephant-packets 100
00107         # For traffic in the reverse direction.
00108         client-reverse-chance 0
00109         # Pkt size in bytes.
00110         # NEEDSWORK:  should check that everything is uniformly
00111         # specified (router queues are in packets of 1000B length?).
00112         client-pkt-size 576
00113 
00114         #
00115         # CLIENT NETWORK CONNECTION:
00116         #
00117         client-bw 56kb
00118         # client-server rtt is uniform over this range (currently)
00119         # NEEDSWORK:  does this need to be modeled more accurately?
00120         client-delay random
00121         client-delay-range 100ms
00122         client-queue-method DropTail
00123         # Insure that client routers are never a bottleneck.
00124         client-queue-length 100
00125 
00126         #
00127         # CLIENT/SERVER TCP IMPLEMENTATION:
00128         #
00129         # NEEDSWORK: should add HTTP model over TCP.
00130         source-tcp-method TCP/Reno
00131         sink-ack-method TCPSink/DelAck
00132         # Set init-win to 1 for initial windows of size 1.
00133         # Set init-win to 10 for initial windows of 10 packets.
00134         # Set init-win to 0 for initial windows per internet-draft.
00135         init-win 1
00136 
00137         #
00138         # BOTTLENECK LINK MODEL:
00139         #
00140         bottle-bw 10Mb
00141         bottle-delay 4ms
00142         bottle-queue-method RED
00143         # bottle-queue-length is either in packets or
00144         # is "bw-delay-product" which does the currently
00145         # expected thing.
00146         bottle-queue-length bw-delay-product
00147 
00148         #
00149         # OUTPUT OPTIONS:
00150         #
00151         graph-results 0
00152         # Set graph-scale to 2 for "rows" for each flow.
00153         graph-scale 1
00154         graph-join-queueing 1
00155         gen-map 0
00156         mem-trace 0
00157         print-drop-rate 0
00158         debug 1
00159         title none
00160         # set test-suite to write the graph to opts(test-suite-file)
00161         test-suite 0
00162         test-suite-file temp.rands
00163                    
00164         # Random number seed; default is 0, so ns will give a 
00165         # diff. one on each invocation.
00166         ns-random-seed 0
00167         
00168         # Animation options; complete traces are useful
00169         # for nam only, so do those only when a tracefile
00170         # is being used for nam
00171         # Set trace-filename to "none" for no tracefile.
00172         trace-filename out
00173         trace-all 0
00174         namtrace-some 0
00175         namtrace-all 0
00176         
00177         # Switch to generate the nam tcl file from here
00178         # itself
00179         nam-generate-cmdfile 0
00180 }
00181 
00182 Class Main
00183 
00184 Main instproc default_options {} {
00185         global opts opt_wants_arg raw_opt_info
00186         set cooked_opt_info $raw_opt_info
00187 
00188         while {$cooked_opt_info != ""} {
00189                 if {![regexp "^\[^\n\]*\n" $cooked_opt_info line]} {
00190                         break
00191                 }
00192                 regsub "^\[^\n\]*\n" $cooked_opt_info {} cooked_opt_info
00193                 set line [string trim $line]
00194                 if {[regexp "^\[ \t\]*#" $line]} {
00195                         continue
00196                 }
00197                 if {$line == ""} {
00198                         continue
00199                 } elseif [regexp {^([^ ]+)[ ]+([^ ]+)$} $line dummy key value] {
00200                         set opts($key) $value
00201                         set opt_wants_arg($key) 1
00202                 } else {
00203                         set opt_wants_arg($key) 0
00204                         # die "unknown stuff in raw_opt_info\n"
00205                 }
00206         }
00207 }
00208 
00209 Main instproc process_args {av} {
00210         global opts opt_wants_arg
00211 
00212         $self default_options
00213         for {set i 0} {$i < [llength $av]} {incr i} {
00214                 set key [lindex $av $i]
00215                 if {$key == "-?" || $key == "--help" || $key == "-help" || $key == "-h"} {
00216                         usage
00217                 }
00218                 regsub {^-} $key {} key
00219                 if {![info exists opt_wants_arg($key)]} {
00220                         puts stderr "unknown option $key";
00221                         usage
00222                 }
00223                 if {$opt_wants_arg($key)} {
00224                         incr i
00225                         set opts($key) [lindex $av $i]
00226                 } else {
00227                         set opts($key) [expr !opts($key)]
00228                 }
00229         }
00230 }
00231 
00232 
00233 proc my-duplex-link {ns n1 n2 bw delay queue_method queue_length} {
00234         global opts 
00235 
00236         $ns duplex-link $n1 $n2 $bw $delay $queue_method
00237         $ns queue-limit $n1 $n2 $queue_length
00238         $ns queue-limit $n2 $n1 $queue_length
00239 }
00240 
00241 Main instproc init_network {} {
00242         global opts fmon
00243         # nodes
00244         # build right to left
00245         $self instvar bottle_l_ bottle_r_ cs_l_ cs_r_ ns_ cs_count_ ns_ clients_started_ clients_finished_ 
00246 
00247         #
00248         # Figure supported load.
00249         #
00250         set expected_load_per_client_in_bps [expr ($opts(client-mouse-chance)/100.0)*$opts(client-mouse-packets)*$opts(client-pkt-size)*8 + (1.0-$opts(client-mouse-chance)/100.0)*$opts(client-elephant-packets)*$opts(client-pkt-size)*8]
00251         if {$opts(debug)} {
00252                 set max_clients_per_second [expr [$ns_ bw_parse $opts(bottle-bw)]/$expected_load_per_client_in_bps]
00253                 puts [format "maximum clients per second: %.3f" $max_clients_per_second]
00254         }
00255 
00256         # Compute optimal (?) bottleneck queue size
00257         # as the bw-delay product.
00258         if {$opts(bottle-queue-length) == "bw-delay-product"} {
00259                 set opts(bottle-queue-length) [expr ([$ns_ bw_parse $opts(bottle-bw)] * ([$ns_ delay_parse $opts(bottle-delay)] + [$ns_ delay_parse $opts(client-delay-range)]) + $opts(client-pkt-size)*8 - 1)/ ($opts(client-pkt-size) * 8)]
00260                 puts "optimal bw queue size: $opts(bottle-queue-length)"
00261         }
00262 
00263         # Do our own routing with expanded addresses (21 bits nodes).
00264         # (Basic routing limits us to 128 nodes == 64 clients).
00265         $ns_ rtproto Manual
00266         $ns_ set-address-format expanded
00267 
00268         # set up the bottleneck
00269         set bottle_l_ [$ns_ node]
00270         set bottle_r_ [$ns_ node]
00271         my-duplex-link $ns_ $bottle_l_ $bottle_r_ $opts(bottle-bw) $opts(bottle-delay) $opts(bottle-queue-method) $opts(bottle-queue-length)
00272         if {$opts(print-drop-rate)} {
00273                 set slink [$ns_ link $bottle_l_ $bottle_r_]
00274                 set fmon [$ns_ makeflowmon Fid]
00275                 $ns_ attach-fmon $slink $fmon
00276         }
00277 
00278         # Bottlenecks need large routing tables.
00279 #       [$bottle_l_ set classifier_] resize 511
00280 #       [$bottle_r_ set classifier_] resize 511
00281 
00282         # Default routes to the other.
00283         [$bottle_l_ get-module "Manual"] add-route-to-adj-node -default $bottle_r_
00284         [$bottle_r_ get-module "Manual"] add-route-to-adj-node -default $bottle_l_
00285 
00286         # Clients are built dynamically.
00287         set cs_count_ 0
00288         set clients_started_ 0
00289         set clients_finished_ 0
00290 }
00291 
00292 # create a new pair of end nodes
00293 Main instproc create_client_nodes {node} {
00294         global opts 
00295         $self instvar bottle_l_ bottle_r_ cs_l_ cs_r_ sources_ cs_count_ ns_ rng_
00296 
00297         set now [$ns_ now]
00298         set cs_l_($node) [$ns_ node]
00299         set cs_r_($node) [$ns_ node]
00300 
00301         # Set delay.
00302         set delay $opts(client-delay)
00303         if {$delay == "random"} {
00304                 set delay [$rng_ exponential [$ns_ delay_parse $opts(client-delay-range)]]
00305         }
00306         # Now divide the delay into the two haves and set up the network.
00307         set ldelay [$rng_ uniform 0 $delay]
00308         set rdelay [expr $delay - $ldelay]
00309 
00310         my-duplex-link $ns_ $cs_l_($node) $bottle_l_ $opts(client-bw) $ldelay $opts(client-queue-method) $opts(client-queue-length)
00311         my-duplex-link $ns_ $cs_r_($node) $bottle_r_ $opts(client-bw) $rdelay $opts(client-queue-method) $opts(client-queue-length)
00312 
00313         # Add routing in all directions
00314         [$cs_l_($node) get-module "Manual"] add-route-to-adj-node -default $bottle_l_
00315         [$cs_r_($node) get-module "Manual"] add-route-to-adj-node -default $bottle_r_
00316         [$bottle_l_ get-module "Manual"] add-route-to-adj-node $cs_l_($node)
00317         [$bottle_r_ get-module "Manual"] add-route-to-adj-node $cs_r_($node)
00318 
00319         if {$opts(debug)} {
00320                  # puts "t=[format %.3f $now]: node pair $node created"
00321                  # puts "delay $delay ldelay $ldelay"
00322         }
00323 }
00324 
00325 # Get the number of the node pair
00326 Main instproc get_node_number { client_number } {
00327         global opts
00328         if {$opts(node-number) > 0} {
00329                 set node [expr $client_number % $opts(node-number)]
00330         } else {
00331                 set node $client_number
00332         }
00333         return $node
00334 }
00335 
00336 # return the client index
00337 Main instproc create_a_client {} {
00338         global opts
00339         $self instvar cs_l_ cs_r_ sources_ cs_count_ ns_ rng_
00340 
00341         # Get the client number for the new client.
00342         set now [$ns_ now]
00343         set i $cs_count_
00344         incr cs_count_
00345         set node $i
00346         if {[expr $i % 100] == 0} {
00347                 puts "t=[format %.3f $now]: client $i created"
00348         }
00349 
00350         # Get the source and sink nodes.
00351         if {$opts(node-number) > 0} {
00352                 if {$node < $opts(node-number) } {
00353                         $self create_client_nodes $node
00354                 } else {
00355                         set node [$self get_node_number $i]
00356                 }
00357         } else {
00358                 $self create_client_nodes $node
00359         }
00360         if {$opts(debug)} {
00361                 # puts "t=[format %.3f $now]: client $i uses node pair $node"
00362         }
00363         
00364         # create sources and sinks in both directions
00365         # (actually, only one source per connection, for now)
00366         if {[$rng_ integer 100] < $opts(client-reverse-chance)} {
00367                 set sources_($i) [$ns_ create-connection-list $opts(source-tcp-method) $cs_r_($node) $opts(sink-ack-method) $cs_l_($node) $i]
00368         } else {
00369                 set sources_($i) [$ns_ create-connection-list $opts(source-tcp-method) $cs_l_($node) $opts(sink-ack-method) $cs_r_($node) $i]
00370         }
00371         [lindex $sources_($i) 0] set maxpkts_ 0
00372         [lindex $sources_($i) 0] set packetSize_ $opts(client-pkt-size)
00373 
00374         # Set up a callback when this client ends.
00375         [lindex $sources_($i) 0] proc done {} "$self finish_a_client $i"
00376 
00377         if {$opts(debug)} {
00378                 # puts "t=[$ns_ now]: client $i created"
00379         }
00380 
00381         return $i
00382 }
00383 
00384 #
00385 # Make a batch of clients to amortize the cost of routing recomputation
00386 # (actually no longer improtant).
00387 #
00388 Main instproc create_some_clients {} {
00389         global opts
00390         $self instvar idle_clients_ ns_ cs_count_
00391 
00392         set now [$ns_ now]
00393         set step 16
00394         if {$opts(debug)} {
00395                 puts "t=[format %.3f $now]: creating clients $cs_count_ to [expr $cs_count_ + $step - 1]"
00396         }
00397 
00398         for {set i 0} {$i < $step} {incr i} {
00399                 lappend idle_clients_ [$self create_a_client]
00400         }
00401 
00402         # debugging:
00403         # puts "after client_create:"
00404         # $ns_ gen-map
00405         # $self instvar bottle_l_ bottle_r_
00406         # puts "bottle_l_ classifier_:"
00407         # [$bottle_l_ set classifier_] dump
00408         # puts "bottle_r_ classifier_:"
00409         # [$bottle_r_ set classifier_] dump
00410 }
00411 
00412 Main instproc start_a_client {} {
00413         global opts
00414         $self instvar idle_clients_ ns_ sources_ rng_ source_start_ source_size_ clients_started_
00415 
00416         set i ""
00417         set now [$ns_ now]
00418         # can we reuse a dead client?
00419         if {![info exists idle_clients_]} {
00420                 set idle_clients_ ""
00421         }
00422         while {$idle_clients_ == ""} {
00423                 $self create_some_clients
00424         }
00425         set i [lindex $idle_clients_ 0]
00426         set idle_clients_ [lrange $idle_clients_ 1 end]
00427 
00428         # Reset the connection.
00429         [lindex $sources_($i) 0] reset
00430         [lindex $sources_($i) 1] reset 
00431 
00432         # Start traffic for that client.
00433         if {[$rng_ integer 100] < $opts(client-mouse-chance)} {
00434                 set len $opts(client-mouse-packets)
00435         } else {
00436                 set len $opts(client-elephant-packets)
00437         }
00438 
00439         [lindex $sources_($i) 0] advanceby $len
00440         set source_start_($i) $now
00441         set source_size_($i) $len
00442 
00443         if {$opts(debug)} {
00444                  # puts "t=[$ns_ now]: client $i started, ldelay=[format %.6f $ldelay], rdelay=[format %.6f $rdelay]"
00445                 puts "t=[format %.3f $now]: client $i started"
00446         }
00447         incr clients_started_
00448 }
00449 
00450 Main instproc finish_a_client {i} {
00451         global opts
00452         $self instvar ns_ idle_clients_ source_start_ source_size_ clients_finished_
00453 
00454         set now [$ns_ now]
00455         if {$opts(debug)} {
00456                 set delta [expr $now - $source_start_($i)]
00457                 puts "t=[format %.3f $now]: client $i finished ($source_size_($i) pkts, $delta s)"
00458         }
00459 
00460         lappend idle_clients_ $i
00461         incr clients_finished_
00462 }
00463 
00464 Main instproc schedule_continuing_traffic {} {
00465         global opts
00466         $self instvar ns_ rng_
00467 
00468         $self start_a_client
00469         # schedule the next one
00470         set next [expr [$ns_ now]+([$rng_ exponential]/$opts(client-arrival-rate))]
00471         if {$opts(debug)} {
00472                 # puts "t=[$ns_ now]: next continuing traffic at $next"
00473         }
00474         $ns_ at $next "$self schedule_continuing_traffic"
00475 }
00476 
00477 Main instproc schedule_initial_traffic {} {
00478         global opts
00479 
00480         # Start with no pending clients.
00481         $self instvar idle_clients_
00482 
00483         # Start initial clients.
00484         for {set i 0} {$i < $opts(initial-client-count)} {incr i} {
00485                 $self start_a_client
00486         }
00487 }
00488 
00489 Main instproc open_trace { stop_time } {
00490         global opts
00491         $self instvar ns_ trace_file_ nam_trace_file_ trace_filename_
00492         set trace_filename_ $opts(trace-filename)
00493         exec rm -f "$trace_filename_.tr"
00494         set trace_file_ [open "$trace_filename_.tr" w]
00495         set stop_actions "close $trace_file_"
00496         if {$opts(namtrace-some) || $opts(namtrace-all)} {
00497                 exec rm -f "$trace_filename_.nam"
00498                 set nam_trace_file_ [open "$trace_filename_.nam" w]
00499                 set $stop_actions "$stop_actions; close $nam_trace_file_"
00500         } else {
00501                 set nam_trace_file_ ""
00502         }
00503         $ns_ at $stop_time "$stop_actions; $self finish"
00504         return "$trace_file_ $nam_trace_file_"
00505 }
00506 
00507 # There seems to be a problem with the foll function, so quit plotting 
00508 # with -a -q, use just -a.
00509 
00510 Main instproc finish {} {
00511         global opts fmon PERL
00512         $self instvar trace_filename_ ns_ cs_count_ clients_started_ clients_finished_
00513 
00514         puts "total clients started: $clients_started_"
00515         puts "total clients finished: $clients_finished_"
00516         if {$opts(print-drop-rate)} {
00517                 set drops [$fmon set pdrops_]
00518                 set pkts [$fmon set parrivals_]
00519                 puts "total_drops $drops total_packets $pkts"
00520                 set droprate [expr 100.0*$drops / $pkts ]
00521                 puts [format "drop_percentage %7.4f" $droprate]
00522         }
00523         if {$opts(trace-filename) != "none"} {
00524                 set title $opts(title)
00525                 set flow_factor 1
00526                 if {$opts(graph-scale) == "2"} {
00527                         set flow_factor 100
00528                 }
00529                 # Make sure that we run in place even without raw2xg in our path
00530                 # (for the test suites).
00531                 set raw2xg raw2xg
00532                 if [file exists ../../bin/raw2xg] {
00533                         set raw2xg ../../bin/raw2xg
00534                 }
00535                 set raw2xg_opts ""
00536                 if {$opts(graph-join-queueing)} {
00537                         set raw2xg_opts "$raw2xg_opts -q"
00538                 }
00539                 # always run raw2xg because maybe we need the output
00540                 set cmd "$raw2xg -a $raw2xg_opts -n $flow_factor < $trace_filename_.tr >$trace_filename_.xg"
00541                 eval "exec $PERL $cmd"
00542                 if {$opts(graph-results)} {
00543                         if {$opts(graph-join-queueing)} {
00544                                 exec xgraph -t $title  < $trace_filename_.xg &
00545                         } else {
00546                                 exec xgraph -tk -nl -m -bb -t $title < $trace_filename_.xg &
00547                         }
00548                 }
00549                 if {$opts(test-suite)} {
00550                         exec cp $trace_filename_.xg $opts(test-suite-file)
00551                 }
00552         #       exec raw2xg -a < out.tr | xgraph -t "$opts(server-tcp-method)" &
00553         }
00554 
00555         if {$opts(mem-trace)} {
00556                 $ns_ clearMemTrace
00557         }
00558         exit 0
00559 }
00560 
00561 Main instproc trace_stuff {} {
00562         global opts
00563 
00564         $self instvar bottle_l_ bottle_r_ ns_ trace_file_ nam_trace_file_
00565         $self open_trace $opts(duration)
00566 
00567         if {$opts(trace-all)} {
00568                 $ns_ trace-all $trace_file_
00569         }
00570 
00571         if {$opts(namtrace-all)} {
00572                 $ns_ namtrace-all $nam_trace_file_
00573         } elseif {$opts(namtrace-some)} {
00574 # xxx
00575                 $bottle_l_ dump-namconfig
00576                 $bottle_r_ dump-namconfig
00577                 [$ns_ link $bottle_l_ $bottle_r_] dump-namconfig
00578                 $ns_ namtrace-queue $bottle_l_ $bottle_r_ $nam_trace_file_
00579                 $ns_ namtrace-queue $bottle_r_ $bottle_l_ $nam_trace_file_
00580         }
00581 
00582         # regular tracing.
00583         # trace left-to-right only
00584         $ns_ trace-queue $bottle_l_ $bottle_r_ $trace_file_
00585         $ns_ trace-queue $bottle_r_ $bottle_l_ $trace_file_
00586         
00587         # Currently tracing is somewhat broken because
00588         # of how the plumbing happens.
00589 }
00590 
00591 Main instproc init {av} {
00592         global opts
00593 
00594         $self process_args $av
00595 
00596         $self instvar ns_ 
00597         set ns_ [new Simulator]
00598 
00599         # Seed random no. generator; ns-random with arg of 0 heuristically
00600         # chooses a random number that changes on each invocation.
00601         $self instvar rng_
00602         set rng_ [new RNG]
00603         $rng_ seed $opts(ns-random-seed)
00604         $rng_ next-random
00605 
00606         $self init_network
00607         if {$opts(trace-filename) == "none"} {
00608                 $ns_ at $opts(duration) "$self finish"
00609         } else {
00610                 $self trace_stuff
00611         }
00612 
00613         # xxx: hack (next line)
00614 #       $self create_some_clients
00615         $ns_ at 0 "$self schedule_initial_traffic"
00616         if {$opts(client-arrival-rate) != 0} {
00617                 $ns_ at 0 "$self schedule_continuing_traffic"
00618         }
00619 
00620         if {$opts(gen-map)} {
00621                 $ns_ gen-map
00622         }       
00623         Agent/TCP set syn_ true
00624         Agent/TCP set delay_growth_ true
00625         Agent/TCP set windowInit_ 1
00626         Agent/TCP set windowInitOption_ 1
00627         if {$opts(init-win) == "0"} {
00628                 Agent/TCP set windowInitOption_ 2
00629         } elseif {$opts(init-win) == "10"} {
00630                 Agent/TCP set windowInitOption_ 1
00631                 Agent/TCP set windowInit_ 10
00632         } elseif {$opts(init-win) == "20"} {
00633                 Agent/TCP set windowInitOption_ 1
00634                 Agent/TCP set windowInit_ 20
00635                 puts "init-win 20"
00636         }
00637         $ns_ run
00638 }
00639 
00640 global in_test_suite
00641 if {![info exists in_test_suite]} {
00642         global $argv
00643         new Main $argv
00644 }
