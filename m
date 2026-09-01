Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [85.215.255.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460B6481238;
	Tue,  1 Sep 2026 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788277926; cv=pass; b=k80UyQG5p5t50U1f2WNXeqJZWIbsTDOK/vGqQmkCAlNPNoQFD4B7cyYu03hMICUVJmGfm6e+Y30G7qOhgGweu0QdjX85lzoMBWi92DxxxE4mWy2POYADuqq4YO6QW2jVcD9GebILpeRgohz0A/yHOAOgPRImzXEhbv0nWaKApZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788277926; c=relaxed/simple;
	bh=fzpw5P40GGrK58NIvU+E6sp5pJ2LdFfjIfXY2dc1exw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZT2egekI7iD+ATG3frP7UUvl29epjRxnauzu3R/zRbm0RWrJ0i8xstz4DYHsRoG1dK4eTW0TM16gl54k2CCdFXptY3QUOKMvakHto0feZiqHO+Hr2axjsDGvSMOBodTT+IIpsAMesINb5IOV/Ylsvm2ZwCtIH0j/tsyiE2rPgHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net; spf=fail smtp.mailfrom=hartkopp.net; dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=jGXAT85V; dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b=yEQBoCdL; arc=pass smtp.client-ip=85.215.255.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hartkopp.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="jGXAT85V";
	dkim=permerror (0-bit key) header.d=hartkopp.net header.i=@hartkopp.net header.b="yEQBoCdL"
ARC-Seal: i=1; a=rsa-sha256; t=1788277877; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=UIDKvZ96tBS0wJLKwkAPLeMn2SH0kAHY8Wa2QYqalN8CXDFEH3FGtYQUxU1N0v+4KB
    +7ij0S4hUzDXbamZiuc/YeKO9ZU5CCscupV55T0XNndLH+4F44PnX7iMnIUZGF2u8pAv
    aNpdTfqU8Ct3BiWgMrugA0Vp/iJ0p47LE84G9Z9Rmr9NDeek692m11hMWRxPY8J2PKdq
    vidQviFlGlTdVB67Ledezv8OhwDfjGv/A3y15m4+SReQMI3QAIgrmR5g1WrztGjrOWEI
    QI9oyaniN6fSVMOSK0Ant3yWgCFtYhtiC1t5/ieXSHEXLKdAs/YETofs/bOGb/vMbldD
    6vqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1788277877;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=juGEAs4+udemnrvJ1LFIIBJEftiu2byod+ztqSfQa7Y=;
    b=JC33S1ls1gX6YNoJ004rs9Gkr6mQXB4MVy0TBFjLpU6meo2CAwvDQR9nW5nmww+WQh
    IiwVkWCFLAURrc3WJQH3MbITt8UsFKEGD4OLKjF+3jO/XTff+wsokMOoc1cIR/A4HM8Z
    7XlXZETzh2Zlx8fwj+yXIr66OghLX4QhSgUBeiaraSZeBAcfGtlSA+Cf2/SYk9N/cJsZ
    2tJrBXSmkRTPhU8MpeLag9PdyqhKOqLLEgCTuXWen/wWa/ddYgFCD2vq14/JnRhfHLek
    K4qa63RMu/QYwrHB/v3Z6uLJAiTTxfjuRulmt/8Rw7m+YIIwmsK5Ky7JOgYvuNe5pUCF
    NXEA==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1788277877;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=juGEAs4+udemnrvJ1LFIIBJEftiu2byod+ztqSfQa7Y=;
    b=jGXAT85VMaaJHZIjBO4TF2lrBvGnYpSdEp5KgIUXj77U8s6iqe6FPO77iHFEByAPG5
    Jkkp1c/UsX0CtPPghr9mZtij0+i/rpyo7irQwb6lFQqmgxZFvYR3pDotDCMHKP1w0RIx
    fdfnfHVMbSSOYSzlA7kk8DyFlgvxGTMauqjNaU1ezPyvUo48GTN/qnKXGJnaWGdDomcw
    +RVkpzlnBUsMuV0e59XDiQHI46ofB8RuEzTYbnt23fsnfQs80tvQcWr5VnQwksNzJciW
    8fbbRhi86hOVlIXRFgbQejCQ/mRiL3ZNkLhePHQOcGTHmQiZPPjDefc1FZDNfhVYrMow
    VHIQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1788277877;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=juGEAs4+udemnrvJ1LFIIBJEftiu2byod+ztqSfQa7Y=;
    b=yEQBoCdLkJ2D9ilQmCtSby8BQ18j52oB+oZd//klHatuRc754IpGD/nSsnbpyP04EF
    AU8bPT9VS40R6l4UTqBA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjH4JKvMdQv2tTUsMrZpkO3Mw3lZ/t54cFxeEQ7s8bDup0Q=="
Received: from [IPV6:2a00:6020:4a38:6810::989]
    by smtp.strato.de (RZmta 55.6.2 AUTH)
    with ESMTPSA id K171b7281FpFShV
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 1 Sep 2026 17:51:15 +0200 (CEST)
Message-ID: <9e18a5a0-33c7-482b-9edc-972de9954453@hartkopp.net>
Date: Tue, 1 Sep 2026 17:51:10 +0200
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4] net: Replace %pK output with 0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 linux-atm-general@lists.sourceforge.net, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Jakub Kicinski <kuba@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Marc Kleine-Budde
 <mkl@pengutronix.de>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Remi Denis-Courmont <courmisch@gmail.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Petr Mladek <pmladek@suse.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Kees Cook <kees@kernel.org>
References: <20260901153706.RKMS7kBY@linutronix.de>
Content-Language: en-US
From: Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20260901153706.RKMS7kBY@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 01.09.26 17:37, Sebastian Andrzej Siewior wrote:
> Commit 71338aa7d050c ("net: convert %p usage to %pK") which is from
> 2011 and changed the %p annotation for pointer to %pK. Back then the
> default behaviour for %p was to print the pointer. The %pK modifier was
> introduced to able to control the behaviour of specific pointer values
> without changing the behaviour of %p for everyone. It was dedicated to
> avoid leaking pointers via /proc.
> 
> There was also the idea to remove the check from formatting the string
> and move to the open callback with some helpers but this did not happen.
> 
> Things changed over time. The default behaviour for %p is now to print a
> hash pointer which does not leak the address but allows to correlate if
> two pointers are equal.
> The policy on %p is to not introduce new ones. This is somehow in
> between since it already exists. The pointer are usually socket pointers
> and I don't see any value in exposing them. Therefore I am following the
> recommendation of removing them. Since their usage in /proc/ can be
> considered ABI I replace the pointer with a 0.
> 
> Replace the %pK annotation with 0 value. Correct the spacing for the
> cases where pointer is at the beginning (a few drivers did expect 32bit
> pointers so things got a bit off with 64bit wide pointers).
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> v3…v4: https://lore.kernel.org/all/20260812110531.ITPqiY2O@linutronix.de/
>   - The CAN changes have been dropped.

No. They are still part of your patch - in the former way.

Would you like to integrate my patch into yours or do you want me to 
rebase my code once it shows up in net-next?

https://lore.kernel.org/linux-can/20260815103400.117175-1-socketcan@hartkopp.net/

Best regards,
Oliver


> There will be different change removing
>     the %p coming from the CAN department. There is now no %pS user in
>     this patch but the issue sashiko complained about is in the works…
>   - Field description updated in Documentation/networking/proc_net_tcp.rst
> 
> v2…v3: https://lore.kernel.org/all/20260720144031.oU6azheV@linutronix.de/
>   - seq_printf() with static strings have been replaced with seq_puts()
>     (checkpatch)
>   - Added missing fixed length in the CAN_EFF_FLAG case
>     (can_print_rcvlist(), sashiko)
>   - Added missing 0 in get_timewait6_sock() (Jakub)
>   - Added back padding to the unix_seq_show() output. There is a selftest
>     which checks the length of the first line. (kernel test robot
>     <oliver.sang@intel.com>)
> 
> v1…v2: https://lore.kernel.org/all/20260706073824.xixrLxoD@linutronix.de
>   - This follows Kees' feedback regarding the general policy and "is it
>     really needed?". Since I don't think that this is of general usage I
>     replaced them all with 0 and corrected the spacing at the beginning.
> 
>   - can_print_rcvlist() is now using a %ps to print the name of the
>     function. Everything is a sock pointer (or some other data structure)
>     and is now 0.
> 
>   net/atm/proc.c           |  7 +++----
>   net/can/bcm.c            |  4 +---
>   net/can/proc.c           | 12 ++++--------
>   net/ipv4/ping.c          |  5 ++---
>   net/ipv4/raw.c           |  4 ++--
>   net/ipv4/tcp_ipv4.c      | 13 ++++++-------
>   net/ipv4/udp.c           |  5 ++---
>   net/ipv6/datagram.c      |  5 ++---
>   net/ipv6/tcp_ipv6.c      | 12 ++++++------
>   net/key/af_key.c         |  5 ++---
>   net/netlink/af_netlink.c |  5 ++---
>   net/packet/af_packet.c   |  7 ++-----
>   net/phonet/socket.c      |  5 ++---
>   net/sctp/proc.c          |  6 +++---
>   net/unix/af_unix.c       |  3 +--
>   15 files changed, 40 insertions(+), 58 deletions(-)
> 
> diff --git a/net/atm/proc.c b/net/atm/proc.c
> index 8f20b49b9c02a..ca0fc6b90998c 100644
> --- a/net/atm/proc.c
> +++ b/net/atm/proc.c
> @@ -159,7 +159,7 @@ static void vcc_info(struct seq_file *seq, struct atm_vcc *vcc)
>   {
>   	struct sock *sk = sk_atm(vcc);
>   
> -	seq_printf(seq, "%pK ", vcc);
> +	seq_puts(seq, "      0 ");
>   	if (!vcc->dev)
>   		seq_printf(seq, "Unassigned    ");
>   	else
> @@ -228,9 +228,8 @@ static const struct seq_operations pvc_seq_ops = {
>   static int vcc_seq_show(struct seq_file *seq, void *v)
>   {
>   	if (v == SEQ_START_TOKEN) {
> -		seq_printf(seq, sizeof(void *) == 4 ? "%-8s%s" : "%-16s%s",
> -			"Address ", "Itf VPI VCI   Fam Flags Reply "
> -			"Send buffer     Recv buffer      [refcnt]\n");
> +		seq_puts(seq, "Address Itf VPI VCI   Fam Flags Reply "
> +			 "Send buffer     Recv buffer     [refcnt]\n");
>   	} else {
>   		struct vcc_state *state = seq->private;
>   		struct atm_vcc *vcc = atm_sk(state->sk);
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index 3d637a1e0ac1a..794faf83e0e4f 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -220,9 +220,7 @@ static int bcm_proc_show(struct seq_file *m, void *v)
>   	struct bcm_sock *bo = bcm_sk(sk);
>   	struct bcm_op *op;
>   
> -	seq_printf(m, ">>> socket %pK", sk->sk_socket);
> -	seq_printf(m, " / sk %pK", sk);
> -	seq_printf(m, " / bo %pK", bo);
> +	seq_puts(m, ">>> socket 0 / sk 0 / bo 0");
>   	seq_printf(m, " / dropped %lu", bo->dropped_usr_msgs);
>   	seq_printf(m, " / bound %s", bcm_proc_getifname(net, ifname, bo->ifindex));
>   	seq_printf(m, " <<<\n");
> diff --git a/net/can/proc.c b/net/can/proc.c
> index de4d05ae34597..4314180fd7a14 100644
> --- a/net/can/proc.c
> +++ b/net/can/proc.c
> @@ -192,12 +192,11 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
>   
>   	hlist_for_each_entry_rcu(r, rx_list, list) {
>   		char *fmt = (r->can_id & CAN_EFF_FLAG)?
> -			"   %-5s  %08x  %08x  %pK  %pK  %8ld  %s\n" :
> -			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
> +			"   %-5s  %08x  %08x  %-20ps %8u %8ld  %s\n" :
> +			"   %-5s     %03x    %08x  %-20ps %8u %8ld  %s\n";
>   
>   		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
> -			   r->func, r->data, atomic_long_read(&r->matches),
> -			   r->ident);
> +			   r->func, 0, atomic_long_read(&r->matches), r->ident);
>   	}
>   }
>   
> @@ -207,10 +206,7 @@ static void can_print_recv_banner(struct seq_file *m)
>   	 *                  can1.  00000000  00000000  00000000
>   	 *                 .......          0  tp20
>   	 */
> -	if (IS_ENABLED(CONFIG_64BIT))
> -		seq_puts(m, "  device   can_id   can_mask      function          userdata       matches  ident\n");
> -	else
> -		seq_puts(m, "  device   can_id   can_mask  function  userdata   matches  ident\n");
> +	seq_puts(m, "  device   can_id   can_mask  function             userdata  matches  ident\n");
>   }
>   
>   static int can_stats_proc_show(struct seq_file *m, void *v)
> diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
> index d36f1e273fde4..223a0108b74cc 100644
> --- a/net/ipv4/ping.c
> +++ b/net/ipv4/ping.c
> @@ -1095,15 +1095,14 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
>   	__u16 srcp = ntohs(inet->inet_sport);
>   
>   	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> -		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
> +		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u",
>   		bucket, src, srcp, dest, destp, sp->sk_state,
>   		sk_wmem_alloc_get(sp),
>   		sk_rmem_alloc_get(sp),
>   		0, 0L, 0,
>   		from_kuid_munged(seq_user_ns(f), sk_uid(sp)),
>   		0, sock_i_ino(sp),
> -		refcount_read(&sp->sk_refcnt), sp,
> -		sk_drops_read(sp));
> +		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
>   }
>   
>   static int ping_v4_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index d756e5e31b90d..9d01006d8189e 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -1054,14 +1054,14 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
>   	      srcp  = inet->inet_num;
>   
>   	seq_printf(seq, "%4d: %08X:%04X %08X:%04X"
> -		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
> +		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u\n",
>   		i, src, srcp, dest, destp, sp->sk_state,
>   		sk_wmem_alloc_get(sp),
>   		sk_rmem_alloc_get(sp),
>   		0, 0L, 0,
>   		from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
>   		0, sock_i_ino(sp),
> -		refcount_read(&sp->sk_refcnt), sp, sk_drops_read(sp));
> +		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
>   }
>   
>   static int raw_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b8887cdd66c57..2cd8ae4a0e4b6 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2748,7 +2748,7 @@ static void get_openreq4(const struct request_sock *req,
>   	long delta = req->rsk_timer.expires - jiffies;
>   
>   	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
> -		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d %pK",
> +		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %u %d 0",
>   		i,
>   		ireq->ir_loc_addr,
>   		ireq->ir_num,
> @@ -2763,8 +2763,7 @@ static void get_openreq4(const struct request_sock *req,
>   				 sk_uid(req->rsk_listener)),
>   		0,  /* non standard timer */
>   		0, /* open_requests have no inode */
> -		0,
> -		req);
> +		0);
>   }
>   
>   static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
> @@ -2811,7 +2810,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>   				      READ_ONCE(tp->copied_seq), 0);
>   
>   	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
> -			"%08X %5u %8d %llu %d %pK %lu %lu %u %u %d",
> +			"%08X %5u %8d %llu %d 0 %lu %lu %u %u %d",
>   		i, src, srcp, dest, destp, state,
>   		READ_ONCE(tp->write_seq) - tp->snd_una,
>   		rx_queue,
> @@ -2821,7 +2820,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
>   		from_kuid_munged(seq_user_ns(f), sk_uid(sk)),
>   		READ_ONCE(icsk->icsk_probes_out),
>   		sock_i_ino(sk),
> -		refcount_read(&sk->sk_refcnt), sk,
> +		refcount_read(&sk->sk_refcnt),
>   		jiffies_to_clock_t(icsk->icsk_rto),
>   		jiffies_to_clock_t(icsk->icsk_ack.ato),
>   		(icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sk),
> @@ -2844,10 +2843,10 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
>   	srcp  = ntohs(tw->tw_sport);
>   
>   	seq_printf(f, "%4d: %08X:%04X %08X:%04X"
> -		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
> +		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d 0",
>   		i, src, srcp, dest, destp, READ_ONCE(tw->tw_substate), 0, 0,
>   		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
> -		refcount_read(&tw->tw_refcnt), tw);
> +		refcount_read(&tw->tw_refcnt));
>   }
>   
>   #define TMPSZ 150
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index af96032174441..a01db598c00bf 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -3283,15 +3283,14 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
>   	__u16 srcp	  = ntohs(inet->inet_sport);
>   
>   	seq_printf(f, "%5d: %08X:%04X %08X:%04X"
> -		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u",
> +		" %02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u",
>   		bucket, src, srcp, dest, destp, sp->sk_state,
>   		sk_wmem_alloc_get(sp),
>   		udp_rqueue_get(sp),
>   		0, 0L, 0,
>   		from_kuid_munged(seq_user_ns(f), sk_uid(sp)),
>   		0, sock_i_ino(sp),
> -		refcount_read(&sp->sk_refcnt), sp,
> -		sk_drops_read(sp));
> +		refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
>   }
>   
>   static int udp4_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
> index 38d7b48452817..191c9733ff9fa 100644
> --- a/net/ipv6/datagram.c
> +++ b/net/ipv6/datagram.c
> @@ -1102,7 +1102,7 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
>   	src   = &sp->sk_v6_rcv_saddr;
>   	seq_printf(seq,
>   		   "%5d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %u\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %u\n",
>   		   bucket,
>   		   src->s6_addr32[0], src->s6_addr32[1],
>   		   src->s6_addr32[2], src->s6_addr32[3], srcp,
> @@ -1115,6 +1115,5 @@ void __ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
>   		   from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
>   		   0,
>   		   sock_i_ino(sp),
> -		   refcount_read(&sp->sk_refcnt), sp,
> -		   sk_drops_read(sp));
> +		   refcount_read(&sp->sk_refcnt), sk_drops_read(sp));
>   }
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 9e9155b1b3aa7..87dbdc9086045 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -2103,7 +2103,7 @@ static void get_openreq6(struct seq_file *seq,
>   
>   	seq_printf(seq,
>   		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d %pK\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %d %d 0\n",
>   		   i,
>   		   src->s6_addr32[0], src->s6_addr32[1],
>   		   src->s6_addr32[2], src->s6_addr32[3],
> @@ -2120,7 +2120,7 @@ static void get_openreq6(struct seq_file *seq,
>   				    sk_uid(req->rsk_listener)),
>   		   0,  /* non standard timer */
>   		   0, /* open_requests have no inode */
> -		   0, req);
> +		   0);
>   }
>   
>   static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
> @@ -2171,7 +2171,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
>   
>   	seq_printf(seq,
>   		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d %pK %lu %lu %u %u %d\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5u %8d %llu %d 0 %lu %lu %u %u %d\n",
>   		   i,
>   		   src->s6_addr32[0], src->s6_addr32[1],
>   		   src->s6_addr32[2], src->s6_addr32[3], srcp,
> @@ -2186,7 +2186,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
>   		   from_kuid_munged(seq_user_ns(seq), sk_uid(sp)),
>   		   READ_ONCE(icsk->icsk_probes_out),
>   		   sock_i_ino(sp),
> -		   refcount_read(&sp->sk_refcnt), sp,
> +		   refcount_read(&sp->sk_refcnt),
>   		   jiffies_to_clock_t(icsk->icsk_rto),
>   		   jiffies_to_clock_t(icsk->icsk_ack.ato),
>   		   (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sp),
> @@ -2211,7 +2211,7 @@ static void get_timewait6_sock(struct seq_file *seq,
>   
>   	seq_printf(seq,
>   		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
> -		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK\n",
> +		   "%02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d 0\n",
>   		   i,
>   		   src->s6_addr32[0], src->s6_addr32[1],
>   		   src->s6_addr32[2], src->s6_addr32[3], srcp,
> @@ -2219,7 +2219,7 @@ static void get_timewait6_sock(struct seq_file *seq,
>   		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
>   		   READ_ONCE(tw->tw_substate), 0, 0,
>   		   3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
> -		   refcount_read(&tw->tw_refcnt), tw);
> +		   refcount_read(&tw->tw_refcnt));
>   }
>   
>   static int tcp6_seq_show(struct seq_file *seq, void *v)
> diff --git a/net/key/af_key.c b/net/key/af_key.c
> index 1d8965d7f4f3c..d215b33b7492c 100644
> --- a/net/key/af_key.c
> +++ b/net/key/af_key.c
> @@ -3803,10 +3803,9 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
>   	struct sock *s = sk_entry(v);
>   
>   	if (v == SEQ_START_TOKEN)
> -		seq_printf(f ,"sk       RefCnt Rmem   Wmem   User   Inode\n");
> +		seq_puts(f, "sk RefCnt Rmem   Wmem   User   Inode\n");
>   	else
> -		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6llu\n",
> -			       s,
> +		seq_printf(f, "0  %-6d %-6u %-6u %-6u %-6llu\n",
>   			       refcount_read(&s->sk_refcnt),
>   			       sk_rmem_alloc_get(s),
>   			       sk_wmem_alloc_get(s),
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index e6b1d9758c9c9..537562aacb7ef 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2700,14 +2700,13 @@ static int netlink_native_seq_show(struct seq_file *seq, void *v)
>   {
>   	if (v == SEQ_START_TOKEN) {
>   		seq_puts(seq,
> -			 "sk               Eth Pid        Groups   "
> +			 "sk Eth Pid        Groups   "
>   			 "Rmem     Wmem     Dump  Locks    Drops    Inode\n");
>   	} else {
>   		struct sock *s = v;
>   		struct netlink_sock *nlk = nlk_sk(s);
>   
> -		seq_printf(seq, "%pK %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
> -			   s,
> +		seq_printf(seq, "0  %-3d %-10u %08x %-8d %-8d %-5d %-8d %-8u %-8llu\n",
>   			   s->sk_protocol,
>   			   nlk->portid,
>   			   nlk->groups ? (u32)nlk->groups[0] : 0,
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 435756877abaa..9ebf1605fec1a 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -4744,16 +4744,13 @@ static void packet_seq_stop(struct seq_file *seq, void *v)
>   static int packet_seq_show(struct seq_file *seq, void *v)
>   {
>   	if (v == SEQ_START_TOKEN)
> -		seq_printf(seq,
> -			   "%*sRefCnt Type Proto  Iface R Rmem   User   Inode\n",
> -			   IS_ENABLED(CONFIG_64BIT) ? -17 : -9, "sk");
> +		seq_puts(seq, "sk RefCnt Type Proto  Iface R Rmem   User   Inode\n");
>   	else {
>   		struct sock *s = sk_entry(v);
>   		const struct packet_sock *po = pkt_sk(s);
>   
>   		seq_printf(seq,
> -			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6llu\n",
> -			   s,
> +			   "0  %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6llu\n",
>   			   refcount_read(&s->sk_refcnt),
>   			   s->sk_type,
>   			   ntohs(READ_ONCE(po->num)),
> diff --git a/net/phonet/socket.c b/net/phonet/socket.c
> index 631a99cdbd006..ad12b746d4fca 100644
> --- a/net/phonet/socket.c
> +++ b/net/phonet/socket.c
> @@ -586,14 +586,13 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
>   		struct pn_sock *pn = pn_sk(sk);
>   
>   		seq_printf(seq, "%2d %04X:%04X:%02X %02X %08X:%08X %5d %llu "
> -			"%d %pK %u",
> +			"%d 0 %u",
>   			sk->sk_protocol, pn->sobject, pn->dobject,
>   			pn->resource, sk->sk_state,
>   			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
>   			from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
>   			sock_i_ino(sk),
> -			refcount_read(&sk->sk_refcnt), sk,
> -			sk_drops_read(sk));
> +			refcount_read(&sk->sk_refcnt), sk_drops_read(sk));
>   	}
>   	seq_pad(seq, '\n');
>   	return 0;
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index 43433d7e2acd7..7ea123b90aa59 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -174,7 +174,7 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
>   		sk = ep->base.sk;
>   		if (!net_eq(sock_net(sk), seq_file_net(seq)))
>   			continue;
> -		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5llu ", ep, sk,
> +		seq_printf(seq, "%8d %8d %-3d %-3d %-4d %-5d %5u %5llu ", 0, 0,
>   			   sctp_sk(sk)->type, sk->sk_state, hash,
>   			   ep->base.bind_addr.port,
>   			   from_kuid_munged(seq_user_ns(seq), sk_uid(sk)),
> @@ -260,9 +260,9 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
>   	sk = epb->sk;
>   
>   	seq_printf(seq,
> -		   "%8pK %8pK %-3d %-3d %-2d %-4d "
> +		   "%8d %8d %-3d %-3d %-2d %-4d "
>   		   "%4d %8d %8d %7u %5llu %-5d %5d ",
> -		   assoc, sk, sctp_sk(sk)->type, sk->sk_state,
> +		   0, 0, sctp_sk(sk)->type, sk->sk_state,
>   		   assoc->state, 0,
>   		   assoc->assoc_id,
>   		   assoc->sndbuf_used,
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 10ed9421e43aa..8f32bafd36c86 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -3555,8 +3555,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
>   		struct unix_sock *u = unix_sk(s);
>   		unix_state_lock(s);
>   
> -		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5llu",
> -			s,
> +		seq_printf(seq, "%08u: %08X %08X %08X %04X %02X %5llu", 0,
>   			refcount_read(&s->sk_refcnt),
>   			0,
>   			s->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,

