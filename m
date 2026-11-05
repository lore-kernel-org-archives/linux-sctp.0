Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793848436;
	b=yEfgRzJ1GxyPnFaNv3kD+XRh20CdLrafDJQSvd+Rj9UVoTM9vE65waSwIhrZLNaKUqtP
	 +cvni92w3ps71Byrmk9dkVq6nQN0ZJw5r1ICy2kLjjlcrL8RC6eqdfZEPFdQHqIGf2+Ig
	 gA9Vm7rl8EHp/qM8ZwGs64nTLToMznS+dSf1B/sWNiG9x7gRwsiVjejphZ9U3qK7284/V
	 aIrXiV6Tw3GI1NdTymDdqEW2pqOiV8cZweng5b4oFIcc7GuwpESFtvpQpBfoXJ5sjgwnl
	 hobbMpkWYQV4iIRKByLOJh9w9AFzKvTqDM/y9cN09TiDWS/t/IemYg+LLnsK6qfgWFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793848436;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=APb1zxIAvX78bkBqgur/Yfvw9HDOt3nX0NcaiIPyRNA=;
	b=bdoJvmyrEoLiad6FNGT7TVKUWU8Yfz/rxcy74n/Z3OukPPOYjxOS/kDvll6lQz4mHm2t
	 Pp1OSnVuJeKXM082ExpR3P8tTtfsgvRY5hNdOfeB3jeCrjzWsDFsuNj4w4N9ABHbGK4vw
	 IhkDHHNXhSr+SoV8uIJug8eGRpunYYYKYCeAYgvr9nevCh8nzuVkfW4xxAlZWyLLjuYzD
	 9QbCCaFORU3QxBPikliRz02VqgjAEYjC/y2IDMJUJzslJUZKb/atKaLX8L8vCgmIwhRdl
	 glfjZpPACBQj/gwEGrPyTcBixap9dnHZUwnh6XxTNlZEh0K5IhLO1f3Czt8MbPWSRjA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SotK8+sm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120F606A328
	for <linux-sctp@vger.kernel.org>; Thu,  5 Nov 2026 03:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2120F606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SotK8+sm
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a05e3f0d23so699886b3a.0
        for <linux-sctp@vger.kernel.org>; Wed, 04 Nov 2026 19:13:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793848435; cv=none;
        d=google.com; s=arc-20260327;
        b=sKIaH2M9cjRnczjIqYlUcwyW4gm7z/sjaia4ntjD8ncedqSaAQeK8UkblxXxyV1Y4x
         GoAyhrLVWfYxKk8iOJhk0DeYXqy4Zy/2YWHDiyVBl0trjaHJGWqTzvAHseWkRYvw5lIO
         mUcG+Bpqm+axZsSs14T+grKPR+v3e54iOFBJYIuTIAcbBavh1WpenNYdZ2fjdEqL1r5j
         oA/v2UjJhl6DX/cTjzC/E1bXJfwBYLlT481D20ZxRzvIKl40wopeycrAxmo97y+4G9nT
         KbqDCNgT7MLkPGeUHDL+5pBqQ5prXT8XxxQsIouU/Tj/ZeE/ZUx9wGx4QimvYDDLfMT/
         0TIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=APb1zxIAvX78bkBqgur/Yfvw9HDOt3nX0NcaiIPyRNA=;
        fh=Gk2RbWSmilvSEdSJjn0PYV/M/tdyipVo0YyIvYnVLpc=;
        b=SAx22doM3GpKzBUu+Vf3Ip1nm6GtbGhE+7aRv2J9iayylz4iGsctirQmjiXExW2s4D
         ro5MMvo7/Vbtzh41megGe/+7CSgNHfLOOXNuZ+vRRhZNDO0gA63FX/OHmMi87QzEenW5
         UEMzYF7Csc8nZpOGvAXz4D2iIRHjakbHcwzqHsFrCO19Y/0PpGBGD2UHBVAQdMRwVFi9
         AT4O3ndqxlcjMFkBZWSW/jmopFQCBkEIwQD/eIKqFs/sc6Xrh2nlJrNZOSaQ68pGRayv
         W32r4T3WreuZ3vU4uNWchADToKTdwZ+34GwzpXzQ2ncjzjULBqYDjHBepSr4JicNPLya
         ErfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793848435; x=1794453235; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=APb1zxIAvX78bkBqgur/Yfvw9HDOt3nX0NcaiIPyRNA=;
        b=SotK8+smhvTUz4PSDyKGGwKHQT37/ySX4O669vPZw3Y0ELWARihuFr6hV9JHo02O85
         iFWoIXL4q+fSWCkcxBGA9m2vH9VxdwGkgF3MXMMNfDINB72d4WbWc2+9pPo5lOD/BOCE
         94aDCIN7y/RrwVkylu5ixdn++P7o0COea4HsYz8D6+77TVIcN9SJ458yU38AMgDT7NIj
         0byKk/5SP5GYBHFIZ9ObiSyP7x6kBUbTeQMSkqaU+2IaQMqVkQDda/GaEcbETx5NW201
         VoMLJAQPmg3xOvRyA+7eYXE/mbUCc+nMXESjC9WD7nJu3X9PXQvQKGrnPVUwEj3921E+
         CC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793848435; x=1794453235;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=APb1zxIAvX78bkBqgur/Yfvw9HDOt3nX0NcaiIPyRNA=;
        b=UAt+dIwTxROE35UDCXZLx6aFcnqcwOcAB777nTGsoQQ/2mfnZREbXj5svG7cAI8nrL
         Q28ez8jnAUG5x9YWrkDhTlkb23R3zSDb5FBl8PzXCuIWXqANB3KLT/DJ4px+455HzB5F
         QTxkMsbOXbZdCn2BmvtZLqoTvSQekrbgF/hah8yifh1PCpFQ5NAT75k2w4rThN1FKfzA
         RKQs0103J84fi/Edh8rLXwJnEdcOSw28CbsXcH8IGXh2CTatFlGJuJjBjGMWa+jsv0mM
         mJteymnL2cTEL0fQ5r3OiIwVMXletk7OtpioKd/BmdwH6bNNvXM3if8BaHkKSuIuLDK/
         IY8A==
X-Forwarded-Encrypted: i=1; AKwUvBx9UB0WKWd9LgHJHTmZNrQgw0NpeHZfHbMaBAIPtbdy6P5z+4fdRlx5e9sdv+CnkdcTRaX9+LL4HrM4@vger.kernel.org
X-Gm-Message-State: APuU4Z9keZErdjyZlPZ/QeYcuaNbj0Eg/BJOMgLk9R2byiLmTX2QcSOE
	v3LtTmSe4+5TM+O3cCeffaHvuCi/fzF5C/6gaimWv8M/cWchE8yq8PDK42YPmxkcsMU661XhcBw
	eDBWx9OzcPbo0TXjo+jsEPBacQjJacxk=
X-Gm-Gg: AYBFou2HJEHk857vvpZHdV97tjnqqfredvG5MJg0dZhoh6yoy1gGuRcYgnHDnAbcXV1
	5LF/Eq/DgRLxfD/JiLoXQmmfoxGRfcRvMByhAL8FuR9dZmfDZJ4VuUvowpJL8HJA8qDA54Ym1V1
	a+hurWfuuDg+9ldHAzDh2BixsD6h60XVDUZdbxLn3ZAJc8AzXvyqqWRkabF5mF+8xOTgy8aU5jS
	6+GkbpAmSszqFyObNXCJPBM6QUB3LkXMg75JsjHZAl3gFbUlCilTgW2OykDQ9N8tdUisDrdgqhL
	XjJwC9OJaaR3v7q66IfY+Q/6e5pog5cybdjcccIoZhwlCwv9pFcNIDX24aF+DMUus64CyvMqzSK
	GZsKWkOfZr/17H5YFRUr8ywoUoZs0Wm1vRFMtwrRhhzjHtUFwO0S2o8OXrkjfuM+YAfzjcTO1El
	/D9LEqp8wAaCDKxuWq4vuRGbJAGMICMJOQdg==
X-Received: by 2002:a05:6a21:4e03:b0:3de:79fe:13f with SMTP id
 adf61e73a8af0-3e928d4d2bdmr15266438637.38.1793848435284; Wed, 04 Nov 2026
 19:13:55 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <6ae3d50b.9c6421ad.36baac.0003.GAE@google.com> <6aeabca9.fc50a118.dd1b.0001.GAE@google.com>
In-Reply-To: <6aeabca9.fc50a118.dd1b.0001.GAE@google.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Nov 2026 22:13:43 -0500
X-Gm-Features: AclHuK-yj_RUDHyp9Y1n7HDYnVb1Clcvxnwwl_T_i4pkmkAMpXWxuQiWBKy17_s
Message-ID: <CADvbK_cMBZbgujcxnj+rvwthSdNQzxEFXvr5jKr4HweQZbHZ+A@mail.gmail.com>
Subject: Re: [syzbot] [sctp?] kernel BUG in __pskb_pull_tail (2)
To: syzbot <syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@kernel.org, horms@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 12:03=E2=80=AFAM syzbot
<syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    05441d697f7f Merge tag 'cocci-7.4-rc1' of git://git.kerne=
l..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D162b8add58000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1cf189394a856=
f11
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df15a6eff7a53f6e=
b7dc3
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for D=
ebian) 2.44
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D11b49b29580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15b49b2958000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-05441d69.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/0edd3964be19/vmlinu=
x-05441d69.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/84d6d8dd5648/b=
zImage-05441d69.xz
>
> AI-generated root cause summary:
> When receiving an SCTP packet that is nonlinear (such as an SCTP GSO pack=
et
> constructed with fragments in frag_list), sctp_rcv attempts to linearize =
the
> packet using skb_linearize() if the sk_buff is cloned (e.g., tapped by a =
packet
> socket or shared) or not recognized as GSO. During linearization via
> __skb_linearize() and __pskb_pull_tail(), skb_copy_bits() fails with -EFA=
ULT due
> to a discrepancy in frag_list fragment lengths or readable offsets, trigg=
ering a
> BUG_ON assertion failure. In production builds, this BUG() results in an =
invalid
> opcode oops and kernel panic, causing an immediate denial of service.
>
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=3Df15a6ef=
f7a53f6eb7dc3
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+f15a6eff7a53f6eb7dc3@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:2903!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 2 UID: 0 PID: 6002 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2 04/01/2014
> RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
> Code: 5b f8 48 89 df e8 2b 03 fe ff 31 ff 41 89 c4 89 c6 e8 7f 58 5b f8 4=
5 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 5c 5e 5b f8 90 <0f> 0b e8 54 5e=
 5b f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc90000648870 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
> RDX: ffff88802ce60000 RSI: ffffffff89b30684 RDI: 0000000000000005
> RBP: ffffc900006488f0 R08: 0000000000000000 R09: 00000000fffffff2
> R10: ffff888046a12f77 R11: 0000000000000000 R12: 00000000000000e4
> R13: 0000000000000180 R14: 0000000000000000 R15: ffff888030406780
> FS:  000055558120b500(0000) GS:ffff8880d467c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000001a000 CR3: 00000000385f5000 CR4: 0000000000352ef0
> Call Trace:
>  <IRQ>
>  __skb_linearize include/linux/skbuff.h:4025 [inline]
>  skb_linearize include/linux/skbuff.h:4037 [inline]
>  sctp_rcv+0x143e/0x3cc0 net/sctp/input.c:120
>  ip_protocol_deliver_rcu+0x44c/0x4d0 net/ipv4/ip_input.c:207
>  ip_local_deliver_finish+0x3fb/0x6e0 net/ipv4/ip_input.c:241
>  NF_HOOK include/linux/netfilter.h:325 [inline]
>  NF_HOOK include/linux/netfilter.h:319 [inline]
>  ip_local_deliver+0x1a3/0x200 net/ipv4/ip_input.c:262
>  dst_input include/net/dst.h:481 [inline]
>  ip_rcv_finish net/ipv4/ip_input.c:492 [inline]
>  NF_HOOK include/linux/netfilter.h:325 [inline]
>  NF_HOOK include/linux/netfilter.h:319 [inline]
>  ip_rcv+0x33a/0x3c0 net/ipv4/ip_input.c:612
>  __netif_receive_skb_one_core+0x197/0x1e0 net/core/dev.c:6433
>  __netif_receive_skb+0x1f/0x120 net/core/dev.c:6546
>  process_backlog+0x487/0x1600 net/core/dev.c:6897
>  __napi_poll.constprop.0+0xaf/0x450 net/core/dev.c:7966
>  napi_poll net/core/dev.c:8029 [inline]
>  net_rx_action+0xa40/0xf20 net/core/dev.c:8186
>  handle_softirqs+0x216/0xa20 kernel/softirq.c:669
>  do_softirq kernel/softirq.c:569 [inline]
>  do_softirq+0xaf/0xf0 kernel/softirq.c:556
>  </IRQ>
>  <TASK>
>  __local_bh_enable_ip+0xff/0x120 kernel/softirq.c:473
>  local_bh_enable include/linux/bottom_half.h:33 [inline]
>  ipt_do_table+0xd71/0x1b10 net/ipv4/netfilter/ip_tables.c:357
>  nf_hook_entry_hookfn include/linux/netfilter.h:165 [inline]
>  nf_hook_slow+0xbf/0x220 net/netfilter/core.c:633
>  nf_hook include/linux/netfilter.h:280 [inline]
>  __ip_local_out+0x541/0xb80 net/ipv4/ip_output.c:120
>  ip_local_out+0x2a/0x1f0 net/ipv4/ip_output.c:129
>  __ip_queue_xmit+0x876/0x1f50 net/ipv4/ip_output.c:533
>  sctp_v4_xmit+0x91a/0x1070 net/sctp/protocol.c:1061
>  sctp_packet_transmit+0x22fe/0x30b0 net/sctp/output.c:659
>  sctp_outq_flush_transports net/sctp/outqueue.c:1174 [inline]
>  sctp_outq_flush+0xb2b/0x3380 net/sctp/outqueue.c:1222
>  sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1826 [inline]
>  sctp_side_effects net/sctp/sm_sideeffect.c:1211 [inline]
>  sctp_do_sm+0xce1/0x5c30 net/sctp/sm_sideeffect.c:1182
>  sctp_assoc_bh_rcv+0x392/0x740 net/sctp/associola.c:1048
>  sctp_inq_push+0x25c/0x320 net/sctp/inqueue.c:91
>  sctp_backlog_rcv+0x169/0x590 net/sctp/input.c:331
>  sk_backlog_rcv include/net/sock.h:1194 [inline]
>  __release_sock+0x39d/0x440 net/core/sock.c:3341
>  release_sock+0x1e5/0x280 net/core/sock.c:3940
>  sctp_sendmsg+0x1166/0x22e0 net/sctp/socket.c:2091
>  inet_sendmsg+0x11c/0x140 net/ipv4/af_inet.c:864
>  sock_sendmsg_nosec net/socket.c:800 [inline]
>  __sock_sendmsg net/socket.c:818 [inline]
>  ____sys_sendmsg+0xa23/0xc30 net/socket.c:2715
>  ___sys_sendmsg+0x190/0x1e0 net/socket.c:2769
>  __sys_sendmmsg+0x20c/0x440 net/socket.c:2858
>  __do_sys_sendmmsg net/socket.c:2885 [inline]
>  __se_sys_sendmmsg net/socket.c:2882 [inline]
>  __x64_sys_sendmmsg+0x9c/0x100 net/socket.c:2882
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff80879fb19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff70bcd848 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007ff808a25fa0 RCX: 00007ff80879fb19
> RDX: 0000000000000001 RSI: 0000200000000e40 RDI: 0000000000000004
> RBP: 00007ff808837b70 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff808a25fac R14: 00007ff808a25fa0 R15: 00007ff808a25fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__pskb_pull_tail+0x1335/0x1920 net/core/skbuff.c:2903
> Code: 5b f8 48 89 df e8 2b 03 fe ff 31 ff 41 89 c4 89 c6 e8 7f 58 5b f8 4=
5 84 e4 0f 84 1c f2 ff ff e9 84 f2 ff ff e8 5c 5e 5b f8 90 <0f> 0b e8 54 5e=
 5b f8 48 8b 54 24 30 48 b8 00 00 00 00 00 fc ff df
> RSP: 0018:ffffc90000648870 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 00000000fffffff2 RCX: 0000000000000101
> RDX: ffff88802ce60000 RSI: ffffffff89b30684 RDI: 0000000000000005
> RBP: ffffc900006488f0 R08: 0000000000000000 R09: 00000000fffffff2
> R10: ffff888046a12f77 R11: 0000000000000000 R12: 00000000000000e4
> R13: 0000000000000180 R14: 0000000000000000 R15: ffff888030406780
> FS:  000055558120b500(0000) GS:ffff8880d467c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000020000001a000 CR3: 00000000385f5000 CR4: 0000000000352ef0
>
>
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

Thanks for the reproducer.

The issue was caused by iptables TEE target (`pskb_copy`), where the new
skb doesn't copy the skbs in frag_list, so modifying the skbs from frag_lis=
t
in sctp stack is not safe.

I will prepare a patch for this.
