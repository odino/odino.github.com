---
layout: post
title: "A little bit of strace doesn't hurt"
date: 2018-01-11 14:05
comments: true
categories: [debugging, linux, unix, shell, bash]
description: "The art of figuring out why things went south when nothing else helps"
---

[strace(1)](https://linux.die.net/man/1/strace) is an amazing tool that you can use to debug processes that went south
when nothing else helps.

<!-- more -->

At it's core, strace simply runs a command and prints out all system calls
executed:

```
$ strace echo "1" > test.txt

execve("/bin/echo", ["echo", "1"], [/* 79 vars */]) = 0
brk(NULL)                               = 0xa99000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0fe9a58000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=105962, ...}) = 0
mmap(NULL, 105962, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f0fe9a3e000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f0fe946b000
mprotect(0x7f0fe962b000, 2097152, PROT_NONE) = 0
mmap(0x7f0fe982b000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7f0fe982b000
mmap(0x7f0fe9831000, 14752, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f0fe9831000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0fe9a3d000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0fe9a3c000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f0fe9a3b000
arch_prctl(ARCH_SET_FS, 0x7f0fe9a3c700) = 0
mprotect(0x7f0fe982b000, 16384, PROT_READ) = 0
mprotect(0x606000, 4096, PROT_READ)     = 0
mprotect(0x7f0fe9a5a000, 4096, PROT_READ) = 0
munmap(0x7f0fe9a3e000, 105962)          = 0
brk(NULL)                               = 0xa99000
brk(0xaba000)                           = 0xaba000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=10305248, ...}) = 0
mmap(NULL, 10305248, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f0fe8a97000
close(3)                                = 0
fstat(1, {st_mode=S_IFREG|0664, st_size=0, ...}) = 0
write(1, "1\n", 2)                      = 2
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

Now, that's quite a bit of information: you will see each and every system call
that's been run in order to execute your command, with arguments (up to a certain
length) and the exit code.

How is this useful? Well, in order to debug a running process you can simply
*strace* it by its pid:

```
$ sleep 20 &

[1] 15977

$ strace -p $!

strace: Process 15977 attached
restart_syscall(<... resuming interrupted nanosleep ...>) = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
[1]+  Done                    sleep 20
```

(note that `$!` is the pid of the previous process, it's just a magic shell variable)

Now we're talking! Remember that process that inexplicably hangs after running
for a couple minutes? Let's run it, then find its pid and strace it on the fly.

You can even trace child processes and even threads with the `-f` option, so
that you can literally follow anything your parent process triggers -- just this
week this turned out handy for me since I needed to debug an android app running
on an emulated device, which can be easily done through something like:

```
$ adb shell

(in the emulated device)

$ ps -A | grep com.myapp

(get the pid)

$ strace -f -p $PID
```

Remember: when you think there's nothing left to try, strace(1) will always have
your back.
