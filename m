Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A100C3C3F48
	for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784734949; cv=none; b=T/gvv0QScpNZpdms1GmV8PhgFOwdROuJ3u2HAW5hzz9XyHFO4L4IzmsKF3uJVi0VGj9WWhdL1If6EgbLNIzHdaA9BnQO+54CzdMY4cpFiUq6DCoE9uySJfyRCRz8M90adb7QdMiS46VXFrKDltEsF1udKYhmVANc3B2w/+UZCz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784734949; c=relaxed/simple;
	bh=V/CQbT4cG8PgvTKQzeaJ54oebvYZdOM4cDO7MD3EZ6E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=KaaHLwlyfL+PboyLJ4YUdJhwT4nxxeMaFsUF0vhTehzGzhREAlcrV/JgHDpoew1+N0o+ihLeeJA9rGwVdGv4ovZiJPS8DMVyJTkgY0hbdUZasf1a1niE7528ssxGBF/h7fbVpFwZuHFKSd+AlOU/OQwnmxF3nTfOXYgw1QA3f20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-6a13b72112dso15517935eaf.2
        for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 08:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784734945; x=1785339745;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G8kIQWvUiIWF94Q4aGyO9Xh0mRTexcHO5dZFZn3R9Jg=;
        b=tLhSFHsaay93cUxAhTtdfavlR3Kl96701I8zbV/4RCleC8UC70AQtLIx6c0sSzM9IL
         27aHP2MJKZqkAHMeFYPEvF87B7WLmm38KR1h9NNv7Ufcwd4ZbcWtgSW7qhUYhYca/r/q
         WNxwC8BmFt6O/qj9xo6UwdFsCJRY+wgrxLJO8qVKd7UXIJ3Uh9PTiaIc4oWoz++/bfpu
         YtLzb3l3UDimiDqqcWbFW28Z2s3GVTbHPs0Gn//26nu9+kXE5GB7lGdPQoCmQelPGB4H
         lvypHdymdsmf4A34AJ2zGHrjmInb01om5pf5BQY22rYdIbEmyk9rJBy4Gshb/pHs8JKF
         BQqA==
X-Forwarded-Encrypted: i=1; AHgh+RquiwLunJSd6AO3IKc2adj3Q8LSIIKLZWLjMi9mVW3AnYEIOq13w6/VYThgqvsPjwwCtO7GuLIZjWSK@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+IDnfVwm4Acpu37gjvdf9Vn34F4Vj3I3H7YZ+DAXF4NH8+Rx9
	uzsDty9GZrEGAxmdG56VOkwVKszbuQgXg1FWY6k9sVm01O+IeN2psA78AmQdu8IrDRotjocHW3p
	UCJNrbdyVEuBWIAjTx1LUI5TME/o9efuu+OUgiheQsV3JrEyZ72TWth/WFIM=
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198b:b0:6a1:7fa0:1151 with SMTP id
 006d021491bc7-6a536a8b1ffmr11337244eaf.66.1784734945067; Wed, 22 Jul 2026
 08:42:25 -0700 (PDT)
Date: Wed, 22 Jul 2026 08:42:25 -0700
In-Reply-To: <6877daee.a70a0220.693ce.002d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a60e4e1.16bfb6d0.3c48cb.0003.GAE@google.com>
Subject: Re: [syzbot] [bpf?] [sctp?] [tipc?] INFO: rcu detected stall in
 sock_close (5)
From: syzbot <syzbot+9a29e1dba699b6f46a03@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, jmaloy@redhat.com, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-wireless@vger.kernel.org, lucien.xin@gmail.com, 
	marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    248951ddc14d Merge tag 'hwmon-for-v7.2-rc5' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15080ab9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=98da55a882774dfe
dashboard link: https://syzkaller.appspot.com/bug?extid=9a29e1dba699b6f46a03
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165d9746580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ba2ab9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cbba9d9c5929/disk-248951dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/84360c1cd7aa/vmlinux-248951dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c128dc7a62e1/bzImage-248951dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9a29e1dba699b6f46a03@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5985
rcu: 	(detected by 0, t=10502 jiffies, g=18453, q=4003 ncpus=2)
task:syz.0.20        state:R  running task     stack:22176 pid:5985  tgid:5984  ppid:5819   task_flags:0x400040 flags:0x00080002
Call Trace:
 <IRQ>
 sched_show_task+0x4aa/0x5f0 kernel/sched/core.c:8184
 rcu_print_detail_task_stall_rnp kernel/rcu/tree_stall.h:292 [inline]
 print_other_cpu_stall+0xf7b/0x1310 kernel/rcu/tree_stall.h:680
 check_cpu_stall kernel/rcu/tree_stall.h:855 [inline]
 rcu_pending kernel/rcu/tree.c:3708 [inline]
 rcu_sched_clock_irq+0x93d/0x1050 kernel/rcu/tree.c:2744
 update_process_times+0x234/0x2d0 kernel/time/timer.c:2475
 tick_sched_handle kernel/time/tick-sched.c:296 [inline]
 tick_nohz_handler+0x38f/0x6b0 kernel/time/tick-sched.c:317
 __run_hrtimer kernel/time/hrtimer.c:2032 [inline]
 __hrtimer_run_queues+0x3a0/0xaf0 kernel/time/hrtimer.c:2096
 hrtimer_interrupt+0x44a/0x900 kernel/time/hrtimer.c:2215
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1051 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1068
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:__local_bh_enable_ip+0x1c2/0x2b0 kernel/softirq.c:307
Code: f7 89 df e8 60 01 00 00 41 f7 c4 00 02 00 00 74 05 e8 c2 9e 45 00 9c 58 a9 00 02 00 00 75 23 41 f7 c4 00 02 00 00 74 01 fb 5b <41> 5c 41 5d 41 5e 41 5f 5d e9 00 97 be 09 cc 90 0f 0b 90 e9 66 fe
RSP: 0018:ffffc900040ee0f0 EFLAGS: 00000206
RAX: 0000000000000006 RBX: dffffc0000000000 RCX: 0000000000000046
RDX: 0000000000000002 RSI: ffffffff8d883356 RDI: ffffffff8bca6680
RBP: 1ffff11005252d1e R08: ffffffff8faf8df7 R09: 1ffffffff1f5f1be
R10: dffffc0000000000 R11: fffffbfff1f5f1bf R12: 0000000000000282
R13: dffffc0000000000 R14: ffff8880292968f4 R15: 0000000000000001
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 spin_unlock_bh include/linux/spinlock_rt.h:116 [inline]
 tipc_skb_peek_port net/tipc/msg.h:1235 [inline]
 tipc_sk_rcv+0x44d/0x2b30 net/tipc/socket.c:2495
 tipc_node_xmit+0x218/0xf10 net/tipc/node.c:1701
 tipc_node_xmit_skb+0x139/0x1b0 net/tipc/node.c:1766
 tipc_sk_rcv+0x2926/0x2b30 net/tipc/socket.c:2526
 tipc_node_xmit+0x218/0xf10 net/tipc/node.c:1701
 tipc_sk_push_backlog net/tipc/socket.c:1313 [inline]
 tipc_sk_filter_connect net/tipc/socket.c:2259 [inline]
 tipc_sk_filter_rcv+0x1811/0x3240 net/tipc/socket.c:2368
 tipc_sk_enqueue net/tipc/socket.c:2449 [inline]
 tipc_sk_rcv+0x8c4/0x2b30 net/tipc/socket.c:2501
 tipc_node_xmit+0x218/0xf10 net/tipc/node.c:1701
 tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
 tipc_node_distr_xmit+0x2da/0x420 net/tipc/node.c:1781
 tipc_sk_backlog_rcv+0x1b6/0x280 net/tipc/socket.c:2416
 sk_backlog_rcv include/net/sock.h:1190 [inline]
 __release_sock+0x2b2/0x3d0 net/core/sock.c:3261
 release_sock+0x1be/0x290 net/core/sock.c:3860
 tipc_release+0x1abe/0x2500 net/tipc/socket.c:651
 __sock_release net/socket.c:710 [inline]
 sock_close+0xad/0x220 net/socket.c:1501
 __fput+0x42a/0xa80 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1fa/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7460e5de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f74604be028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: 00000000000203a0 RBX: 00007f74610e5fa0 RCX: 00007f7460e5de99
RDX: 0000000000000000 RSI: 00002000000003c0 RDI: 0000000000000003
RBP: 00007f7460ef3eaf R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f74610e6038 R14: 00007f74610e5fa0 R15: 00007ffc753a57c8
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
