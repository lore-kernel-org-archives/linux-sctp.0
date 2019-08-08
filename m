From: syzbot <syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com>
Date: Thu, 08 Aug 2019 14:58:05 +0000
Subject: memory leak in sctp_get_port_local (2)
Message-Id: <000000000000f93dd2058f9c4873@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot found the following crash on:

HEAD commit:    0eb0ce0a Merge tag 'spi-fix-v5.3-rc3' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x34588c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x9113f5c48aea971
dashboard link: https://syzkaller.appspot.com/bug?extid-7ecdf99f15689032b3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x0e1906600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x0ab906600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2d7ecdf99f15689032b3@syzkaller.appspotmail.com

executing program
executing program
executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810fa4b380 (size 64):
   comm "syz-executor900", pid 7117, jiffies 4294946947 (age 16.560s)
   hex dump (first 32 bytes):
     20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
     58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
   backtrace:
     [<00000000f1461735>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
     [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0  
net/sctp/socket.c:8121
     [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
     [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
     [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
     [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
     [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
     [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
     [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
     [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810fa4b380 (size 64):
   comm "syz-executor900", pid 7117, jiffies 4294946947 (age 19.260s)
   hex dump (first 32 bytes):
     20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
     58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
   backtrace:
     [<00000000f1461735>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
     [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0  
net/sctp/socket.c:8121
     [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
     [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
     [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
     [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
     [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
     [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
     [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
     [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810fa4b380 (size 64):
   comm "syz-executor900", pid 7117, jiffies 4294946947 (age 21.990s)
   hex dump (first 32 bytes):
     20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
     58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
   backtrace:
     [<00000000f1461735>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
     [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0  
net/sctp/socket.c:8121
     [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
     [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
     [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
     [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
     [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
     [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
     [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
     [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88810fa4b380 (size 64):
   comm "syz-executor900", pid 7117, jiffies 4294946947 (age 22.940s)
   hex dump (first 32 bytes):
     20 4e 00 00 89 e7 4c 8d 00 00 00 00 00 00 00 00   N....L.........
     58 40 dd 16 82 88 ff ff 00 00 00 00 00 00 00 00  X@..............
   backtrace:
     [<00000000f1461735>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:43 [inline]
     [<00000000f1461735>] slab_post_alloc_hook mm/slab.h:522 [inline]
     [<00000000f1461735>] slab_alloc mm/slab.c:3319 [inline]
     [<00000000f1461735>] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
     [<00000000ff3ccf22>] sctp_bucket_create net/sctp/socket.c:8374 [inline]
     [<00000000ff3ccf22>] sctp_get_port_local+0x189/0x5b0  
net/sctp/socket.c:8121
     [<00000000eed41612>] sctp_do_bind+0xcc/0x1e0 net/sctp/socket.c:402
     [<000000002bf65239>] sctp_bind+0x44/0x70 net/sctp/socket.c:302
     [<00000000b1aaaf57>] inet_bind+0x40/0xc0 net/ipv4/af_inet.c:441
     [<00000000db36b917>] __sys_bind+0x11c/0x140 net/socket.c:1647
     [<00000000679cfe3c>] __do_sys_bind net/socket.c:1658 [inline]
     [<00000000679cfe3c>] __se_sys_bind net/socket.c:1656 [inline]
     [<00000000679cfe3c>] __x64_sys_bind+0x1e/0x30 net/socket.c:1656
     [<000000002aac3ac2>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:296
     [<000000000c38e074>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

executing program
executing program
executing program
executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
