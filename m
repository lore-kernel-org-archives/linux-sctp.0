From: Eric Biggers <ebiggers3@gmail.com>
Date: Wed, 31 Jan 2018 06:12:23 +0000
Subject: Re: KASAN: use-after-free Read in refcount_inc_not_zero
Message-Id: <20180131061223.GC2736@zzz.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <94eb2c1fae04669449055d036865@google.com>
 <089e082bdf1062d5ed056050f926@google.com>
In-Reply-To: <089e082bdf1062d5ed056050f926@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <bot+9e3011b5e961675e736b38d6fd82ad12723a3fa3@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, alexander.deucher@amd.com, broonie@kernel.org, chris@chris-wilson.co.uk, davem@davemloft.net, deepa.kernel@gmail.com, gregkh@linuxfoundation.org, gscrivan@redhat.com, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, luc.vanoostenryck@gmail.com, lucien.xin@gmail.com, mingo@kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk, vyasevich@gmail.com, xiyou.wangcong@gmail.com

On Thu, Dec 14, 2017 at 10:23:01AM -0800, syzbot wrote:
> syzkaller has found reproducer for the following crash on
> 82bcf1def3b5f1251177ad47c44f7e17af039b4b
> git://git.cmpxchg.org/linux-mmots.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> C reproducer is attached
> syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> for information about syzkaller reproducers
> 
> 
> =================================
> BUG: KASAN: use-after-free in __read_once_size include/linux/compiler.h:183
> [inline]
> BUG: KASAN: use-after-free in atomic_read arch/x86/include/asm/atomic.h:27
> [inline]
> BUG: KASAN: use-after-free in refcount_inc_not_zero+0x16e/0x180
> lib/refcount.c:120
> Read of size 4 at addr ffff8801c51bb200 by task syzkaller711981/3156
> 
> CPU: 1 PID: 3156 Comm: syzkaller711981 Not tainted 4.15.0-rc2-mm1+ #39
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_load4_noabort+0x14/0x20 mm/kasan/report.c:429
>  __read_once_size include/linux/compiler.h:183 [inline]
>  atomic_read arch/x86/include/asm/atomic.h:27 [inline]
>  refcount_inc_not_zero+0x16e/0x180 lib/refcount.c:120
>  refcount_inc+0x15/0x50 lib/refcount.c:153
>  get_ipc_ns include/linux/ipc_namespace.h:129 [inline]
>  __get_ns_from_inode ipc/mqueue.c:110 [inline]
>  get_ns_from_inode ipc/mqueue.c:118 [inline]
>  mqueue_evict_inode+0x137/0x9c0 ipc/mqueue.c:402
>  evict+0x481/0x920 fs/inode.c:552
>  iput_final fs/inode.c:1514 [inline]
>  iput+0x7b9/0xaf0 fs/inode.c:1541
>  dentry_unlink_inode+0x4b0/0x5e0 fs/dcache.c:376
>  __dentry_kill+0x3b7/0x6d0 fs/dcache.c:573
>  shrink_dentry_list+0x3c5/0xcf0 fs/dcache.c:1020
>  shrink_dcache_parent+0xba/0x230 fs/dcache.c:1454
>  do_one_tree+0x15/0x50 fs/dcache.c:1485
>  shrink_dcache_for_umount+0xbb/0x290 fs/dcache.c:1502
>  generic_shutdown_super+0xcd/0x540 fs/super.c:424
>  kill_anon_super fs/super.c:987 [inline]
>  kill_litter_super+0x72/0x90 fs/super.c:997
>  deactivate_locked_super+0x88/0xd0 fs/super.c:312
>  deactivate_super+0x141/0x1b0 fs/super.c:343
>  cleanup_mnt+0xb2/0x150 fs/namespace.c:1173
>  __cleanup_mnt+0x16/0x20 fs/namespace.c:1180
>  task_work_run+0x199/0x270 kernel/task_work.c:113
>  exit_task_work include/linux/task_work.h:22 [inline]
>  do_exit+0x9bb/0x1ae0 kernel/exit.c:869
>  do_group_exit+0x149/0x400 kernel/exit.c:972
>  SYSC_exit_group kernel/exit.c:983 [inline]
>  SyS_exit_group+0x1d/0x20 kernel/exit.c:981
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> RIP: 0033:0x440729
> RSP: 002b:00007ffd090ef228 EFLAGS: 00000206 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0030656c69662f2e RCX: 0000000000440729
> RDX: 0000000000440729 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 00000000006cb018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000401bf0
> R13: 0000000000401c80 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 3156:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x136/0x750 mm/slab.c:3614
>  kmalloc include/linux/slab.h:516 [inline]
>  create_ipc_ns ipc/namespace.c:45 [inline]
>  copy_ipcs+0x1b3/0x520 ipc/namespace.c:96
>  create_new_namespaces+0x278/0x880 kernel/nsproxy.c:87
>  unshare_nsproxy_namespaces+0xae/0x1e0 kernel/nsproxy.c:206
>  SYSC_unshare kernel/fork.c:2421 [inline]
>  SyS_unshare+0x653/0xfa0 kernel/fork.c:2371
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> 
> Freed by task 3156:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3492 [inline]
>  kfree+0xca/0x250 mm/slab.c:3807
>  free_ipc_ns ipc/namespace.c:139 [inline]
>  put_ipc_ns+0x112/0x150 ipc/namespace.c:164
>  free_nsproxy+0xc0/0x1f0 kernel/nsproxy.c:180
>  switch_task_namespaces+0x9d/0xc0 kernel/nsproxy.c:229
>  exit_task_namespaces+0x17/0x20 kernel/nsproxy.c:234
>  do_exit+0x9b6/0x1ae0 kernel/exit.c:868
>  do_group_exit+0x149/0x400 kernel/exit.c:972
>  SYSC_exit_group kernel/exit.c:983 [inline]
>  SyS_exit_group+0x1d/0x20 kernel/exit.c:981
>  entry_SYSCALL_64_fastpath+0x1f/0x96
> 

syzbot hasn't hit this crash since next-20171221, and it looks like it was
caused by the patch "ipc, mqueue: lazy call kern_mount_data in new namespaces"
which was dropped and replaced by "mqueue: switch to on-demand creation of
internal mount" (thanks Al!).  So, invalidating this bug so that syzbot can
report crashes here again if they occur.

#syz invalid

- Eric
