Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794386694;
	b=l2sAib/k8ZaP5RwgGteMm6DOBxorYKvB6sWnhgdhshq5FOXRYnStIe5ymDUvaKsyA8KB
	 wCgyS8p4dJFgQ+nOs4kDCL0Ilv80faBgnXNcV1UoPDTzR9wDFc9FqaJ781ivk2z52UYZY
	 Bi2/jG98Bd0RS7Au9fUmzJVjaqOl0hokfsPs41kb8subnHquaNZYgVWTjEjGDwRzbV2iA
	 YemtdMXa9BJe1cuD7ta7OMeSUD+9Y8k2MnSnBmcJRpQS5KpvJIVobNetIhclylAuXneZE
	 t24GbKnEOQ1pOp8E3cz9jpGshUdhhyqsQEGwdyzdaodHkMA52Fs20qcK5U0ptH4R0dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794386694;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=JYgFy7Rxm9zfJYPCoxlxIjMufN9lJT2DNswzl8zQoco=;
	b=VOB75OhelsRRrsGUOxTiRysD7Rx3DJGuHcs69rbLS2/obXbI56XK5GLMVpY51AW10XhC
	 +IX0lWsrf+3mv6Byqj/hYhlyQcVIu3Jhu7JD3F99BmDmOV6hg67G3rzpr427Qg8Lm0OZA
	 vrTMyaq89FuwTlBWwvjXcDizZ0WWeBGER/FumwQTPi0DAFD9nl+33HAmENBL9wzdK61l6
	 4JBrVwwCCJKjjFFNj2JfKeWSsFFNFJrHdi6fJssBY07mHvz+Ve6x+cigGVVwMttybxi7Y
	 DT+MkpIzM1X1gLbr9EGGBJTCQHoaET9UyF8UIRtV+GF6x3h3nso9ABGpWUFhUUwgs4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=meftBSpr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC121606A31C;
	Wed, 11 Nov 2026 08:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=meftBSpr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C3F1F00A05;
	Wed, 11 Nov 2026 08:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794386694;
	bh=JYgFy7Rxm9zfJYPCoxlxIjMufN9lJT2DNswzl8zQoco=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=meftBSprrZMdyl/QUcBuDZPqfn1/Nf4fdhXedVq8w7sInjB3FIBuxCEXTxFSmVnbD
	 BBsU368+4HBnFkwN/NUuYv9SlsOipme/HoBvw9wxidpDDkBeaD964ZqwiJOx6hoyVB
	 cY1y2cIi8ynhREksQPEr/La8oEUnqw3zgyY6tFACtgiwDbti2eyD33fSSmKt08TkLO
	 rghDtMLRbUwuXF1YIINJykfaDQtKclmDmHu4sXpAvKZth0hKU0pm3J7sSLRL2Wq6jB
	 6HWcAz1i4kNFFIll9oP1BMEMEhZhohbTRwmEjzc9r4Zos0GAR1gceuW2Uu1ih/HFDW
	 bswbiNT2vjkUQ==
Subject: Re: [PATCH v2] sctp: fix race between addr_wq timer handler and
 backlog draining
From: netdev-bot+sashiko@kernel.org
To: 18983559317@163.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Wed, 11 Nov 2026 08:44:53 +0000
Message-ID: <179438669316.2199510.365044781249431849@kernel.org>
In-Reply-To: <20261109024219.347985-1-18983559317@163.com>
References: <20261109024219.347985-1-18983559317@163.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 3 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Kernel memory can grow without limit through repeated DEL_IP
  ASCONF chunks.
- [Medium] The new early exit breaks an invariant that
  sctp_addr_wq_mgmt() depends on.
- [Medium] One socket can now stall address-event processing for the
  whole netns.
- [Medium] The commit message says that sockets processed earlier 'will
  see a duplicate ASCONF on retry; the peer reports that in an ASCONF-…
- [Low] The new sock_owned_by_user() deferral branch in
  sctp_addr_wq_timeout_handler() (net/sctp/protocol.c) sets retry=true…

--

sctp: fix race between addr_wq timer handler and backlog draining

This patch makes sctp_addr_wq_timeout_handler() check sock_owned_by_user()
on each auto-asconf socket before it calls sctp_asconf_mgmt(). If the
socket is owned, processing stops and the addr_waitq entry stays queued.
The addr_wq_timer is then re-armed to retry after SCTP_ADDRESS_TICK_DELAY,
in a single mod_timer() shared with the existing IPv6 DAD retry.

> Sockets processed earlier for the same
> address event will see a duplicate ASCONF on retry; the peer reports
> that in an ASCONF-ACK error indication, which the association
> tolerates.

[Severity: Medium]
Is this description accurate for both event types?

For an SCTP_ADDR_NEW entry, the first pass through
sctp_send_asconf_add_ip() has already added the address with
sctp_add_bind_addr(..., SCTP_ADDR_NEW). On retry the lookup finds it and
skips the association, so no duplicate is sent:

net/sctp/socket.c:sctp_send_asconf_add_ip() {
    ...
			if (sctp_assoc_lookup_laddr(asoc, addr))
				break;
    ...
		if (i < addrcnt)
			continue;
    ...
}

For an SCTP_ADDR_DEL entry, the first pass in sctp_send_asconf_del_ip()
only marks the bind address:

				if (sctp_cmp_addr_exact(&saddr->a, laddr))
					saddr->state = SCTP_ADDR_DEL;

The entry stays valid until the ASCONF-ACK arrives. sctp_bind_addr_match()
only tests ->valid, so the !sctp_assoc_lookup_laddr() check still passes.
Each retry builds another DEL_IP chunk and queues it on addip_chunk_list
behind the outstanding ASCONF. That is one new chunk per retry, not a
single duplicate.

Could the commit message describe what actually happens on retry?

> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 27c26e12f95d8..267dc9b7a0e73 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c

[ ... ]

> @@ -645,16 +643,27 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
>  			if (!sctp_is_ep_boundall(sk))
>  				continue;
>  			bh_lock_sock(sk);
> +			if (sock_owned_by_user(sk)) {
> +				bh_unlock_sock(sk);
> +				retry = true;
> +				break;
> +			}

[Severity: Medium]
Can a single owned socket stall address event processing for the whole
netns here?

The first user-owned boundall socket in net->sctp.auto_asconf_splist
breaks out of both loops. No later socket gets processed, and neither does
any later addr_waitq entry, including events for unrelated addresses.

Each retry starts again at the head of both lists. Every socket ahead of
the owned one therefore gets sctp_asconf_mgmt() again on every tick.

User context can hold the socket lock for an unbounded time. For example,
sctp_recvmsg() holds lock_sock() across skb_copy_datagram_msg(). A copy
that faults on a FUSE or userfaultfd backed page keeps sk_lock.owned set
for as long as the user wants.

The other async entry points defer per socket or per association: the
sctp_rcv() backlog queueing and the timer handlers in sm_sideeffect.c. One
busy socket does not block the others there.

Would it make sense to skip only this socket and track which sockets
still need the event, instead of halting all processing?

[Severity: Low]
This isn't a bug, but the sibling deferral sites in
net/sctp/sm_sideeffect.c log before they reschedule. One example is
sctp_generate_heartbeat_event():

	if (sock_owned_by_user(sk)) {
		pr_debug("%s: sock is busy\n", __func__);

The DAD retry in this same handler also logs. Should this branch have a
similar pr_debug() so repeated deferrals show up in dynamic debug?

>  			if (sctp_asconf_mgmt(sp, addrw) < 0)
>  				pr_debug("%s: sctp_asconf_mgmt failed\n", __func__);
>  			bh_unlock_sock(sk);
>  		}
> +		if (retry)
> +			break;

[Severity: Medium]
Does leaving a partly delivered addrw on addr_waitq break the offset logic
in sctp_addr_wq_mgmt()?

By this point sctp_asconf_mgmt() has run for every boundall socket ahead
of the owned one, but the entry stays queued after addr_wq_lock is
dropped. sctp_addr_wq_mgmt() assumes no socket has seen a queued entry
yet:

net/sctp/protocol.c:sctp_addr_wq_mgmt() {
    ...
	/* Offsets existing events in addr_wq */
	addrw = sctp_addr_wq_lookup(net, addr);
	if (addrw) {
		if (addrw->state != cmd) {
			...
			list_del(&addrw->list);
			kfree(addrw);
		}
		spin_unlock_bh(&net->sctp.addr_wq_lock);
		return;
	}
    ...
}

Take a partly delivered SCTP_ADDR_NEW entry, and suppose RTM_DELADDR or
NETDEV_DOWN for the same address arrives before the retry. Both events are
dropped. The earlier sockets' associations have already sent ADD_IP for
the address. They keep it in asoc->base.bind_addr after it is gone, and no
DEL_IP is ever sent.

The reverse happens with a partly delivered SCTP_ADDR_DEL entry if the
address comes back before the retry. The earlier sockets' associations
remove the address when the ASCONF-ACK arrives and never re-add it.

Before this patch, the only path that left an entry queued was the IPv6
DAD break. That break runs before the socket loop, so no socket had seen
the entry yet.

>  #if IS_ENABLED(CONFIG_IPV6)
>  free_next:
>  #endif
>  		list_del(&addrw->list);
>  		kfree(addrw);
>  	}
> +
> +	if (retry)
> +		mod_timer(&net->sctp.addr_wq_timer,
> +			jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY));

[Severity: High]
Can this retry grow kernel memory without bound for an SCTP_ADDR_DEL
entry?

The retry has no limit and keeps no record of which sockets were already
handled. Every SCTP_ADDRESS_TICK_DELAY (500 ms), the timer replays the
same DEL addrw on every boundall socket ahead of the owned one:

sctp_addr_wq_timeout_handler()
  sctp_asconf_mgmt()
    sctp_send_asconf_del_ip()
      sctp_assoc_lookup_laddr()     <- still matches, ->valid is 1
      sctp_find_unmatch_addr()      <- still returns another address
      sctp_make_asconf_update_ip()  <- new skb and chunk, GFP_ATOMIC
      sctp_send_asconf()

While asoc->addip_last_asconf is set, sctp_send_asconf() appends the new
chunk with no length limit:

	if (asoc->addip_last_asconf) {
		list_add_tail(&chunk->list, &asoc->addip_chunk_list);
		goto out;
	}

Each retry also calls sctp_transport_route() on every transport of each
association. These allocations happen in timer softirq context and are
not charged to any memcg.

The growth only stops when the owned socket is released or the ASCONF-ACK
arrives. A peer that drops only ASCONF-ACKs keeps the association alive,
because heartbeat ACKs and data SACKs reset overall_error_count. So
sctp_sf_t4_timer_expire() never reaches max_retrans.

A local unprivileged user with user and net namespaces can set this up:

  - enable net.sctp.addip_enable in their own netns
  - flap an address on a dummy interface
  - filter ASCONF-ACKs
  - keep a socket owned through a stalled user copy

Before this patch, one address event produced exactly one DEL ASCONF per
association.

>  	spin_unlock_bh(&net->sctp.addr_wq_lock);
>  }

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261109024219.347985-1-18983559317%40163.com
