From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 28 Apr 2010 18:47:21 +0000
Subject: [PATCH 4/5] sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set
Message-Id: <1272480442-32673-5-git-send-email-vladislav.yasevich@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1272480442-32673-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1272480442-32673-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, Vlad Yasevich <vladislav.yasevich@hp.com>

From: Wei Yongjun <yjwei@cn.fujitsu.com>

When calculating the INIT/INIT-ACK chunk length, we should not
only account the length of parameters, but also the parameters
zero padding length, such as AUTH HMACS parameter and CHUNKS
parameter. Without the parameters zero padding length we may get
following oops.

skb_over_panic: text:ce2068d2 len:130 put:6 head:cac3fe00 data:cac3fe00 tai=
l:0xcac3fe82 end:0xcac3fe80 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:127!
invalid opcode: 0000 [#2] SMP
last sysfs file: /sys/module/aes_generic/initstate
Modules linked in: authenc ......

Pid: 4102, comm: sctp_darn Tainted: G      D    2.6.34-rc2 #6
EIP: 0060:[<c0607630>] EFLAGS: 00010282 CPU: 0
EIP is at skb_over_panic+0x37/0x3e
EAX: 00000078 EBX: c07c024b ECX: c07c02b9 EDX: cb607b78
ESI: 00000000 EDI: cac3fe7a EBP: 00000002 ESP: cb607b74
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process sctp_darn (pid: 4102, ti=CB607000 task=CAbdc990 task.ti=CB607000)
Stack:
 c07c02b9 ce2068d2 00000082 00000006 cac3fe00 cac3fe00 cac3fe82 cac3fe80
<0> c07c024b cac3fe7c cac3fe7a c0608dec ca986e80 ce2068d2 00000006 0000007a
<0> cb8120ca ca986e80 cb812000 00000003 cb8120c4 ce208a25 cb8120ca cadd9400
Call Trace:
 [<ce2068d2>] ? sctp_addto_chunk+0x45/0x85 [sctp]
 [<c0608dec>] ? skb_put+0x2e/0x32
 [<ce2068d2>] ? sctp_addto_chunk+0x45/0x85 [sctp]
 [<ce208a25>] ? sctp_make_init+0x279/0x28c [sctp]
 [<c0686a92>] ? apic_timer_interrupt+0x2a/0x30
 [<ce1fdc0b>] ? sctp_sf_do_prm_asoc+0x2b/0x7b [sctp]
 [<ce202823>] ? sctp_do_sm+0xa0/0x14a [sctp]
 [<ce2133b9>] ? sctp_pname+0x0/0x14 [sctp]
 [<ce211d72>] ? sctp_primitive_ASSOCIATE+0x2b/0x31 [sctp]
 [<ce20f3cf>] ? sctp_sendmsg+0x7a0/0x9eb [sctp]
 [<c064eb1e>] ? inet_sendmsg+0x3b/0x43
 [<c04244b7>] ? task_tick_fair+0x2d/0xd9
 [<c06031e1>] ? sock_sendmsg+0xa7/0xc1
 [<c0416afe>] ? smp_apic_timer_interrupt+0x6b/0x75
 [<c0425123>] ? dequeue_task_fair+0x34/0x19b
 [<c0446abb>] ? sched_clock_local+0x17/0x11e
 [<c052ea87>] ? _copy_from_user+0x2b/0x10c
 [<c060ab3a>] ? verify_iovec+0x3c/0x6a
 [<c06035ca>] ? sys_sendmsg+0x186/0x1e2
 [<c042176b>] ? __wake_up_common+0x34/0x5b
 [<c04240c2>] ? __wake_up+0x2c/0x3b
 [<c057e35c>] ? tty_wakeup+0x43/0x47
 [<c04430f2>] ? remove_wait_queue+0x16/0x24
 [<c0580c94>] ? n_tty_read+0x5b8/0x65e
 [<c042be02>] ? default_wake_function+0x0/0x8
 [<c0604e0e>] ? sys_socketcall+0x17f/0x1cd
 [<c040264c>] ? sysenter_do_call+0x12/0x22
Code: 0f 45 de 53 ff b0 98 00 00 00 ff b0 94 ......
EIP: [<c0607630>] skb_over_panic+0x37/0x3e SS:ESP 0068:cb607b74

To reproduce:

# modprobe sctp
# echo 1 > /proc/sys/net/sctp/addip_enable
# echo 1 > /proc/sys/net/sctp/auth_enable
# sctp_test -H 3ffe:501:ffff:100:20c:29ff:fe4d:f37e -P 800 -l
# sctp_darn -H 3ffe:501:ffff:100:20c:29ff:fe4d:f37e -P 900 -h 192.168.0.21 =
-p 800 -I -s -t
sctp_darn ready to send...
3ffe:501:ffff:100:20c:29ff:fe4d:f37e:900-192.168.0.21:800 Interactive mode>=
 bindx-add=192.168.0.21
3ffe:501:ffff:100:20c:29ff:fe4d:f37e:900-192.168.0.21:800 Interactive mode>=
 bindx-add=192.168.1.21
3ffe:501:ffff:100:20c:29ff:fe4d:f37e:900-192.168.0.21:800 Interactive mode>=
 snd=10

------------------------------------------------------------------
eth0 has addresses: 3ffe:501:ffff:100:20c:29ff:fe4d:f37e and 192.168.0.21
eth1 has addresses: 192.168.1.21
------------------------------------------------------------------

Reported-by: George Cheimonidis <gchimon@gmail.com>
Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 net/sctp/sm_make_chunk.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 17cb400..f6fc5c1 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -208,7 +208,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_ass=
ociation *asoc,
 	sp =3D sctp_sk(asoc->base.sk);
 	num_types =3D sp->pf->supported_addrs(sp, types);
=20
-	chunksize =3D sizeof(init) + addrs_len + SCTP_SAT_LEN(num_types);
+	chunksize =3D sizeof(init) + addrs_len;
+	chunksize +=3D WORD_ROUND(SCTP_SAT_LEN(num_types));
 	chunksize +=3D sizeof(ecap_param);
=20
 	if (sctp_prsctp_enable)
@@ -238,14 +239,14 @@ struct sctp_chunk *sctp_make_init(const struct sctp_a=
ssociation *asoc,
 		/* Add HMACS parameter length if any were defined */
 		auth_hmacs =3D (sctp_paramhdr_t *)asoc->c.auth_hmacs;
 		if (auth_hmacs->length)
-			chunksize +=3D ntohs(auth_hmacs->length);
+			chunksize +=3D WORD_ROUND(ntohs(auth_hmacs->length));
 		else
 			auth_hmacs =3D NULL;
=20
 		/* Add CHUNKS parameter length */
 		auth_chunks =3D (sctp_paramhdr_t *)asoc->c.auth_chunks;
 		if (auth_chunks->length)
-			chunksize +=3D ntohs(auth_chunks->length);
+			chunksize +=3D WORD_ROUND(ntohs(auth_chunks->length));
 		else
 			auth_chunks =3D NULL;
=20
@@ -255,7 +256,8 @@ struct sctp_chunk *sctp_make_init(const struct sctp_ass=
ociation *asoc,
=20
 	/* If we have any extensions to report, account for that */
 	if (num_ext)
-		chunksize +=3D sizeof(sctp_supported_ext_param_t) + num_ext;
+		chunksize +=3D WORD_ROUND(sizeof(sctp_supported_ext_param_t) +
+					num_ext);
=20
 	/* RFC 2960 3.3.2 Initiation (INIT) (1)
 	 *
@@ -397,13 +399,13 @@ struct sctp_chunk *sctp_make_init_ack(const struct sc=
tp_association *asoc,
=20
 		auth_hmacs =3D (sctp_paramhdr_t *)asoc->c.auth_hmacs;
 		if (auth_hmacs->length)
-			chunksize +=3D ntohs(auth_hmacs->length);
+			chunksize +=3D WORD_ROUND(ntohs(auth_hmacs->length));
 		else
 			auth_hmacs =3D NULL;
=20
 		auth_chunks =3D (sctp_paramhdr_t *)asoc->c.auth_chunks;
 		if (auth_chunks->length)
-			chunksize +=3D ntohs(auth_chunks->length);
+			chunksize +=3D WORD_ROUND(ntohs(auth_chunks->length));
 		else
 			auth_chunks =3D NULL;
=20
@@ -412,7 +414,8 @@ struct sctp_chunk *sctp_make_init_ack(const struct sctp=
_association *asoc,
 	}
=20
 	if (num_ext)
-		chunksize +=3D sizeof(sctp_supported_ext_param_t) + num_ext;
+		chunksize +=3D WORD_ROUND(sizeof(sctp_supported_ext_param_t) +
+					num_ext);
=20
 	/* Now allocate and fill out the chunk.  */
 	retval =3D sctp_make_chunk(asoc, SCTP_CID_INIT_ACK, 0, chunksize);
--=20
1.6.0.4

