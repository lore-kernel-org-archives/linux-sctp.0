Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ABA42EECE;
	Mon, 20 Jul 2026 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784558437; cv=none; b=sgZeIVaIUtRYikH+0RV8h7FFCnQOtwx+a2xQ+CnFRYDCy0GTSooAwNqRigNJBqZqDjzP+CQCQgQybToR+32BhMMZYDYByQJQXgOg/E22Y02HXxMPYnKDr9JtkgNsrEBVFby3uss2LhYrcELRZ+gbWU/ozY/tMT2pQJB8rHC8wPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784558437; c=relaxed/simple;
	bh=xTHaCRVBxiBq3GASQUHpTBNxhm/iMyoUvDxS+tsvie0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rPRAYXNv2f6Mp+n02KDs5lmx65AV+0yMRYA7NFPZ03REYBCzdQs04/vcYWdjs/ZU86WpSmu5C2wV5OlKEfq/3Tl06MJJ/kfVVImph34KVRJ6C++MgN43WVPqDfxefzeSRjDUig04gXETJiw8vjtRxLu6rimEB6OF3R5oHk8Pnfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cWw0aLRJ; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=vNatXph9; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cWw0aLRJ";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="vNatXph9"
Date: Mon, 20 Jul 2026 16:40:31 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784558433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHHrlE6Os/L4uUSD/3qt63JlC6told+IuaBcZjfvKkU=;
	b=cWw0aLRJ+11Yh0CqLPNAR5/JFR5dwacblMFYjEctWbIPt6zixBRbETjcf3G34DgD0tdu8W
	DUwO2o6U0O0U/KYEiIhrysZp0nUl1JwgCI3+KQNVVNPYm1W4aqwqsXV4jf8CRUrdXb/gy0
	GfpdlbMJhZLQ2jWxGGbDQYXpTDE4NR4J2LlNh2OmcHhrjp+VeIwB7ZK5UYTxLWIIiI+ZOC
	c74BfxQFUoohWdmCHfJV9DbLt46I6R2wtpQT4qs5MRjUwq+2xaV8qLNq288WTHBwdOvb95
	pXiJJw/hdtr6FHTfTlRXuTdYgjVWep9gzFXdV7Zoi0KLzFr2ewkYBlOOHaGw/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784558433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xHHrlE6Os/L4uUSD/3qt63JlC6told+IuaBcZjfvKkU=;
	b=vNatXph9ubobipygyyd/MNVMpHknCTrMPyKlMffaAOEgEzEs3WYSDBBCCtrzcvCPdlzLuX
	BWguZw58GUbuKiAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Xin Long <lucien.xin@gmail.com>, Petr Mladek <pmladek@suse.com>,
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH net-next v2] net: Replace %pK output with 0
Message-ID: <20260720144031.oU6azheV@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
2011 and changed the %p annotation for pointer to %pK. Back then the
default behaviour for %p was to print the pointer. The %pK modifier was
introduced to able to control the behaviour of specific pointer values
without changing the behaviour of %p for everyone. It was dedicated to
avoid leaking pointers via /proc.

There was also the idea to remove the check from formatting the string
and move to the open callback with some helpers but this did not happen.

Things changed over time. The default behaviour for %p is now to print a
hash pointer which does not leak the address but allows to correlate if
two pointers are equal.
The policy on %p is to not introduce new ones. This is somehow in
between since it already exists. The pointer are usually socket pointers
and I don't see any value in exposing them. Therefore I am following the
recommendation of removing them. Since their usage in /proc/ can be
considered ABI I replace the pointer with a 0.

Replace the %pK annotation with 0 value. Correct the spacing for the
cases where pointer is at the beginning. Use %ps in CAN where the read
callback is used.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

v1=E2=80=A6v2: https://lore.kernel.org/all/20260706073824.xixrLxoD@linutron=
ix.de
 - This follows Kees' feedback regarding the general policy and "is it
   really needed?". Since I don't think that this is of general usage I
   replaced them all with 0 and corrected the spacing at the beginning.

 - can_print_rcvlist() is now using a %ps to print the name of the
   function. Everything is a sock pointer (or some other data structure)
   and is now 0.

 net/atm/proc.c           |  7 +++----
 net/can/bcm.c            |  4 +---
 net/can/proc.c           | 12 ++++--------
 net/ipv4/ping.c          |  5 ++---
 net/ipv4/raw.c           |  4 ++--
 net/ipv4/tcp_ipv4.c      | 13 ++++++-------
 net/ipv4/udp.c           |  5 ++---
 net/ipv6/datagram.c      |  5 ++---
 net/ipv6/tcp_ipv6.c      | 12 ++++++------
 net/key/af_key.c         |  5 ++---
 net/netlink/af_netlink.c |  5 ++---
 net/packet/af_packet.c   |  6 ++----
 net/phonet/socket.c      |  5 ++---
 net/sctp/proc.c          |  6 +++---
 net/unix/af_unix.c       |  5 ++---
 15 files changed, 41 insertions(+), 58 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index 8f20b49b9c02a..4db7036ba8e72 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -159,7 +159,7 @@ static void vcc_info(struct seq_file *seq, struct atm_v=
cc *vcc)
 {
 	struct sock *sk =3D sk_atm(vcc);
=20
-	seq_printf(seq, "%pK ", vcc);
+	seq_printf(seq, "      0 ");
 	if (!vcc->dev)
 		seq_printf(seq, "Unassigned    ");
 	else
@@ -228,9 +228,8 @@ static const struct seq_operations pvc_seq_ops =3D {
 static int vcc_seq_show(struct seq_file *seq, void *v)
 {
 	if (v =3D=3D SEQ_START_TOKEN) {
-		seq_printf(seq, sizeof(void *) =3D=3D 4 ? "%-8s%s" : "%-16s%s",
-			"Address ", "Itf VPI VCI   Fam Flags Reply "
-			"Send buffer     Recv buffer      [refcnt]\n");
+		seq_printf(seq, "Address Itf VPI VCI   Fam Flags Reply "
+			   "Send buffer     Recv buffer     [refcnt]\n");
 	} else {
 		struct vcc_state *state =3D seq->private;
 		struct atm_vcc *vcc =3D atm_sk(state->sk);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 3d637a1e0ac1a..c262d9530f553 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -220,9 +220,7 @@ static int bcm_proc_show(struct seq_file *m, void *v)
 	struct bcm_sock *bo =3D bcm_sk(sk);
 	struct bcm_op *op;
=20
-	seq_printf(m, ">>> socket %pK", sk->sk_socket);
-	seq_printf(m, " / sk %pK", sk);
-	seq_printf(m, " / bo %pK", bo);
+	seq_printf(m, ">>> socket 0 / sk 0 / bo 0");
 	seq_printf(m, " / dropped %lu", bo->dropped_usr_msgs);
 	seq_printf(m, " / bound %s", bcm_proc_getifname(net, ifname, bo->ifindex)=
);
 	seq_printf(m, " <<<\n");
diff --git a/net/can/proc.c b/net/can/proc.c
index de4d05ae34597..cc3050f4c8e75 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -192,12 +192,11 @@ static void can_print_rcvlist(struct seq_file *m, str=
uct hlist_head *rx_list,
=20
 	hlist_for_each_entry_rcu(r, rx_list, list) {
 		char *fmt =3D (r->can_id & CAN_EFF_FLAG)?
-			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
-			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
+			"   %-5s  %08x  %08x  %ps %8u %8ld  %s\n" :
+			"   %-5s     %03x    %08x  %-20ps %8u %8ld  %s\n";
=20
 		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
-			   r->func, r->data, atomic_long_read(&r->matches),
-			   r->ident);
+			   r->func, 0, atomic_long_read(&r->matches), r->ident);
 	}
 }
=20
@@ -207,10 +206,7 @@ static void can_print_recv_banner(struct seq_file *m)
 	 *                  can1.  00000000  00000000  00000000
 	 *                 .......          0  tp20
 	 */
-	if (IS_ENABLED(CONFIG_64BIT))
-		seq_puts(m, "  device   can_id   can_mask      function          userdat=
a       matches  ident\n");
-	else
-		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches =
 ident\n");
+	seq_puts(m, "  device   can_id   can_mask  function             userdata =
 matches  ident\n");
 }
=20
 static int can_stats_proc_show(struct seq_file *m, void *v)
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index d36f1e273fde4..223a0108b74cc 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1095,15 +1095,14 @@ static void ping_v4_format_sock(struct sock *sp, st=
ruct seq_file *f,
 	__u16 srcp =3D ntohs(inet->inet_sport);
=20
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(f), sk_uid(sp)),
 		0, sock_i_ino(sp),
-		refcount_read(&sp->sk_refcnt), sp,
-		sk_drops_read(sp));
+		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
 }
=20
 static int ping_v4_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 2aebaf8297e04..0a3e561f670bd 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1045,14 +1045,14 @@ static void raw_sock_seq_show(struct seq_file *seq,=
 struct sock *sp, int i)
 	      srcp  =3D inet->inet_num;
=20
 	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u\n",
 		i, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		sk_rmem_alloc_get(sp),
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
 		0, sock_i_ino(sp),
-		refcount_read(&sp->sk_refcnt), sp, sk_drops_read(sp));
+		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
 }
=20
 static int raw_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4a46da375043b..3a0ce1743642a 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2745,7 +2745,7 @@ static void get_openreq4(const struct request_sock *r=
eq,
 	long delta =3D req->rsk_timer.expires - jiffies;
=20
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d 0",
 		i,
 		ireq->ir_loc_addr,
 		ireq->ir_num,
@@ -2760,8 +2760,7 @@ static void get_openreq4(const struct request_sock *r=
eq,
 				 sk_uid(req->rsk_listener)),
 		0,  /* non standard timer */
 		0, /* open_requests have no inode */
-		0,
-		req);
+		0);
 }
=20
 static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
@@ -2808,7 +2807,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq=
_file *f, int i)
 				      READ_ONCE(tp->copied_seq), 0);
=20
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
-			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
+			"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
 		READ_ONCE(tp->write_seq) - tp->snd_una,
 		rx_queue,
@@ -2818,7 +2817,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq=
_file *f, int i)
 		from_kuid_munged(seq_user_ns(f), sk_uid(sk)),
 		READ_ONCE(icsk->icsk_probes_out),
 		sock_i_ino(sk),
-		refcount_read(&sk->sk_refcnt), sk,
+		refcount_read(&sk->sk_refcnt),
 		jiffies_to_clock_t(icsk->icsk_rto),
 		jiffies_to_clock_t(icsk->icsk_ack.ato),
 		(icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sk),
@@ -2841,10 +2840,10 @@ static void get_timewait4_sock(const struct inet_ti=
mewait_sock *tw,
 	srcp  =3D ntohs(tw->tw_sport);
=20
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
+		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d 0",
 		i, src, srcp, dest, destp, READ_ONCE(tw->tw_substate), 0, 0,
 		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
-		refcount_read(&tw->tw_refcnt), tw);
+		refcount_read(&tw->tw_refcnt));
 }
=20
 #define TMPSZ 150
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 59248a59358ca..b35e448e48c59 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3280,15 +3280,14 @@ static void udp4_format_sock(struct sock *sp, struc=
t seq_file *f,
 	__u16 srcp	  =3D ntohs(inet->inet_sport);
=20
 	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
-		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
+		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u",
 		bucket, src, srcp, dest, destp, sp->sk_state,
 		sk_wmem_alloc_get(sp),
 		udp_rqueue_get(sp),
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(f), sk_uid(sp)),
 		0, sock_i_ino(sp),
-		refcount_read(&sp->sk_refcnt), sp,
-		sk_drops_read(sp));
+		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
 }
=20
 static int udp4_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 38d7b48452817..191c9733ff9fa 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1102,7 +1102,7 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, =
struct sock *sp,
 	src   =3D &sp->sk_v6_rcv_saddr;
 	seq_printf(seq,
 		   "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u\n",
 		   bucket,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
@@ -1115,6 +1115,5 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, =
struct sock *sp,
 		   from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
 		   0,
 		   sock_i_ino(sp),
-		   refcount_read(&sp->sk_refcnt), sp,
-		   sk_drops_read(sp));
+		   refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
 }
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 522ba45ce9b75..bc45e647c4956 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2101,7 +2101,7 @@ static void get_openreq6(struct seq_file *seq,
=20
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d %pK\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d 0\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3],
@@ -2118,7 +2118,7 @@ static void get_openreq6(struct seq_file *seq,
 				    sk_uid(req->rsk_listener)),
 		   0,  /* non standard timer */
 		   0, /* open_requests have no inode */
-		   0, req);
+		   0);
 }
=20
 static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
@@ -2169,7 +2169,7 @@ static void get_tcp6_sock(struct seq_file *seq, struc=
t sock *sp, int i)
=20
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %lu %lu %u %u %d\=
n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %lu %lu %u %u %d\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
@@ -2184,7 +2184,7 @@ static void get_tcp6_sock(struct seq_file *seq, struc=
t sock *sp, int i)
 		   from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
 		   READ_ONCE(icsk->icsk_probes_out),
 		   sock_i_ino(sp),
-		   refcount_read(&sp->sk_refcnt), sp,
+		   refcount_read(&sp->sk_refcnt),
 		   jiffies_to_clock_t(icsk->icsk_rto),
 		   jiffies_to_clock_t(icsk->icsk_ack.ato),
 		   (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sp),
@@ -2209,7 +2209,7 @@ static void get_timewait6_sock(struct seq_file *seq,
=20
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n",
+		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d\n",
 		   i,
 		   src->s6_addr32[0], src->s6_addr32[1],
 		   src->s6_addr32[2], src->s6_addr32[3], srcp,
@@ -2217,7 +2217,7 @@ static void get_timewait6_sock(struct seq_file *seq,
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   READ_ONCE(tw->tw_substate), 0, 0,
 		   3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
-		   refcount_read(&tw->tw_refcnt), tw);
+		   refcount_read(&tw->tw_refcnt));
 }
=20
 static int tcp6_seq_show(struct seq_file *seq, void *v)
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 1d8965d7f4f3c..aa12e16edfdcb 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3803,10 +3803,9 @@ static int pfkey_seq_show(struct seq_file *f, void *=
v)
 	struct sock *s =3D sk_entry(v);
=20
 	if (v =3D=3D SEQ_START_TOKEN)
-		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
+		seq_printf(f ,"sk RefCnt Rmem   Wmem   User   Inode\n");
 	else
-		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6llu\n",
-			       s,
+		seq_printf(f, "0  %-6d %-6u %-6u %-6u %-6llu\n",
 			       refcount_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
 			       sk_wmem_alloc_get(s),
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5202fe0b08671..d5172778f2a4a 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2700,14 +2700,13 @@ static int netlink_native_seq_show(struct seq_file =
*seq, void *v)
 {
 	if (v =3D=3D SEQ_START_TOKEN) {
 		seq_puts(seq,
-			 "sk               Eth Pid        Groups   "
+			 "sk Eth Pid        Groups   "
 			 "Rmem     Wmem     Dump  Locks    Drops    Inode\n");
 	} else {
 		struct sock *s =3D v;
 		struct netlink_sock *nlk =3D nlk_sk(s);
=20
-		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
-			   s,
+		seq_printf(seq, "0  %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
 			   s->sk_protocol,
 			   nlk->portid,
 			   nlk->groups ? (u32)nlk->groups[0] : 0,
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8e6f3a734ba0b..177c2810cff48 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4719,15 +4719,13 @@ static int packet_seq_show(struct seq_file *seq, vo=
id *v)
 {
 	if (v =3D=3D SEQ_START_TOKEN)
 		seq_printf(seq,
-			   "%*sRefCnt Type Proto  Iface R Rmem   User   Inode\n",
-			   IS_ENABLED(CONFIG_64BIT) ? -17 : -9, "sk");
+			   "sk RefCnt Type Proto  Iface R Rmem   User   Inode\n");
 	else {
 		struct sock *s =3D sk_entry(v);
 		const struct packet_sock *po =3D pkt_sk(s);
=20
 		seq_printf(seq,
-			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6llu\n",
-			   s,
+			   "0  %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6llu\n",
 			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
 			   ntohs(READ_ONCE(po->num)),
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 631a99cdbd006..ad12b746d4fca 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -586,14 +586,13 @@ static int pn_sock_seq_show(struct seq_file *seq, voi=
d *v)
 		struct pn_sock *pn =3D pn_sk(sk);
=20
 		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %llu "
-			"%d %pK %u",
+			"%d 0 %u",
 			sk->sk_protocol, pn->sobject, pn->dobject,
 			pn->resource, sk->sk_state,
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
 			from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
 			sock_i_ino(sk),
-			refcount_read(&sk->sk_refcnt), sk,
-			sk_drops_read(sk));
+			refcount_read(&sk->sk_refcnt), sk_drops_read(sk));
 	}
 	seq_pad(seq, '\n');
 	return 0;
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 43433d7e2acd7..7ea123b90aa59 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -174,7 +174,7 @@ static int sctp_eps_seq_show(struct seq_file *seq, void=
 *v)
 		sk =3D ep->base.sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
 			continue;
-		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5llu ", ep, sk,
+		seq_printf(seq, "%8d %8d %-3d %-3d %-4d %-5d %5u %5llu ", 0, 0,
 			   sctp_sk(sk)->type, sk->sk_state, hash,
 			   ep->base.bind_addr.port,
 			   from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
@@ -260,9 +260,9 @@ static int sctp_assocs_seq_show(struct seq_file *seq, v=
oid *v)
 	sk =3D epb->sk;
=20
 	seq_printf(seq,
-		   "%8pK %8pK %-3d %-3d %-2d %-4d "
+		   "%8d %8d %-3d %-3d %-2d %-4d "
 		   "%4d %8d %8d %7u %5llu %-5d %5d ",
-		   assoc, sk, sctp_sk(sk)->type, sk->sk_state,
+		   0, 0, sctp_sk(sk)->type, sk->sk_state,
 		   assoc->state, 0,
 		   assoc->assoc_id,
 		   assoc->sndbuf_used,
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f7a9d55eee8a1..ee3eb5eeee7e8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -3547,15 +3547,14 @@ static int unix_seq_show(struct seq_file *seq, void=
 *v)
 {
=20
 	if (v =3D=3D SEQ_START_TOKEN)
-		seq_puts(seq, "Num       RefCount Protocol Flags    Type St "
+		seq_puts(seq, "Num RefCount Protocol Flags    Type St "
 			 "Inode Path\n");
 	else {
 		struct sock *s =3D v;
 		struct unix_sock *u =3D unix_sk(s);
 		unix_state_lock(s);
=20
-		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5llu",
-			s,
+		seq_printf(seq, "0:  %08X %08X %08X %04X %02X %5llu",
 			refcount_read(&s->sk_refcnt),
 			0,
 			s->sk_state =3D=3D TCP_LISTEN ? __SO_ACCEPTCON : 0,
--=20
2.53.0

