Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709851;
	b=a3oPk/T7VB/UwnGs2d47e6n2s/AkjcSj1jSUztDuW0yptfZ+0MtHxzEV3DtmqTGsdqQi
	 yw8Saa4giti9t4eaEvMT00C5HA0j3NziKEXL+a/KxeCaeRbTMvXNtFjqR9q1y7QuppE/q
	 RSGTEVh7SsV/JojpmXzgDOdmm223iNy6zv3vJUSYYPIiiGg9vQZNoGM+Uzz/NDpq0pSas
	 KaPxCik7DKyCKUBPgmBm3STmER8u3UBWwH9AibtWBGVbWVMsBDBhmMXjRSDlaih1IWPcK
	 do5RvzS+i0QxaxfJkfDXUxyEvcJq1rjgeYSsn2HEQpZANgySHfRQ8y7MQS3eTZThm3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709851;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=+a4HiDUMGDKLB8Staz0X/kEQRbxg1uoNm3FaDKu7aWQ=;
	b=Kq1XYcjnynn8KZHTdmcMu+gvzYJ41Ay3IxMkGbV60K6PCOF6U/OjF1cw3aDc0evcjH0B
	 g7RfrC2yyF/who/0ezKDhMbhvCoz2Ot6W3uQxx10ULEAUrmSo1qFOBoqjHaM6BhKemc9b
	 B270ThO888HDwhNyo1PS7YuvS79KjOs5OA3W/377DVGMrnL52DodDepIeuT6JChZyP2nr
	 rHGqb3uhX9sQEgneu9ORiXbjWRtwm54t1fkd3Zg7LDMKO92/WM3YVfgXvh45qSZOh90tO
	 NUmaWI4fH/vKCLJr6K/qa4+OJPd7gmJmt+v43BUwE7d78Xfs4w1bSUKFRo7rGVr0z4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e5daNYRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D870606A31C;
	Thu, 26 Nov 2026 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e5daNYRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB481F000CA;
	Thu, 26 Nov 2026 16:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709850;
	bh=+a4HiDUMGDKLB8Staz0X/kEQRbxg1uoNm3FaDKu7aWQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=e5daNYRmWbgQGnBtZ0PYV3Wk8RW4R3gUmKthaW+nZTATFKs1TyweRrwnY5vk9g28r
	 e3jqLg5m83dDOUfwGOHI1ElwRUE8qRbMDrjJlnYiYMsaPVU7Cpcc9nAWLDrc1cVUoH
	 ltJZAKOEeOAU3dwOO/sDBitkgbT4HOEQUKu2NQkfEZNUMXVzIZIuIc7fcoTotJSz2u
	 40JzvRfQSwcH9vp/TpmKj3yjAh3WDy/8BaTB/l8WPeqtsw2YNO9XN8o2LD8is7Cr1A
	 LfQH2YcFDEDSLALXmtgJSk37yJkS27Di2lwjwF6aTLlfTgfHHr8jkcawUua2t99vIM
	 YWoGeU2Q/cz/A==
Subject: Re: [PATCH net v2] sctp: unshare GSO skb frag_list members instead of
 linearizing
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Thu, 26 Nov 2026 16:17:29 +0000
Message-ID: <179570984998.3135.13925553650605121170@kernel.org>
In-Reply-To: <739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin@gmail.com>
References: <739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] In net/sctp/input.c, sctp_gso_unshare() does not give SCTP
  exclusive ownership of the frag_list data buffers, although the commit…

--

sctp: unshare GSO skb frag_list members instead of linearizing

This patch stops linearizing SCTP GSO packets in sctp_rcv(). It adds
sctp_gso_unshare() instead, which unclones the outer skb and replaces
each shared frag_list member with a private pskb_copy(). The intent is to
give SCTP exclusive ownership of both the member headers and their data,
so that AUTH verification can rewrite the digest in place safely.

> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa51106c..f993191ee1ea1 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -82,6 +82,39 @@ static inline int sctp_rcv_checksum(struct net *net, struct sk_buff *skb)
>  	return 0;
>  }
>  
> +/* Ensure exclusive ownership of frag_list members for GSO skbs.
> + * pskb_copy() shares them by reference; unshare with private copies
> + * so AUTH verification can safely modify the digest in place.
> + */
> +static int sctp_gso_unshare(struct sk_buff *skb)
> +{
> +	struct sk_buff **pp, *p;
> +
> +	if (skb_unclone(skb, GFP_ATOMIC))
> +		return -ENOMEM;
> +
> +	if (!skb_has_frag_list(skb))
> +		return 0;
> +
> +	pp = &skb_shinfo(skb)->frag_list;
> +	skb_walk_frags(skb, p) {
> +		if (skb_shared(p)) {

[Severity: High]

Does this check catch members whose data buffer is shared while their
users count is 1?

skb_shared() only tests refcount_read(&p->users) != 1. A frag_list member
can have users == 1 and still have skb_cloned(p) true (dataref > 1). The
skb_unclone() on the outer skb doesn't help here, because by this point
the outer head is already private.

Core skb code produces this state. ___pskb_trim() forks shared members
like this:

net/core/skbuff.c:___pskb_trim() {
    ...
		if (skb_shared(frag)) {
			struct sk_buff *nfrag;

			nfrag = skb_clone(frag, GFP_ATOMIC);
			...
			consume_skb(frag);
    ...
}

__pskb_pull_tail() forks shared members with skb_clone() in the same way.
In both cases, the member left behind in the other skb has users == 1 and
shares its data with the clone.

One path that appears to reach this is an SCTP GSO skb looped over lo,
with a non-mmap AF_PACKET socket attached whose BPF filter returns a
snaplen:

packet_rcv()
  pskb_trim(skb, snaplen)
    ___pskb_trim()
      pskb_expand_head()   /* skb_clone_fraglist(), members users == 2 */
      skb_clone(frag) + consume_skb(frag)   /* SCTP side users == 1 */

The original skb then reaches sctp_rcv()->sctp_gso_unshare(). There,
skb_unclone() does nothing and skb_shared(p) is false for every forked
member, so nothing gets copied.

skb_condense() only undoes the sharing when the trimmed data_len fits in
the head's tailroom. Any snaplen larger than that keeps the sharing.

Later, sctp_inq_pop() passes the member to sctp_sf_authenticate(), which
does:

	memset(digest, 0, sig_len);

	if (sctp_auth_calculate_hmac(asoc, chunk->skb,
				     (struct sctp_auth_chunk *)chunk->chunk_hdr,
				     sh_key, GFP_ATOMIC)) {

Wouldn't this zero the digest and then overwrite it inside a buffer that
the nfrag clones queued on the packet socket still share? The AF_PACKET
reader would then copy out modified data.

That appears to be the case the commit message says pskb_copy() prevents:

    with skb_clone() the data buffer stays shared, which could let a
    crafted packet pass AUTH on a second copy or corrupt data visible
    to AF_PACKET readers.

A similar fork could happen through __pskb_pull_tail() on one of two
copies that both reach SCTP, for example a TEE duplicate plus a rule that
pulls past the head. Two SCTP receivers could then write the same digest
bytes at the same time. That variant is more speculative.

Would checking skb_shared(p) || skb_cloned(p) here, or calling
skb_unclone(p) when users == 1, give the exclusive data ownership that
the comment above sctp_gso_unshare() describes?

> +			struct sk_buff *copy;
> +
> +			copy = pskb_copy(p, GFP_ATOMIC);

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/739a5caed11c49ce53078747c43ea8cec5076d50.1795619846.git.lucien.xin%40gmail.com
