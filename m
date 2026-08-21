Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8A30CD95
	for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787326104; cv=pass; b=Ul4lftuIZbUYcDgo7YitE67flyHtxb+Mz6qIDmdA/HMtUJSOolNqE3jEhs0gqJIYYaee06K+hLzag4THjEGjJUA9QuDi1YNVvpCTXxrT+gIz5x0l1EznNL31Udjv20bPkvus3C88HP5m9Ym8fpeljqQIwNnUzbIu85QcYUlbiUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787326104; c=relaxed/simple;
	bh=aO2N8q0Q35fQWhEOu/usLOdYao6zCWFoNMCa62VLzWM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q29/jNddQ3QHXex/ZIZVycNxaHnItkOseWlOq9bcv9FU8N8EmwUl/o/n41Ttmmxv4+/oLBXXfchexisleC8XY30xPoZ6TH3KnthFyIJ1EoaZAW879FyPx4OZF7IucJm1C9RHAbF9TzFYBAfcMO9b2OZYFCQxhmxIT5aI3okDHzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n246E7PT; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n246E7PT"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-851cbd64814so253213b3a.1
        for <linux-sctp@vger.kernel.org>; Fri, 21 Aug 2026 08:28:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787326101; cv=none;
        d=google.com; s=arc-20260327;
        b=jnuteXGktzOCD8gh9EdPMwrvXdgYVGUbkCWOdM/FKjOHyAoTC2uTa8BoXoRFWEQOTw
         85MSJTEuW2vqGo8J0/c8jSAc8SPtuixtgQI2AC4k8CBpD6jazdvn7mAxwCC3UtqbKvD/
         SXTq+OlIr/xc5OsTrUAhNqFu0CN93d3+jBr55M36fZrMQ2p7fsHKUqfgR8vqRxNfjeGC
         RMzQtUWYDNEMrf1G0pbb70irRmhUHDxvtBR2bWOf7iz8vPQesN8QmIgyRqdRFwYy1LLN
         EMnIgaPLBSByBm7m7seJNGLF1deHZH4SmrP6EWX8oqmWa/0Di10Mvz/BT1UM8ZXJquDk
         MUrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k7uiZrvZnYmQNQRmUHNAo1Fr+zNWc8uQD+Fv871H7h8=;
        fh=ygs0nQQxWjdpoR1zUoIIIozQ1CrjG9qUniZKK2wozOQ=;
        b=CKWdKTvcLU/d5FGR9snbrvFwjEl25kJjUuJjYspH8AXn2Zo04ELoZ0+IZggy1dZmwn
         rET0V5XMB/v7xNCXs7ur2A3s4zIDRTCFGDcvI48jzj8ntWqeAsmuVTv+4bCpwyz4x10P
         oSp+DuBb24jbGbYB4AhTHwdxsw0MWdEwk3MYx0wd5+FKFY2nM2JufQM2w58nQI8aXr5k
         XdjFH4a3/l24B8fmk6pSYCw4Vnxbe71lFMe5KVHdd7dZpiQLXfk8mLbZluefGWJ1k21b
         7zEeEZNFz3Gn/slTs3+701bJkzNYjWfO78Jzxw5n5bJHTtri0JRAPo+KVUpXHZBdmsJ0
         PXCQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787326101; x=1787930901; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k7uiZrvZnYmQNQRmUHNAo1Fr+zNWc8uQD+Fv871H7h8=;
        b=n246E7PTM5z2mMKK6PWxcv1aqnC91L+ktcu3zcWAloiqX/7wRbhdE3+N8IFlgS+SpJ
         oYDPHBkpEULmZuuRV9bwmEUzaX26OEbgNdbdQYQRMqg0JL6obmAehhITRsSBXDKPX2F7
         2ads44Hpe5KQPbLPscp1fX9GANVU21E1of8oLr3R9j1ztbpEPNm9qYmyJCYYXwaMJVbX
         J0OewI34eb9hPOp17xaJZJUjmG3QD3bwElc0UZfooZh8DMEMm9YLhkHDaOgqfmPdzFpq
         VY/9IYFicLAl+sRUgbfLwzz8EBMhZ40imLwvorTiGppIz3t+dbhzbkD041VFA+WbkS1G
         ZyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787326101; x=1787930901;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7uiZrvZnYmQNQRmUHNAo1Fr+zNWc8uQD+Fv871H7h8=;
        b=Y8nJk8F9JpePr4z/h9v4aziBFnGqcP4nTOL+ph3bFxxUQ6i9Rt0xkUizmw4EN+2G1a
         MRIl6TIvgjyjjRDVe1WuUIkCqidxOBujCQZcygiciJX43D4RpfWNUvQaqUPHX7+ckas3
         oislOYT3l6OWlLaDpChMPJ7weKBL89118F7HSmUIQS3JiuEdCS7fKTwktNe6sINjN/a2
         cUQLAiWq/3UTkqF2WgbTws67sbSf9KyuanG1SqZqOlGN16/+m9/dv9YZXV1V1Q69Fdwx
         TlMMDxCeVqgxFkSzdcTddW9StFzupD+nYyW8OWPgMpux4BpU56I40C1/YXqyLP7+cbfI
         JHXA==
X-Forwarded-Encrypted: i=1; AHgh+RqgxT6jZTpK1Umo6qL4ER8YT9I+cjNzOc0/K6CMn1zkXfHOe9kVBXyToV8/H+1V39XSwIZIZmcCbJJa@vger.kernel.org
X-Gm-Message-State: AFuF++k3RRAHuS89ZfYAwFwy6DMSpF6k1KAcnseuW4siiEGoRMqqECdi
	wvQIgztiDbBRjQxksF4TLQNOvIy0Aui1vesUXCVEWG1rGWCSLrH5ENtEEXwRpT4dHUUC+1z2rbp
	Lr+MaOXxARSYpww30RIT2tRcJaRraKeo=
X-Gm-Gg: AR+sD10Z5qTQQ4xDl18BxxGP/o2DNGj7gwssudY5ZUUmyOmUM7vQVwH4/LAhVk0MHT+
	ADdYVj1poYxSZzUxS6QbI+0hxRR8FOI7NpPtx+WXKVFCx3kyw4AfiOMHYdOgmg86j7cYRalMM2x
	BTo50LS8etFbC15W6ZunhXwKT2r/yqllsJyin4ujmAfB/6xWFE1XYTsl+OWUNCKTaGvjXO61o7l
	Z6nHBLKIWuBnA1QEt65sZqqh11aet0I2+xTYLI3OiMPwyCX+gIgXuch/lydIMi7goiINLxUsc7k
	Ogkmtu4nsuh4f5TeP1pML5p1gwVkXIuDQNpsLSEMWfOxL9IHUe3U08qq7E5yS68/tM91G/jzkfl
	vxFDtbFu64BSvJ1eWFHUYHgwpo2CfV3Vfvjd3ZHLamZQF+jEVM6m8WmDJUWTxvwdAEXAYWOAweE
	ip
X-Received: by 2002:a05:6a00:2e19:b0:84c:4b58:2cec with SMTP id
 d2e1a72fcca58-851fa071eccmr11065029b3a.15.1787326100663; Fri, 21 Aug 2026
 08:28:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260820162235.2668698-2-bestswngs@gmail.com>
In-Reply-To: <20260820162235.2668698-2-bestswngs@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Aug 2026 11:28:08 -0400
X-Gm-Features: AcwNN1UHjVHC0nrat9gCj5-HdAaF9SV-qu5rB8IwX-X2vzEVe-Gsi4pJ6NsHqH4
Message-ID: <CADvbK_cC8A3vjV0mweyBX_RyHFk_-ruyQ-Wp6UDmWpeAvNMvTQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix NULL deref on untransmitted RECONF completion
To: bestswngs@gmail.com
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, horms@kernel.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, xmei5@asu.edu, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 12:23=E2=80=AFPM <bestswngs@gmail.com> wrote:
>
> From: Weiming Shi <bestswngs@gmail.com>
>
> sctp_process_strreset_outreq(), sctp_process_strreset_addstrm_out() and
> sctp_process_strreset_resp() finish a pending stream reconfiguration
> request by stopping the reconf timer on the transport the request was
> sent on:
>
>         t =3D asoc->strreset_chunk->transport;
>         if (timer_delete(&t->reconf_timer))
>                 sctp_transport_put(t);
>
> On the transmit path chunk->transport is assigned by
> __sctp_packet_append_chunk(), that is, when the chunk is actually
> appended to an outbound packet. A RECONF chunk that was queued but never
> transmitted keeps transport =3D=3D NULL, and its reconf timer is never ar=
med
> either, since that too only happens once the chunk has been appended.
>
> sctp_outq_flush_ctrl() skips every non-ASCONF control chunk while
> asoc->src_out_of_asoc_ok is set and leaves it on control_chunk_list, so
> in that state a RECONF is never put on the wire. The sender side has
> already published the chunk in asoc->strreset_chunk and armed
> asoc->strreset_outstanding, so an incoming RECONF that drives
> strreset_outstanding down to 0 dereferences the NULL transport.
>
> sctp_send_asconf_del_ip() reaches that state without any peer
> interaction: when the address being removed is the association's last
> one it stashes the address in asoc->asconf_addr_del_pending, sets
> src_out_of_asoc_ok and skips chunk creation and transmission
> ("stored =3D 1; goto skip_mkasconf"). As only sctp_process_asconf_ack()
> clears the flag, it stays set until a later bindx() ADD picks the pending
> delete up. An unprivileged process that removes the last address of an
> ASCONF-enabled association and then asks for a stream reset panics the
> kernel from softirq:
>
>   Oops: general protection fault, probably for non-canonical address
>   0xdffffc000000003d: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x00000000000001e8-0x00000000000001ef]
>   RIP: 0010:timer_delete+0x67/0x110
>   Call Trace:
>    <IRQ>
>    sctp_process_strreset_addstrm_out (net/sctp/stream.c:832)
>    sctp_sf_do_reconf (net/sctp/sm_statefuns.c:4212)
>    sctp_do_sm (net/sctp/sm_sideeffect.c:1172)
>    sctp_assoc_bh_rcv (net/sctp/associola.c:1044)
>    sctp_rcv (net/sctp/input.c:243)
>    ip_protocol_deliver_rcu (net/ipv4/ip_input.c:207)
>    ip_local_deliver (net/ipv4/ip_input.c:262)
>    ip_rcv (net/ipv4/ip_input.c:612)
>    process_backlog (net/core/dev.c:6680)
>    net_rx_action (net/core/dev.c:7959)
>    handle_softirqs (kernel/softirq.c:622)
>    </IRQ>
>   Kernel panic - not syncing: Fatal exception in interrupt
>
> Skip the timer deletion when the RECONF chunk never reached a packet:
> there is no armed reconf timer and no transport reference to drop.
>
> Fixes: 810544764536 ("sctp: implement receiver-side procedures for the Ou=
tgoing SSN Reset Request Parameter")
> Cc: stable@vger.kernel.org
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
> Note to reviewers: this only stops the crash, and I want to be upfront th=
at it
> does not remove the state that produces it.
>
> That state has exactly one producer. sctp_send_asconf_del_ip() latches
> src_out_of_asoc_ok on the branch that stashes the association's last addr=
ess
> without building or sending an ASCONF, and sctp_process_asconf_ack() is t=
he
> only place that clears it -- so the flag survives until the application i=
ssues
> the follow-up bindx() ADD that sctp_make_asconf_update_ip()'s del_pickup =
needs.
> 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host") desc=
ribes
> this as a transient state ("the other chunks cannot be transmitted in thi=
s
> state"), but nothing bounds how long it lasts: an application that never =
adds a
> replacement address leaves the association unable to send any DATA or
> non-ASCONF control chunk for the rest of its life, with the RECONF sittin=
g on
> control_chunk_list and strreset_outstanding armed.
>
> I kept this patch to the dereference because it is what the rest of net/s=
ctp
> already does -- every other chunk->transport dereference is NULL-checked =
-- and
> because it backports cleanly. But would you prefer the latch itself to be
> addressed, or the reconf request to be abandoned here rather than complet=
ed
> against a chunk that never went out? Happy to follow up with either for
> net-next. net/sctp/stream.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 34ffe6c945a4..1cb30def2eb9 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -577,7 +577,7 @@ struct sctp_chunk *sctp_process_strreset_outreq(
>                         struct sctp_transport *t;
>
>                         t =3D asoc->strreset_chunk->transport;
> -                       if (timer_delete(&t->reconf_timer))
> +                       if (t && timer_delete(&t->reconf_timer))
>                                 sctp_transport_put(t);
>
>                         sctp_chunk_put(asoc->strreset_chunk);
> @@ -829,7 +829,7 @@ struct sctp_chunk *sctp_process_strreset_addstrm_out(
>                         struct sctp_transport *t;
>
>                         t =3D asoc->strreset_chunk->transport;
> -                       if (timer_delete(&t->reconf_timer))
> +                       if (t && timer_delete(&t->reconf_timer))
>                                 sctp_transport_put(t);
>
>                         sctp_chunk_put(asoc->strreset_chunk);
> @@ -1084,7 +1084,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
>         /* remove everything for this reconf request */
>         if (!asoc->strreset_outstanding) {
>                 t =3D asoc->strreset_chunk->transport;
> -               if (timer_delete(&t->reconf_timer))
> +               if (t && timer_delete(&t->reconf_timer))
>                         sctp_transport_put(t);
>
>                 sctp_chunk_put(asoc->strreset_chunk);
> --
> 2.55.0
>
If the STRRESET chunk has never been sent, we should NOT allow an incoming
chunk to =E2=80=9CACK=E2=80=9D it.

Could you try fixing this by returning NULL from
sctp_chunk_lookup_strreset_param() if the STRRESET chunk has not been
transmitted yet? like:

@@ -488,7 +488,7 @@ static struct sctp_paramhdr
*sctp_chunk_lookup_strreset_param(
        struct sctp_reconf_chunk *hdr;
        union sctp_params param;

-       if (!chunk)
+       if (!chunk || !chunk->transport)
                return NULL;

Please also share the PoC with the maintainers, if there is one.

Thanks.
