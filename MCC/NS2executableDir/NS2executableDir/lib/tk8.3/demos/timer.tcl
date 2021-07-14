#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

# timer --
# This script generates a counter with start and stop buttons.
#
# RCS: @(#) $Id: timer,v 1.2 1998/09/14 18:23:30 stanton Exp $

label .counter -text 0.00 -relief raised -width 10
button .start -text Start -command {
    if $stopped {
	set stopped 0
	tick
    }
}
button .stop -text Stop -command {set stopped 1}
pack .counter -side bottom -fill both
pack .start -side left -fill both -expand yes
pack .stop -side right -fill both -expand yes

set seconds 0
set hundredths 0
set stopped 1

proc tick {} {
    global seconds hundredths stopped
    if $stopped return
    after 50 tick
    set hundredths [expr $hundredths+5]
    if {$hundredths >= 100} {
	set hundredths 0
	set seconds [expr $seconds+1]
    }
    .counter config -text [format "%d.%02d" $seconds $hundredths]
}

bind . <Control-c> {destroy .}
bind . <Control-q> {destroy .}
focus .
