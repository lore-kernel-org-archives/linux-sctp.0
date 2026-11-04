Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793768619;
	b=2dpntfKiPTC/xuRn4bkwA5RrvOyoSR/5BozvyT05Z1/DGwLkZKrWJCyfBa2w0dl4ivV5
	 kiVlSKga4b/ReLlAfastaMs8PMiuhzBT60oG9rj84cSc2dxeKXEg+CY3FxcHhDh6s6N4g
	 PY1M81wPwJgqMyrIyRzcE8xQkEMB6oAABj3I4F/SNLmfxH9kj493l5k1qaOn2iIGKaslh
	 3u+iVH/i3+7O3WS0kmXW7ZEiPAxUPcuEczMG4uxyPVCFAvsHF5v52H+Ij05c3JXKSPTCV
	 zES6m+PPdSamII/kY8qM6TdUS+VLMPiFCecWYSHGy5+fzjCLs9qnilS3HTYWZLa/wzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793768619;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=NwhFy6BQ6fYDBl77314WUNOYeP2MIqXuKdbvJFIH2ek=;
	b=JHaHI4X/Nn8mU/L4+AL1O78WjWCmPOgsEUYqzaRhHyN0T/IIgoI245gC63EfMvxY8zpy
	 ttb7GrZ9LzWD4J9P9JoniOhP/clMViecoJDBZCPvJ/C2n2WHHQnRdPOSTE7NEZB5U+mlM
	 8CtcCuiSbeaz+ajxhBvtcetbZiHw5pA4gla8MBxAMRebLE0GEO56zm9AX/l8G9UwJLDzU
	 EQG5TY8iIzODd7rRrrcl7ePIlzxF7l9VqbYiJ4893v5lXRPF2YKnYaTq6Y/dfgXKfApzV
	 fu9uXxcvP9Vi+nCW9rzYQP2BSVsMCqbOeQ2pY9ps7i1S752lCtXEiel6HY5TNE86iUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.199
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAA9606A328
	for <linux-sctp@vger.kernel.org>; Wed,  4 Nov 2026 05:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BAA9606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f2040e10d8so285785b6e.3
        for <linux-sctp@vger.kernel.org>; Tue, 03 Nov 2026 21:03:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793768618; x=1794373418;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NwhFy6BQ6fYDBl77314WUNOYeP2MIqXuKdbvJFIH2ek=;
        b=b6bS4yg5A04Mk1WvQ7yAYueMCW//PjAJAOMLxXEf6xnUNZlyaxHeueGQJRVMRTMzJ/
         4u9iVQnqaMqFh7StVfBz9GWMpD1jgkXUFz51lYcumzy6pdyBf1/ssYtAiwd1tyHuqKsx
         M+vl9cXzCy2azCi4h0MKeitAdgmrGwYxw/BMm9XMBkBn6cEPqPGfEg8yfDRW+/unyz7m
         KPQGWwmh/jA7+Iy4IZmLpbGib106CgJO+np/MZhPcf3I5BL9RdgByuWKdry2LS2tIdTh
         s2THbp700kyKy8d+GmQK11GLnVBED8t5LZ+2LG7fTVVhRdH97BTf5/QFqFOPo4GWBW41
         oBgQ==
X-Forwarded-Encrypted: i=1; AKwUvBx/ByV+3iZC84NWETZ5/rG7VdNmAj4rOVedPx+soN3MxMAH7fnsiWIWK9em5btUilUDQXOiqMdGhqXF@vger.kernel.org
X-Gm-Message-State: APuU4Z/PCd+KMoE2j3bWK9+ggqZyPqptHUSyaoDbft1TShWpZA/rFOEF
	fwboA4XwcSzLN4ooJyyX4gQZRyF7Qc3A8M2ZUybAay0lXkLRk9GqSvX0Vw65VsNTfRsvMxPsMKB
	vDx77uBCY8P92rsody1xGb3FP9F1PT55w1weQmG4ven3aADcsKjPP6M2Krok=
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2382:b0:4b9:e5fa:8a13 with SMTP id
 5614622812f47-5640dd44e89mr10919497b6e.24.1793768617926; Tue, 03 Nov 2026
 21:03:37 -0800 (PST)
Date: Tue, 03 Nov 2026 21:03:37 -0800
In-Reply-To: <6ae3d50b.9c6421ad.36baac.0003.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aeabca9.fc50a118.dd1b.0001.GAE@google.com>
Subject: Re: [syzbot] [sctp?] kernel BUG in __pskb_pull_tail (2)
From: syzbot <syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@kernel.org, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	lucien.xin@gmail.com, marcelo.leitner@gmail.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    05441d697f7f Merge tag 'cocci-7.4-rc1' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=162b8add580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1cf189394a856f11
dashboard link: https://syzkaller.appspot.com/bug?extid=f15a6eff7a53f6eb7dc3
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11b49b29580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15b49b29580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-05441d69.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0edd3964be19/vmlinux-05441d69.xz
kernel image: https://storage.googleapis.com/syzbot-assets/84d6d8dd5648/bzImage-05441d69.xz

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
CPU: 2 UID: 0 PID: 6002 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
Code: 5b f8 48 89 df e8 2b 03 fe ff 31 ff 41 89 c4 89 c6 e8 7f 58 5b f8 45 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 5c 5e 5b f8 90 <0f> 0b e8 54 5e 5b f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90000648870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
RDX: ffff88802ce60000 RSI: ffffffff89b30684 RDI: 0000000000000005
RBP: ffffc900006488f0 R08: 0000000000000000 R09: 00000000fffffff2
R10: ffff888046a12f77 R11: 0000000000000000 R12: 00000000000000e4
R13: 0000000000000180 R14: 0000000000000000 R15: ffff888030406780
FS:  000055558120b500(0000) GS:ffff8880d467c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000001a000 CR3: 00000000385f5000 CR4: 0000000000352ef0
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
 __netif_receive_skb_one_core+0x197/0x1e0 net/core/dev.c:6433
 __netif_receive_skb+0x1f/0x120 net/core/dev.c:6546
 process_backlog+0x487/0x1600 net/core/dev.c:6897
 __napi_poll.constprop.0+0xaf/0x450 net/core/dev.c:7966
 napi_poll net/core/dev.c:8029 [inline]
 net_rx_action+0xa40/0xf20 net/core/dev.c:8186
 handle_softirqs+0x216/0xa20 kernel/softirq.c:669
 do_softirq kernel/softirq.c:569 [inline]
 do_softirq+0xaf/0xf0 kernel/softirq.c:556
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0xff/0x120 kernel/softirq.c:473
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 ipt_do_table+0xd71/0x1b10 net/ipv4/netfilter/ip_tables.c:357
 nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
 nf_hook_slow+0xbf/0x220 net/netfilter/core.c:633
 nf_hook include/linux/netfilter.h:280 [inline]
 __ip_local_out+0x541/0xb80 net/ipv4/ip_output.c:120
 ip_local_out+0x2a/0x1f0 net/ipv4/ip_output.c:129
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
RIP: 0033:0x7ff80879fb19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff70bcd848 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007ff808a25fa0 RCX: 00007ff80879fb19
RDX: 0000000000000001 RSI: 0000200000000e40 RDI: 0000000000000004
RBP: 00007ff808837b70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff808a25fac R14: 00007ff808a25fa0 R15: 00007ff808a25fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
Code: 5b f8 48 89 df e8 2b 03 fe ff 31 ff 41 89 c4 89 c6 e8 7f 58 5b f8 45 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 5c 5e 5b f8 90 <0f> 0b e8 54 5e 5b f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
RSP: 0018:ffffc90000648870 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
RDX: ffff88802ce60000 RSI: ffffffff89b30684 RDI: 0000000000000005
RBP: ffffc900006488f0 R08: 0000000000000000 R09: 00000000fffffff2
R10: ffff888046a12f77 R11: 0000000000000000 R12: 00000000000000e4
R13: 0000000000000180 R14: 0000000000000000 R15: ffff888030406780
FS:  000055558120b500(0000) GS:ffff8880d467c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000001a000 CR3: 00000000385f5000 CR4: 0000000000352ef0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
