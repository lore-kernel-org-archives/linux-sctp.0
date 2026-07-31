Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B633D4F2
	for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511090; cv=pass; b=hKvRaTky/Xt+AeNRR3MXH1+ZENbLtB5LrE4h5rBsZcUFyj9MYoUldPLqIuax4OlPGINX31L9gnI9xcZNU1+6A1N92xgJD2zdQbpt6RJH9ZZV+h+WICUlbV1Wdbj2Hb3WiQIk9iq5Amqkdg5mPeJHxm6DxZe5RurupJsBWKgXqzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511090; c=relaxed/simple;
	bh=C7Cc303QoAtASz0N6FKewrMzMqxqD+wZkax6oVSWMfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sMSpQGzNpkPdT7yTZsdwXais54gdOEHS7n9OEln1pW1gsjRX8NaS6i5tL7cKy1vUA+jNg59GDZEtfvjNf1Q1CvlPgK3glG2sSLD0K+f8Axhk7aCUWiRs5e+KYmY1AI3AvCqOAnD9CfiMicNCW9jNKpR91ll4yykUI0deP0BdFDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R2GyjvHq; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R2GyjvHq"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-848d21bbaffso1273009b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 08:18:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785511088; cv=none;
        d=google.com; s=arc-20260327;
        b=RHG1dspHvMZnab8GTsIpLh8V8eH0cWYDDA60t+sNwgWVXf4Rdjgoc5wJjPTF4xeq0T
         RgCmd1vHzUePsJpCSgyOTK7xh78z5RJxH52Cdei48YgC5buz/ZHAeZQkb+RBM1ahe/NI
         V7WSdmYm4XI5SvovODZVSdyMDsX97QCzbG+ZqzJWYLYp3QRMOdJ6Hrw5sA479kwTPg+r
         6mFmDy5eNvjR3dPwhajaPyiinyijdx2M3SdCKkwJdaw/RwsGrRNv7kGrNIpZJxYxLsZZ
         l2dgNHgz8TRVhjz/q0WoYdbU13c5lL6GmLVUxg4kAN/uAaalMt0Y23oyFzeexFokUnxV
         eiJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5A/8t0GiaDz5Ne/xZDa7Ogn6GPJ5N8fZ1MQ3v+kZW1U=;
        fh=A05rsP84/u58JzzHVsYxkuGc0vmOYyx6O6bBS2G2j3s=;
        b=BbTA/EbRUIamZQPDzr2AhR/lk5gSx8acctV8paG86DYwdOFOR9zcL5hB6YbTxysfND
         Y694hGJJWBd6zlYdHPbNr6PoA2YiOcX7FrdHetwdHqavxFRfd3x6nPur+3loh1k8n6zC
         QvOENOGqeDrnRGUQOUT3O+CT5eFCTfOZBJ7zxTO7Gqgs0S8YozZbOssUZjD+Q9UDCpwV
         DfwbBAKI1inS0sk+R7Sws8Jbi9ktmmstLVL/64wEuWUN5tpTJDuBqsgabNTbgz/0gRzN
         DnuI/pYr0preIvVmcBLI+5+qG2jbvBuZdDHmMZGaNDGqY8WQgt1LiEDi6OEzKegiUPrk
         nJ4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785511088; x=1786115888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5A/8t0GiaDz5Ne/xZDa7Ogn6GPJ5N8fZ1MQ3v+kZW1U=;
        b=R2GyjvHqJrJ15VJUSXVUgoS8l0ERMLGHtFH+0q8Qy6gjUPKoRQTrAWPJrZ7fbteEg+
         GeX2GYNZIY/TRw4GAYOd24ictW8nLuF2zrRtnlUFALsUVhkI0N+QmpTLZWNot+yzFsAc
         ZYydKtv7aK8Rg0+AFRuVwm+Y6daMYucjVvl4Ngp7B3GsdTgUi+PEoggNeYlZJK0WyYOM
         Q7ZxL0YnFW8MQNJypSL/uCN3ZZe35kbBoCcjoll/0zLpprCrtntVEqm4UAkKyeoEumDf
         oKkgiZ41ovcW0eXswuGBWD5zQCvIJgxLp97kcFnShZFCe37F/XP9VvVd4o1lPnSOB/Xw
         8Qxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785511088; x=1786115888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5A/8t0GiaDz5Ne/xZDa7Ogn6GPJ5N8fZ1MQ3v+kZW1U=;
        b=YlEIpA2j0ZYcYXFFFRZjFA8waQtCqLFxLbiiLP24w7XVcsJoTGMRgrAW9a1FT9e8B2
         DG30qnhoC0uQbgAwwNtAN39IG5HuHaE+E8pfdDNfikfNVHzEGDeFVpib69K13cH4Jq8c
         rci5Ao8DWrA8uxJlwVBcCtir7pMPF2xbACaq8E+BC2XvFvCACFriCACe+gUE73AZfhQd
         2iVQaa/ovk7ajvw3qaM9FMZIvWenBsIa9+1OFfQ2UuW41HH8O33H9iWKwmChY2fHdC+I
         WrJ17S115QZByHVP4tQ/HGuDKFO9oDPdwqoxl8hD17tn0IDqQ2QmeXvPEvS6zaftESV7
         Aa6w==
X-Forwarded-Encrypted: i=1; AHgh+Ro6NE7uOkvAc2QsqdoEn1huu6Wka2qd5UvRtul+u9ue++3wZFleX2CMY0NhzMY7HFwoFDztBCVEc2x3@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1KIaNndrV62ZYb5oUS4osG9eyIZdXproRG+jFe6m4RQeK4Loi
	sHfEYha+iEkz6qxSclwjg+W15Flp+ExeWAHFUXftBDgoOajYOO35ECe6EdhxsIu6KNYqJDxhGUm
	9DcWpmHp79OiZfgadbi8NC/P6woYP8Ys=
X-Gm-Gg: AR+sD13bs9TUhXiO48FyYGbqs0/HcY7e7/jLSbvLS9G2d4+NT2Qtv3NFfySmVvk0BtK
	rCv4UUf1DxnGG+8NCZD1WRG+ulYVA6sW7LmYqw9/G54SyhxdtFdGB11bBZjaKsiQ1QSBrBiGYZN
	RQqpFmoPeAIUMeEpYrfxRCiOaFo2Va5J0AP50FhHaSzmq3JPUK+NO7HDN0fr61Oo67sqyMfrk3p
	Tw5gNCPSUHchoBaGdoVXwRRC4lRCo1UY6e8NKYZdGdvVmVscCDbVOD3eyidm1mn5R1KrCPU+vJg
	G0pTQFbWRGAtr5D5bK/ZTa5Sk/8eUeVH50NZ9t8HSk0oE78PApNfo6szKHshcjQydbU8c6gG1y4
	o/I3OaDeqQXtOyP8ntyCJ2v8Gc5BuejjbcQf9oFdE9Jfy
X-Received: by 2002:a05:6a00:178e:b0:84e:915:d7eb with SMTP id
 d2e1a72fcca58-84ee48cf36dmr73628b3a.37.1785511088185; Fri, 31 Jul 2026
 08:18:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730110225.37371-1-juny24602@gmail.com>
In-Reply-To: <20260730110225.37371-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Jul 2026 11:17:55 -0400
X-Gm-Features: AUfX_mwAXs3VdnUx9IBNMuNpKz-bfEDTMCN_rlRbjGI-kve_yDusJgOLHI-k-3E
Message-ID: <CADvbK_cr33waMA=R1RgK5sW9+SQL1hq=W6BCv2sBTda-ttdw6A@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix stream->outcnt underflow on duplicate
 RECONF responses
To: Jun Yang <juny24602@gmail.com>
Cc: netdev@vger.kernel.org, Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 7:02=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_process_strreset_resp() rolls back a denied ADD_OUT_STREAMS request
> by subtracting the requested count from the current stream count:
>
>   nums   =3D ntohs(addstrm->number_of_streams);
>   number =3D stream->outcnt - nums;          /* net/sctp/stream.c:1050 */
>   ...
>   stream->outcnt =3D number;                 /* net/sctp/stream.c:1060 */
>
> This undoes the increment sctp_send_add_streams() performed at request
> time, and is only correct if it runs exactly once per request.  Nothing
> enforces that.
>
> The function does not check asoc->strreset_outstanding on entry; it only
> decrements it at the tail, and asoc->strreset_chunk - the only thing
> sctp_chunk_lookup_strreset_param() consults - stays live until that
> counter reaches zero.  When both outgoing and incoming streams are added
> in one setsockopt(SCTP_ADD_STREAMS), sctp_send_add_streams() sets
> strreset_outstanding to 2 and caches a chunk holding both the ADD_OUT
> and ADD_IN parameters.
>
> sctp_verify_reconf() permits a RESET_RESPONSE to follow another
> RESET_RESPONSE, and the lookup accepts any request still present in the
> cached chunk.  A peer can therefore put two responses carrying the
> ADD_OUT request_seq into a single RECONF chunk.  sctp_sf_do_reconf()
> processes both: the first rollback restores the original count and the
> second subtracts nums again.  Depending on the counts, this either wraps
> the __u16 or silently shrinks the stream count a second time.
>
> SCTP_SO() is genradix_ptr(), which returns NULL past the preallocated
> range, so sctp_sendmsg_to_asoc() accepts an out-of-range stream id at
> net/sctp/socket.c:1803 and dereferences the resulting NULL slot at
> net/sctp/socket.c:1808.  Other stream walkers likewise trust the
> inflated count until a later operation repairs or tears down the
> association.
>
> Only accept the response sequence currently named by strreset_outseq.
> Each accepted response advances that sequence, so a duplicate becomes
> stale even while another request parameter remains outstanding.  Also
> reject a response whose count exceeds the current stream count as a
> defence-in-depth check on the subtraction.
>
> Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Re=
conf Response Parameter")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
>  net/sctp/stream.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 34ffe6c945a4..b751d0843b3d 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -927,6 +927,14 @@ struct sctp_chunk *sctp_process_strreset_resp(
>         struct sctp_paramhdr *req;
>         __u32 result;
>
> +       /* Process responses in request sequence.  strreset_outseq advanc=
es after
> +        * each accepted response, so this also rejects duplicate respons=
es while
> +        * another parameter from the same RECONF chunk remains outstandi=
ng.
> +        */
> +       if (!asoc-> strreset_outstanding ||
> +           resp->response_seq !=3D htonl(asoc->strreset_outseq))
> +               return NULL;
> +
Hi, Jun, thanks for the patch.

Checking !asoc->strreset_outstanding doesn't really prevent the issue.
When both ADD_OUT and ADD_IN are sent in the same RE-CONFIG chunk,
strreset_outstanding is 2. After processing the ADD_OUT response, it
becomes 1. If a duplicate ADD_OUT response arrives before the ADD_IN
response, this check still passes.

Checking resp->response_seq !=3D htonl(asoc->strreset_outseq) may break the
normal case. ADD_OUT uses outseq, while ADD_IN uses outseq + 1. If the
ADD_IN response arrives first, the check rejects a valid response.

>         req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq=
, 0);
>         if (!req)
>                 return NULL;
> @@ -1047,6 +1055,8 @@ struct sctp_chunk *sctp_process_strreset_resp(
>
>                 addstrm =3D (struct sctp_strreset_addstrm *)req;
>                 nums =3D ntohs(addstrm->number_of_streams);
> +               if (nums > stream->outcnt)
> +                       return NULL;

This prevents the underflow, but it's a defensive check rather than
addressing the root cause.

I think a better approach would be to make strreset_outstanding a bitmask
that tracks each outstanding request type independently, for example:

#define SCTP_STRRESET_MASK(type)        (1 << (ntohs(type) - 0x000d))
#define SCTP_STRRESET_TEST(asoc, type) \
        ((asoc)->strreset_outstanding & SCTP_STRRESET_MASK(type))
#define SCTP_STRRESET_SET(asoc, type) \
        ((asoc)->strreset_outstanding |=3D SCTP_STRRESET_MASK(type))
#define SCTP_STRRESET_CLEAR(asoc, type) \
        ((asoc)->strreset_outstanding &=3D ~SCTP_STRRESET_MASK(type))

Then replace the existing strreset_outstanding increment/decrement logic
with these helpers. Especially, add a check in sctp_process_strreset_resp()
like:

req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0);
if (!req || !SCTP_STRRESET_TEST(asoc, req->type))
        return NULL;

This way, once the response for a given request type has been processed,
any duplicate response for that type will be rejected, while responses for
other outstanding request types can still be accepted regardless of arrival
order.
