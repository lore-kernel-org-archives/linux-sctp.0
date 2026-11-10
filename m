Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794312231;
	b=wjnomZQFu8f/0eIU0GQzNDFvUWSYDsAKVynxOFnXdSWEOVx17veWYYvWXKW3QBSjayUd
	 ZfSyDqffn6XFIuxjL/wE6WX3bawzOaXI/eK2CWTlDn7QLNUwNCKeVXvlP6IA3U0Yr1c2D
	 jM1ej5sRAmQskfMgfIsKU1QGGfBgMld3s2oJlKwBTPQh1O97dVJO0ettZ+qkxIJtHqlp4
	 8veuVUy8GvAjGLC4JvExr3gjymb5IsoKwOxGnyJ1G3Jfh0UxT3pes1Lepmg26v4Zs9VnN
	 lkbjSotrg/60z9aJRu576ZETbEgxdFflEfVpsKGTSD+v7yH+XtD3Z1fHvS5js0zYfgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794312231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=pqLHXawZlGErQii6rLTx7gLohrIRe5nAcrcd/ce+DdU=;
	b=zWdK47B0Y9iFqudR/3ksjLQ5DG/zZMtkSpv/MG4yR0MoC1usfO767ApGeIDuKheSF/mb
	 9d5WQQBaOk0cE8xKTkWP8hkc39BW+S2eSU6HxaVjehXospIObj4W3ySRAJR50Rt27ee/2
	 Y+Xkyq/pCsAroYoVcUL9ABsdAjrBgY9jaYF4ZqaOUPTOWEL5pY3+i7q8W5RDdQ8gqozAY
	 yjaqZ5T859bOwDpseSu5Rjb9zoI73w3ZM4K0GjGsms6PXEsCvhHtzjDOi3rXC7Ut121mX
	 bUXWndRLkxIHDcmljvgrg+pP2UDlH30jmgB3B9y6ITN6W1R+dW6M4Libhkoy9CTtmXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V47ELy0a;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12527606A335
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 12:03:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12527606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V47ELy0a
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cdb2893531bso1102230a12.1
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 04:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794312227; x=1794917027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pqLHXawZlGErQii6rLTx7gLohrIRe5nAcrcd/ce+DdU=;
        b=V47ELy0aMx3z2Naonb3DmCacCrfE7SIE+sy9aaEqq27CpcKuobe1/sQSA24LvM+KbW
         kI14xII7Y3V6GLo8TLXqrq0hXgs7gLANMkiIfFBR1ERJBNMl1t4wg5zsB9cMBqRXTjbo
         8af5B/blUUZJ1j334r+TOINRHsdZXrfr1TUx8Mc48e5ADmIyusvLo4XMllqu1SjQzkdq
         Sof75grKyHLcBHDjUHZFLDWRZRPUNV0EouLhmxwBC9P17kC1t6BjqzWNlqi+MNWbYh7O
         AfrEvpr8+6KMyqRZUrTO5GmRm2dZl9JxF18mY19c1bmWyH7caZo9QgtblsDmxbS8MkYb
         nptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794312227; x=1794917027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pqLHXawZlGErQii6rLTx7gLohrIRe5nAcrcd/ce+DdU=;
        b=WqnKHJrjd5eXDoaGQAFrKPECJTk0sQdLCHK0/fpqzZ6kvDoDDf5mQxM705fQIirGCI
         HLuwcbmAryL6hZ9wfFT4wTygObeZxe4EBc8VqgbKzCvKxtEsJI69jQXhkCgeoup9+0YX
         0c8dc++7DtxG9CzS/+VA5Bmk4pXNZBU0LxwoKi1EdfgpTqG2H3NWDzBxvq7KF8U5bqJg
         C8lPSdFKcsHY6YeHj4imxQTtZH2XaNNX+H0EYf4T6/l8M/BDKBZKa24gY6pXmBZ4b20q
         /YIC9dzfcKBWRbLlYVN2ZrKzNdeeQZWlem4GuiatmsS3c6KtNtkZ0QfpX204Yh0oITFw
         w3Bw==
X-Gm-Message-State: APuU4Z/dEgReTVctaX8TeVA0JxT6S7yxr/x+gkE/5cGEZDKRZOC+vIVA
	0N77S8KGAxwjpfVA/d67/EKwjMBilfxG9kksXnwbq/FVurGSZD++Zzp8
X-Gm-Gg: AYBFou3t8gyv2hzx5dt9hm/v7VZ7xuqFqUBNW0OlimaxPiVUrbWsC8h7ycBWWEMqBU+
	QyfpZgOFwvk/DresDV0+UufJaHK+7MU7nGFBS5cC+2A0g73J4gY2ywrkVln2Ci7UMeE50lg1Fdf
	5uy207Vt9ANC4LGvEXCY/wo3Jq3OTMBCi/LZ7PqNWfsePT4L4tVnY56Ol+CPYSn+tHqdQ2IY/zY
	Z6DdlqthxSN6YE+Kp0qwW5B8p2fl3vrNrT4uMEt0n3myyufe0dkg6CdtdzI79DLEXy5b5+urffZ
	xzyJe6XbeFtstnUVSJRGyCBCXEZoHTpAW9j2DVwDTM5eMqG1bXkuoHshGTk8anc2BQSC6niQTfF
	/PD6b/9tDbcpEGZSBtLTVCust6GlqumdtkvEY6VE91JkYHdomAH1hwV+KCwMbwDDyUZnS81sByu
	aLSQppHl7yiyTY9XKnB7fMLCNFG+8yZJck5ZdJUFM8MoREstEnjbHeYNbO2JjawJzy153Etycf4
	IDwyyJNJpUvQPBxWz+dghJRKvbiN1bD/V9NDUiF5vPinNpXLkYWJA/bQp9XlbFLA8e4S8gA1YOn
	e4pluYQybaQVWWchJgPB0y2ZSqCb+pRfiwQLX2uhyA==
X-Received: by 2002:a17:90a:e7c8:b0:3ac:da41:ef7e with SMTP id 98e67ed59e1d1-3b166d1a008mr2560989a91.52.1794312227260;
        Tue, 10 Nov 2026 04:03:47 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b16771705asm3693853a91.12.2026.11.10.04.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:03:46 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] sctp: fix timer locking across association migration
Date: Tue, 10 Nov 2026 20:02:08 +0800
Message-ID: <20261110120212.1110283-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes SCTP timer callbacks revalidate the association's socket
after taking its BH lock. If accept or peeloff moves the association before
the callback acquires the lock, the callback can otherwise process queues
under the old socket's lock while abortive close tears them down under the
new socket's lock. The T3 retransmit path then reads a freed chunk.

One possible interleaving on the unfixed kernel (time flows downward):

  CPU 0: sctp_generate_t3_rtx_event()  CPU 1 (peeloff / abortive close)
  -----------------------------------  ------------------------------------
  sk = asoc->base.sk; /* oldsk */
                                       lock_sock(oldsk);
                                       lock_sock_nested(newsk, ...);
                                       asoc->base.sk = newsk;
                                       release_sock(newsk);
                                       release_sock(oldsk);
  bh_lock_sock(sk); /* oldsk */
  sock_owned_by_user(sk) == false
  sctp_retransmit_mark(...);
  chunk = list_entry(...);
                                       lock_sock(newsk);
                                       sctp_primitive_ABORT(...);
                                       sctp_association_free(asoc);
                                       sctp_outq_free(&asoc->outqueue);
                                       __sctp_outq_teardown(...);
                                       /* chunk is freed */
  sctp_chunk_abandoned(chunk);
  /* reads freed chunk: UAF */
  bh_unlock_sock(sk);

The development and reproduction baseline is Linux 7.4.0-rc2 at commit
b3dfbde62cf1981c4638939c159dfd087b7a72e9. The UAF was reproduced with an
mdelay() instrumentation patch widening the windows between the T3
callback caching the socket and locking it, and between the retransmit
path obtaining a queued chunk and using it. With unacknowledged
DATA pending, peeloff moves the association to a new socket; abortive close
of that socket frees the chunks while the timer is still running.

The patch treats an association/socket mismatch like a busy socket and
reschedules the timer through the existing reference-counted retry path.
The next callback reads the current socket again. The check is applied to
the six timer entry points with this locking pattern.

KASAN report:

[  417.538580] ==================================================================
[  417.538597] BUG: KASAN: slab-use-after-free in sctp_chunk_abandoned+0x706/0x840
[  417.538674] Read of size 8 at addr ffff8881079c8a90 by task swapper/0/0

[  417.538684] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.4.0-rc2-gb3dfbde62cf1-dirty #2 PREEMPT(lazy) 
[  417.538687] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  417.538691] Call Trace:
[  417.538698]  <IRQ>
[  417.538700]  dump_stack_lvl+0x53/0x70
[  417.538710]  print_report+0xd0/0x630
[  417.538737]  kasan_report+0xce/0x100
[  417.538741]  sctp_chunk_abandoned+0x706/0x840
[  417.538746]  sctp_retransmit_mark+0x107/0xb00
[  417.538749]  sctp_retransmit+0x25a/0x5b0
[  417.538751]  sctp_do_sm+0x3c01/0x5c30
[  417.538810]  sctp_generate_t3_rtx_event+0x174/0x270
[  417.538814]  call_timer_fn+0x29/0x230
[  417.538818]  __run_timers+0x56a/0x8d0
[  417.538861]  timer_expire_remote+0xd3/0x120
[  417.538872]  tmigr_handle_remote_up+0x4e0/0xa60
[  417.538890]  __walk_groups_from+0x40/0x150
[  417.538892]  tmigr_handle_remote+0x229/0x2c0
[  417.538901]  run_timer_softirq+0x1f5/0x250
[  417.538908]  handle_softirqs+0x1b3/0x600
[  417.538917]  __irq_exit_rcu+0xfc/0x160
[  417.538919]  sysvec_apic_timer_interrupt+0x6b/0x80
[  417.538923]  </IRQ>
[  417.538924]  <TASK>
[  417.538925]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[  417.538928] RIP: 0010:pv_native_safe_halt+0xf/0x20
[  417.538931] Code: 44 de 00 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 73 44 16 00 fb f4 <c3> cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90
[  417.538933] RSP: 0018:ffffffff85e07d10 EFLAGS: 00000212
[  417.538939] RAX: ffff88819372e000 RBX: ffffffff85e18700 RCX: ffffffff84ef0c0b
[  417.538940] RDX: ffffed10236062a3 RSI: 0000000000000004 RDI: 00000000000324bc
[  417.538942] RBP: fffffbfff0bc30e0 R08: 0000000000000001 R09: ffffed10236062a2
[  417.538943] R10: ffff88811b031513 R11: 0000000000000002 R12: 0000000000000000
[  417.538944] R13: 0000000000000000 R14: 1ffffffff0bc0fa6 R15: dffffc0000000000
[  417.538948]  default_idle+0x9/0x10
[  417.538952]  default_idle_call+0x39/0x60
[  417.538954]  do_idle+0x37b/0x560
[  417.538960]  cpu_startup_entry+0x4f/0x60
[  417.538962]  rest_init+0x186/0x1b0
[  417.538997]  start_kernel+0x354/0x3b0
[  417.539009]  x86_64_start_reservations+0x18/0x30
[  417.539013]  x86_64_start_kernel+0x111/0x120
[  417.539015]  common_startup_64+0x13e/0x158
[  417.539023]  </TASK>

[  417.539024] Allocated by task 255:
[  417.539027]  kasan_save_stack+0x33/0x60
[  417.539031]  kasan_save_track+0x14/0x30
[  417.539032]  __kasan_slab_alloc+0x6e/0x70
[  417.539034]  kmem_cache_alloc_noprof+0x10e/0x340
[  417.539039]  sctp_chunkify+0x42/0x270
[  417.539041]  _sctp_make_chunk+0x11c/0x230
[  417.539042]  sctp_make_datafrag_empty+0x134/0x200
[  417.539044]  sctp_datamsg_from_user+0x49d/0xf70
[  417.539046]  sctp_sendmsg_to_asoc+0x6cb/0x16b0
[  417.539049]  sctp_sendmsg+0x5c8/0x1960
[  417.539051]  __sys_sendto+0x31c/0x390
[  417.539061]  __x64_sys_sendto+0xdb/0x1b0
[  417.539063]  do_syscall_64+0xdf/0x4c0
[  417.539065]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

[  417.539068] Freed by task 255:
[  417.539069]  kasan_save_stack+0x33/0x60
[  417.539070]  kasan_save_track+0x14/0x30
[  417.539072]  kasan_save_free_info+0x3b/0x60
[  417.539075]  __kasan_slab_free+0x43/0x70
[  417.539077]  kmem_cache_free+0xba/0x3a0
[  417.539078]  __sctp_outq_teardown+0x16c/0x960
[  417.539080]  sctp_association_free+0x157/0x5e0
[  417.539082]  sctp_do_sm+0x31c7/0x5c30
[  417.539085]  sctp_primitive_ABORT+0x7c/0xd0
[  417.539086]  sctp_close+0x203/0x810
[  417.539088]  inet_release+0xc9/0x1c0
[  417.539096]  __sock_release+0xa1/0x260
[  417.539098]  sock_close+0x10/0x20
[  417.539100]  __fput+0x2f8/0x9e0
[  417.539107]  fput_close_sync+0xe2/0x190
[  417.539109]  __x64_sys_close+0x78/0xd0
[  417.539111]  do_syscall_64+0xdf/0x4c0
[  417.539113]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

[  417.539115] The buggy address belongs to the object at ffff8881079c8a00
                which belongs to the cache sctp_chunk of size 256
[  417.539117] The buggy address is located 144 bytes inside of
                freed 256-byte region [ffff8881079c8a00, ffff8881079c8b00)

[  417.539120] The buggy address belongs to the physical page:
[  417.539122] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1079c8
[  417.539125] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  417.539126] flags: 0x200000000000040(head|node=0|zone=2)
[  417.539132] page_type: f5(slab)
[  417.539134] raw: 0200000000000040 ffff8881017d5040 dead000000000100 dead000000000122
[  417.539139] raw: 0000000000000000 0000000000190019 00000000f5000000 0000000000000000
[  417.539140] head: 0200000000000040 ffff8881017d5040 dead000000000100 dead000000000122
[  417.539142] head: 0000000000000000 0000000000190019 00000000f5000000 0000000000000000
[  417.539143] head: 0200000000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
[  417.539145] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[  417.539146] page dumped because: kasan: bad access detected

[  417.539147] Memory state around the buggy address:
[  417.539148]  ffff8881079c8980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[  417.539149]  ffff8881079c8a00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  417.539150] >ffff8881079c8a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  417.539151]                          ^
[  417.539152]  ffff8881079c8b00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
[  417.539153]  ffff8881079c8b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  417.539154] ==================================================================
[  417.539179] Disabling lock debugging due to kernel taint

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent system.

A reproducer and additional reproduction materials are available. Please
contact me privately if you need them.

Regards,
liuyong
360 Vulnerability Research Institute

liuyong (1):
  sctp: revalidate the association socket in timer callbacks

 net/sctp/associola.c     |  4 ++--
 net/sctp/sm_sideeffect.c | 41 ++++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 23 deletions(-)

-- 
2.43.0

