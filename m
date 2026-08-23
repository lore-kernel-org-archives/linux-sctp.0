Received: from mail-oi2-f4.google.com (mail-oi2-f4.google.com [74.125.231.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E0D49362B
	for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 13:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787490262; cv=none; b=kbAOURz5LEG1WkO+VJP886l1sbqM5r++dPo1/Wn9bkJcN2EVXPYx2ZxXHDBrh2qp1A9HLS8SpmkCAO4hZ4pCUN2VDcKjNJGSgOJzRFSSZgV+6Kyug/B5oQzaqPVDwrnnvbw/URtdMehp+795aqrQ8+fTGdmDMvzU3l9zPFh+3i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787490262; c=relaxed/simple;
	bh=dESsOJ3nB8kE5s6xivhaWVs5QBXwECAabLsp+3/NelA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JuCoL+I9RmrBaPGX/ZLgB1HcO12StXKcnkXFJm7TFSguQOCJsUxYEIkMc2fxmReLe6go+jMEzzdbxfisQhEmRpzpSL6guBHtX9jQiFVaaOO+AaOqTJF0CD2HY04M8iYrCDYWmK4xw4xnpqdWYVVdJ6cJarzFZchLHLTEEWCWZac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p4NdNvLM; arc=none smtp.client-ip=74.125.231.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4NdNvLM"
Received: by mail-oi2-f4.google.com with SMTP id 5614622812f47-49ec9d117f2so143501b6e.0
        for <linux-sctp@vger.kernel.org>; Sun, 23 Aug 2026 06:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787490258; x=1788095058; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mFBTHeOFuVWd/CaQPqjHq9RPHHOZPO5Fy/4i4ouPwjc=;
        b=p4NdNvLMljaA2fInGPjgI3hx0zvoKJgbIjzXe9grE2ZjaQ0yMbHAyriix01/UHGk7y
         adeMXTKy3UIHP20ECTRMOhPKpe0BBTBdTjvm7CyoTND4aR2GLqBmq7QA/XoKBkoDaRVE
         VpT/Sy++VMB7LGT5KXUIWNoE5e74DJSEL6V5r+YTLRbEsG03IvSOiayhij5j0hHl8+2A
         ekV7VZUU45pUczcnUS3QkPO2lN5J5BcQoTDKG9C3b67mjEOpb7uR4KqtYmY1Gb8J2rOb
         dQnkpi56i0cvrO6jKWx/XieMaSs2vW1RIdG0gPuuNG+D/ET8Nm9hXl6bZwSDqC4rJAZ+
         uc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787490258; x=1788095058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mFBTHeOFuVWd/CaQPqjHq9RPHHOZPO5Fy/4i4ouPwjc=;
        b=o/TXaHm+JBNK7nH9NwgaGWkwlCgLImAwt5CQb+YZk+XRsrpKqeMT5/mZNKGdnshMRj
         e95o2jYnq+6pPIlTQEoEZPWdYiaPs9+oup3Qi23Icp1018hEnOhdHHTkGIfE6lHDjtZQ
         /Y1Oe5Wl0s7yMwKXf3ic60G8TaQ8K5HqupVQwkLdcuZIlQzr2g+SLeHS37mqVd/KbbRO
         emd5CaNR5s84kCROnimeLIsxFwkoVoO84YqDGgXV1eRqICVw1FTQK4zl2U+ZiXXrmCaf
         QAA0fRMbOQE8CJImf386qN+AiAUH43E7BMxGBEXkU4aD5v/fB5inz85i0UDflibd7LOE
         WoXA==
X-Gm-Message-State: AFuF++nTMjbm0Sf1Ur7ptK2QUT9Gz/862EDQ9yrzZ+f1zrgjIYzhrb5t
	yj8ugjK90uu5qKz71IEMAZ4iJ6Dy00GVZIsOq0sfEru/gWujAZqXoyRW
X-Gm-Gg: AR+sD13MkM4S4LB7991RF5L7zNj55BwAx+eLdl2VQjcIO1M62tq3/P78WPbeSezYYug
	8a+1ck1+hixtC5c/LFkK6mmXPplEdXS/ae+X1OzIfAia2Lzo7qoJMuP7+pTUFNigxDpHRocUUHm
	nlMpKOT7mCIukVmcBB61R+CQP9kEdyGE6aXoeVfiohPFaW7oFTn5ioK0uW3Z+VtqGBXtJiVn7oW
	4tOUt2fqPXRkOyK7DALGUGXrzJmM1cC6SHyhMJOkl33/mk8F+ewXoeds8yYPGYGPlkZljaaFh5u
	t7PYDoqTdByRm/wXo7GgTpLEXUalM3WvFRtpHYd9JT0EhuujyxANZPTEVqUF22ZFrr+jBt8d7gU
	9rXdsQVjwyxKhrn05wsmX+zb8TZwYRhgPK5txAa9oGycwr+JTShqlD9TJ0dYfZv/1a8FHjkVgJ2
	QftZXXKD2MrVa4LrMMn2dGOnEHC3xHKptE9GB5idwi832GE/ykkWU8mQKmUR7jtFaMQQEGjoBDj
	IM1LSeoTIdGBFAEYcVthWLCfcg=
X-Received: by 2002:a05:6808:228f:b0:492:973e:1c23 with SMTP id 5614622812f47-4b309b2f7dfmr12955593b6e.15.1787490257771;
        Sun, 23 Aug 2026 06:04:17 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.41])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c8c8093sm1120758b6e.17.2026.08.23.06.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 06:04:16 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-sctp@vger.kernel.org,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: [PATCH net] sctp: fix slab OOB read from oversized AUTH parameters in COOKIE-ECHO
Date: Sun, 23 Aug 2026 21:04:05 +0800
Message-ID: <20260823130405.1337444-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sctp_unpack_cookie() copies the attacker-supplied sctp_cookie into the
new association without validating the length fields of the three
embedded AUTH parameters (auth_random, auth_hmacs, auth_chunks) against
their fixed in-struct capacities (36/12/20 bytes). When cookie
authentication is disabled (net.sctp.cookie_hmac_alg=none), a remote
peer can forge a COOKIE-ECHO with an inflated param_hdr.length.

The polluted length then drives out-of-bounds reads past the
association: n_elt in sctp_auth_asoc_verify_hmac_id() (up to ~64KB of
16-bit probe reads), the key vector memcpy in
sctp_auth_make_key_vector() (up to ~64KB source read copied into the
HMAC key material), and the chunk-id scan in __sctp_auth_cid().
KASAN reports slab-out-of-bounds reads crossing into unrelated slabs.
[  552.245703] ==================================================================
[  552.245873] BUG: KASAN: slab-out-of-bounds in sctp_auth_asoc_verify_hmac_id+0x105/0x110
[  552.246050] Read of size 2 at addr ffff8881012a90f4 by task poc_guest/333

[  552.246258] CPU: 1 UID: 0 PID: 333 Comm: poc_guest Tainted: G    B               7.2.0-rc6-dirtyfrag-00017-g848acc8ffe1b-dirty #65 PREEMPT(lazy) 
[  552.246283] Tainted: [B]=BAD_PAGE
[  552.246291] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-4.tl4 04/01/2014
[  552.246304] Call Trace:
[  552.246328]  <IRQ>
[  552.246344]  dump_stack_lvl+0x53/0x70
[  552.246374]  print_report+0xce/0x620
[  552.246395]  ? sctp_auth_asoc_verify_hmac_id+0x105/0x110
[  552.246412]  kasan_report+0xce/0x100
[  552.246430]  ? sctp_auth_asoc_verify_hmac_id+0x105/0x110
[  552.246453]  sctp_auth_asoc_verify_hmac_id+0x105/0x110
[  552.246473]  sctp_sf_authenticate+0xd2/0x470
[  552.246491]  ? __pfx__raw_spin_lock+0x10/0x10
[  552.246508]  sctp_auth_chunk_verify+0x25b/0x380
[  552.246526]  ? __pfx_sctp_auth_chunk_verify+0x10/0x10
[  552.246558]  ? sctp_auth_asoc_init_active_key+0x1eb/0x810
[  552.246576]  ? sctp_auth_asoc_init_active_key+0x163/0x810
[  552.246598]  sctp_sf_do_5_1D_ce+0x6cf/0x1b50
[  552.246619]  ? __pfx_sctp_sf_do_5_1D_ce+0x10/0x10
[  552.246637]  ? stack_depot_save_flags+0x485/0x7f0
[  552.246675]  ? __pfx_sctp_sm_lookup_event+0x10/0x10
[  552.246696]  sctp_do_sm+0x111/0x5b90
[  552.246732]  ? ip_local_deliver_finish+0x31c/0x4a0
[  552.246751]  ? ip_rcv+0x2ed/0x360
[  552.246768]  ? process_backlog+0x1ea/0x5f0
[  552.246785]  ? __napi_poll+0xa1/0x530
[  552.246801]  ? net_rx_action+0x944/0xfa0
[  552.246816]  ? handle_softirqs+0x1bd/0x620
[  552.246831]  ? do_softirq+0x43/0x60
[  552.246844]  ? __local_bh_enable_ip+0x6a/0x70
[  552.246858]  ? __dev_queue_xmit+0x9f3/0x3470
[  552.246874]  ? ip_finish_output2+0x724/0x1900
[  552.246889]  ? __pfx_sctp_do_sm+0x10/0x10
[  552.246903]  ? raw_sendmsg+0xe72/0x2710
[  552.246919]  ? __x64_sys_sendto+0xe0/0x1c0
[  552.246938]  ? do_syscall_64+0x102/0x5a0
[  552.246955]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  552.246991]  ? __pfx_sctp_epaddr_lookup_transport+0x10/0x10
[  552.247013]  sctp_endpoint_bh_rcv+0x2c4/0x8e0
[  552.247038]  sctp_rcv+0x1545/0x3980
[  552.247063]  ? sock_queue_rcv_skb_reason+0x39/0x70
[  552.247081]  ? __pfx_sctp_rcv+0x10/0x10
[  552.247105]  ? __pfx_raw_local_deliver+0x10/0x10
[  552.247121]  ? lapic_next_event+0x15/0x20
[  552.247138]  ? clockevents_program_event+0x2bf/0x860
[  552.247159]  ip_protocol_deliver_rcu+0x279/0x2f0
[  552.247176]  ? _raw_spin_lock+0x84/0xe0
[  552.247192]  ip_local_deliver_finish+0x31c/0x4a0
[  552.247211]  ip_local_deliver+0x18b/0x2d0
--
[  552.247752]  ? __pfx___dev_queue_xmit+0x10/0x10
[  552.247769]  ? csum_and_copy_from_iter_full+0x1d9/0x1da0
[  552.247788]  ? kasan_save_track+0x14/0x30
[  552.247803]  ? __kasan_kmalloc+0x8f/0xa0
[  552.247821]  ? __alloc_skb+0x123/0x890
[  552.247843]  ? selinux_ip_postroute+0x3fe/0xb00
[  552.247863]  ip_finish_output2+0x724/0x1900
[  552.247882]  ? __pfx_ip_finish_output2+0x10/0x10
[  552.247899]  ? __ip_append_data+0x16ec/0x4150
[  552.247925]  __ip_finish_output+0x508/0xa30
[  552.247944]  ? __pfx___ip_finish_output+0x10/0x10
[  552.247961]  ? nf_hook_slow+0xaa/0x1c0
[  552.247981]  ip_output+0x17d/0x2f0
[  552.247999]  ? __pfx_ip_output+0x10/0x10
[  552.248015]  ? __ip_make_skb+0xe0f/0x2520
[  552.248031]  ? __pfx_ip_finish_output+0x10/0x10
[  552.248047]  ? ip_append_data+0xcb/0x170
[  552.248066]  ip_push_pending_frames+0x15a/0x1a0
[  552.248084]  raw_sendmsg+0xe72/0x2710
[  552.248107]  ? __pfx_raw_sendmsg+0x10/0x10
[  552.248122]  ? mutex_unlock+0x82/0xd0
[  552.248137]  ? __pfx_mutex_unlock+0x10/0x10
[  552.248157]  ? anon_pipe_write+0xa18/0x1900
[  552.248193]  ? selinux_socket_sendmsg+0x91/0x270
[  552.248215]  __sys_sendto+0x31b/0x390
[  552.248235]  ? __pfx___sys_sendto+0x10/0x10
[  552.248278]  ? ksys_write+0x181/0x1d0
[  552.248295]  ? __pfx_ksys_write+0x10/0x10
[  552.248334]  __x64_sys_sendto+0xe0/0x1c0
[  552.248354]  ? fpregs_assert_state_consistent+0x63/0xf0
[  552.248379]  do_syscall_64+0x102/0x5a0
[  552.248400]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  552.248420] RIP: 0033:0x7facd02ef0a7
[  552.248442] Code: c7 c0 ff ff ff ff eb be 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 80 3d a5 ef 0d 00 00 41 89 ca 74 10 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 69 c3 55 48 89 e5 53 48 83 ec 38 44 89 4d d0
[  552.248461] RSP: 002b:00007ffc9f687208 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  552.248489] RAX: ffffffffffffffda RBX: 0000000000000144 RCX: 00007facd02ef0a7
[  552.248501] RDX: 0000000000000150 RSI: 00007ffc9f687234 RDI: 0000000000000003
[  552.248512] RBP: 000000000100007f R08: 00007ffc9f687210 R09: 0000000000000010
[  552.248523] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000014e
[  552.248534] R13: 00007ffc9f688100 R14: 0000000000000144 R15: 0000000000000100
[  552.248555]  </TASK>

[  552.260224] Allocated by task 1:
[  552.260304]  kasan_save_stack+0x33/0x60
[  552.260410]  kasan_save_track+0x14/0x30
[  552.260501]  __kasan_kmalloc+0x8f/0xa0
[  552.260588]  __kmalloc_cache_noprof+0x1b6/0x420
[  552.260714]  pci_alloc_bus.constprop.0+0x3f/0x300
[  552.260847]  pci_register_host_bridge+0xcf/0x15f0
[  552.260957]  pci_create_root_bus+0x1e5/0x300
[  552.261076]  acpi_pci_root_create+0x42d/0x880
[  552.261193]  pci_acpi_scan_root+0x3df/0x5a0
[  552.261320]  acpi_pci_root_add+0x369/0x8e0
[  552.261453]  acpi_bus_attach+0x4f3/0xa40
[  552.261574]  device_for_each_child+0xf8/0x170
[  552.261732]  acpi_dev_for_each_child+0x7a/0xa0
[  552.261849]  acpi_bus_attach+0x72b/0xa40
[  552.261983]  device_for_each_child+0xf8/0x170
[  552.262087]  acpi_dev_for_each_child+0x7a/0xa0
[  552.262187]  acpi_bus_attach+0x72b/0xa40
[  552.262281]  acpi_bus_scan+0xbd/0x3e0
[  552.262384]  acpi_scan_init+0x1c9/0x580
[  552.262470]  acpi_init+0x2e2/0x6d0
[  552.262540]  do_one_initcall+0xa6/0x370
[  552.262626]  kernel_init_freeable+0x42d/0x760
[  552.262727]  kernel_init+0x1f/0x1e0
[  552.262867]  ret_from_fork+0x3af/0x620
[  552.262974]  ret_from_fork_asm+0x1a/0x30

[  552.263133] The buggy address belongs to the object at ffff8881012a8800
                which belongs to the cache kmalloc-2k of size 2048
[  552.263468] The buggy address is located 1244 bytes to the right of
                allocated 1048-byte region [ffff8881012a8800, ffff8881012a8c18)

[  552.263836] The buggy address belongs to the physical page:
[  552.263955] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1012a8
[  552.264112] head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  552.264255] flags: 0x200000000000040(head|node=0|zone=2)
[  552.264383] page_type: f5(slab)
[  552.264460] raw: 0200000000000040 ffff888100043240 ffffea0004044410 ffffea0004057c10
[  552.264616] raw: 0000000000000000 0000000800050005 00000000f5000000 0000000000000000
[  552.264850] head: 0200000000000040 ffff888100043240 ffffea0004044410 ffffea0004057c10
[  552.264998] head: 0000000000000000 0000000800050005 00000000f5000000 0000000000000000
[  552.265145] head: 0200000000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
[  552.265288] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000008
[  552.265437] page dumped because: kasan: bad access detected

[  552.265575] Memory state around the buggy address:
[  552.265660]  ffff8881012a8f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  552.265881]  ffff8881012a9000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  552.266013] >ffff8881012a9080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  552.266143]                                                              ^
[  552.266272]  ffff8881012a9100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  552.266412]  ffff8881012a9180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  552.266544] ==================================================================
[  553.517512] systemd[1]: e2scrub_all.service: Deactivated successfully.
[  553.545039] systemd[1]: Finished e2scrub_all.service - Online ext4 Metadata Check for All Filesystems.
[  553.682216] systemd[1]: systemd-journald.service: Main process exited, code=killed, status=6/ABRT
[  553.688936] systemd[1]: systemd-journald.service: Failed with result 'watchdog'.
[  553.698303] systemd[1]: systemd-journald.service: Consumed 7min 31.125s CPU time.
[  553.716114] systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 1.
[  553.849464] systemd[1]: Starting systemd-journald.service - Journal Service...
[  554.149027] systemd[1]: systemd-update-utmp-runlevel.service: Deactivated successfully.
[  554.176031] systemd[1]: Finished systemd-update-utmp-runlevel.service - Record Runlevel Change in UTMP.
[  554.675881] systemd-journald[352]: Collecting audit messages is disabled.
[  554.722954] systemd-journald[352]: File /var/log/journal/650a0aae2d504220b5076f94e1b000de/system.journal corrupted or uncleanly shut down, renaming and replacing.
[  555.046104] systemd[1]: fstrim.service: Deactivated successfully.
[  555.053901] systemd[1]: Finished fstrim.service - Discard unused blocks on filesystems from /etc/fstab.
[  555.063225] systemd[1]: fstrim.service: Consumed 1.297s CPU time.
[  555.079769] systemd-journald[352]: /dev/kmsg buffer overrun, some messages lost.
[  556.021993] systemd[1]: Started systemd-journald.service - Journal Service.

Reject cookies whose embedded AUTH parameter lengths exceed the
struct capacities, the same "malformed" path used for other corrupt
cookie fields.

The issue was found by ZeroHive, a vulnerability hunting agent at
Tencent Yunding Lab.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/sctp/sm_make_chunk.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 5a335c980a7a4..0634241fd6649 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1855,6 +1855,16 @@ struct sctp_association *sctp_unpack_cookie(
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
 
+	if (ntohs(((__be16 *)retval->c.auth_random)[1]) >
+	    sizeof(retval->c.auth_random) ||
+	    ntohs(((__be16 *)retval->c.auth_hmacs)[1]) >
+	    sizeof(retval->c.auth_hmacs) ||
+	    ntohs(((__be16 *)retval->c.auth_chunks)[1]) >
+	    sizeof(retval->c.auth_chunks)) {
+		*error = -SCTP_IERROR_MALFORMED;
+		goto fail;
+	}
+
 	if (sctp_assoc_set_bind_addr_from_cookie(retval, bear_cookie,
 						 GFP_ATOMIC) < 0) {
 		*error = -SCTP_IERROR_NOMEM;
--
2.43.0
