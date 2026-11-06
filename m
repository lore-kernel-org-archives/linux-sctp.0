Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793983973;
	b=TG9Mfe2TEg2dBV+uv6bszDxBbRRF3Na9LKiGQbPBIsfSaFYj2gwphkTHN8zOKAPMzP43
	 Z+5H6Wohey3ZJBqEapJ38nGIi4kOaZEqPTSWYbfR8yt07kei4Y/2TFlhmPFbOSgQKWjVa
	 RjknwcwIonQGDoJ8GKesY2MJuSD9J6Cr+SOWQpnE7T3RLZmG0itb1xcwE0Kdoaqxxos3p
	 F/hEn5CkWkLswcuQAqpJE85Cd+qgfDvmAb+IgYxQj+rA6C2Q8Jbgnk6z4zjJl74AoDmrX
	 i6tpq5t4D5j3zJA7ZjdpAqcR3TevaFdl6+MQKs7kg7KrpmkJ4GCHqolJWUdAghjGs8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793983973;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YBkkwCMF7E0Jrr0hGSDv7wIrrEuUI75SMkeEZ3MS910=;
	b=vAN4OR/5JoqelehHxbFTz6FgSQNQtQVP0ukwM00J5dCNRnVS20IQJLFiVVeup3J9k2PZ
	 8gPocssisUi2arbDiFo+58EJAO9L63yH9v01EgwXcnfNa2Az9OuMZgFdBUqaJH4JLO3w9
	 XK119VM8I0CsenUOgK/hRZCR/PfKEcaIg68EGQJHzAaMotOy6Wb5ObwC7gDGIByZLOcU6
	 DlIJYERH8GpLARlvnfWTGvjE4GxTR3W5wfo7XzFfWKJnWQRpFYMoOVw+LmLbdJLXaCRGa
	 72qGHCYKcSmvTpKm29K7F0YN+WlPN8k1pRWRDa5FAEpouRZKUaQSM/JbzGCFuIRd+8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dL6TY56i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1DA606A326
	for <linux-sctp@vger.kernel.org>; Fri,  6 Nov 2026 16:52:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC1DA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dL6TY56i
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a070755c8cso377466b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 06 Nov 2026 08:52:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793983972; cv=none;
        d=google.com; s=arc-20260327;
        b=fsfDioW3AAe97kHjBSFDtBswKzVPIIKHBLXyfJyeoQXdJq1ZTLKak/cbdUSumxkyup
         isSgu563XeZL+uHUdr2i/V0q3n2jhNYwitXzJlD9hdcr0XvWFLofGNXOF5kTtYgus5Jg
         dKkpoN8zUrmxtADKSWkAInGvTBQkP+ctlh5pGWthTj6s6vS066Dq/W7LsL2MSYizV+7l
         bWgPsk2filUK8syw6tgS/aIhU3MpBsuE+VXB0Aa5Ms43j392pXpM14ffIqRkA1jRQScu
         ZUFEHJCNcFtip0+fHU/H67riTvZMWakmJ7zdKR/exZ+jvFge+K2sdseHw4ddcogT0XgB
         SCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YBkkwCMF7E0Jrr0hGSDv7wIrrEuUI75SMkeEZ3MS910=;
        fh=Bs8ry/SlMNSA5jHBZasLwYt3FNNWay87qvAOAul36ik=;
        b=DiKvrZJGL8lYQX/IB83iR/u8d8m0FixwF9TUIxz+AOguMn5/pp9Dh24uPallNeJvWe
         AleA/ANlV/AlsyRgRFTSsw4NW9JOprQIx+TbcR46slAtehJgvUxDUAyQ1i5xgUKZAwgj
         0Yfvsz1T+SA0C1i/9fUn8nH3Fl3GMBclM4qp2C2+U2S6gczDq+Dh2o+jQbnt69pVSXWp
         aWZHYK8G/FG/1MhDyY25gXhNGzqSpNh1DQswoZOR5GnSvMddBvGriu4zxsuC7V3GHIw0
         FjuD+GRy+Z6CjA3VpDdZpdEiL+eYQaHXwfJ8Tpnv9bGIeuQpFsPFiBAA0q7yfRaxeIZc
         LfYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793983972; x=1794588772; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YBkkwCMF7E0Jrr0hGSDv7wIrrEuUI75SMkeEZ3MS910=;
        b=dL6TY56iWpuzVc7nEVJB/x0qGy9+4rTnmHP0Lkj8oQQUEI4PMurPzQTMRoD1feFOac
         qkcbp8QHG0pFmzPO6oJO/ESGRQfCM/OF4Gh00a4s3z6n+5LF5c9pB8AMzWkv89YNiUYC
         IwPAKbcREGxQkfHjNo1zZZGU4oMhqcPhcA3kH5xKSzsClm8DMhTO/+1DhWoSDn1X4Iif
         B44ee27mIf9/7QzSGmLjHbtIR0PQtnOUxNu1TChGUvroDil4A1h3OCef4QNr/nnv49cY
         8IgbchaB3CAgGt/TvHeQjPttvRTgQKhNV8Wu9eF6d9e3JmAAECdlzn3vSjXLhbc2SkRQ
         0cXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793983972; x=1794588772;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YBkkwCMF7E0Jrr0hGSDv7wIrrEuUI75SMkeEZ3MS910=;
        b=XtlO9cWgUUjmjhTnzaspbaik5bkF3vgaWAMvsp7/g5MnxsDzpoRX4WfYzCiHUlnh31
         g0RSRQESYvHAzGOdrZZeY6XViyyqmLKl48Cv26uxZrnLdksAo1VMUWIyVPTLXVlP6Wkj
         u5MkxSTq5EN7rn9MhVuRhQoMIym3Au1kClU1gH0mdu3rE+oN0bL+xzjonSid7V9iM/h6
         xaV72lwRMxCDgGPkqXuiRzMMxN457miaU2eAMXI9g/U073xiFUy8yZmnTsSetXO5wwYD
         m8fkoLdWEdMfFvqpVGM2pfivdFyIsSvB3r7P6101T1LHm46yJzMVq7iLJrQ4B6Lm6bbD
         FOGA==
X-Forwarded-Encrypted: i=1; AKwUvBxtHkH8iuOvK+4XN9RP1fvHmzxyy0KPcSvTmqfjo5ff8wkEnbYwUnCMykcwxdKFNPoyK9leBN4eUUHy@vger.kernel.org
X-Gm-Message-State: APuU4Z9mtesf6QmpusxRu39+S35nn4kq+WMaW2SZqDBhTNjvsXUJ/ohz
	VbRlIJwM3Jhx0grAjIUijS0fjd4SaJzyPZHukeWn7EZMgVz7SHCvHCngDsc79WCMJOjQ/I/F2yU
	JdD0IThA/8EPYNTQ1ywfa9Zy3i7wiyD8=
X-Gm-Gg: AYBFou0iL79salyPp5kZ4S6T4kFfqTwiY0CZXkJqJfeZtXEdC8/Av9HesNQaWJ9D/kR
	VUGPDiA7OInpfinDb5vkIpwQ7mAjq+4ToBjCR8t6DuKxG3EO5g2Z2cFHGniL8/esF0mJTXen/Tz
	K+H/cdwC9fhTAEkKAsC4aWrtbf2je8pMeLUD3dUSayB55AP+0LQxR0/eBQV4tUpu9drPoizp3wH
	/7I+FAmVyaoiJ+2krJAnJ8cd+W11/uOYvDkg37Z6/iTyrD/kdwbxXDjtWvbSlIiy3fcvvKfcTg7
	ZA+SjXJ9EU8JbR4ULgd7KoRbUpX/1gfoPk1hmpoO8DBaO2ka75WMR16lPoAcR+KnNlKyDycnyQ2
	hr9owamlKU6L5MS1qQ0E+voGal6HF72qVi18OvaA0QNnds0Y1BY4xRUd/N9FvPpSOddlqIF5Hps
	CfJgbTF2aAHXbZij7zogW2iLnP4s+G0/oehf0=
X-Received: by 2002:a05:6a00:2e9a:b0:89e:261c:447a with SMTP id
 d2e1a72fcca58-8b377f7fbedmr3041044b3a.7.1793983972138; Fri, 06 Nov 2026
 08:52:52 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104105507.62743-1-juny24602@gmail.com>
In-Reply-To: <20261104105507.62743-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 6 Nov 2026 11:52:40 -0500
X-Gm-Features: AclHuK_1KtwGRGoHNYyrNVGPMWykc4PtFpxqqos5XP8fO0mNLCVDVrBCDTDX7UE
Message-ID: <CADvbK_eH6jY2GmpDKH-1+KtHHG_wERJtBezYCn83nPQ6Pm3mTA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: preserve stream scheduler across outq teardown
To: Jun Yang <juny24602@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 5:55=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrote=
:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_outq_teardown() reinitializes a live outqueue with sctp_outq_init(),
> which clears q->sched before calling sctp_sched_set_sched(). This makes
> sctp_sched_set_sched() skip sctp_sched_free_sched(), although the
> association's streams still retain their scheduler-private state. If the
> socket's default scheduler differs from the installed one, the new
> scheduler interprets that stale state through the shared union in
> struct sctp_stream_out_ext.
>
> Preserve q->sched across the reset so sctp_sched_set_sched() can free the
> old scheduler's per-stream state and clear the union before installing
> a different scheduler.
>
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
> A KASAN reproducer for this issue is available if requested.
>
>  net/sctp/outqueue.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index e92fb9da4647..6cb4b4339d8b 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -190,9 +190,13 @@ static inline int sctp_cacc_skip(struct sctp_transpo=
rt *primary,
>   */
>  void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
>  {
> +       const struct sctp_sched_ops *sched =3D q->sched;
> +
>         memset(q, 0, sizeof(struct sctp_outq));
>
>         q->asoc =3D asoc;
> +       /* Retain the scheduler to allow freeing its per-stream state. */
> +       q->sched =3D sched;
>         INIT_LIST_HEAD(&q->out_chunk_list);
>         INIT_LIST_HEAD(&q->control_chunk_list);
>         INIT_LIST_HEAD(&q->retransmit);

This doesn't look nice.
Can you try initializing the necessary members one by one instead of
memset(q, 0, sizeof(struct sctp_outq));? like:

          q->out_qlen =3D 0;
          q->error =3D 0;
          q->outstanding_bytes =3D 0;
          q->fast_rtx =3D 0;
          q->cork =3D 0;

Thanks.
