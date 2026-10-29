Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316109;
	b=pDaHZMaaNPf2x437I+/noL4M+MVkKzK2SERjs5O86alaPOGm5lgnfv+5AcuZFr/M7AkN
	 eBUYHxn0K1TH6hfLQiu+V0eG9FowWG1xhVep0g1aVSomFzuB+ck97wB3k9VwS4IgnUBkS
	 UFM19W9WkAWTmPDqMqlqy8gVe+Cv9atQqwh4EQ8JLhTUAZeqgasD+xBVSZeYAGmUF3p3r
	 zbecJjc/hAvtF+dIVX7G45TT2cHv+4wHNkqQNj1wJpR+Z+tKOJuMAbXoJvkCaQUN0NaNr
	 cjNChz+n+Y8CqfoGDUOogZxOOgyhj/VW+Eyz1mIcsfkoKFGohhEJQyP2DhsKY6EGnIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316109;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=9KXT4dHagJhrc5RYxqkBMcxc0mqm0x3wYl4HY30il/o=;
	b=C4ulzRs30S7gHn9W8ttwVrx7skcrdJqwy/7Y+P8gG0HEDp857HgQWBVqb5nj1Nc85pQ1
	 rtPhPHR0ZAJSvKAoQX3qodJvF9vzZEOGHwLKlvFTHs5ubnhqK3bKENqWR6MQIoTz+dLoM
	 7UMQKKHqnhBUWLK+ByNbnRxEaVi3rPElR4atYM804zaQ2CJRJYSH89RXdvm67+uYSCn/e
	 zdPyXf2W0RTWtK/k/pcWGKa8JS7IGwWSKz8QUOOK9Ji7cCjX1uIkF6N2XxvE9XyS02EmN
	 9qOgPqhHmkUSaUjRgmtjcZy0CPlLEyqv2ryNYGTD/owvebep69w9+erKgFiMMkget1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE22C606A31A
	for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 23:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE22C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-8486941f252so264550a34.3
        for <linux-sctp@vger.kernel.org>; Thu, 29 Oct 2026 16:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793316108; x=1793920908;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9KXT4dHagJhrc5RYxqkBMcxc0mqm0x3wYl4HY30il/o=;
        b=oYC6z/B/X196X9wKE8lUtyIhn9yy5xoVj8FoTIEnTQKY+cm0v9DKTYcDa3QEiI4/Hj
         sl6N0Xv36TcNkRCkrrnkgA1jdqvYDoNJalZ9kSa/vlAb6mEJ1kE8hWI3r1zGDdFxsLk3
         cC34F1zC+7bor1B7ob+ppj2Oy3z9DUcWhQ6RgKKCosCdFVNxWBmTSe7ccFJ7wIC0zpdi
         sm4lRnIMdoPyu0VzSmOedQrFwJCpwqc/GXjfTsoD5XcWaVXndmqpDZU2bwd8PSgSVf6z
         YlCNRL6wW7l1a4YO0dTKvSDbjbdWn3xoq8H7na9IiusFCTWgZ1FRJj/r4LemITfnxB1U
         gS4A==
X-Forwarded-Encrypted: i=1; AKwUvBzYMUjBBgo72P3KKCbAVNSYLg6o6nwe0/ZZ3AAU/tdQpUTdIc1qzahtyxODCqbnmzFpDcPlHA8C3GLB@vger.kernel.org
X-Gm-Message-State: AFq9FYK5S+TKP62gMXV5Eey2soGWeleod66dtTQm8Nm0L2lzTEsrsdYI
	WUuvrj6KiuIeoR1wM+K3fHuAjdY1r6YKjqWX44317APekcfz0yUvG2lqReIuyEAoU4rAM5wymjn
	VWXisO3JuwF9b2rg9+/r9tzBo0WmJc9wvJWUSlZd2IY8PjA6SIdPsNK8OuTc=
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:23c2:b0:4fb:73e8:5a25 with SMTP id
 5614622812f47-5640dee0b4bmr681041b6e.53.1793316107858; Thu, 29 Oct 2026
 16:21:47 -0700 (PDT)
Date: Thu, 29 Oct 2026 16:21:47 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae3d50b.9c6421ad.36baac.0003.GAE@google.com>
Subject: [syzbot] [sctp?] kernel BUG in __pskb_pull_tail (2)
From: syzbot <syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@kernel.org, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    21a7f44fd076 Merge tag 'devicetree-for-7.4' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1299b469580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b92e3106016c03ef
dashboard link: https://syzkaller.appspot.com/bug?extid=f15a6eff7a53f6eb7dc3
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-21a7f44f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9b86d9af9ad5/vmlinux-21a7f44f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6f435992c0d2/bzImage-21a7f44f.xz

AI-generated root cause summary:
When receiving an SCTP packet that is nonlinear (such as an SCTP GSO packet
constructed with fragments in frag_list), sctp_rcv attempts to linearize the
packet using skb_linearize() if the sk_buff is cloned (e.g., tapped by a packet
socket or shared) or not recognized as GSO. During linearization via
__skb_linearize() and __pskb_pull_tail(), skb_copy_bits() fails with -EFAULT due
to a discrepancy in frag_list fragment lengths or readable offsets, triggering a
BUG_ON assertion failure. In production builds, this BUG() results in an invalid
opcode oops and kernel panic, causing an immediate denial of service.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=f15a6eff7a53f6eb7dc3

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:2903!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 8843 Comm: syz.2.816 Tainted: G             L       syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
Code: 61 f8 48 89 df e8 6b 03 fe ff 31 ff 41 89 c4 89 c6 e8 af c5 61 f8 45 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 8c cb 61 f8 90 <0f> 0b e8 84 cb 61 f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90000007870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
RDX: ffff888031daa580 RSI: ffffffff89ac4f84 RDI: ffff888031daa580
RBP: ffffc900000078f0 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff2 R11: 0000000000000000 R12: 00000000000000e4
R13: 0000000000000180 R14: 0000000000000000 R15: ffff88803a46bb80
FS:  00007fa1c8fde6c0(0000) GS:ffff8880d44ac000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000037f0f000 CR4: 0000000000352ef0
Call Trace:
 <IRQ>
 __skb_linearize include/linux/skbuff.h:4025 [inline]
 skb_linearize include/linux/skbuff.h:4037 [inline]
 sctp_rcv+0x143e/0x3cc0 net/sctp/input.c:120
 ip_protocol_deliver_rcu+0x44c/0x4d0 net/ipv4/ip_input.c:207
 ip_local_deliver_finish+0x3fb/0x6e0 net/ipv4/ip_input.c:241
 NF_HOOK include/linux/netfilter.h:325 [inline]
 NF_HOOK include/linux/netfilter.h:319 [inline]
 ip_local_deliver+0x1a3/0x200 net/ipv4/ip_input.c:262
 dst_input include/net/dst.h:481 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:492 [inline]
 NF_HOOK include/linux/netfilter.h:325 [inline]
 NF_HOOK include/linux/netfilter.h:319 [inline]
 ip_rcv+0x33a/0x3c0 net/ipv4/ip_input.c:612
 __netif_receive_skb_one_core+0x197/0x1e0 net/core/dev.c:6405
 __netif_receive_skb+0x1f/0x120 net/core/dev.c:6518
 process_backlog+0x487/0x1600 net/core/dev.c:6869
 __napi_poll.constprop.0+0xaf/0x450 net/core/dev.c:7938
 napi_poll net/core/dev.c:8001 [inline]
 net_rx_action+0xa40/0xf20 net/core/dev.c:8158
 handle_softirqs+0x216/0xa20 kernel/softirq.c:669
 do_softirq kernel/softirq.c:569 [inline]
 do_softirq+0xaf/0xf0 kernel/softirq.c:556
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xff/0x120 kernel/softirq.c:473
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 __dev_queue_xmit+0xa73/0x4a50 net/core/dev.c:5101
 dev_queue_xmit include/linux/netdevice.h:3483 [inline]
 neigh_hh_output include/net/neighbour.h:538 [inline]
 neigh_output include/net/neighbour.h:552 [inline]
 ip_finish_output2+0xfa4/0x2740 net/ipv4/ip_output.c:236
 __ip_finish_output.part.0+0x43b/0x6f0 net/ipv4/ip_output.c:314
 __ip_finish_output net/ipv4/ip_output.c:302 [inline]
 ip_finish_output net/ipv4/ip_output.c:324 [inline]
 NF_HOOK_COND include/linux/netfilter.h:314 [inline]
 ip_output+0x392/0xc00 net/ipv4/ip_output.c:437
 dst_output include/net/dst.h:471 [inline]
 ip_local_out+0x193/0x1f0 net/ipv4/ip_output.c:131
 __ip_queue_xmit+0x876/0x1f50 net/ipv4/ip_output.c:533
 sctp_v4_xmit+0x91a/0x1070 net/sctp/protocol.c:1061
 sctp_packet_transmit+0x22fe/0x30b0 net/sctp/output.c:659
 sctp_outq_flush_transports net/sctp/outqueue.c:1174 [inline]
 sctp_outq_flush+0xb2b/0x3380 net/sctp/outqueue.c:1222
 sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1826 [inline]
 sctp_side_effects net/sctp/sm_sideeffect.c:1211 [inline]
 sctp_do_sm+0xce1/0x5c30 net/sctp/sm_sideeffect.c:1182
 sctp_assoc_bh_rcv+0x392/0x740 net/sctp/associola.c:1048
 sctp_inq_push+0x25c/0x320 net/sctp/inqueue.c:91
 sctp_backlog_rcv+0x169/0x590 net/sctp/input.c:331
 sk_backlog_rcv include/net/sock.h:1194 [inline]
 __release_sock+0x39d/0x440 net/core/sock.c:3341
 release_sock+0x1e5/0x280 net/core/sock.c:3940
 sctp_sendmsg+0x1166/0x22e0 net/sctp/socket.c:2091
 inet_sendmsg+0x11c/0x140 net/ipv4/af_inet.c:864
 sock_sendmsg_nosec net/socket.c:800 [inline]
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0xa23/0xc30 net/socket.c:2715
 ___sys_sendmsg+0x190/0x1e0 net/socket.c:2769
 __sys_sendmmsg+0x20c/0x440 net/socket.c:2858
 __do_sys_sendmmsg net/socket.c:2885 [inline]
 __se_sys_sendmmsg net/socket.c:2882 [inline]
 __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2882
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1c819f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa1c8fde028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fa1c8426180 RCX: 00007fa1c819f559
RDX: 0000000000000001 RSI: 00002000000004c0 RDI: 0000000000000006
RBP: 00007fa1c8236b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa1c8426218 R14: 00007fa1c8426180 R15: 00007fff741e8248
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
Code: 61 f8 48 89 df e8 6b 03 fe ff 31 ff 41 89 c4 89 c6 e8 af c5 61 f8 45 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 8c cb 61 f8 90 <0f> 0b e8 84 cb 61 f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90000007870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
RDX: ffff888031daa580 RSI: ffffffff89ac4f84 RDI: ffff888031daa580
RBP: ffffc900000078f0 R08: 0000000000000005 R09: 0000000000000000
R10: 00000000fffffff2 R11: 0000000000000000 R12: 00000000000000e4
R13: 0000000000000180 R14: 0000000000000000 R15: ffff88803a46bb80
FS:  00007fa1c8fde6c0(0000) GS:ffff8880d44ac000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000037f0f000 CR4: 0000000000352ef0


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
