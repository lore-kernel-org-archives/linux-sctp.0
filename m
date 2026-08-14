Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E24A3D669F;
	Fri, 14 Aug 2026 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786672813; cv=none; b=hdbLQx/uh3Gs/wguPhSIuZIyLu0DU7O9pm7r8flKTCX9IwLIC//eBA9kvx8NNyXSX26dqTCdC8ozXDtbeslCr5633AQd3fhbcCFRGOEk18aZIKl1cSQP26N/N2YHImcqQybOTcaJd6mqV3HKKEK/OqSScBV28iEOpsl+3Pf7Ofg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786672813; c=relaxed/simple;
	bh=BkqYISZMCE3I+d1zkMHciIyUm3StjDP5HyE61566S/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUdgG3anaaa2HSOoVbE2hFmdhaP9TggYfaqbl2cl428kHAPC/ItjHDxMDp9Ldls327bHzNA5BTXqM2llRRLPJl/1vnPhtQ403ajsdnjpW/bnblgMRCJAidFilfrvV5wUl1q2W70gf2CXGZKFUovtq1G7H+chkOlFsz28JyLVX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpMHf3tI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpMHf3tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2941F000E9;
	Fri, 14 Aug 2026 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786672811;
	bh=PgzYGdP7hVdfZzBeBpIunkbp2WU5NvkodaLDGdLR/cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpMHf3tIMupXhpzArrZD1ueX4IKpCH4XTvAZmMnDuR/G2eHuHL2xopLeHLtzWxvxt
	 Pcbh/nvnNDXuBv1hxBz+9LdF145InvAtHN0Rm5Opk3Stk3KMFm2u4L5nLmp5cu/VhX
	 20JQxG5Q4/pwqLM+7XnisC8J5xHBUOutcr217ZT8kBip6AiXTpWSjHKY8mB/X/22Yu
	 9yAz5byd22gAulSFP5ESw7bqd1GY/H0VEiQhPHyNWRiZHNTGOuo/KAOJiWkkFBMWxs
	 rb9q4bn5kcPFH0n4aw7/nUeF1gM8BAtQhKR6HwlStWXGVPWyWc3RsgsP0P0DLIqN0P
	 6EqaVxkEZxdrQ==
From: Jakub Kicinski <kuba@kernel.org>
To: bigeasy@linutronix.de
Cc: Jakub Kicinski <kuba@kernel.org>,
	linux-atm-general@lists.sourceforge.net,
	linux-can@vger.kernel.org,
	linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	herbert@gondor.apana.org.au,
	kuniyu@google.com,
	mkl@pengutronix.de,
	marcelo.leitner@gmail.com,
	ncardwell@google.com,
	socketcan@hartkopp.net,
	pabeni@redhat.com,
	courmisch@gmail.com,
	horms@kernel.org,
	steffen.klassert@secunet.com,
	willemdebruijn.kernel@gmail.com,
	lucien.xin@gmail.com,
	pmladek@suse.com,
	thomas.weissschuh@linutronix.de,
	kees@kernel.org
Subject: Re: [PATCH net-next v3] net: Replace %pK output with 0
Date: Thu, 13 Aug 2026 18:58:01 -0700
Message-ID: <20260814015800.2837019-2-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812110531.ITPqiY2O@linutronix.de>
References: <20260812110531.ITPqiY2O@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Sebastian!

We have upgraded the slop...itifier since v2, it has more comments now...
The one about %ps potentially leaking more rather than less looks legit?
---
This is an AI-generated review of your patch.
---
net: Replace %pK output with 0

This replaces the %pK socket/object pointers printed by various /proc/net
files with a literal 0, adjusts the spacing of the affected header lines,
and switches the CAN receive list to print the receive callback with %ps.

> diff --git a/net/atm/proc.c b/net/atm/proc.c
> index 8f20b49b9c02..ca0fc6b90998 100644
> --- a/net/atm/proc.c
> +++ b/net/atm/proc.c

The changelog says:

    The pointer are usually socket pointers and I don't see any value in
    exposing them. Therefore I am following the recommendation of removing
    them.

[Severity: Low]
This isn't something introduced by this patch, but after it is applied
net/bluetooth/af_bluetooth.c bt_seq_show() is the only remaining %pK
socket-pointer printer under net/:

  net/bluetooth/af_bluetooth.c:bt_seq_show() {
      ...
      seq_printf(seq,
                 "%pK %-6d %-6u %-6u %-6u %-6llu %-6llu",
                 sk,
                 refcount_read(&sk->sk_refcnt),
      ...
  }

That site was converted by the very commit 71338aa7d050c quoted in the
changelog.  Was it intentionally left out, and could the changelog say so
(for example that net/bluetooth goes through a separate tree)?

> @@ -159,7 +159,7 @@ static void vcc_info(struct seq_file *seq, struct atm_vcc *vcc)
>  {
>  	struct sock *sk = sk_atm(vcc);
>  
> -	seq_printf(seq, "%pK ", vcc);
> +	seq_puts(seq, "      0 ");
>  	if (!vcc->dev)
>  		seq_printf(seq, "Unassigned    ");
>  	else
> @@ -228,9 +228,8 @@ static const struct seq_operations pvc_seq_ops = {
>  static int vcc_seq_show(struct seq_file *seq, void *v)
>  {
>  	if (v == SEQ_START_TOKEN) {
> -		seq_printf(seq, sizeof(void *) == 4 ? "%-8s%s" : "%-16s%s",
> -			"Address ", "Itf VPI VCI   Fam Flags Reply "
> -			"Send buffer     Recv buffer      [refcnt]\n");
> +		seq_puts(seq, "Address Itf VPI VCI   Fam Flags Reply "
> +			 "Send buffer     Recv buffer     [refcnt]\n");

[Severity: Low]
The changelog describes this as "Correct the spacing for the cases where
pointer is at the beginning", but the first column changes width in
several files, so the byte offsets of every following column move:

  vcc_seq_show()            /proc/net/atm/vc     16 -> 8 chars (64-bit)
  netlink_native_seq_show() /proc/net/netlink    17 -> 3
  packet_seq_show()         /proc/net/packet     17 -> 3
  pfkey_seq_show()          /proc/net/pfkey       9 -> 3
  unix_seq_show()           /proc/net/unix       18 -> 10

Whitespace/field-index parsers still work since the trailing column widths
are preserved, but anything indexing by fixed byte offset sees a new
layout.  Is that worth spelling out in the changelog, given it also states
that the /proc format can be considered ABI?

Separately, this hunk drops one space before "[refcnt]" in the header
("Recv buffer      [refcnt]" becomes "Recv buffer     [refcnt]"), which
isn't mentioned in the changelog at all.  Was that intended?

> diff --git a/net/can/proc.c b/net/can/proc.c
> index de4d05ae3459..4314180fd7a1 100644
> --- a/net/can/proc.c
> +++ b/net/can/proc.c
> @@ -192,12 +192,11 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
>  
>  	hlist_for_each_entry_rcu(r, rx_list, list) {
>  		char *fmt = (r->can_id & CAN_EFF_FLAG)?
> -			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
> -			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
> +			"   %-5s  %08x  %08x  %-20ps %8u %8ld  %s\n" :
> +			"   %-5s     %03x    %08x  %-20ps %8u %8ld  %s\n";
>  
>  		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
> -			   r->func, r->data, atomic_long_read(&r->matches),
> -			   r->ident);
> +			   r->func, 0, atomic_long_read(&r->matches), r->ident);
>  	}
>  }

[Severity: Medium]
Does this widen what unprivileged readers can see, rather than narrow it?
The rcvlist_* files are created world readable by can_init_proc():

  net/can/proc.c:can_init_proc() {
      ...
      net->can.pde_rcvlist_all = proc_create_net_single(CAN_PROC_RCVLIST_ALL,
                      0644, net->can.proc_dir, can_rcvlist_proc_show,
                      (void *)RX_ALL);
      ...
  }

Unlike %pK, %ps is not filtered by kptr_restrict and is never hashed.  With
CONFIG_KALLSYMS=n, symbol_string() takes the fallback branch:

  lib/vsprintf.c:symbol_string() {
      ...
      return string_nocheck(buf, end, sym, spec);
  #else
      return special_hex_number(buf, end, value, sizeof(void *));
  #endif
  }

so the raw kernel/module text address of the receive callback is printed to
any local reader, even with kptr_restrict=2.

With CONFIG_KALLSYMS=y the address is not printed, but the symbol plus the
owning module name is now disclosed unconditionally, since
__sprint_symbol() appends the module:

  kernel/kallsyms.c:__sprint_symbol() {
      ...
      if (modname) {
              len += sprintf(buffer + len, " [%s", modname);
      ...
  }

Previously kptr_restrict >= 1 censored this field for readers without
CAP_SYSLOG.  Would the literal 0 placeholder used for the other 14 sites
work here too?

> @@ -207,10 +206,7 @@ static void can_print_recv_banner(struct seq_file *m)
>  	 *                  can1.  00000000  00000000  00000000
>  	 *                 .......          0  tp20
>  	 */

[Severity: Low]
This example comment still shows the old layout, where the receive callback
was an 8-hex-digit %pK value (the third 00000000 column) and userdata was a
pointer.  can_print_rcvlist() now emits a left-justified symbol name via
%-20ps and a constant 0 for userdata, so nothing the code can produce
matches this example.  Should the comment be refreshed?

> -	if (IS_ENABLED(CONFIG_64BIT))
> -		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
> -	else
> -		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
> +	seq_puts(m, "  device   can_id   can_mask  function             userdata  matches  ident\n");
>  }

[Severity: Low]
The new banner advertises a fixed 20-character "function" column, but does
the row format actually stay inside it?

Module symbols printed by %ps carry the module suffix, e.g.
"bcm_rx_handler [can_bcm]" (24 chars), "j1939_can_recv [can_j1939]" (26)
or "isotp_rcv [can_isotp]" (21), so userdata/matches/ident get pushed to
the right whenever can_bcm, can_isotp or can_j1939 is loaded.

In the CONFIG_KALLSYMS=n case symbol_string() calls

      return special_hex_number(buf, end, value, sizeof(void *));

which discards the caller's spec, so the field is an unpadded 18-character
0xffffffffXXXXXXXX and the following columns shift left instead.

[Severity: Low]
Documentation/networking/can.rst still documents the previous output of
/proc/net/can/rcvlist_*:

        device   can_id   can_mask  function  userdata   matches  ident
         vcan0     000    00000000  f88e6370  f6c6f400         0  raw

After this change the banner is spaced differently, "function" is a symbol
name that may itself contain a space before "[module]", and "userdata" is
always 0.  Should can.rst be updated in the same patch?

> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b8887cdd66c5..2cd8ae4a0e4b 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c

[ ... ]

> @@ -2811,7 +2810,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>  					      READ_ONCE(tp->copied_seq), 0);
>  
>  	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
> -			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
> +			"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d",

[Severity: Low]
Documentation/networking/proc_net_tcp.rst still describes this field as the

    |          |    |     |    |------------------> location of socket in memory

and names tcp4_seq_show()/tcp6_seq_show() as the implementation, with a
nonzero example value.  With get_tcp4_sock(), get_tcp6_sock(),
get_openreq4()/get_openreq6() and get_timewait4_sock()/get_timewait6_sock()
all emitting a literal 0 there, no code path can produce the documented
value any more.  Could that documentation be adjusted along with this
change?

[ ... ]
-- 
pw-bot: cr
