Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795852179;
	b=5bnsBUjeS1nFcLf2scyDRzknthNqQ0uJUqlw8qQ90NVyY4O8/N5DivOVANbUGavYqgsv
	 MMLnHKm/vM2nI4uAoxJBgkamrmioOCKX/srcBXmfMX3bBOm30sJZbxGcAHZLVlYdIXIuf
	 x91x3VlETMO2nQc12jYKLwk9IgnuWhUici8T3cqeh1DpACoS9AVxARAtUuLX1PsRBYy8+
	 wwJPKrVfKHYHOUkrahVl2N0ES76W6qI1PeyianepOeHINY0HLiuBkUyp2Xw8cMySrlgdH
	 TfaZ3VFvMiWvNTU/HYwBudVj8R+/tWfI6TpzBXQHkmuDrH8NNBn+CUeNt7RbKhxRdCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795852179;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Y2CkVKlJv9q8tIcTk64or8wHGvQhFgWI4FBCczrgvuk=;
	b=KZ5PQ3ZJKGyIp76HYIcmIZFLAC/82u7A7eksE/kn7IIor4jM//2sXJMHscvX94eZZ370
	 T5SV/Y3Bv0JIItE/eIiTOCF45hxi77L/hDl/Oq+r51grPRp0qxmeOBsK7h+bietFs7bYU
	 Vc08ZXOn90l3/+xO1KUdIzx4dO0HBKPMsDHFyqOCslSUgBct3zZygRZu9WXdrqY/oXwoW
	 DV41pUkZOr/W+FzUGFIWXmLGJmubOEVb+zySEaUTCyygIh18054816HFyTzEtE3Qw7/a+
	 CTIFNfmyknUHSrlMEfHoY85sABe3yNTdS3S9PM7LFuYzGU4yRlKe7yQUA+jlJl0CL6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I0vOHecQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298E5606A31F;
	Sat, 28 Nov 2026 07:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I0vOHecQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268751F00893;
	Sat, 28 Nov 2026 07:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795852178;
	bh=Y2CkVKlJv9q8tIcTk64or8wHGvQhFgWI4FBCczrgvuk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I0vOHecQV/wHc5kazkWzvIkJy1qsJ4shaHWLmvJKjTL7VYHJYfkc+dv5XMexB9ZFz
	 oJbZ9/F03jrJBIdwmc+KjAnT29rJ2L86YGtYNzcV4iM9zc18uKJQC3HnJdgrF7u6b2
	 YcdsiwlgIg37hLa9Z6Km7aFnEc3fb6/TXP/D/QWctoP7ip5B1I7ofT33oV40Q1clGL
	 m3UCOWuHzfdieEBcbgWrZ87z8K26ELNhT0M84XbrHljPNa2UX/LdF9ViGZa3TWERJ3
	 F6cGt8E4mFxxtgcohgxNBE7TQCB+PshRzNDkl4TSho76xf+puWoVzTLVGG1hI3AgFD
	 jzIP+vLd3l9HA==
Subject: Re: [PATCH net] sctp: don't count pending-deleted addresses as
 survivors on bindx del
From: netdev-bot+sashiko@kernel.org
To: bsdhenrymartin@gmail.com
Cc: lucien.xin@gmail.com, marcelo.leitner@gmail.com, vladislav.yasevich@hp.com,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org
Date: Sat, 28 Nov 2026 07:49:37 +0000
Message-ID: <179585217768.3135.9630756221208198819@kernel.org>
In-Reply-To: <20261127065017.2922776-1-bsdhenrymartin@gmail.com>
References: <20261127065017.2922776-1-bsdhenrymartin@gmail.com>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch only partly closes the bug class it claims to fix.
- [Medium] The patch sends a second delete into the keep-last branch of
  sctp_send_asconf_del_ip() (net/sctp/socket.c:863-896) while the first…
- [Low] Two comments no longer match the patched code: - The header
  comment of sctp_find_unmatch_addr() (net/sctp/bind_addr.c:429-431)…

--

sctp: don't count pending-deleted addresses as survivors on bindx del

This patch makes sctp_find_unmatch_addr() skip entries that are already
marked SCTP_ADDR_DEL. Two bindx deletes in a row, with unacknowledged
ASCONFs, should then no longer be able to empty the association's bind
address list. When no undeleted survivor is left, the keep-last handling
in sctp_send_asconf_del_ip() is used instead.

> diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
> index 31737f144c7f0..e20006b9f12e4 100644
> --- a/net/sctp/bind_addr.c
> +++ b/net/sctp/bind_addr.c
> @@ -445,6 +445,12 @@ union sctp_addr *sctp_find_unmatch_addr(struct sctp_bind_addr	*bp,
>  	 * can't change.
>  	 */
>  	list_for_each_entry(laddr, &bp->address_list, list) {
> +		/* An address already being deleted cannot serve as the
> +		 * one remaining address.
> +		 */
> +		if (laddr->state == SCTP_ADDR_DEL)
> +			continue;

[Severity: High]
Can the SCTP_ADDR_DEL mark be overwritten while its delete is still
queued?

The new check relies only on laddr->state. However,
sctp_asconf_param_success() sets the state back to SRC on a successful
ADD_IP ack, without checking the current state:

net/sctp/sm_make_chunk.c:sctp_asconf_param_success() {
    ...
	case SCTP_PARAM_ADD_IP:
		...
		list_for_each_entry(saddr, &bp->address_list, list) {
			if (sctp_cmp_addr_exact(&saddr->a, &addr))
				saddr->state = SCTP_ADDR_SRC;
		}
    ...
}

Take an association whose list is only A(SRC). The endpoint also holds a
third address D, which is needed to pass the endpoint-level check in
sctp_bindx_rem(). The reproducer in the commit message needs the same
thing.

  bindx ADD B
    B is SCTP_ADDR_NEW, ASCONF1 (ADD B) sent
  bindx DEL B
    sctp_find_unmatch_addr() returns A
    ASCONF2 (DEL B) queued behind ASCONF1, B marked SCTP_ADDR_DEL
  peer acks ASCONF1
    sctp_asconf_param_success() sets B back to SCTP_ADDR_SRC
    ASCONF2 sent, peer holds the ack
  bindx DEL A
    B is SRC, so the new check doesn't skip it; B returned as survivor
    keep-last branch skipped, ASCONF3 (DEL A) queued, A marked DEL
  peer acks ASCONF2 and ASCONF3
    sctp_del_bind_addr() runs for B and A, asoc list is now empty

sctp_sf_do_asconf_ack() matches acks by serial number only.

The next bindx ADD then reaches sctp_send_asconf_add_ip(). It takes the
first entry without checking whether the list is empty:

net/sctp/socket.c:sctp_send_asconf_add_ip() {
    ...
		bp = &asoc->base.bind_addr;
		p = bp->address_list.next;
		laddr = list_entry(p, struct sctp_sockaddr_entry, list);
		chunk = sctp_make_asconf_update_ip(asoc, &laddr->a, addrs,
    ...
}

Wouldn't this hit the same NULL af dereference in sctp_make_asconf(), and
the same diag leak, that the commit message describes?

Could pending deletes be tracked in a way the ADD-ack path can't reset?
For example, sctp_asconf_param_success() could skip entries that are
SCTP_ADDR_DEL. Or the survivor check could look at the queued and
outstanding DEL params.

[Severity: Medium]
Is the keep-last branch really the same as the single-address case here?

With this change, a second delete issued while the first DEL ASCONF is
still outstanding goes into the keep-last branch of
sctp_send_asconf_del_ip(), which does:

			asoc->src_out_of_asoc_ok = 1;
			stored = 1;
			goto skip_mkasconf;

sctp_process_asconf_ack() clears that flag on any error-free ack, even if
asconf_addr_del_pending is still set:

net/sctp/sm_make_chunk.c:sctp_process_asconf_ack() {
    ...
	if (no_err && asoc->src_out_of_asoc_ok) {
		asoc->src_out_of_asoc_ok = 0;
		sctp_transport_immediate_rtx(asoc->peer.primary_path);
	}
    ...
}

Take an association with [A(SRC), B(SRC)]:

  bindx DEL A
    ASCONF(DEL A) sent, A marked DEL
  bindx DEL B
    patched sctp_find_unmatch_addr() skips A, returns NULL
    keep-last: pending = B, src_out_of_asoc_ok = 1, B marked DEL
  peer acks DEL A, delayed only by normal RTT
    A removed, pending B kept (no match), src_out_of_asoc_ok cleared

That leaves the association with [B(DEL)] and src_out_of_asoc_ok == 0.

sctp_v4_get_dst() then rejects every candidate source address, and the
IPv6 version does the same:

			if (!laddr->valid || (laddr->state == SCTP_ADDR_DEL) ||
			    (laddr->state != SCTP_ADDR_SRC &&
			    !asoc->src_out_of_asoc_ok))
				continue;

sctp_packet_transmit() drops packets when tp->dst is NULL.

Keep-last relies on a later bindx ADD C to recover, by sending
ASCONF(ADD C, DEL B). That ASCONF doesn't look like it can be sent
either:

  - C is SCTP_ADDR_NEW, so it can't be a source address without
    src_out_of_asoc_ok.
  - The transport reset block in sctp_send_asconf_add_ip() runs only when
    asoc->src_out_of_asoc_ok is set, so it is skipped.

Can the association do anything other than stall until the
retransmission limits abort it?

The clear-on-any-ack logic is older than this patch. Still, the commit
message's "same as it already does for a single-address delete" relies on
it.

[Severity: Low]
This isn't a bug, but the header comment of sctp_find_unmatch_addr() still
says:

/* Find the first address in the bind address list that is not present in
 * the addrs packed array.
 */

With this change the function also skips SCTP_ADDR_DEL entries. It can
return NULL even when an unmatched address exists.

Should this comment be updated? The same applies to the "Find one address
in the association's bind address list that is not in the packed array of
addresses" comment in sctp_send_asconf_del_ip().

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261127065017.2922776-1-bsdhenrymartin%40gmail.com
