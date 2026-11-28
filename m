Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795878706;
	b=QHOvxiMdOtHVIyegYIuL08w2Z5sMd1bNZ/ZUx3vgIVHOJS5PwpZwXimVtZQtFCWd6uz0
	 q5nSIFSXfuIeY9W7eP/dQaaCgM07MuVqbGvSgiBh6yXqnoEFLztgXHbYPjOHSKXfTZEoF
	 hhUVHAgPEDBCqQ+pBqyDVl0amGmj90kaXb2im2HgiPWqcASg/BqCS81A/13u71w5PMz9U
	 cfHpuMyH30e2KxRERa+Aw8tDhcIpZHVmkbh3RRnsExTNqXfxS1Fg2gn6B3uRO5Qwv9Blk
	 12GwCEOtIlf+whJCqXADo+//lzVSP0T0EeGk1kzeKjIFFIlf49PT5bZFo2eGgtCh1QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878706;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=jdFsW/qXzv+GJ2/Ep5efHFXrEwL/b7oLclwqiMHNgUE=;
	b=hausTP458R0LceSnvZfqqG8T9AO/ibrUY3tCTvFXwFDcUN9Ws1zFmhZ94NgQRYRYQYOG
	 GKrIFlIhemudFSMzbQX6pBSkXD27YtR+16O/Fsg1dvtLlwoBMDc7SVWvyhKdFjSc/wwAl
	 u3epXdBq7RHEIHp68Cb68SFroEKuk9KwJ8UFgciKNFpZhFpXEZobvUNKhv6+GpQBpYF8s
	 wQipn8M1FM/Hy6BbjqvOgsqhGHvcml3QBuDQoMEfLuGSBRJEo3kqUDpYii4hy8F9zpcb5
	 7UL0o0E/Ti5udW+Dk3AhGioxsYIhfnP9R5BpweREMvAjUmu6TYdgSvEI0g9SgZaUkoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjRYNSil;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397DB606A31F;
	Sat, 28 Nov 2026 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjRYNSil
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBD21F000C1;
	Sat, 28 Nov 2026 15:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795878706;
	bh=jdFsW/qXzv+GJ2/Ep5efHFXrEwL/b7oLclwqiMHNgUE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CjRYNSilsgQJdjJOFgPnFrzhgpVB9x0BZqkc8E7m1Vq1vVwyZxZ5coq+Q0t6iP2cl
	 y6jjUXQwXj/Cu5Pw9oB5pXvyiEPd0Y5+p3HWtHDLkA6GbyRpWLmhdThp7PIz2I4N2Z
	 JQBU5zgyamdWYRUG+lcGcMtCabyljHj2jBjdcuZ2WNo+1BMwYqPeE2M6B2FYPYFmQG
	 zLK5X0csk8HZ7/yqNOjnJ/9vtQ3n6Ka9FFfEbg9Y8ANOlAilrwA66LD5DV4H4MAWMv
	 xHsI64mdULygAiC+PfVQYVbQsBTb3s+dsqxp+zbxGxv54+lXy5+vhuGA8JQ6wLG0LC
	 iIi3ybyFmVvjA==
Subject: Re: [PATCH net v3] sctp: unshare GSO skb frag_list members instead of
 linearizing
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 marcelo.leitner@gmail.com
Date: Sat, 28 Nov 2026 15:11:45 +0000
Message-ID: <179587870513.3135.6948385293009459924@kernel.org>
In-Reply-To: <112afb6053d880d08bc768ecc72853357240ce29.1795789564.git.lucien.xin@gmail.com>
References: <112afb6053d880d08bc768ecc72853357240ce29.1795789564.git.lucien.xin@gmail.com>
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

Critical: 0 · High: 0 · Medium: 2 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The patch makes data buffers exclusive only for GSO skbs, but
  the commit message's reason for doing so applies just as much to non-…
- [Medium] sctp: short GSO frag_list segment read in sctp_inq_pop() after
  unshare

--

sctp: unshare GSO skb frag_list members instead of linearizing

The patch stops linearizing SCTP GSO packets in sctp_rcv(). It adds
sctp_gso_unshare(), which unclones the outer skb and takes exclusive
ownership of each frag_list member, using pskb_copy() for shared members
and skb_unclone() for the others. The stated goal is to keep data
exclusive, so that sctp_sf_authenticate() can rewrite the HMAC digest in
place without corrupting other readers.

> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa51106c..89599fe4c2f1a 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c

[ ... ]

> @@ -117,8 +153,14 @@ int sctp_rcv(struct sk_buff *skb)
>  	 * it's better to just linearize it otherwise crc computing
>  	 * takes longer.
>  	 */
> -	if (((!is_gso || skb_cloned(skb)) && skb_linearize(skb)) ||
> -	    !pskb_may_pull(skb, sizeof(struct sctphdr)))
> +	if (!is_gso) {
> +		if (skb_linearize(skb))
> +			goto discard_it;
> +	} else if (sctp_gso_unshare(skb)) {
> +		goto discard_it;
> +	}

[Severity: Medium]
Can a trimmed trailing frag_list member end up being parsed as a
chunk header with fewer than four valid bytes behind it?

Both length checks in sctp_rcv() look only at the aggregate skb->len.
One runs before the linearize/unshare step and the other after
sk_filter(). Suppose ___pskb_trim() cuts a multi-segment GSO skb so
that the last frag_list member keeps only 1 to 3 bytes. The total
length still passes both checks, but that member cannot hold a struct
sctp_chunkhdr.

Before this patch, a cloned GSO skb in that state was linearized.
sctp_inq_pop() only treats the remaining bytes as another chunk when
chunk->chunk_end + sizeof(*ch) <= skb_tail_pointer(chunk->skb), so the
short tail was ignored.

Now the frag_list is kept. If the member was trimmed before
sctp_gso_unshare() runs, pskb_copy() and skb_unclone() (through
pskb_expand_head()) both allocate a new head and copy only up to the
tail, which is p->len bytes. The bytes after that, up to
sizeof(struct sctp_chunkhdr), are uninitialized.

sctp_inq_pop() then moves on to that member with
chunk->skb = chunk->skb->next and jumps to new_skb, which does:

	ch = (struct sctp_chunkhdr *)chunk->skb->data;
	...
	chunk->chunk_end = ((__u8 *)ch) + SCTP_PAD4(ntohs(ch->length));
	skb_pull(chunk->skb, sizeof(*ch));

Nothing checks chunk->skb->len against sizeof(*ch) first, so a few
things follow:

- ch->length is read from the uninitialized part of the new buffer,
  which KMSAN would report.

- skb_pull() returns NULL without advancing data.

- If the chunk is then rejected for its length,
  sctp_make_abort_violation() copies chunk->chunk_hdr->length into the
  ABORT it sends. Two bytes of uninitialized heap go out on the wire,
  and the association is torn down.

Trimming a shared or cloned GSO skb before sctp_rcv() needs
CAP_NET_ADMIN in some namespace, for example tc, netfilter, or TEE
combined with AF_PACKET.

A socket filter attached with SO_ATTACH_FILTER can produce the same
short member from sk_filter(). That happens after sctp_gso_unshare(),
so the bytes past the tail are stale rather than uninitialized. The
header read past the member's len is still there in that case.

Should sctp_gso_unshare() drop a GSO skb whose frag_list members are
shorter than sizeof(struct sctp_chunkhdr)? Or should sctp_inq_pop()
check chunk->skb->len at new_skb and discard that segment? The second
option would also cover a trim done by sk_filter() after the unshare.

[Severity: Medium]
Can the non-GSO path still write into a shared data buffer? The commit
message gives this reason for the change:

  "Data exclusivity matters because sctp_sf_authenticate() zeroes the
  digest and writes the computed HMAC in place; shared data would corrupt
  AF_PACKET readers or let a crafted packet pass AUTH on a second copy."

On the !is_gso branch, only skb_linearize() runs. It returns 0 right away
when !skb_is_nonlinear(skb). A cloned linear skb (dataref > 1) therefore
reaches the AUTH handling still sharing its data with the other clone.

Later, in sctp_sf_authenticate() in net/sctp/sm_statefuns.c:

	memset(digest, 0, sig_len);

	if (sctp_auth_calculate_hmac(asoc, chunk->skb,
				     (struct sctp_auth_chunk *)chunk->chunk_hdr,
				     sh_key, GFP_ATOMIC)) {

sctp_auth_calculate_hmac() in net/sctp/auth.c then writes the computed
HMAC to digest = (u8 *)(&auth->auth_hdr + 1). Both writes go into the
shared data area.

This state looks common on ingress. With an AF_PACKET tap active:

__netif_receive_skb_core()->deliver_skb()  (refcount_inc(&skb->users))
packet_rcv()  (skb_shared(skb), so it queues skb_clone(skb))
ip_rcv()->...->sctp_rcv()  (original arrives with cloned=1)

A tc mirred mirror produces the same state through skb_clone().

In that case, the AF_PACKET reader would see the digest field zeroed or
replaced by the HMAC the receiver computed. If two clones of a forged
packet reach the same association, the first fails AUTH but leaves a valid
HMAC in the shared data, and the second one could pass.

The non-GSO behaviour existed before this patch. Since the commit message
gives this exact hazard as its reason, should the non-GSO branch also call
skb_unclone(), or something equivalent, before AUTH can write in place?

> +
> +	if (!pskb_may_pull(skb, sizeof(struct sctphdr)))
>  		goto discard_it;
>  
>  	/* Pull up the IP header. */

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/112afb6053d880d08bc768ecc72853357240ce29.1795789564.git.lucien.xin%40gmail.com
