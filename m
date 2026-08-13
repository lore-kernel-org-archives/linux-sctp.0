Received: from mail-ot1-f77.google.com (mail-ot1-f77.google.com [209.85.210.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E25396B9A
	for <linux-sctp@vger.kernel.org>; Thu, 13 Aug 2026 08:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611574; cv=none; b=ILGhooKZpCWNrN9doTEqsMOB1d8zTe6V43hkLR7nTF0nPkV+dZ+6bcvEEgzwXuSvbH1lfuvab0W/nidJPr94vX7hq7K3LC/b27Y0t5es4yUrQ0OIwqOk3Tm7fbb1tvwWQvFOjkM9YYKL0hc9TibeauKoY1yrA/ExzaHdgUYGNQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611574; c=relaxed/simple;
	bh=isw7UPUMWbVsmqLjO8nrNnypyaJxT9erAkEpWTf83rQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JytTiN25qZXid4dfjxvuj3G7EdrwekEo0X6t3y9Q8EYGk5uWTPSUja2mPmuV9o9xHQ+pI8h1t0W7EOtfedBDOgafzjxJfCLW6ntvFk+Ef1RnPoYoI/fJxMJ8NOjhswcXBOe9c1ScRV20o8YJ9/EEIDe4Cw3C0jRfePcMRu3wLEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f77.google.com with SMTP id 46e09a7af769-7e9fdc2870fso354065a34.2
        for <linux-sctp@vger.kernel.org>; Thu, 13 Aug 2026 01:59:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786611571; x=1787216371;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tE1+RzQhpvKQxLGpZ5xo6ecpjtwzXrqcnNj3zDdS/kU=;
        b=Kn9cqeN9dDUXV5eI9WDtDcHVs0nf0G8LaxM7UDpnI+o1cJZC+yTEnS5CQ71r+gZHua
         NiPTdpw/RkuWL3NLtjnKwDtk4bZW3qIa09cI1Zx7cPbq1xNkp8gJAjlep7I4KL2Q6Rme
         HGtPfEygztIC0DcHc1jB3td0qdcEx4jSIXc+W6+KidCtm2kOWdAOyXqmWGav/Qzvk/8G
         CMEjqx+ONU6z4TPha4GPDZWldzlDCipVlEHE/T+ABKZ2EvT1m9QQbuUSNYklUgIH0bvS
         h/81oxqMlN7b3nsHfcY0AQ32cAgF0zRxuoTHPMQqxe2WHnaGmuxKMBquAzYkdI9wdhMc
         C8JA==
X-Forwarded-Encrypted: i=1; AHgh+RqEv0DzDyRE+829fZxnK9dnKSdjoYk1LBqnn5rDVJmm283nVjfTq+7lXSbR3dwV4nlaTdzEDKR5qloG@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0YYs61ZSgywNOngouWkxC6970T49/XkiRdk5qMPgalQWddDEw
	hWaZPYb2l9Qnv5ygWeXYErXGeUdURUFseuvV/p9z17AajdZ27tsXWAcDqPF+QMvM5zU7JkanE6e
	5F1ISsFxycUVHQCRXNpuc0pecZHBTngvvJAOsc6TOO22Mu6L5wMhp6ouVHuA=
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1844:b0:6b0:19bc:fd14 with SMTP id
 006d021491bc7-6b0c45ca615mr4405974eaf.32.1786611571127; Thu, 13 Aug 2026
 01:59:31 -0700 (PDT)
Date: Thu, 13 Aug 2026 01:59:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7d8773.c5ad36c8.12f49d.002e.GAE@google.com>
Subject: [syzbot] [sctp?] WARNING: refcount bug in sctp_transport_put (6)
From: syzbot <syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b9f479580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
dashboard link: https://syzkaller.appspot.com/bug?extid=80dfcb1a2235b3efc877
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/025cec82d3d2/disk-3d6d8176.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9200091a0c2f/vmlinux-3d6d8176.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b47828829039/bzImage-3d6d8176.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80dfcb1a2235b3efc877@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xf4/0x130 lib/refcount.c:28, CPU#1: swapper/1/0
Modules linked in:
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:refcount_warn_saturate+0xf4/0x130 lib/refcount.c:28
Code: cc e8 10 93 ec fc 48 8d 3d 09 be 0e 0c 67 48 0f b9 3a e8 ff 92 ec fc 5b 5d e9 d8 23 a0 06 e8 f3 92 ec fc 48 8d 3d fc bd 0e 0c <67> 48 0f b9 3a e8 e2 92 ec fc 5b 5d c3 cc cc cc cc e8 d6 92 ec fc
RSP: 0018:ffffc90000a08c28 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802afce820 RCX: ffffffff851ddffb
RDX: ffff88801eaca540 RSI: ffffffff851de08d RDI: ffffffff912c9e90
RBP: 0000000000000003 R08: 0000000000000005 R09: 0000000000000004
R10: 0000000000000003 R11: 0000000000000000 R12: ffff88802afce820
R13: 1ffff9200014118e R14: ffffffff8af14810 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888123eec000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe49ed8e10 CR3: 000000005416b000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 __refcount_sub_and_test include/linux/refcount.h:400 [inline]
 __refcount_dec_and_test include/linux/refcount.h:432 [inline]
 refcount_dec_and_test include/linux/refcount.h:450 [inline]
 sctp_transport_put+0x134/0x180 net/sctp/transport.c:476
 call_timer_fn+0x19a/0x610 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers+0x757/0xb00 kernel/time/timer.c:2374
 __run_timer_base kernel/time/timer.c:2386 [inline]
 __run_timer_base kernel/time/timer.c:2378 [inline]
 run_timer_base+0x114/0x190 kernel/time/timer.c:2395
 run_timer_softirq+0x1a/0x50 kernel/time/timer.c:2405
 handle_softirqs+0x1ea/0x9b0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x162/0x210 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inline]
 sysvec_apic_timer_interrupt+0xa3/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: 55 8c 02 e9 83 4b 03 00 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 83 cf 10 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
RSP: 0018:ffffc90000197e00 EFLAGS: 00000246
RAX: 0000000002ec63ed RBX: ffff88801eaca540 RCX: ffffffff8bbad335
RDX: 0000000000000000 RSI: ffffffff8e1a9419 RDI: ffffffff8c400480
RBP: ffffed1003d594a8 R08: 0000000000000001 R09: ffffed10170a678d
R10: ffff8880b8533c6b R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 1ffff92000032fc4 R15: dffffc0000000000
 arch_safe_halt arch/x86/include/asm/paravirt.h:62 [inline]
 default_idle+0x9/0x10 arch/x86/kernel/process.c:768
 default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x3a7/0x5b0 kernel/sched/idle.c:355
 cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:454
 start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x158
 </TASK>
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	e8 10 93 ec fc       	call   0xfcec9316
   6:	48 8d 3d 09 be 0e 0c 	lea    0xc0ebe09(%rip),%rdi        # 0xc0ebe16
   d:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  12:	e8 ff 92 ec fc       	call   0xfcec9316
  17:	5b                   	pop    %rbx
  18:	5d                   	pop    %rbp
  19:	e9 d8 23 a0 06       	jmp    0x6a023f6
  1e:	e8 f3 92 ec fc       	call   0xfcec9316
  23:	48 8d 3d fc bd 0e 0c 	lea    0xc0ebdfc(%rip),%rdi        # 0xc0ebe26
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e8 e2 92 ec fc       	call   0xfcec9316
  34:	5b                   	pop    %rbx
  35:	5d                   	pop    %rbp
  36:	c3                   	ret
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	e8 d6 92 ec fc       	call   0xfcec9316


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
