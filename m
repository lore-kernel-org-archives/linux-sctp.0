Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795481409;
	b=xgVvq5h8qzq0topBcgd/UGVycSEDw7Im5Kf/MKl2j38t1e6EVEqO7pibSjMeFUwy1wCc
	 96ajZZ9PMbxe8N1DF0kX+D8OcWMfZRo3bhgJ4lWpEdhUgKzmwwxDVcua71hFgXNBTcoBZ
	 epw431/0ddDyq7pCxAMm1gJYF78q41cyMIc0UgV2zfax+UmZuOvnrB9bDo1mVnTi1G06E
	 goV+xM+n9mAU89oh1SdxXBY/C7VafTwYDO/DQHvoxn96vthl5fL924PlWKzyXhqWUrPZR
	 53bYzGTdSeSyCXIa8V/3k6UC14CeIcd+ByOou9WwhLw+6Vnbi/28/hXtjrAiaD/Gu0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795481409;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=4KWptGHQxTDlm9noJyMVFUeMMm2hkEYym8kr8eGf88M=;
	b=p3aNBdICKLIJ5+NyExuud15IMIfq3kQQTD3N9W2rnqyZXdxuWC+IUiS+2e5r8mM9Ws/d
	 mwujFOeCTJsYLlZIms0CgD3yPxaj56EFYL6wUX754rr0Dpd70CxcakonZ4Ln6AQBpmTuu
	 GLkETyCoOphY/e/VleuD4aES7PWWh5i0jepbfKOdnHwUqrbWnXSz/8cZ3531BVDzcecgf
	 Mj97COtxVffpWk+phTM6e9qcywmyx67IY5Wob2/1uqXUdyFXV5RrM1vG0QyF38jsdpKka
	 fSMhwIdaMELNs44q9ZB47tuR6KtEi5UOeDGUS80JDyaQFZTnxHy61xIlhwpYePhfd0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COxMOhzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE9606A321;
	Tue, 24 Nov 2026 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COxMOhzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50161F000D3;
	Tue, 24 Nov 2026 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795481409;
	bh=4KWptGHQxTDlm9noJyMVFUeMMm2hkEYym8kr8eGf88M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=COxMOhzyGkPH+01W1GFSnTYC5P8RTUBqvgnjy4jQtz8jESqX+YJTss5eujf0QEpnJ
	 aQM9h/mCZWkNz+767U7U7gs6k9H/Ck5bypvhk9JsjkN8zY3uFAMiPCB84ZfePN1hEs
	 dB07A6wWVZCBrjBdX15lR2+Ikq3ev4FYpShNkVv/9gun4HzP5ybIdGm3aFwhL4df9K
	 i3ETe4gCLW1okQdL9dnpkxZPrMmeVHlKvVGB7f6wKN0X8tD58JJCSTzxqFVlErVg/7
	 e1Ff5nuuN2cwNOnjXr4rMPZHziD0n6MXpDeLg8XVd3s5fF9NLNPltSH8uPvUmi70kF
	 QZyJl/RisU8oA==
Subject: Re: [PATCH net-next] sctp: diag: set sin6_scope_id for IPv6
 link-local lookup addresses
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Tue, 24 Nov 2026 00:50:08 +0000
Message-ID: <179548140847.3135.8828188577061386396@kernel.org>
In-Reply-To: <409da01d058fee776791de001ffd222069f06090.1795394936.git.lucien.xin@gmail.com>
References: <409da01d058fee776791de001ffd222069f06090.1795394936.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] sctp_diag_dump_one() (net/sctp/diag.c:458 and 464) uses the
  single req->id.idiag_if as the scope id for both laddr and paddr.
- [Low] The patch fixes a long-standing bug but has no Fixes: tag and no
  Reported-by: tag.

--

sctp: diag: set sin6_scope_id for IPv6 link-local lookup addresses

This patch sets sin6_scope_id from req->id.idiag_if on the IPv6 laddr
and paddr lookup addresses built in sctp_diag_dump_one(). The goal is to
let exact SOCK_DIAG_BY_FAMILY queries match IPv6 link-local associations
when the caller supplies the correct interface index.

> As gomaja noticed, sctp_diag_dump_one() builds IPv6 lookup addresses on the
> stack but never sets sin6_scope_id.

[Severity: Low]
Should this patch have Fixes: and Reported-by: tags?

The laddr and paddr union in sctp_diag_dump_one() has been declared
without an initializer since commit 8f840e47f190 ("sctp: add the
sctp_diag.c file"). So on the IPv6 path, sin6_scope_id has been
uninitialized stack data since that commit.

For link-local peers, the scope of the transport's ipaddr is non-zero.
Both sctp_v6_from_skb() and sctp_v6_from_addr_param() set it from the
iif. This means __sctp_v6_cmp_addr() reads the uninitialized value
through two paths:

  sctp_hash_cmp()->sctp_cmp_addr_exact()
  sctp_bind_addr_match()->sctp_inet6_cmp_addr()

As a result, whether an exact query matches has depended on leftover
stack contents, and KMSAN could flag the read.

Would it make sense to add a Fixes: 8f840e47f190 tag, so stable tooling
picks this up, and a Reported-by: tag for gomaja?

> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index c2a0de2adf6fd..dc199e3e96b1c 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -455,11 +455,13 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
>  		memcpy(&laddr.v6.sin6_addr, req->id.idiag_src,
>  		       sizeof(laddr.v6.sin6_addr));
>  		laddr.v6.sin6_family = AF_INET6;
> +		laddr.v6.sin6_scope_id = req->id.idiag_if;

[Severity: Medium]
Can using idiag_if as the scope for laddr make an exact query fail, even
when the sockid is copied straight from the kernel's own dump?

On the dump side, inet_diag_msg_sctpasoc_fill() takes idiag_src and
idiag_if from different places:

net/sctp/diag.c:inet_diag_msg_sctpasoc_fill() {
    ...
	laddr = list_entry(asoc->base.bind_addr.address_list.next,
			   struct sctp_sockaddr_entry, list)->a;
	paddr = asoc->peer.primary_path->ipaddr;
	dst = asoc->peer.primary_path->dst;
    ...
	r->id.idiag_if = dst ? dst->dev->ifindex : 0;
    ...
}

So idiag_src comes from the first bind entry, which has its own
sin6_scope_id. idiag_if comes from the primary path's dst device.

Here is an example. A multi-homed socket calls bindx() with fe80::a%eth0
and then fe80::b%eth1, and its peer is fe80::p%eth1.
sctp_inet6_bind_verify() allows these binds without setting
sk_bound_dev_if.

sctp_add_bind_addr() uses list_add_tail_rcu(), and sctp_bind_addr_copy()
keeps that order. The dump therefore reports idiag_src=fe80::a,
idiag_dst=fe80::p and idiag_if=eth1.

When that sockid is sent back, laddr.sin6_scope_id is set to eth1. The
lookup then goes through:

sctp_transport_lookup_process()
  sctp_addrs_lookup_transport()
    sctp_bind_addr_match()
      sctp_inet6_cmp_addr()
        __sctp_v6_cmp_addr()

__sctp_v6_cmp_addr() rejects the fe80::a entry because both scopes are
non-zero and differ:

	if ((ipv6_addr_type(&addr1->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
	    addr1->v6.sin6_scope_id && addr2->v6.sin6_scope_id &&
	    addr1->v6.sin6_scope_id != addr2->v6.sin6_scope_id)
		return 0;

The other bind entry has a different address, so the query returns
-ENOENT.

In this case no non-zero idiag_if works for both laddr and paddr. Only
idiag_if == 0 works, and only for sockets not bound to a device.
Wildcard-bound sockets on hosts with several NICs might hit the same
problem, depending on the order of local_addr_list.

The transport hash lookup is keyed on paddr, and dif already filters on
the bound device. Would it be better to set only the scope id on paddr,
or to leave the laddr scope at 0 so it acts as a wildcard?

>  
>  		paddr.v6.sin6_port = req->id.idiag_dport;
>  		memcpy(&paddr.v6.sin6_addr, req->id.idiag_dst,
>  		       sizeof(paddr.v6.sin6_addr));
>  		paddr.v6.sin6_family = AF_INET6;
> +		paddr.v6.sin6_scope_id = req->id.idiag_if;
>  	}

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/409da01d058fee776791de001ffd222069f06090.1795394936.git.lucien.xin%40gmail.com
