From: syzbot <syzbot+cd494c1dd681d4d93ebb@syzkaller.appspotmail.com>
Date: Mon, 23 Apr 2018 01:02:02 +0000
Subject: KASAN: slab-out-of-bounds Read in __sctp_v6_cmp_addr
Message-Id: <000000000000f35c4b056a7995f4@google.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, vyasevich@gmail.com

Hello,

syzbot hit the following crash on upstream commit
83beed7b2b26f232d782127792dd0cd4362fdc41 (Fri Apr 20 17:56:32 2018 +0000)
Merge branch 'fixes' of =20
git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal
syzbot dashboard link: =20
https://syzkaller.appspot.com/bug?extid=CD494c1dd681d4d93ebb

So far this crash happened 305 times on net-next, upstream.
C reproducer: https://syzkaller.appspot.com/x/repro.c?idf84817483628544
syzkaller reproducer: =20
https://syzkaller.appspot.com/x/repro.syz?idc21732692475904
Raw console output: =20
https://syzkaller.appspot.com/x/log.txt?idS81423422767104
Kernel config: =20
https://syzkaller.appspot.com/x/.config?id=1808800213120130118
compiler: gcc (GCC) 8.0.1 20180413 (experimental)

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+cd494c1dd681d4d93ebb@syzkaller.appspotmail.com
It will help syzbot understand when the bug is fixed. See footer for =20
details.
If you forward the report, please keep this part and the footer.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in ipv6_addr_equal include/net/ipv6.h:507 =20
[inline]
BUG: KASAN: slab-out-of-bounds in __sctp_v6_cmp_addr+0x4c7/0x530 =20
net/sctp/ipv6.c:580
Read of size 8 at addr ffff8801b58626d0 by task syzkaller106428/4452

CPU: 1 PID: 4452 Comm: syzkaller106428 Not tainted 4.17.0-rc1+ #10
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =20
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1b9/0x294 lib/dump_stack.c:113
  print_address_description+0x6c/0x20b mm/kasan/report.c:256
  kasan_report_error mm/kasan/report.c:354 [inline]
  kasan_report.cold.7+0x242/0x2fe mm/kasan/report.c:412
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/report.c:433
  ipv6_addr_equal include/net/ipv6.h:507 [inline]
  __sctp_v6_cmp_addr+0x4c7/0x530 net/sctp/ipv6.c:580
  sctp_inet6_cmp_addr+0x169/0x1a0 net/sctp/ipv6.c:898
  sctp_bind_addr_conflict+0x28c/0x470 net/sctp/bind_addr.c:368
  sctp_get_port_local+0x9fc/0x1540 net/sctp/socket.c:7515
  sctp_do_bind+0x21c/0x5f0 net/sctp/socket.c:435
  sctp_bindx_add+0x90/0x1a0 net/sctp/socket.c:529
  sctp_setsockopt_bindx+0x2ad/0x320 net/sctp/socket.c:1058
  sctp_setsockopt+0x12c4/0x7000 net/sctp/socket.c:4227
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3039
  __sys_setsockopt+0x1bd/0x390 net/socket.c:1903
  __do_sys_setsockopt net/socket.c:1914 [inline]
  __se_sys_setsockopt net/socket.c:1911 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1911
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x445839
RSP: 002b:00007fbe3f0fdd98 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000006dac24 RCX: 0000000000445839
RDX: 0000000000000064 RSI: 0000000000000084 RDI: 0000000000000004
RBP: 00000000006dac20 R08: 0000000000000010 R09: 000000000000a6fe
R10: 00000000205ba000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc1404827f R14: 00007fbe3f0fe9c0 R15: 0000000000000003

Allocated by task 4452:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  kasan_kmalloc+0xc4/0xe0 mm/kasan/kasan.c:553
  __do_kmalloc_node mm/slab.c:3682 [inline]
  __kmalloc_node+0x47/0x70 mm/slab.c:3689
  kmalloc_node include/linux/slab.h:554 [inline]
  kvmalloc_node+0x6b/0x100 mm/util.c:421
  kvmalloc include/linux/mm.h:550 [inline]
  vmemdup_user+0x2d/0xa0 mm/util.c:186
  sctp_setsockopt_bindx+0x5d/0x320 net/sctp/socket.c:1022
  sctp_setsockopt+0x12c4/0x7000 net/sctp/socket.c:4227
  sock_common_setsockopt+0x9a/0xe0 net/core/sock.c:3039
  __sys_setsockopt+0x1bd/0x390 net/socket.c:1903
  __do_sys_setsockopt net/socket.c:1914 [inline]
  __se_sys_setsockopt net/socket.c:1911 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:1911
  do_syscall_64+0x1b1/0x800 arch/x86/entry/common.c:287
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 2818:
  save_stack+0x43/0xd0 mm/kasan/kasan.c:448
  set_track mm/kasan/kasan.c:460 [inline]
  __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:521
  kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:528
  __cache_free mm/slab.c:3498 [inline]
  kfree+0xd9/0x260 mm/slab.c:3813
  single_release+0x8f/0xb0 fs/seq_file.c:609
  __fput+0x34d/0x890 fs/file_table.c:209
  ____fput+0x15/0x20 fs/file_table.c:243
  task_work_run+0x1e4/0x290 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:191 [inline]
  exit_to_usermode_loop+0x2bd/0x310 arch/x86/entry/common.c:166
  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:265 [inline]
  do_syscall_64+0x6ac/0x800 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8801b58626c0
  which belongs to the cache kmalloc-32 of size 32
The buggy address is located 16 bytes inside of
  32-byte region [ffff8801b58626c0, ffff8801b58626e0)
The buggy address belongs to the page:
page:ffffea0006d61880 count:1 mapcount:0 mapping:ffff8801b5862000 =20
index:0xffff8801b5862fc1
flags: 0x2fffc0000000100(slab)
raw: 02fffc0000000100 ffff8801b5862000 ffff8801b5862fc1 0000000100000032
raw: ffffea0006ddd1e0 ffffea0006dd2860 ffff8801da8001c0 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8801b5862580: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
  ffff8801b5862600: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
> ffff8801b5862680: fb fb fb fb fc fc fc fc 00 00 fc fc fc fc fc fc
                                                  ^
  ffff8801b5862700: 00 00 00 00 fc fc fc fc 00 00 04 fc fc fc fc fc
  ffff8801b5862780: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D


---
This bug is generated by a dumb bot. It may contain errors.
See https://goo.gl/tpsmEJ for details.
Direct all questions to syzkaller@googlegroups.com.

syzbot will keep track of this bug report.
If you forgot to add the Reported-by tag, once the fix for this bug is =20
merged
into any tree, please reply to this email with:
#syz fix: exact-commit-title
If you want to test a patch for this bug, please reply with:
#syz test: git://repo/address.git branch
and provide the patch inline or as an attachment.
To mark this as a duplicate of another syzbot report, please reply with:
#syz dup: exact-subject-of-another-report
If it's a one-off invalid bug report, please reply with:
#syz invalid
Note: if the crash happens again, it will cause creation of a new bug =20
report.
Note: all commands must start from beginning of the line in the email body.
