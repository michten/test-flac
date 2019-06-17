# test-flac
Test flac files and write to stout path of bad files.


## General info
Default flac command when testing correctness of a file print only filename to stout.
This script print log to stout with full path of files with errors and warnings.
flac command is one-tread only, so there are two versions of the test-flac;
- test-flac.sh  - test one file at a time
- test-flac-parallel.sh  - run X parallel flac commands on different files, where X is number of cpu threads in system
