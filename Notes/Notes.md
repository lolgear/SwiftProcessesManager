# Introduction
This task involves many resources and examples. I would like to gather most of valuable links ( blogs, examples, github projects, apple documentation ) into one file.

They are grouped by themes

## XPC and services.

### Apple documentation.

- [Designing Daemons and Services](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/DesigningDaemons.html#//apple_ref/doc/uid/10000172i-SW4-BBCBHBFB)
- [Porting Your macOS Apps to Apple Silicon](https://developer.apple.com/documentation/apple-silicon/porting-your-macos-apps-to-apple-silicon)
- [MacOS application continuously running. Should I create daemon?](https://developer.apple.com/forums/thread/126864)
- [Daemons and Agents](https://developer.apple.com/library/archive/technotes/tn2083/_index.html)

### Apple Forums.

- [XCode+Swift+XPC: How to start and deploy a Swift XPC target on MacOS](https://developer.apple.com/forums/thread/96339)

### Blogs.

- [A Look into XPC Internals: Reverse Engineering the XPC Objects](https://www.fortinet.com/blog/threat-research/a-look-into-xpc-internals--reverse-engineering-the-xpc-objects)
- [Example: Writing a Launch Agent for Apple's launchd](https://thoughtbot.com/blog/example-writing-a-launch-agent-for-apples-launchd)

### StackOverflow.

- [How to synchronously wait for reply block when using NSXPCConnection](https://stackoverflow.com/questions/35305003/how-to-synchronously-wait-for-reply-block-when-using-nsxpcconnection)

### Example Projects.

- [xpc-service-example](https://github.com/aronskaya/xpc-service-example)
- [LaunchAgent](https://github.com/SheffieldKevin/LaunchAgent)

## Privileged Helper.

### Apple documentation.

- [Introduction to Authorization Services Programming Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/authorization_concepts/01introduction/introduction.html#//apple_ref/doc/uid/TP30000995-CH204-TP1)
- [Authorization for Everyone](https://developer.apple.com/library/archive/technotes/tn2095/_index.html)

### Apple Forums.

- [Privileged Helper tool not getting access to write to disk](https://developer.apple.com/forums/thread/123344)
- [Install a privileged helper in other location using SMJobBless](https://developer.apple.com/forums/thread/66272)
- [debugging privileged helper](https://developer.apple.com/forums/thread/133415)
- [Using SMJobBless in modern Xcode](https://developer.apple.com/forums/thread/112700)
- [How to and When to uninstall a privileged helper](https://developer.apple.com/forums/thread/66821)

### Blogs.

- [https://www.woodys-findings.com/posts/cocoa-implement-privileged-helper](https://www.woodys-findings.com/posts/cocoa-implement-privileged-helper)
- [The Story Behind CVE-2019-13013](https://blog.obdev.at/what-we-have-learned-from-a-vulnerability/)

### StackOverflow.

- [SMJobBless gives error CFErrorDomainLaunchd Code=8](https://stackoverflow.com/questions/31020919/smjobbless-gives-error-cferrordomainlaunchd-code-8)
- [Change Authorization Dialog shown by AuthorizationCreate()](https://stackoverflow.com/questions/13634719/change-authorization-dialog-shown-by-authorizationcreate)
- [Writing a privileged helper tool with SMJobBless()](https://stackoverflow.com/questions/9134841/writing-a-privileged-helper-tool-with-smjobbless)

### Examples Projects.

- [SwiftPrivilegedHelper](https://github.com/erikberglund/SwiftPrivilegedHelper#setup)
- [EvenBetterAuthorizationSample](https://developer.apple.com/library/archive/samplecode/EvenBetterAuthorizationSample/Introduction/Intro.html)
- [smjobbless](https://github.com/aronskaya/smjobbless)
- [Elevator](https://www.dropbox.com/s/5kjl8koyqzvszrl/Elevator.zip)

## System Extensions.

### Apple documentation.

- [Build an Endpoint Security app](https://developer.apple.com/videos/play/wwdc2020/10159/)
- [es_events_t](https://developer.apple.com/documentation/endpointsecurity/3228936-es_events_t)
- [Endpoint Security](https://developer.apple.com/documentation/endpointsecurity)

### Apple Forums.

- [SystemExtension Mach service](https://developer.apple.com/forums/thread/118211)
- [XPC with multiple System Extension instances](https://developer.apple.com/forums/thread/654458)

### Blogs.

- [Writing a Process Monitor with Apple's Endpoint Security Framework](https://objective-see.com/blog/blog_0x47.html)

### Examples Projects.

- [Monitoring System Events with Endpoint Security](https://developer.apple.com/documentation/endpointsecurity/monitoring_system_events_with_endpoint_security)

## Killing process.

### Apple documentation.

- [SIGNAL(3)](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man3/signal.3.html)
- [KILL](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kill.2.html#//apple_ref/doc/man/2/kill)

### Blogs.

- [Killing a root process](http://hints.macworld.com/article.php?story=20010418154235144)

## Process list.

### Apple documentation.

- [Getting List of All Processes on Mac OS X](https://developer.apple.com/library/archive/qa/qa2001/qa1123.html)
- [KVM_GETPROCS](http://mirror.informatimago.com/next/developer.apple.com/documentation/Darwin/Reference/ManPages/man3/kvm_getprocs.3.html)

### Apple Forums.

- [Как программно получить uid из pid в osx с помощью c++?](https://coderoad.ru/6457682/Как-программно-получить-uid-из-pid-в-osx-с-помощью-c)

### Blogs.

- [Нет-Work: Darwin Networking](http://newosxbook.com/bonus/vol1ch16.html)

### StackOverflow.

- [Determine Process Info Programmatically in Darwin/OSX](https://stackoverflow.com/questions/220323/determine-process-info-programmatically-in-darwin-osx)
- [Logging of all process started since boot?](https://apple.stackexchange.com/questions/61584/logging-of-all-process-started-since-boot)
- [Can I use `sysctl` to retrieve a process list with the user?](https://stackoverflow.com/questions/7729245/can-i-use-sysctl-to-retrieve-a-process-list-with-the-user)
- [Killing a process with swift programmatically](https://stackoverflow.com/questions/66919520/killing-a-process-with-swift-programmatically)

### Examples Projects.

- [For Mac OS X: Get a list of running processes, and tell if a particular process is running, by name](https://gist.github.com/s4y/1173880/9ea0ed9b8a55c23f10ecb67ce288e09f08d9d1e5)
- [Retrieve process name from pid using sysctl (Darwin)](https://gist.github.com/loderunner/1372bab8060b012b2117)
- [PS listing](http://src.gnu-darwin.org/src/bin/ps/ps.c.html)

## Process events.

### Apple documentation.

- [bserving Process Lifetimes Without Polling](https://developer.apple.com/library/archive/technotes/tn2050/_index.html)
- [KQUEUE](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kqueue.2.html)
- [Kqueue in BSD](https://man.openbsd.org/kqueue.2)

### Blogs.

- [I/O Multiplexing using epoll and kqueue System Calls](https://austingwalters.com/io-multiplexing/)
- [Kqueue: A generic and scalable event notification facility](https://sjmulder.nl/dl/pdf/unsorted/2000%20-%20Lemon%20-%20Kqueue,%20A%20generic%20and%20scalable%20event%20notification%20facility.pdf)
- [/proc on Mac OS X](http://web.archive.org/web/20200103161748/http://osxbook.com/book/bonus/ancient/procfs/)

### StackOverflow.

- [Detect process exit on OSX](https://stackoverflow.com/questions/24689728/detect-process-exit-on-osx)
- [unable to detect application running with another user (via switch user)](https://stackoverflow.com/questions/18820199/unable-to-detect-application-running-with-another-user-via-switch-user/18821357#18821357])
- [Programmatically check if a process is running on Mac](https://stackoverflow.com/questions/2518160/programmatically-check-if-a-process-is-running-on-mac])


## Preference pane.
### Apple documentation.

- [Creating a Preference Pane Bundle](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/PreferencePanes/Tasks/Creation.html)
- [Preference Pane Programming Guide](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.693.6043&rep=rep1&type=pdf)
- [Implementing a Simple Preference Pane](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/PreferencePanes/Tasks/Sample.html#//apple_ref/doc/uid/20000710-BABFCABJ)
- [Preference Panes](https://developer.apple.com/documentation/preferencepanes)

### Blogs.

- [Creating a PreferencePane](http://cocoadevcentral.com/articles/000040.php)

### StackOverflow.

- [How do I create a Preference Pane?](https://stackoverflow.com/questions/1192124/how-do-i-create-a-preference-pane)
