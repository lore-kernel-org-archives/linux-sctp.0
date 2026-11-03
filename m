Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.178
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793715766;
	b=M48Ze+LBmtsoTmUn15fpaN6aOu6xS0X5TmSg8/zAivQfYh8SEOuXXJsDlXVxA+QOLn8R
	 FdQkZ7X1OfLRxUUpjqtrsXlJnDC1yJiCOtWUiKux6PxX9CMesHWlRyLUxIhevjSTVCwtt
	 aY0csL49Ochi3fnrnIgGfRHGjjsm8U4naaMwProECQ/nrbfftCKITcWDfAqwVactLI6L2
	 U/I7HOlWlKFKI1lSIOKh5bm58SGmA1s/AU9C7Hx/S7Y7Pe5vz69y3yFs2ukzoNP3sduxi
	 JWql9ABAUVoeRjZ3BePna4KRIuwlXTZBg4JMo4m9Mn+cZjTBl4S8S+jkNIRVyjQ1EOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715766;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=goUEmUyHzHRn/JAgbYWl2i7yvd0k17zq6RZVq6dJndA=;
	b=El27Oe7uJ3qV7i7p/lVyDcCGBJpY5bBZmCDFTuzNxxW/JRJic6xRFhjhriTMmeCVOlQZ
	 qiwnHkLU+lgxpD3MEc6vDG820xXfXsrV3DZJeIgccaMdIdGIlbn0TzSUqmGj63L3c9DTS
	 Elg+sGex4L7xu5Uqy9zSzLKCmLRUPfoXcgeE416PzEbryj6E+XtYSJG+Uq0TifYTeIvU3
	 118STV7Ujh/GLRVoVWazqDnmRQ5RJGNCIf33n+FhlRWNdeG+uE06+XmnMh6HMVLzZ4TNK
	 Ipf6UzS+3wd6reC4+Xnh4joAhPBK8COWpMIbhP3+tMdJJnwdBOKpLrR9CRtfyCo5KMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jhkisa2S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC4C606A32C
	for <linux-sctp@vger.kernel.org>; Tue,  3 Nov 2026 14:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EC4C606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jhkisa2S
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc502d509c0so1720060a12.2
        for <linux-sctp@vger.kernel.org>; Tue, 03 Nov 2026 06:22:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793715765; cv=none;
        d=google.com; s=arc-20260327;
        b=CYYN48BxCxcwXjcJ+HFRPxqwrh2tfrWb6xSOSUttn20fau8ryWF5OyYrLSC14IZxYE
         TcjaQwZxVIPHqv0rHqWpdTPOZEardW6x6iG1j8RkjKgj7l0jKuKLlZpk0zkcX14IedBq
         a/i5QX+zYUVa9wixY9Xln+T5HTfKueBULwYDH36qaoJO+oEEyHcVp/IYUEIax0dDejkG
         kCoEtK5UumC229zwP0LExhJMOoiDkwlRUgfU0OVtWKP/QbEpVlUzpO5hmUxb+HfAX30y
         7aIEPA1GHdYN8VHC+ORn6ShuonjXtsvVXFbi71YwoQr697lNa3O+no20hf98st15n8m/
         /vag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=goUEmUyHzHRn/JAgbYWl2i7yvd0k17zq6RZVq6dJndA=;
        fh=8BI2uDnjuZuFFben54b9d9R+Cp/Vl8TZxkef/2futk4=;
        b=B3PD77vN17jx/v3GXqGuJVjPNgKu6UUGke0JnqC3Ryz356q/tqK+3/M8Rm2BkQUgf0
         mhZzsr/H/1B2enh83VL7vHcY3sA0tDmqDXpvrkCfXF91gUQZjyEA9daJ91LOuroQ0pNM
         IepvB8PsZQwH/SSc2Gv9aS05UdhP/6YtenOBEkASXSJkB7Nfz6EBdt4E0kUGDNGHBjoF
         RXh1AWMvJtX8TO7nmqgkL4PqB56YLMW1BvDkHAgmq1EOVf6MmyLWaFc2IsVJUoB+t8wI
         0RDYycM7bCdbtsgvJHJWjOeOUZBJgLa3FLWJX2Hlp+M/tud+QcZOAapcBzo8lMWt6bx5
         WFbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793715765; x=1794320565; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=goUEmUyHzHRn/JAgbYWl2i7yvd0k17zq6RZVq6dJndA=;
        b=Jhkisa2S2vXFBSNqqCyZnrR6JpuM5BBpw/U1ykOmBCVbHHAGBHiG59udh4q4ocSZzT
         B+VLP21mZOHIS1JiMcrm4hn1l7sTaZeW36g+3nwf+SorUXmrDWEMCYf+9/iaAtGkWP2Z
         jvIaLLuZeQ4HOU+rRp31Qy0Y1c0Y++wgaT0ywmdFgHf/MWUk0f+ANbMLe19dXKYipBm3
         DqkuIdu20GgR3QdxoXR+SnZkJh1tFg0zTOIXILFVjTGAuUeaaF6fXdUsYCZwgoWvaGzk
         AFufwdIM3Ds11CGHgak7opO6f4y9wacjoIffPeNer/sXD3iDcQGEv82oJ75qb5JfHozX
         bmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793715765; x=1794320565;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=goUEmUyHzHRn/JAgbYWl2i7yvd0k17zq6RZVq6dJndA=;
        b=rFnjf/K69okAyVHMqR+35yqE65ZxaJAJMUmYRP5MZ/ly9LlmFINxGp+Ghx6rtQo40x
         9ldmix2L6Y8dM2QUmd3bFWAtRGXMSEZmaDwg0IfGUS+Svnl4pqZbmQf5pgNPnP8ZMFeu
         htLv1CzQyZxVl3TdmEerFjg+PfjMcntEAofPWIBLpEvt6WSjP+kohjBYN6v1QdjHFMm7
         drgrz+ZxSbVOmFm4fiMiWmW5jWfroKs4VtTARAAx87ShKyEGDIqre8x9GoTnUpe02fs8
         rlYGQtAF1Ze+q4Tb/d4D91H5hsYEcK3eIsfE4sf27AjCZfSsVPH+47staNDp1Qr7HLyD
         +hXA==
X-Gm-Message-State: APuU4Z/QaRbMnrYqOD/iJX8q8pB77ZKcnHiQxuHgNk2ecdpYRBG8U4wK
	fCSZpFwEwdpavTwgZR/6kOydG0m+4a1ydA5XC/QnWR5RBpMsBWxfNnBXBByg6UyW2oMKWmIgHIw
	ZxNckH/bLVjZwVqoE/mnojwE3xVM//qg=
X-Gm-Gg: AYBFou2D1O0/hY+AGPajTqtMkJtt0pEg/0J7rt3nAHTRA86qKICMX2sG1ekIvgz+6+u
	ll8yGYfD7pCJBgQpkqZATeCsCZKljc77CMbgBrvNU0TSNY/IaAGxpVeDxk2jZULeVFjnpd1EFoJ
	X0W5g2qrSRssaOAiHuBBjxoF7B9YCnq/oqjQT/5DWnmaB208sRt3BQXSehY3UwRNSmCLgQTToMZ
	1jL4c8mw9EsoRJK6gAXVRVOZEjoUomqZVbqdtd9cCuLHlYXlxxfcev4Nnb3CAfueDsFo5bCgfPd
	rzDzsqHTrvpie2zuWA0SslrmBmhQGDAZHskjS38ByH5DpbUUWCe5Mec7YC5upHe+LFjtiJ9lzn8
	yAlR28h5kAeu/qKc4BFU1dOBxsfiWdhBjirLhPGpiS5eIIaBTR+kjkkh6EgMjRIbFJN98zeJ/La
	f5O3Vq1DH4hjRWpdgwLlRc/1QtnaB7sv2eNfBHog==
X-Received: by 2002:a05:6a21:3f90:b0:3e1:d119:ee35 with SMTP id
 adf61e73a8af0-3e928d40e11mr9916793637.12.1793715764802; Tue, 03 Nov 2026
 06:22:44 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261030042321.74407-1-kylebot@openai.com>
In-Reply-To: <20261030042321.74407-1-kylebot@openai.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 3 Nov 2026 09:22:33 -0500
X-Gm-Features: AclHuK9rygcKHlFq8M3zeAsoFHUWP0OF3Dg8S91AWQVg--msS91soOe9ITJpZK0
Message-ID: <CADvbK_fwt6s14a0yJjRa5whAT-H+7RtaDXi4cR0-XmrvoJkeQg@mail.gmail.com>
Subject: Re: [PATCH] sctp: avoid requeueing pending control chunks
To: Kyle Zeng <kylebot@openai.com>
Cc: linux-sctp@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 12:23=E2=80=AFAM Kyle Zeng <kylebot@openai.com> wro=
te:
>
> The T4 and RE-CONFIG timeout handlers take a reference to their cached
> control chunk and submit it through SCTP_CMD_REPLY. A previous transmissi=
on
> can still be on the control outqueue when output is corked or suppressed,
> or when sctp_packet_transmit_chunk() could not append the chunk.
>
> sctp_outq_tail() then adds the same list node a second time. In particula=
r,
> re-adding a non-tail entry can corrupt the list without being caught by
> the insertion-time list checks. A subsequent flush or association teardow=
n
> can walk the corrupted list and access an already freed chunk. The T4 pat=
h
> is reproducible by an unprivileged SCTP socket owner in a user/network
> namespace, with KASAN reporting a use-after-free in __sctp_outq_teardown(=
).
>
> Check sctp_chunk_pending() before adding a control chunk to the outqueue.
> If it is already linked, release the extra reference supplied for this
> enqueue and leave the existing queue entry in place. Continue to the usua=
l
> flush so that the pending transmission can be retried.
>
> This also covers RE-CONFIG retransmission after sctp_assoc_rm_peer() move=
s
> the request to another transport and starts its timer. Keep the existing
> timer handling, corking rules and data-chunk path unchanged.
>
> Signed-off-by: Kyle Zeng <kylebot@openai.com>

Please add a "Fixes: " tag for this patch.

> ---
> I have a reproducer for this issue and can share via DM
>
>  net/sctp/outqueue.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index e92fb9da4647..a5f9f0fcf5fd 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -304,6 +304,11 @@ void sctp_outq_tail(struct sctp_outq *q, struct sctp=
_chunk *chunk, gfp_t gfp)
>                         SCTP_INC_STATS(net, SCTP_MIB_OUTUNORDERCHUNKS);
>                 else
>                         SCTP_INC_STATS(net, SCTP_MIB_OUTORDERCHUNKS);
> +       } else if (sctp_chunk_pending(chunk)) {
> +               /* A retransmitted control chunk may still be queued.
> +                * Drop the extra reference and retry the flush below.
> +                */
> +               sctp_chunk_free(chunk);
>         } else {
>                 list_add_tail(&chunk->list, &q->control_chunk_list);
>                 SCTP_INC_STATS(net, SCTP_MIB_OUTCTRLCHUNKS);
>
Can you try to fix it by not sending it in sctp_sf_t4_timer_expire() and
sctp_sf_send_reconf(), instead of touching the common path? like:

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8dc65498763c..7671bb0ce946 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1122,9 +1122,11 @@ enum sctp_disposition
sctp_sf_send_reconf(struct net *net,
                return SCTP_DISPOSITION_DELETE_TCB;
        }

-       sctp_chunk_hold(asoc->strreset_chunk);
-       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-                       SCTP_CHUNK(asoc->strreset_chunk));
+       if (!sctp_chunk_pending(asoc->strreset_chunk)) {
+               sctp_chunk_hold(asoc->strreset_chunk);
+               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+                               SCTP_CHUNK(asoc->strreset_chunk));
+       }
        sctp_add_cmd_sf(commands, SCTP_CMD_STRIKE, SCTP_TRANSPORT(transport=
));

        return SCTP_DISPOSITION_CONSUME;
@@ -6197,9 +6199,11 @@ enum sctp_disposition sctp_sf_t4_timer_expire(
         * chunk, it MUST be the same (including its serial number) as the =
last
         * ASCONF sent.
         */
-       sctp_chunk_hold(asoc->addip_last_asconf);
-       sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
-                       SCTP_CHUNK(asoc->addip_last_asconf));
+       if (!sctp_chunk_pending(asoc->addip_last_asconf)) {
+               sctp_chunk_hold(asoc->addip_last_asconf);
+               sctp_add_cmd_sf(commands, SCTP_CMD_REPLY,
+                               SCTP_CHUNK(asoc->addip_last_asconf));
+       }

Thanks.
