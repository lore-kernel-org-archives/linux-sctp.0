Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708163;
	b=NuN1tHDhIv48aDuL24GvnngkqGIo+W5KZ1FDzgOMoul+Uf1BAsglYjxVEYtIy7WNu71F
	 LLu0q+euhGh9eY6Wlc+QVtZk9yGzMaz8kWdU1L/s7+yzvPRwnq6LE+nIYmpd1aM/BY0tw
	 H0Aeq+NawRIkUkf80t25HXZ5kjvVsITPE2Px3wEpUpkgsm67KeUME5UroJTDdSF2i3V/r
	 289KWboG7CMUjNqYRhx7rkCyoBznDoxw/Gt+uOOB36QQvtYrPJztZ8Ik6oc66mdNQjywL
	 tGrH0z27HIYfCtymicp4c5tS3UcKZHxmWfXtLb6vyndrpo/qX9zdGYZWIogn77LohRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708163;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=gkZSowBcMJFI2V7vXB69tRrs3436KhZaHUCben0QEPM=;
	b=LK8oRzvKyjhjl/P6wabInUvzVe2MAIQ7NQoDLeBc4N1NrUS+P+b4x95XMMIOZEbIPt/4
	 k4z8zd1q8lD68mXby3KYRypza14WJOBMquheq1vcxpsNIU2kMcws+0Xg/XbrwPZ7bFcYa
	 XS8L/p62xOSACQIj83z9kWnJogdFKSAqMKPqV4xXxZ2SCJBdPam3ZJ2H5JeB1Pf1mNx2H
	 4KCH130Q2f2oSZPWx1Ok7D/jnj2oPHc2CJRk8YHF3/g7n8N8lcaXUAJmnS6iE+bA90nD/
	 YuFCXMcdcGfZG8i8Vmn59NI/tROwHuWIlbA0LZK2ndZCEidnHODy8VZu9RJ+UYyxXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9OAuIM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038CC606A31E;
	Thu, 26 Nov 2026 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a9OAuIM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6681F000EC;
	Thu, 26 Nov 2026 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795708162;
	bh=gkZSowBcMJFI2V7vXB69tRrs3436KhZaHUCben0QEPM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=a9OAuIM8271oFyCAb1IcFJ9xKW6nlCuzbEOeTbR4qUHrrmD2fD8j0hknFZ3CcGXNL
	 jZd1DpbrNGqr8SVGgaX+OOFQtj2eYA8M5TiymOIelF8quCZ2N8casoIMWYItlKsBe4
	 qhSXr9Ut+5u+v16oq77NSi8In7bzfgcI47E04A0IX/yZD6Ehtzj+bMycPeKRdszQc/
	 6ZVHMRYlJr1qGg9VrVzHogmP6KV/Eshm7R5N/NvWPVPlnBM1oQ6a9HQ/swF7uU0wPH
	 egYt+PkNQ6RAXdnBS5uE+9wikLEi5Bu8g7AaKFzUkIlI2OdihcEcS5TX0WwOCt72km
	 bzE73ZHJr3xLA==
Subject: Re: [PATCH net v2] sctp: diag: fix stack garbage in IPv6 scope_id
 during dump_one lookup
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Thu, 26 Nov 2026 15:49:21 +0000
Message-ID: <179570816138.3135.14968815049241245107@kernel.org>
In-Reply-To: <7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin@gmail.com>
References: <7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin@gmail.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The commit message justifies the wildcard scope_id with: "The
  dif check in sctp_addrs_lookup_transport() already filters by…

--

sctp: diag: fix stack garbage in IPv6 scope_id during dump_one lookup

This commit zero-initializes the laddr and paddr lookup addresses in
sctp_diag_dump_one(). As a result, sin6_scope_id and sin6_flowinfo no
longer hold stack garbage. A zero sin6_scope_id then acts as a wildcard in
__sctp_v6_cmp_addr(), and idiag_if is used only as a dif filter.

> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index c2a0de2adf6fd..564a5b51e6ce3 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -433,7 +433,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
>  	struct sk_buff *skb = cb->skb;
>  	struct net *net = sock_net(skb->sk);
>  	const struct nlmsghdr *nlh = cb->nlh;
> -	union sctp_addr laddr, paddr;
> +	union sctp_addr laddr = {}, paddr = {};
>  	int dif = req->id.idiag_if;

[Severity: Medium]

The commit message says:

  The dif check in sctp_addrs_lookup_transport() already filters by
  sk_bound_dev_if, so scope_id on the lookup addresses is unnecessary.

Does this hold for SCTP the way it does for TCP and UDP?

For TCP, connect() to a link-local peer binds the socket to the scope
interface, so a dif filter on sk_bound_dev_if is enough. SCTP does not
seem to set sk_bound_dev_if from the peer's scope. The scope is kept only
in the transport address:

net/sctp/ipv6.c:sctp_v6_get_dst() {
    ...
	if (ipv6_addr_type(&daddr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL)
		fl6->flowi6_oif = daddr->v6.sin6_scope_id;
	else if (asoc)
		fl6->flowi6_oif = asoc->base.sk->sk_bound_dev_if;
    ...
}

On the dump side, idiag_if also reports something other than
sk_bound_dev_if:

net/sctp/diag.c:inet_diag_msg_sctpasoc_fill() {
    ...
	r->id.idiag_if = dst ? dst->dev->ifindex : 0;
    ...
}

For a link-local peer, this is in effect the peer's scope interface.

On the lookup side, the call chain
sctp_transport_lookup_process()->sctp_addrs_lookup_transport() passes dif
to sctp_sk_bound_dev_eq(). For an unbound socket (bound_dev_if == 0),
inet_bound_dev_eq() returns !sdif || l3mdev_accept. That is true by
default, so any dif passes.

With sin6_scope_id now always 0, __sctp_v6_cmp_addr() matches link-local
transports on every interface. sctp_hash_transport() treats two different
non-zero scope_ids as distinct. So an unbound socket can hold associations
to fe80::X%ethA and fe80::X%ethB on the same port at the same time.

Suppose a dump_one request echoes back a dumped tuple (addresses, ports
and the reported idiag_if). Can it pick the wrong association in that
case? sctp_addrs_lookup_transport() returns the first matching rhlist
entry:

- With INET_DIAG_NOCOOKIE, that entry could be a different association,
  possibly on another socket.
- With a cookie set, the lookup could return -ESTALE even though the
  requested association exists.

The same ambiguity existed before whenever the stack garbage happened to
be 0. This patch makes the wildcard the intended behaviour.

Would it make sense to keep the zero-init and, for link-local addresses,
also set sin6_scope_id from req->id.idiag_if? The commit message could
then be updated to match.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/7cc69548f249ff63527a663c22d9dc918d3c3e84.1795621751.git.lucien.xin%40gmail.com
