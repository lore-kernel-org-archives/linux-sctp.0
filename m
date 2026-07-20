Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF2D26D4CA
	for <linux-sctp@vger.kernel.org>; Mon, 20 Jul 2026 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784554398; cv=none; b=XAxmwdBtrGcvN6wDnS2hwEQiyicHHMmEPDyO7lADTltO4vkmB9PsvqiJmykebb1tfgi4FNSx2uUBkJeB9uRmAEjEfjUmXu+rvc2R3AHvlZ8p4aN669xRN7J2NeCcq9Ax9rIHl+tr/ITKoIDSWHt1no1tlNhOiPgeB7SC395n0qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784554398; c=relaxed/simple;
	bh=/0gy4om9MZPGkRPspEU3Ru3BEVb24EUIQUBaA17mLTc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=A+FmbwXIyGB+QF2YwK1SSMX+QvOOYBqtnJ3IKaAt2Exdev52cshjKybaPDphn1FNXbLPYucKHU0Mj4mj9jjYrJUKlkVO8XPotBgVBkzqdRS6+yzI5flZjRC4qopSvj6B2elVU48wNfsX8pN5QrQxNeSlJz3WysgnxOmF8xXi4Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49f3a97f1caso9825616b6e.0
        for <linux-sctp@vger.kernel.org>; Mon, 20 Jul 2026 06:33:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784554396; x=1785159196;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=TIfbOJfS3KelAtA4NoghHgoCZpOohDChB1W363vqI5w=;
        b=n7g+Wvycj27RN/xzxAUbGKIGidikbrVz3kyXRKcr8znxPLRdhQG0XO9QbNjtTMlXO+
         szjY7NOGRu0DGJo5kKOm98UH58QHdLw/brh5ACwI7RRJiTUjOLZz3GYdzdgjSxlE6muW
         uXwXLH290gCpvSZKqBr8+56B6Hp9IzWeTUeiaQYDTtpGdz3c9V+AL993OUt/DmqPgDGZ
         JieZ0A+QIhc7P0pn5aSDeylr/O0ujeuUbf2qeoZmZQMuAZ5dGGJeF2LUNIHThOM6QNTM
         6QQoB9nUM9T5sbPkKJTUp5wytz16reghOneAjZ2ZXmzuX9LG9TIVxqsWCy8eshcU47m8
         PM0Q==
X-Forwarded-Encrypted: i=1; AHgh+Rom5vJHbKf03vpujq1YpEZLGkhoLB8WTyQxJxqpl5WTQyPdcrtFNwLLkrVe4VfFlQ0zsLHxzC90Dhcs@vger.kernel.org
X-Gm-Message-State: AOJu0YxRnTjDlmROy3YAD1cAU2IbeaG9FwMl2YCXOGo3eFn/g7dLNzCY
	aXXQrd8OKmdtZ/dLVupews6Hfz3fHjHFW+M6no7g5E8DBg1a7v/Lgx21S1frzQVcObmtJFz6C+Q
	SMDG+xr4BXAZHNP4JXVWjLu8DyUAoBBjzqXgJi4uABXJ1qYtww/i5uNV/KzQ=
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1813:b0:4a3:fb6b:bcb8 with SMTP id
 5614622812f47-4a4d038a4edmr8957156b6e.10.1784554395741; Mon, 20 Jul 2026
 06:33:15 -0700 (PDT)
Date: Mon, 20 Jul 2026 06:33:15 -0700
In-Reply-To: <20260720082145.1072547-1-l1138897701@163.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5e239b.42649fcc.6186.0083.GAE@google.com>
Subject: [syzbot ci] Re: sctp: socket: refactor sctp_skb_recv_datagram to use ERR_PTR
From: syzbot ci <syzbot+ci7e6fcf245bce20f2@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, l1138897701@163.com, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, lucien.xin@gmail.com, marcelo.leitner@gmail.com, 
	netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] sctp: socket: refactor sctp_skb_recv_datagram to use ERR_PTR
https://lore.kernel.org/all/20260720082145.1072547-1-l1138897701@163.com
* [PATCH net v4] sctp: socket: refactor sctp_skb_recv_datagram to use ERR_PTR

and found the following issue:
general protection fault in sctp_recvmsg

Full report is available here:
https://ci.syzbot.org/series/f979ded9-9743-486d-b911-69a904c9f4ad

***

general protection fault in sctp_recvmsg

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      e13caf1c26587434f0b768193100440939c0fb91
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/e4b39daf-f862-498e-8aeb-c22b5a168551/config
syz repro: https://ci.syzbot.org/findings/1893a3b4-56e4-49d0-9865-4ff919f027b3/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 5830 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:sctp_recvmsg+0x28d/0xd60 net/sctp/socket.c:2135
Code: ff 72 0d e8 35 6a d6 f6 41 89 ee e9 da 06 00 00 4c 89 7c 24 08 48 8d 7d 70 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 2f 08 00 00 4c 63 7d 70 4d 39 fe 4d 0f 43
RSP: 0018:ffffc90003a8f838 EFLAGS: 00010202
RAX: 000000000000000e RBX: ffff888115ad1c80 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000070
RBP: 0000000000000000 R08: 1ffff92000751ef4 R09: 1ffff11022b5a460
R10: dffffc0000000000 R11: fffffbfff206639f R12: ffff888115ad22f0
R13: ffffc90003a8fd00 R14: 0000000000000000 R15: 0000000000000300
FS:  00007facf6b766c0(0000) GS:ffff88818dc17000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000055c0 CR3: 000000010a812000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 sock_recvmsg_nosec net/socket.c:1128 [inline]
 sock_recvmsg+0x166/0x1e0 net/socket.c:1148
 ____sys_recvmsg+0x1e6/0x4a0 net/socket.c:2904
 ___sys_recvmsg+0x213/0x5a0 net/socket.c:2946
 do_recvmmsg+0x31a/0x7f0 net/socket.c:3041
 __sys_recvmmsg net/socket.c:3115 [inline]
 __do_sys_recvmmsg net/socket.c:3138 [inline]
 __se_sys_recvmmsg net/socket.c:3131 [inline]
 __x64_sys_recvmmsg+0x198/0x250 net/socket.c:3131
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7facf5d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007facf6b76028 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
RAX: ffffffffffffffda RBX: 00007facf6015fa0 RCX: 00007facf5d9ce59
RDX: 000000000400023c RSI: 00002000000055c0 RDI: 0000000000000004
RBP: 00007facf5e32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000300 R11: 0000000000000246 R12: 0000000000000000
R13: 00007facf6016038 R14: 00007facf6015fa0 R15: 00007ffcc05d60d8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:sctp_recvmsg+0x28d/0xd60 net/sctp/socket.c:2135
Code: ff 72 0d e8 35 6a d6 f6 41 89 ee e9 da 06 00 00 4c 89 7c 24 08 48 8d 7d 70 48 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 2f 08 00 00 4c 63 7d 70 4d 39 fe 4d 0f 43
RSP: 0018:ffffc90003a8f838 EFLAGS: 00010202
RAX: 000000000000000e RBX: ffff888115ad1c80 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000070
RBP: 0000000000000000 R08: 1ffff92000751ef4 R09: 1ffff11022b5a460
R10: dffffc0000000000 R11: fffffbfff206639f R12: ffff888115ad22f0
R13: ffffc90003a8fd00 R14: 0000000000000000 R15: 0000000000000300
FS:  00007facf6b766c0(0000) GS:ffff88818dc17000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000055c0 CR3: 000000010a812000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	ff 72 0d             	push   0xd(%rdx)
   3:	e8 35 6a d6 f6       	call   0xf6d66a3d
   8:	41 89 ee             	mov    %ebp,%r14d
   b:	e9 da 06 00 00       	jmp    0x6ea
  10:	4c 89 7c 24 08       	mov    %r15,0x8(%rsp)
  15:	48 8d 7d 70          	lea    0x70(%rbp),%rdi
  19:	48 89 f8             	mov    %rdi,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 2f 08 00 00    	jne    0x865
  36:	4c 63 7d 70          	movslq 0x70(%rbp),%r15
  3a:	4d 39 fe             	cmp    %r15,%r14
  3d:	4d                   	rex.WRB
  3e:	0f                   	.byte 0xf
  3f:	43                   	rex.XB


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
