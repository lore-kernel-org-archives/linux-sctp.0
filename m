Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08D93451A9
	for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988917; cv=pass; b=igtzOy70XhWQcKs4jKdiOz/wTL9BgGdtTFvmnBhX7Ot/avlxjkcWBLrx4rMHIwsjmtc4cVe6z7ls5GLhIm1yl9iL026hANh01AP7AajhksBplD4DzS0DpK5Lt2/TfG6kyvVhehUX5ZljUi6PiTm55RpNDYk8gDNsTi+rtyLLbuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988917; c=relaxed/simple;
	bh=5aR9u4NpdQGu0xWUG9HCJ0eDn30x8Ve8YDxloXGNYwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QV5UZvMzQNt/3RRKFKYSaIzzBtxj3PDr0YVz0Eged9WJCAqsWNRGJ9Nbc+HqFFMyB7BAjpmYqw2dUhLOYFLJKcPuQTwSl+BWwfgidcz6d0jd40toN9HfTPwx7wPVd86FhKjAaTxluNhCt5IztC2xAHjPGmG4Pni5/aa6fy1WB8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kWarzMed; arc=pass smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kWarzMed"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84867f07d63so3853502b3a.2
        for <linux-sctp@vger.kernel.org>; Mon, 17 Aug 2026 10:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786988915; cv=none;
        d=google.com; s=arc-20260327;
        b=bYExGtB+jTnSbynAo1m5j81hBBBZ33aZy70gZF3I0dV2oJuNlKGEfs4mi3MmYhs782
         xIBOLj+zF5GZ6MWTRxb0hAaEWcszpz/Y/URxs7hJoFtPs+YCYARje4hAANauWwNGzhcP
         eOWjlvOr+AZLMDVLnTQweuY7F5aKzSYIOLpOOawHBUPWH9WtfYc3WozcreXp1/cFwaAs
         eIYf25Q16VTTB67JtzwW63LPhofINvrYEmIzXpL62bi2+a1pFBSsipCPpXZd9UG8JvMm
         8LoLGtaSWHR6MEuAPUsmzDRzZYK73Xez7W2KBOgDm9S0wTIOfD05J87u6U6q7cqOMRTU
         5oLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G6J/QMjg2Wi1vnOtRdg6KjrduusjUApAU5kKJjsUEhU=;
        fh=JW/z3eheym5udYl8RZbzT7aoyvxZQRN/IXqviPEiM4o=;
        b=OoIzjsQqQ6JDKOWruqZg3qPxNnHAt7utMv5AUMDP7/vlHTq6RqO3lGPnyPjJCEABDd
         VX0mRSF4XUrCAHNgV+qsrgA0fTOUSha3SzuRfXe7KCrkH1ez9IGJLvJWEZ57pv8wskXf
         /PYZt217maDKC8Pg0a4Iy/lnXlRL4SZuBaiGJCvB7qQQbKvJ3uuk8XlhAzn2JMhJzBlR
         m/Pv4HF1H7MY/lAvUR9Smk/BQDaV873khPDmh02qrF1kWncPG8IvwgGTX/B/apuxPvj8
         vZEGTKsTrM7pY65OsVrUAojSTMnUak9hPJT0GC9lYSuWNMG6yvsva2xK//VP5XiSkJsK
         plyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786988915; x=1787593715; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G6J/QMjg2Wi1vnOtRdg6KjrduusjUApAU5kKJjsUEhU=;
        b=kWarzMedLIVn8vsx9jTEjdMZbjoO+i0w++PqY8oA22FQBILaSP0IyrxbBQQB3fOpUF
         1yAD6c0+12P1rMGi0mINwD8DNhwaPbvSOz5+cqqBq9mOEUPhm3kQmMp9aSty9NxKlnls
         AirCoEbcR3+fSyFtTm92fQDWrwT7YrtoMx6kkiU9NZatMyHoNUJuj4iRh8dR61SDsWyM
         z2tLqkSRE7RPK3NDI6ODE3EOBGmHc7fzyjwWM6+oJFxv8kU5cdPJsfT3wnQ9bCOWz86c
         rdVdIUzil6BVuSa5Kaun+Vj3nzLBk4NyGVxHNtpPvGk8hTlpICn0cxdbK8z1u0QPvQUj
         /N1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786988915; x=1787593715;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G6J/QMjg2Wi1vnOtRdg6KjrduusjUApAU5kKJjsUEhU=;
        b=CTlCa83xJbNFBc0HjGOIXeu6E91EiVhnZoWcVDQnH9YcMPm/a2EmMm10KWDTmJe9sg
         DFo1xXbccM+If5HlvDDZfvI+/cKZiAM7sE0CU9/ZV2HR9NQLeTA+gxAYzd22M6S31zBM
         XvNjMAOhX1t+R5G652JQLLY1IhyLpD+ANb1K0AaCXm38AvS1xwpjOXhiw2pVGsKAFH1W
         oa8Gkl1/MuqXsI4c2OtbvR4fhNbIu7SdYp1gzLARPB1TtW8b7Xl+yEDT3VNTTAQbn+2h
         og5PndtpPjitF+PYwgMGteTqSQ0+fITllifILiHIwxYWmoIO7W8fTWlNG3IqmkJxBelX
         inrg==
X-Forwarded-Encrypted: i=1; AHgh+RqS4Lvg62Jz/NaqqWD+nzHVjVvuUM7wSHGDQ6uFQjra+X4gEFqOFDtbgDzPMwR6/853CxralXRybcem@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1fJP6yhnWS+98DU8R1YJuwPI0CDBl52Ka1x8NjNiNKAoonzmL
	UP4TtgWtuGC50DA4Iyo/jCxvX8Te36CF8gu5ozOrHC+ot6fj8v3LES6wyCfE3kLzvJcIgY9z8qj
	1a+sTRf/6zBVh6uSa+JNVrGJSPwbbNvA=
X-Gm-Gg: AR+sD11nVItKicgLsq2FaT7yA8i5xL7AuUSCdaq8UINTQNOKXrxM5BP+wWJ15qdBWu+
	j5/kvVEaV2uVA/xhrFVvxYI1sOX/i/Xuh5iB+cxLdeaTqqOyVxLlagDJCSoRI/XFpJOUtc/z0DW
	BaM1xItfuvlRK4vrr1WtfC75L1LtbGi1o0FGyDdR/gbW1vRj47DTXQmAGW5cAE0ZEx2GaDak87y
	yPvdLgc9als/MhdDFczONfX9ldUZ8ZIebc+OpYE5CmDB+s1GV8QA6zrUd/bF1s5reBOlRKsJWDq
	cu6LG9hYxHaPgrMDo3mskfSIHPgmnATL0/6/40FusT5OtK4GNCWT99fJaz29B/uU1msYX406CJH
	x2umA24W3tMl4a411JmV/I6XWrtUz3FVUo38ZB61fu2o=
X-Received: by 2002:a05:6a00:1902:b0:848:7552:3d86 with SMTP id
 d2e1a72fcca58-84fde1fb61bmr25030858b3a.23.1786988914867; Mon, 17 Aug 2026
 10:48:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <an-oGfEatacPTSX-@v4bel>
In-Reply-To: <an-oGfEatacPTSX-@v4bel>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 17 Aug 2026 13:48:21 -0400
X-Gm-Features: AcwNN1W1hhTcPLHyV54J5TmxN5XwZW3NxDe9Dae_EV1ntIwqxabf_64Uxcrz1YU
Message-ID: <CADvbK_e60CFEVUVo25Tkcw_p4y16o8vZCf0N=hH+bUoEqpu6Qg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: drop a backlogged chunk if its transport was removed
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 7:43=E2=80=AFPM Hyunwoo Kim <imv4bel@gmail.com> wro=
te:
>
> sctp_rcv() resolves the transport once per packet and leaves it in
> chunk->transport. If the socket is owned by userspace the packet goes to
> the socket backlog, and sctp_add_backlog() takes a reference on that
> transport.
>
> An authenticated ASCONF DEL-IP in an earlier backlogged packet can remove
> it. sctp_assoc_rm_peer() takes the transport out of the association and
> calls sctp_transport_free(), which tags it dead and drops the reference
> the association held. The backlogged packet still holds a reference, so
> the transport stays around.
>
> The DATA chunk in that packet puts the removed transport back into
> asoc->peer.last_data_from. Once the packet is done that reference goes
> away and the transport is freed by RCU, so the next delayed SACK carries
> the pointer into the SACK chunk and sctp_outq_select_transport() reads th=
e
> freed transport's state.
>
> Drop the chunk in sctp_backlog_rcv(), next to the existing rcvr->dead
> check. The peer retransmits it. Guarding the last_data_from assignment is
> not enough, sctp_assoc_rm_peer() clears more than that one pointer and
> letting the packet run fills them in again. sctp_wait_for_sndbuf() alread=
y
> uses the dead flag this way on the send side.
>
> Fixes: df132eff4638 ("sctp: clear the transport of some out_chunk_list ch=
unks in sctp_assoc_rm_peer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  net/sctp/input.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 864741fae4187e..83b8361d149251 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -285,9 +285,10 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff=
 *skb)
>
>         /* If the rcvr is dead then the association or endpoint
>          * has been deleted and we can safely drop the chunk
> -        * and refs that we are holding.
> +        * and refs that we are holding.  Same if the transport
> +        * we looked up has been removed in the meantime.
>          */
> -       if (rcvr->dead) {
> +       if (rcvr->dead || (t && t->dead)) {
>                 sctp_chunk_free(chunk);
>                 goto done;
>         }
> --
> 2.43.0
>
Can you try to move the check to sctp_inq_push() to also cover the
case Sashik reported?

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/an-oGfEatacPTSX-%40v4be=
l

Thanks.
