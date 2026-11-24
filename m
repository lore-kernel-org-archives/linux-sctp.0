Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795529805;
	b=TsOdM8oaD+HI6qpO41daLLvEvIhnaB2+JQoTBOsUOBNgYEH9BpWiBHaojvBmIIOvsokT
	 d8ZHlw8+UEXXA17FATvXYi3eW3GmXbm3jOLB25sRrtmEX6W4XteBkXQn82mYO8fz7v5er
	 o3Fm8zX1co0rnVBo+OcZUy34OX/eN+L8OpE4vlFnLtRcGbzN92yOkn7w4TRXTMbnBKG9G
	 FCTmOshs1PBqq7oXHKpCLj4D21VZNUURkYmVCsJ5i9Qyayhdwpxc86VgFn0SZfFlTVBHn
	 73dXd1G2NTVqyQ7Hx0/IaGU46QKI73ENCXAasrPyGqW3x7gwUt8HKBw4y7zII8R/qVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795529805;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=L/y4bV9sg4YOxw1y8ENYHV1fp3m5L4dzAun12g4rsko=;
	b=GsbSCrxMNq3F1KBfnaIwMuUwA+34TSJOPHjTwQKwrL0mfZHJdewhXg8uMOkWgHr1xQVI
	 5OFexL/9W8ffNIG5eMBttot06Hzuu0LqAab6EnOrUxOfFdA09CrSVoqWr7qnYyPbVoF2J
	 tbxLbEMWEqB/B6NWQs9SNNRQjn7YoZqfSL6DsMWin9qrnAwXNm8yLjP0sNd/wjVSiS1nQ
	 1Rfd4no8CtFl/6iv76zyMpA/3/xQSa+9taN5iBLoOKd6BkA7KLxeFc9C70ZZQUQSt3fca
	 klQgOKNj73BBKFlG0EuCDnL5NM1QxU4fxlHd48BfE/nANUibWhe3eiDh00cYk4zAA/Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=weQ92RIT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979CF606A31E
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 14:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 979CF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=weQ92RIT
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so3054390b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 06:16:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795529804; cv=none;
        d=google.com; s=arc-20260327;
        b=QRlHyBj2CyFhrOYDg8VIDfMa+f0mJ///QNxCvFurm6/eXaAnQPiPJa7JdcgjpUI3y5
         NzSKkXIjp/mwcVUIBVJHgQw+5sso8gUv9zOhyEINhv/M7x4JDHjB9YEeS5i1MHDkT/F+
         dmGp349CIaDcKu8zQm8hnHnpSao68k35tvqHbfBsmKNkdhpmDKXjyDQgpPlaBdFlEbE9
         iccz37m+XvPrvbF4flJZBtxScnBGtjQGrtutoey+OhvLL+zzVUOnkwAi7Psu4k+xFvUm
         sv8abHOxWPf5+8a5cI9jVT0DSmP61hXl/AukiI6S6imn80c7E14da0aIBm3Kz16vsoX6
         1emw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L/y4bV9sg4YOxw1y8ENYHV1fp3m5L4dzAun12g4rsko=;
        fh=/PsE72dTm9wkWXQG8IZ6aS1iGFFqqUXRp7ZoEUfSxjM=;
        b=MhMEeB4rktkUMgYHN8rT3Fbka1ACoPOSl2Q0PnB7qvnbmvDlm+Zs0ixT0Wj3QTXMKv
         OyYFPhgcvKODHiOOdJsAQH/7ImgCyX6eNYOApLtS3DcMHcUZmgVN8jGksF+0evmdaODW
         kOBy5sWaBoqjpW6CP6k8iewGbEwApoB3BKl2EbWwIeZuFFbZScZST/xlLRL/H3tajwfv
         Zo4C4mdoZFchrCSXGsdpefxvv0dTk6mYccyf2x8Xj4wxD71upKHPzARQnSv/iy2mmlZF
         9fpG+GoVCeymApauX5Io/4GpbqUJQM1bD7LmInHHO0OiZPau+OEwctEXY05l09+98MYU
         fLXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795529804; x=1796134604; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L/y4bV9sg4YOxw1y8ENYHV1fp3m5L4dzAun12g4rsko=;
        b=weQ92RITyg7JmS1ykhrmtx4rlzxrZ8f1H1jsn5wV5Al9jkvd8yL1HAtKWhLsplTmtP
         4UL7LauOKi3Ccq5BbdE6mSY6U0Cgxi/paZI+iqEv8X3XOgQGITF6ixm9aJOwWDfx3fg3
         wxWYuWesUJnEGfgEsDueZuPB0LjIq1kjRtkgyleFN1mJa/Mh3rX6cfYN7QSyvNYvClDL
         q3D97ZPX6erhS4ivNSE2ZS+2pr2eZledrjKcBQDPZf+3L9QFotwb/INCmvCBb/Z2WGhL
         3H2xdE71U3IjonoBsdTPjvPsax2cfwPIM4XfNArI18KPUkycKWNcgdxeDyFlWU6n9/ZW
         A9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795529804; x=1796134604;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/y4bV9sg4YOxw1y8ENYHV1fp3m5L4dzAun12g4rsko=;
        b=eRNuril/3Q/344MsUFBUGjo5B358A+JBLao8FkGyIjEO7XqeP35xej8+bN7ca+L72v
         RbxzBx8qMLl6NAyzCi0SXUGkzD78z9DJguNGyCdeoAoPKm+0ThuJmmqcLlmtGZu1kE2/
         GyjlDAh0PFJJAE1gyGU2aBQNwk50tFdRZnlUsgsFuayV3QqXCUN4ZWnDMw6iRYOQ37uM
         R/2wwN8KqrjMr1+VHxNVcEvo/S9LcTObtSrBbAJsulLiUy1zNooiwn6KKd5HOM+VxRio
         GoklMFSrcCmH1uMbCF0+dlXnT+IdydGBEFtQtdxsIpRY+bb/dJaYic30wUUAxf0yzI1u
         95nA==
X-Forwarded-Encrypted: i=1; AL+hErFGYHFu6HovKRxmFtnkY19iIjPB1sqGM2mkOzkLHow0l0SWg9UFoqRr5strFwP1WJB2zXLtLSKdOT/z@vger.kernel.org
X-Gm-Message-State: APuU4Z+PmSpPZzeCjjpTrkPky4vs0hCg6WFbyxHGImpWyTdscapD/10u
	Lc0Z5pJ2O5HJZNb6XFmJpN/IMd+XdE3oHHAboJ5hcVY3+oGSTWXNqlgoP0zOo2I+FaQScL9ceAg
	zPmZcgrI1bwYX5vbvurqwd/16C9ZqOrY=
X-Gm-Gg: AZFdTZflRQtbJIWZRSk7Rqt9xAB678kyBicYkhhcAuF0NJLRFMBV9+wFa19wFp2PgvJ
	XNmAqUP4n5zhYE495v7Cm+5ko/j2o14iOocvREyRdD5AGvH9Xb7t0BSB6g9MG1YXi8bdrErbdP0
	alLbqjUR67UPh9QjeVNAG1/iPfpSlnp/WA2U8IKyVc+7mYDuX6f/ZxAZ0XoBQJwBY7E5qGLCrvb
	Fw/jgKjXbVUK6tyqXh+egh0NjxFIi8HrjaZMxA94ctraYmi8nJ8Rc3GJtQ+ILpfcoq39yfD+uRQ
	ilE4ieYIDNo0z+kpoxyi7A7V/7jahoY0P7NJA5DT9Tl4lz/X20KLks2SFe3V/oPRTliqtQr9uet
	+8xbDIjvIhqDW4U/k4XyORNEoMVRRTcpwbF3B7VUjlKwEUk5Mw8eC/vTBGCS4IapnLDJ7MrhXP6
	frPauO5qvR+a/xYr3zzpDbXz6632WdkVIT2lssbl2DHFi/NbbrfMebK5PJlGJw
X-Received: by 2002:a05:6a00:1382:b0:882:7bed:3b3b with SMTP id
 d2e1a72fcca58-8c87c481e1cmr12587650b3a.36.1795529803877; Tue, 24 Nov 2026
 06:16:43 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179542222978.3276016.1235014191109840927@gmail.com>
In-Reply-To: <179542222978.3276016.1235014191109840927@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 09:16:32 -0500
X-Gm-Features: Aa3M54qTcW6bjqprusjNBKAhplLWpxLKJ9CCK3e-KLDt8tRi922IzPjzhVFOK78
Message-ID: <CADvbK_d1QSJ3sDjLY1G4etCgsnrdzu-nXnxJoDvGR7gTot95iA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: pick the AUTH key by the data chunk type that
 is sent
To: Kyuwon Cho <kyuwoncho18@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
	Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 3:26=E2=80=AFAM Kyuwon Cho <kyuwoncho18@gmail.com> =
wrote:
>
> sctp_datamsg_from_user() takes the chunk key only when the peer asked
> to authenticate DATA, but with stream interleaving the message is sent
> as I-DATA chunks, and _sctp_make_chunk() marks those for AUTH when the
> peer asked for I-DATA. If the peer lists I-DATA but not DATA, the chunk
> has auth set and no key, and bundling the AUTH chunk dereferences it:
>
>   KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
>   RIP: 0010:sctp_packet_append_chunk (net/sctp/output.c:264)
>   Call Trace:
>    <TASK>
>    sctp_packet_transmit_chunk (net/sctp/output.c:189)
>    sctp_outq_flush (net/sctp/outqueue.c:1112 net/sctp/outqueue.c:1218)
>    sctp_do_sm (net/sctp/sm_sideeffect.c:1826)
>    sctp_primitive_SEND (net/sctp/primitive.c:163)
>    sctp_sendmsg_to_asoc (net/sctp/socket.c:1919)
>    sctp_sendmsg (net/sctp/socket.c:2086)
>    __sys_sendto (net/socket.c:2283)
>
> In the opposite case, DATA listed and I-DATA not, the chunks carry a
> key but no AUTH, and room for an AUTH chunk is reserved for nothing.
>
> Ask about the chunk type that will actually be built.
>
> Fixes: 0c3f6f655487 ("sctp: implement make_datafrag for sctp_stream_inter=
leave")
> Reported-by: Sashiko AI review <netdev-bot+sashiko@kernel.org>
> Closes: https://lore.kernel.org/netdev/179540440300.3135.8565987128928534=
228@kernel.org/
> Signed-off-by: Kyuwon Cho <kyuwoncho18@gmail.com>
> ---
> The Sashiko review of our earlier SCTP report pointed this out. We
> reproduced it with a test that enables AUTH and interleaving on both
> ends of a loopback association and has the listener ask for AUTH on
> I-DATA only: the first send() oopses. The test also works as an
> unprivileged user in its own user and network namespace, where
> net.sctp.auth_enable and net.sctp.intl_enable can be set.
>
> The patch was written with LLM assistance; we reviewed and tested it.
> With it, the test runs clean.
>
>  net/sctp/chunk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
> index 5b889e89e9f2..0ed251421cda 100644
> --- a/net/sctp/chunk.c
> +++ b/net/sctp/chunk.c
> @@ -183,7 +183,8 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sc=
tp_association *asoc,
>          * we need to account for bundling of the AUTH chunks along with
>          * DATA.
>          */
> -       if (sctp_auth_send_cid(SCTP_CID_DATA, asoc)) {
> +       if (sctp_auth_send_cid(asoc->peer.intl_capable ? SCTP_CID_I_DATA =
:
> +                                                        SCTP_CID_DATA, a=
soc)) {
>                 const struct sctp_hmac *hmac_desc =3D
>                         sctp_auth_asoc_get_hmac(asoc);
>
> --
> 2.43.0
>

Acked-by: Xin Long <lucien.xin@gmail.com>
