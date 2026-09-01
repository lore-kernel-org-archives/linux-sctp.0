Received: from mail-oa2-f1.google.com (mail-oa2-f1.google.com [74.125.231.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D993331A65
	for <linux-sctp@vger.kernel.org>; Tue,  1 Sep 2026 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271112; cv=none; b=EwASVywUfLYY1PseQ55dDivojKlEbRB+7924TjBy9mYLsqIDKDWZ6ZeSBAtoimcbZQw1tG0EoELqCjgr5c6JnN2xY77x+4M06oBWYdaJsW8rl3PQ1UKnbRpcB7pRsbupQ6d8VAgIyScNMp3fVERz4z+TdsC5CDX/niHyZ0VQEJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271112; c=relaxed/simple;
	bh=ENIdvHRw1IiFMIzhFtYNWAzVUTCe7z0d5NvRi0XN0lQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ImXuV55fGhs9X/qdRxscfGwHWkGcT1AizGkJj+aK/PD2oWWZvgxJjDrDOvsbMrMfiIquRVwurE9X1can26gBsjPvm/Rzqp397WjPmXqlC0d8lGhs4zlsOcq3RqQ/zkC9sB/5vfe0toUJzSqtU8wJf95EyXF9nercnEFF5pZNTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa2-f1.google.com with SMTP id 586e51a60fabf-4489b7aa0e7so1260712fac.1
        for <linux-sctp@vger.kernel.org>; Tue, 01 Sep 2026 06:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788271109; x=1788875909;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSScl9b39LFhA6dCrI2VzC9NEUldGRGWmrst0p3B1xs=;
        b=MRZyxD6ktsW6vKMukQHl/6iRGLhDi1eUHN7fZ6VUsCLIc7GOt/3MLj5qfeDjr32LLw
         cSlqYJ0Dqyl3aPiRO2icyPTWmilx5cvDsqGdri2JHq1rG/yub7qdkhudCnd+cJsADzQa
         HJLnCc4c5H9k+FLsUsB4ttehagE4TncoKSpoi0cSi3Oc3pn2BfKL0c9el5rq/QC/3rCk
         lGOaSKcJpnNGsVSUQsHlM+9wl74J1ra8+H9qBtwz4tKFZz8bu2qrX9/ylyQRDEaauHwT
         UfCeCVgVVenuMtdNI+dgwdt0yCF6+yclY9+9iGZoDZ0hfXlkDnkBCUq5aKGRHbDohaH3
         DF8g==
X-Forwarded-Encrypted: i=1; AHgh+Rrs6AZF9ngOsTegWYV3W2GMtezATew46aAyYaCBw2UkFQYo1bXxnJwm6VH75xYF8Mptl9qvyPOeZ+ig@vger.kernel.org
X-Gm-Message-State: AFuF++kfHg8X5P9kEANWi6uJuOGwWt3tTpWb5n/ZPySblOmrvVsG5XCd
	gHTBxzVZxrrR5BSZknxJTudsqlTxRzTDTUIus6gce9SpAD8nh2CLFsdn3jx/IFzpTgdEXEPW5Dk
	EK3LIwi5S4ofIuOhaHrjfe06rkoLWF/vstqcw6r2nmdYttnzhBYFgHGeZAxc=
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:60b:b0:6b3:bb82:2736 with SMTP id
 006d021491bc7-6b3bb82372amr1185072eaf.17.1788271109452; Tue, 01 Sep 2026
 06:58:29 -0700 (PDT)
Date: Tue, 01 Sep 2026 06:58:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a96da05.08473e0e.15b4ac.0001.GAE@google.com>
Subject: [syzbot] [sctp?] WARNING: refcount bug in sctp_generate_timeout_event (4)
From: syzbot <syzbot+f5baf1a1df3261c2ad8d@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bf1079577a11 Merge tag 'sched_ext-for-7.3-rc1-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d06d9e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=f5baf1a1df3261c2ad8d
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c52dc60311d3/disk-bf107957.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/37591d96a65b/vmlinux-bf107957.xz
kernel image: https://storage.googleapis.com/syzbot-assets/729e80af6e39/bzImage-bf107957.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f5baf1a1df3261c2ad8d@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25, CPU#1: syz.0.2220/13955
Modules linked in:
CPU: 1 UID: 0 PID: 13955 Comm: syz.0.2220 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:refcount_warn_saturate+0x9f/0x110 lib/refcount.c:25
Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 6b d2 e9 fc 48 8d 3d f4 46 a7 0b 67 48 0f b9 3a eb 4a e8 58 d2 e9 fc 48 8d 3d f1 46 a7 0b <67> 48 0f b9 3a eb 37 e8 45 d2 e9 fc 48 8d 3d ee 46 a7 0b 67 48 0f
RSP: 0018:ffffc90000a18c28 EFLAGS: 00010246
RAX: ffffffff84dde548 RBX: 0000000000000002 RCX: ffff88807715be80
RDX: 0000000000000100 RSI: 0000000000000100 RDI: ffffffff90852c40
RBP: 0000000000000000 R08: ffff88807715be80 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000100 R12: dffffc0000000000
R13: 0000000000000001 R14: ffff888020fde004 R15: ffff888020fde640
FS:  00007f4a87be06c0(0000) GS:ffff888124dda000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff55dd92eb8 CR3: 000000005800b000 CR4: 0000000000350ef0
Call Trace:
 <IRQ>
 sctp_generate_timeout_event+0x1c8/0x390 net/sctp/sm_sideeffect.c:284
 call_timer_fn+0x18d/0x5f0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:767
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:784
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:lock_acquire+0x232/0x350 kernel/locking/lockdep.c:5913
Code: ff ff ff e8 a0 a9 40 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 65 48 8b 05 f2 44 f1 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d 41 5e 41 5f 5d e9 ba 25 6d ff cc 48 8d 3d 77 31 da
RSP: 0018:ffffc9000dabfac8 EFLAGS: 00000282
RAX: b29753db72d85c00 RBX: 0000000000000001 RCX: 8000000000000001
RDX: 00000000b866b3b2 RSI: ffffffff8e6fc28f RDI: ffffffff8c6d9380
RBP: ffff88807715be80 R08: 8c00000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: ffff888066f6e418 R12: ffff888066f6e418
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
 __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
 spin_lock include/linux/spinlock.h:347 [inline]
 __io_cq_lock io_uring/io_uring.c:484 [inline]
 __io_submit_flush_completions+0x85/0x10d0 io_uring/io_uring.c:1133
 io_submit_flush_completions io_uring/io_uring.h:253 [inline]
 io_submit_state_end io_uring/io_uring.c:1939 [inline]
 io_submit_sqes+0x1cec/0x2310 io_uring/io_uring.c:2063
 __do_sys_io_uring_enter io_uring/io_uring.c:2637 [inline]
 __se_sys_io_uring_enter+0x35b/0x1bb0 io_uring/io_uring.c:2586
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a86d9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a87bdff38 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 0000200000000340 RCX: 00007f4a86d9e159
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000009
RBP: 0000000000000a12 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000940
R13: 0000200000000948 R14: 0000000000000e26 R15: 0000000000000002
 </TASK>
----------------
Code disassembly (best guess):
   0:	eb 66                	jmp    0x68
   2:	85 db                	test   %ebx,%ebx
   4:	74 3e                	je     0x44
   6:	83 fb 01             	cmp    $0x1,%ebx
   9:	75 4c                	jne    0x57
   b:	e8 6b d2 e9 fc       	call   0xfce9d27b
  10:	48 8d 3d f4 46 a7 0b 	lea    0xba746f4(%rip),%rdi        # 0xba7470b
  17:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  1c:	eb 4a                	jmp    0x68
  1e:	e8 58 d2 e9 fc       	call   0xfce9d27b
  23:	48 8d 3d f1 46 a7 0b 	lea    0xba746f1(%rip),%rdi        # 0xba7471b
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb 37                	jmp    0x68
  31:	e8 45 d2 e9 fc       	call   0xfce9d27b
  36:	48 8d 3d ee 46 a7 0b 	lea    0xba746ee(%rip),%rdi        # 0xba7472b
  3d:	67                   	addr32
  3e:	48                   	rex.W
  3f:	0f                   	.byte 0xf


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
