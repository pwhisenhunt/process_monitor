##Monitor processes on Mac OS X 10.6+ for wildness.

I used this little script to kill rogue processes that grew to large due to memory leaks while I could figure out the issue at hand. You can use it to look for specific processes to kill.

Requirements
-----------
Mac OS X 10.6+

Getting Started
-----------

Download the file and run

```console
	ruby monitor.rb httpd,ruby 400.00
```

To have the script look for httpd and ruby processes of size greater then 400.00 mb.