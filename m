Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793735023;
	b=WzVVioxypJbQVMNgcchxSVR5Yee1680L/bHF7OlQn2VIY1QUB3M2tRKUs244h91vBXiM
	 8Ogsu0JqEC80DawiP0aUjqNv0k20G4O/+YyOBhvE6uYrbZbkwNT94HpyJeFdNwDeIUaG8
	 b9IQG/dTJvzUyOnzku5oMSxBuayaS1ScstugsLrTk04hICgK3xw5imvr6w7ZCHfQ0Kf3A
	 +Du6m2nhhPQeTdJahiTLY05r8ZzF+BziiN9tzU7HBtb4fsvdsLe8BQoC2m3XCOj96NOTG
	 XqnWkVNIKrn/VEIry10rzA27Uiecs4AHSqYz24HzCqXxet0b+KPkC8IhM9WSYczUUUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793735023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=HXiF5Hkq0HzdjVstuqtN1MMqL7UJCviIzr82cLK6HWc=;
	b=ANH2sYwjUOkvrw5osNevUKr2l252J0+YGCvtI29R2DJ0QpV9WlH2ikZZzUzRUoDq6ieA
	 RAzrszLxpkjWNgRe0w1bq+5d5yoFiUrJ8X9I1/HIiJkesOQjb3eymGzAFLFLFdqDEDBKp
	 8ALeZwZIo5eYt9+P3uPRFUOu38J95c1K2iFZjQCTguwxi9LuJLkGKIafJMFux0Dk00sjT
	 1cNSfoHjZdYddWLM4gyXZsKenir5BeeN4DpM7EhYY7T8ExkeGcFInyyTTyNVUYUYIm2dR
	 JitZq7OHjlW99cFYTLapRVZHhmfnxj5+e+SEfsss8eKD3Kq6ewBXxrONFGQ7mwA4aNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BxKVG8Jo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7266606D806
	for <linux-sctp@vger.kernel.org>; Tue,  3 Nov 2026 19:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7266606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BxKVG8Jo
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc147d86bebso779864a12.0
        for <linux-sctp@vger.kernel.org>; Tue, 03 Nov 2026 11:43:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793735022; cv=none;
        d=google.com; s=arc-20260327;
        b=BeqiH8FdwgYe8b/8nnD308LXktcPNPXA+7jl+OGacqM+jKWM9NbhCkYtadjQDBRhMA
         opfDUWTaNVaa8HEH8gdwncRBpnuBWypWWVhNABu1X0dFEQlYwF7lDOAJHkG5VMxJ95Tn
         gtkiwNQULpC09rnN86IEUvk/9BV96E/DlgnO/e9m3S36KrRGZ6gJSgDzJ8xs963XaJB+
         Gr/Gsu/TS1qibPSPy8IuGGKgg9Enkuu2rZY5uIhxSgqVEYavZjmHZhlRbKHliJ7qLAqh
         Z6EPVhGNao1M39qL2xkR/rPBk41JJXhaPbgqXlEzWFSoAfkHubjXMt3uz5jtE/bRfDAO
         FXmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HXiF5Hkq0HzdjVstuqtN1MMqL7UJCviIzr82cLK6HWc=;
        fh=pDLOiZ7tXMOvWRwpnjb0+cKUZB77VatLrihDuN3oqvk=;
        b=MpYeFJiOHCLSSuwq675SmPL+eq1pI9U25me7MjEWLfCo5Y3B9Aq2Gv4sBDm8AfoC/H
         GU2RPSs+A8Ct6bB08yMP8N0nACim4ctgdU4d3ezew8QyKIiMFq1ybldqoh5FFhA+tsWe
         aNX4tpSm4nvCU/KYg7pWgsDIKFNoQZFeNQ1SLYMdQKhyUotj+FBiWW9HDH2xvQfK4fZj
         H3rSeQe85GBF5z3PvIdnzjC6GUUh/Z9GoiR4B4MeMImBjjPVcpiZ1O2KV0ADeO1xjvsj
         SnK8ymyasuXtpkNs4+k8+fRETfhY7T8Y4/FFbNakHRoBvR5J5YRu7GDNONOatNqRPXm0
         la3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793735022; x=1794339822; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HXiF5Hkq0HzdjVstuqtN1MMqL7UJCviIzr82cLK6HWc=;
        b=BxKVG8JoCv/iLQwtckK7tTHB16bZFUqtRztlGqJbBM/qwXqrVU8gxVckUULIHgtRwe
         eAVu1569YSe66F2TCCr8LjC4QzC3JhASOec0GtGkb5ebpm1Qo2E++YCHjminyHPTdK5X
         wBE5RwowM8xsbD56ydU7k8LxUZ2B8rHVPg8n5t+3wYFEyXrdY9qGu52DT1t41PnSPXvE
         Uc9gCXRa1ZtUGFzNSbajQgIHcrbpYASURIPtYKhmtssCGSbc9ZpOio6dC0e88MKez5kF
         2DjxVghz+PDpBd2UmSRKvYzOfk/PP197DE87udZ5Sd087x6FyCvp30CyaxCbFsLLcBZP
         CeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735022; x=1794339822;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HXiF5Hkq0HzdjVstuqtN1MMqL7UJCviIzr82cLK6HWc=;
        b=aMQxmpftsPcrclMrEqqjBUH0gVq3xL5ji9Et5GPilHyhqtXpETQpXLlT6ntY2bxdhS
         EYBRjdkVOIwMdyaFB83OAPhFvIzS8yyOfNhwCrOBVAxnWJcMxZP5BeXmI+BA+83Vya9a
         ocHTdFI0xw+kUVFy0h36UXoAOAGRU06tfTlwqrF4mKrohycAe0Eu5M9eyQQxnsZERQJl
         dbrsKimqY537XABPuC8U5rVYSLQbk2AlP6rlyXQBKy680A9n/BtPklO24v5pAZYt/aJo
         eRWy9zOpXjOWt8451VLtSncc2JJDQHNnKgJujtTqhMiZ98qOacMsRi92dDl0pE25C9qZ
         0xJg==
X-Gm-Message-State: APuU4Z8sa57Kbra13VD6Jy5Uy8INEfIgXKnSYiQhSratmPCMV6I67DVW
	isL7uSUn4nmlidzDX38Uj1lH63Oz3quD3t4FSK+i6vbKaZnNFWpRzF1oXr8fYScMiS7rxmlxI7Z
	ZLoGqjqp3KZuEdSzZMp5x1ngdZuGIRJ8=
X-Gm-Gg: AYBFou1huQqU5luz62gL2kJJQmrEi2OvcSb4G/6QBeSA6PEoIWk3TKxhrn/i7sMieEI
	3g/PkWO19IQjY++E+ws1NGC3wr7rHofVgpaHqGL5Y6GKz21rlgGc1dpxHissyaJIiFHHvtCtmSY
	NwdRyFM7whecg0xuXW7jRMwgoU5NpWRDfcUu7JuBwqGOgJljiZgftRW2Ao7VFdbOdxxaOwz/ahJ
	wHLWw6T5dPRg1mBPYVK9hRrTwHCsI2/pRWru6wXB2RI08ubt/3hNRm3QD3uOJuTffwcfdc0lu3T
	8crnPxSxpSxGMCiMXp2e1uWIQEvW67Awsodj1GMLo5RTRzC/BiLE9gwfY/vccHaHxm0pSE1zqWR
	Sh7ur93fuBHuH5EfVax4nRi08OmJnLsQn/YnzgoBl4VCsxZihi/vQ5A95/13gHmJBMF8cS9ji9/
	a9VQtcfa3WH2l6uOvXfCmP4gHOCL3nhqsLo324gVm0eqC/l4xlaEHXd+MD7A==
X-Received: by 2002:a05:6a21:9105:b0:3e2:2459:b774 with SMTP id
 adf61e73a8af0-3e928914359mr7729030637.16.1793735022129; Tue, 03 Nov 2026
 11:43:42 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103192606.92502-1-kylebot@openai.com>
In-Reply-To: <20261103192606.92502-1-kylebot@openai.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 3 Nov 2026 14:43:30 -0500
X-Gm-Features: AclHuK-Ntnjfy2V4XSDVEY_hZLHadBX9iYXfJBbZvbiqYzD0aYF-YvCMv_txPg8
Message-ID: <CADvbK_d3k8GsgjdHUZ0a2LDs-Y0jd3mxoFvLSnnz3WqCTbBbHA@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: avoid requeueing pending control chunks
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 2:26=E2=80=AFPM Kyle Zeng <kylebot@openai.com> wrote=
:
>
> The T4 and RE-CONFIG timeout handlers take a reference to their cached
> control chunk and submit it through SCTP_CMD_REPLY. A previous
> transmission can still be on the control outqueue when output is corked
> or suppressed, or when sctp_packet_transmit_chunk() could not append the
> chunk.
>
> sctp_outq_tail() then adds the same list node a second time. Re-adding a
> non-tail entry can corrupt the list without being caught by the
> insertion-time list checks. A subsequent flush or association teardown
> can access an already freed chunk. The ASCONF path is reproducible by an
> unprivileged SCTP socket owner in a user/network namespace, with KASAN
> reporting a use-after-free in __sctp_outq_teardown().
>
> Check sctp_chunk_pending() in both timeout handlers before taking the
> extra reference and issuing SCTP_CMD_REPLY. When the chunk is already
> linked, request a deferred outqueue flush instead. Simply omitting the
> reply would also omit its uncork at the end of the timeout event. T4
> would no longer retry the queued ASCONF, and a migrated, pending
> RE-CONFIG could lose its timer until unrelated output flushes the queue.
>
> The flush command acquires a local cork only when the caller has not
> already corked the queue. This preserves the existing flush ordering,
> transport/error accounting and timer handling without changing the
> common enqueue path.
>
> The issue was found by an LLM.
>
> Fixes: 2e3216cd54b1 ("sctp: Follow security requirement of responding wit=
h 1 packet")
> Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
> Cc: stable@kernel.org
> Suggested-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
> v1: https://lore.kernel.org/netdev/20261030042321.74407-1-kylebot@openai.=
com/
> v2: Check pending chunks in the T4 and RE-CONFIG timeout handlers, as
> requested. Preserve their deferred output flush with a state-machine
> command so pending requests can progress without unrelated traffic.
> The common sctp_outq_tail() path is unchanged.
>
> I have a reproducer for this issue and can share by DM.
>
>  include/net/sctp/command.h |  1 +
>  net/sctp/sm_sideeffect.c   |  8 ++++++++
>  net/sctp/sm_statefuns.c    | 20 ++++++++++++++------
>  3 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/sctp/command.h b/include/net/sctp/command.h
> index 2058fabffbf6..abd6cc509183 100644
> --- a/include/net/sctp/command.h
> +++ b/include/net/sctp/command.h
> @@ -39,6 +39,7 @@ enum sctp_verb {
>         SCTP_CMD_CHUNK_ULP,     /* Send a chunk to the sockets layer.  */
>         SCTP_CMD_EVENT_ULP,     /* Send a notification to the sockets lay=
er. */
>         SCTP_CMD_REPLY,         /* Send a chunk to our peer.  */
> +       SCTP_CMD_OUTQ_FLUSH,    /* Flush pending output when uncorked. */
>         SCTP_CMD_SEND_PKT,      /* Send a full packet to our peer.  */
>         SCTP_CMD_RETRAN,        /* Mark a transport for retransmission.  =
*/
>         SCTP_CMD_ECN_CE,        /* Do delayed CE processing.   */
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 35f540fb15fc..6f19ac78749d 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1498,6 +1498,14 @@ static int sctp_cmd_interpreter(enum sctp_event_ty=
pe event_type,
>                         sctp_outq_tail(&asoc->outqueue, cmd->obj.chunk, g=
fp);
>                         break;
>
> +               case SCTP_CMD_OUTQ_FLUSH:
> +                       /* Request a flush without taking over an outer c=
ork. */
> +                       if (!asoc->outqueue.cork) {
> +                               sctp_outq_cork(&asoc->outqueue);
> +                               local_cork =3D 1;
> +                       }
> +                       break;
> +
>                 case SCTP_CMD_SEND_PKT:
>                         /* Send a full packet to our peer.  */
>                         packet =3D cmd->obj.packet;
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index b2f609f177fb..8b76b7e28504 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -1122,9 +1122,13 @@ enum sctp_disposition sctp_sf_send_reconf(struct n=
et *net,
>                 return SCTP_DISPOSITION_DELETE_TCB;
>         }
>
> -       sctp_chunk_hold(asoc->strreset_chunk);
> -       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> -                       SCTP_CHUNK(asoc->strreset_chunk));
> +       if (!sctp_chunk_pending(asoc->strreset_chunk)) {
> +               sctp_chunk_hold(asoc->strreset_chunk);
> +               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> +                               SCTP_CHUNK(asoc->strreset_chunk));
> +       } else {
> +               sctp_add_cmd_sf(commands, SCTP_CMD_OUTQ_FLUSH, SCTP_NULL(=
));
> +       }
>         sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transpo=
rt));
>
>         return SCTP_DISPOSITION_CONSUME;
> @@ -6197,9 +6201,13 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
>          * chunk, it MUST be the same (including its serial number) as th=
e last
>          * ASCONF sent.
>          */
> -       sctp_chunk_hold(asoc->addip_last_asconf);
> -       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> -                       SCTP_CHUNK(asoc->addip_last_asconf));
> +       if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
> +               sctp_chunk_hold(asoc->addip_last_asconf);
> +               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
> +                               SCTP_CHUNK(asoc->addip_last_asconf));
> +       } else {
> +               sctp_add_cmd_sf(commands, SCTP_CMD_OUTQ_FLUSH, SCTP_NULL(=
));
> +       }
>
>         /* ADDIP 4.1 B5) Restart the T-4 RTO timer. Note that if a differ=
ent
>          * destination is selected, then the RTO used will be that of the=
 new
>
I don't really understand why OUTQ_FLUSH is needed if the chunk
was not enqueued by this timeout.

Can you share the reproducer to help understand what caused the
chunk to not be transmitted on time?

Thanks.
