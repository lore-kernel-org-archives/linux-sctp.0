Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304020;
	b=niRI0rUP8a6Lkk8+H+AYo8xDuwgQOZp28S5W3R0xzeLI3Q9JOca7T54jg+68dv9RXo1n
	 FcOx0U3VUrSwtO2WvwI1PzSKrx+aGFQTFGQyel3AWIoXdGtK0XOfeY4e2SooyhmCZVX79
	 6HT+6blOpIoojZ6PAjsewcaMY8gWAjzGpwYGOUgCSDOi5O9C9jSkdDJkP+P2VFu8kfcLf
	 /iF5/11blOJERZDQvkFVWZH/Hf8Hki2+kHMfFMbt9ZmAaDTDBdbVB7XHaok2bCbZkyZVz
	 uFSS630d52u0xBpdk1/DD/F0fg0Y4UHoxfT4Kga8a7XeeMRQoEtkSDPu+XiAPd5HTVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304020;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=aoB/ud1rCkNWKtjDq+VsUym9kzyPrwlWjt3OYzerKLE=;
	b=BS7B0RibwXA1wolwpAPbHC+zBePxVv/JSTiI68PZh9y/GNiZvFsXeVKiZQ8VmKNTDl8L
	 pA2qlAypYqkzjG4sV/DB/ikICJJ3SquC5CWSJtenuUfcUOynT24iwlyLg0DLGWwjx7VwT
	 uKJDgrMgEvhskc2JjCwTgxPXWPa1aqJSq5ZpkLO5dUV6PXUHU2NUQH/MrNPDcGZA2qKk/
	 tfIoLqGKuuf1AqWhG2tkdpyb6DSwvBAD7tY+vT9QzvFnz9YUPM90IL67RGtHpI/hhvdSY
	 P391i5sz80GOJu9hMnNL9jajnG78I6YKiUGmuQwPj5BPAvYrJpbEbkCUli3oJFVnQTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKuoDPqw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567CC606A913;
	Tue, 10 Nov 2026 09:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKuoDPqw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1621F0089F;
	Tue, 10 Nov 2026 09:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304019;
	bh=aoB/ud1rCkNWKtjDq+VsUym9kzyPrwlWjt3OYzerKLE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=eKuoDPqwUNtLOcO4pT9tEKkROIwU+mBPy7zeFUKNQfnurukysWljFND6UsY6ek5yB
	 3E5nMDs4OWYolmlvRiFQ4PzOsQrxXUBzfB/mAkyZdrmlmrwo3xUSrYuOe+iu8+Vb4F
	 fWxmmTc0/L0yaGr3La4sXLpETJYe3Unh/2FkdGqPbfynqUDrk2sA54uSk23MDzcZ7n
	 tNCOm3vZvHkYSojK2N4drI+d4Yc5fbaIm65xBWlq6jwdqJjy7uJlJhBm+YcK+KcOYO
	 YHN14jfiHOHhy/6DBoeGSs5/m5Tz+9vF+KJT2V96rDWDR1lo1w1FMP3HA2gyUpS00G
	 GO75tfnBY9HBg==
Subject: Re: [PATCH v1] sctp: fix race between addr_wq timer handler and
 backlog draining
From: netdev-bot+sashiko@kernel.org
To: 18983559317@163.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 10 Nov 2026 09:46:58 +0000
Message-ID: <179430401881.994134.13883222094263261072@kernel.org>
In-Reply-To: <20261106091938.112942-1-18983559317@163.com>
References: <20261106091938.112942-1-18983559317@163.com>
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The deferral is netns-wide rather than per socket.
- [Medium] The new early return in sctp_addr_wq_timeout_handler()
  (net/sctp/protocol.c:648-655) can leave an addr_waitq entry half-…
- [Medium] Each 500 ms retry runs sctp_asconf_mgmt() again on every
  socket ahead of the owned one.

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it sits on the
  exact path the patch claims to make safe.

--

sctp: fix race between addr_wq timer handler and backlog draining

This patch adds a sock_owned_by_user() check to
sctp_addr_wq_timeout_handler(). When an auto-asconf socket is owned by a
user context, the handler drops both locks and leaves the current
addr_waitq entry queued. It then re-arms addr_wq_timer to retry after
SCTP_ADDRESS_TICK_DELAY.

> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 27c26e12f95d8..7528a40a87f57 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -645,6 +645,14 @@ static void sctp_addr_wq_timeout_handler(struct timer_list *t)
>  			if (!sctp_is_ep_boundall(sk))
>  				continue;
>  			bh_lock_sock(sk);
> +			if (sock_owned_by_user(sk)) {
> +				bh_unlock_sock(sk);
> +				spin_unlock_bh(&net->sctp.addr_wq_lock);
> +				/* Try again later. */
> +				mod_timer(&net->sctp.addr_wq_timer,
> +					jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY));
> +				return;
> +			}

[Severity: High]
Can a single owned socket stall auto-ASCONF for the whole network
namespace?

When any socket on net->sctp.auto_asconf_splist is owned, the handler
stops the whole walk. It skips the current addrw, every later addr_waitq
entry, and every socket after the owned one. It then re-arms every
SCTP_ADDRESS_TICK_DELAY with no retry limit.

An unprivileged user can add a socket to that list. All it needs is an
INADDR_ANY bind, and there is no capability check:

net/sctp/socket.c:sctp_setsockopt_auto_asconf() {
    ...
	if (!sctp_is_ep_boundall(sk) && *val)
		return -EINVAL;
    ...
	} else if (*val && !sp->do_auto_asconf) {
		list_add_tail(&sp->auto_asconf_list,
		    &sock_net(sk)->sctp.auto_asconf_splist);
    ...
}

That user can keep sk_lock.owned set most of the time. Two ways are
threads looping on getsockopt/setsockopt calls that take lock_sock(), or
a recvmsg() copy that faults on a FUSE-backed page. Every retry then hits
the owned socket and addr_waitq never drains. No other user's
associations in the netns get ASCONF ADD/DEL for renumbering or
RTM_DELADDR events.

Even without an attacker, would a server with many busy auto-asconf
sockets reliably find all of them unowned during one pass?

The commit message says this defers "like the other entries do".
sctp_rcv() and the association timers defer per socket or per
association, though, and don't block unrelated sockets.

Could the owned socket be skipped instead, with its pending work handled
later from release_cb or the backlog?

[Severity: Medium]
Can this early return leave an addr_waitq entry half-applied?

Every socket ahead of the owned one in auto_asconf_splist has already run
sctp_asconf_mgmt() for addrw. The entry stays queued, and nothing records
which sockets were handled.

sctp_addr_wq_mgmt() assumes a queued entry hasn't been applied to any
socket yet. When the opposite event for the same address arrives, it
frees the queued entry and returns without queuing the new one:

net/sctp/protocol.c:sctp_addr_wq_mgmt() {
    ...
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

Take a DEL followed by a NEW for address X, which is the DHCP flapping
case described in that function's comment. The earlier sockets'
associations have already sent ASCONF-DEL for X and will drop it, or set
asconf_addr_del_pending if X was their last address. Meanwhile X is back
on the host.

With a NEW followed by a DEL, the earlier associations keep an address
that has been removed, and the peer was told it is valid. Those sockets
never get the reverse ASCONF.

Before this patch, each entry was applied to every socket inside one
addr_wq_lock critical section and then freed. The IPv6 DAD break fires
before any socket has seen the entry. So this state could not happen
before.

[Severity: Medium]
The commit message says:

  "Sockets processed earlier for the same address event will see a
  duplicate ASCONF on retry; the peer reports that in an ASCONF-ACK
  error indication, which the association tolerates."

Is this accurate for both event types?

For ADD, sctp_send_asconf_add_ip() skips associations that already have
the address, so no duplicate is sent:

			if (sctp_assoc_lookup_laddr(asoc, addr))
				break;

For DEL, the first pass only marks the address SCTP_ADDR_DEL in the
association's bind list until the ASCONF-ACK arrives.
sctp_bind_addr_match() checks laddr->valid but not laddr->state. So this
check in sctp_send_asconf_del_ip() still matches and doesn't skip the
association:

			if (!sctp_assoc_lookup_laddr(asoc, laddr))
				break;

Each 500ms retry then builds another DEL chunk per association through
sctp_make_asconf_update_ip(). sctp_send_asconf() queues it with no limit
while an ASCONF is outstanding:

	if (asoc->addip_last_asconf) {
		list_add_tail(&chunk->list, &asoc->addip_chunk_list);
		goto out;
	}

Suppose a later socket is kept owned as described above. Suppose also
that the peer answers heartbeats, which reset overall_error_count, but
never ACKs the ASCONF, so sctp_sf_t4_timer_expire() never reaches
max_retrans.

Can addip_chunk_list then grow without bound until the association is
torn down?

>  			if (sctp_asconf_mgmt(sp, addrw) < 0)
>  				pr_debug("%s: sctp_asconf_mgmt failed\n", __func__);

[Severity: High]
This is a pre-existing issue, not one introduced by this patch, but it
sits on the path this patch is trying to make safe. Does
sctp_asconf_mgmt() reach a GFP_KERNEL allocation from softirq context
here?

sctp_addr_wq_timeout_handler() is a timer_list callback. It holds
addr_wq_lock and the socket spinlock across this call. The primitive
that sends the ASCONF hard-codes GFP_KERNEL:

net/sctp/primitive.c:DECLARE_PRIMITIVE() {
    ...
	error = sctp_do_sm(net, event_type, subtype, state, ep, asoc,	\
			   arg, GFP_KERNEL); \
    ...
}

That gfp is passed down unchanged:

sctp_asconf_mgmt()
  sctp_send_asconf_add_ip() / sctp_send_asconf_del_ip()
    sctp_send_asconf()
      sctp_primitive_ASCONF()
        sctp_do_sm(..., GFP_KERNEL)
          sctp_side_effects()
            sctp_cmd_interpreter()
              sctp_outq_uncork(&asoc->outqueue, gfp)
                sctp_outq_flush()
                  sctp_packet_transmit(packet, ctx->gfp)
                    alloc_skb(..., gfp)

With CONFIG_DEBUG_ATOMIC_SLEEP, this should warn about sleeping in an
invalid context each time an auto-ASCONF is sent while no ASCONF is
outstanding. Under memory pressure, direct reclaim could also schedule
while these spinlocks are held.

>  			bh_unlock_sock(sk);

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261106091938.112942-1-18983559317%40163.com
