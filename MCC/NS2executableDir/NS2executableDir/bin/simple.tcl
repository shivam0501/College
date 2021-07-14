set f1 [open try WRONLY]
# Write something into the file and close it
puts -nonewline $f1 “Writing a sentence into file”
close $f1
# Read the sentence
set f1 [open try RONLY]
set l1 [gets $f1]
puts “Read line: $l1”