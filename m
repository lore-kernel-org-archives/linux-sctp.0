Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794325666;
	b=nBp32Nzklgry17Z5B1Nx14rLebSTg9yPcdgqZe78otxGCJ5N7nIemJdtCaj+EnXcUa6j
	 WV8UEh/285e+XOlDyi51Sn7speEEZr9yag+MPSASp5M0EeMNzfzmGSgWUdYuQmsTNYPOt
	 4DkcmQlTVb1YxCkpW2XbPW4ZSvq2vuI6E/ss9pAyy3F7cBaiDuAQCXzAcROxmdErDVfpj
	 z2xAUyBMQyjS1JrUvMKZd+Q1hUT3RKEsTKPtp70bUAVWEtGYCOJqZsNpK76IABCF2hqtW
	 0mg0BhW6CZ1ca/TBZewd8Q5h6ggSPgxaz3KmT/SxaZ2OSiYqCtnNlppLVkrsfCj6p/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325666;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=czf6TxvkDXLy/zkO0/xTOB61Eq7kaspeLRCs9D7lhNo=;
	b=L29JvIX0Q+YXwJ/Vuu0NvSpt8YyfsW/10W6dM3Cz5+8Ni8gB+gcSTtgBnfDX9Zz5oFbe
	 xqOuWEfqqjcHoMphD1q3iiB/e7OfstaufTFS+VakJKLTtkamCUkOv7JzWIkUERNJke0o9
	 jnRTryWwRjnkbEgXEE8vuo1um0ckZMsTMK4EWPFdl6SlpIz+SBZutMTcQn8GxdRzV9d4P
	 kFcy1phxo38VhfCcC0cpiy6ndBVm5kzFYkT05EywyH3oNY2Xrvi+iC2t7T7ej2uxRgRwA
	 zU6W0oAtCJT4aDKQxBC2yuNMUN2wqthLIWnGIIFvFuYKC+jwPFw7xoRvNbIzVA+aYZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="I/Lw8i/b";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C9F606A325
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 15:47:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33C9F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I/Lw8i/b
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-74ab99038afso1819311137.3
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 07:47:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794325665; cv=none;
        d=google.com; s=arc-20260327;
        b=pgANghA+1V5gU16jTAADAZ0+PoObvMnZvDbHt/Oj3ohiUIjMZTLiDDzTJDA8gbFeAA
         BU4UdKYjhIy8V9GuD/w6P4UclAjlX5egx3e61pVjd/8+UEIHqzboxbesLY9ed+njYqS/
         4kdc+vNCE2HHstOubUrml2nuGFRAlrmhYIOyWEubIniXmYdUCqxHbIx27oKOVzKZQsYC
         D4AY7N/sKTwuplV23gNGp8z5Ao+mEtdwLiMoQsVMTZSpcdwCjWfvh8mAsgRDwsdzzJZ1
         hsK9En2dqO4gdPE1JGFVXKlBy3ZrheOs/7XnmG6la870STh9gwoCPET+yTQT1lR7MGrK
         GVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=czf6TxvkDXLy/zkO0/xTOB61Eq7kaspeLRCs9D7lhNo=;
        fh=Wr38bwDAGAcmCQuJ3QRHJIzdmpbiZSYfCsM1cMV/jnA=;
        b=ccpqN7WDG3eCM3CnO2YG3pR9tgd54X8DTLz+L2d4FdCiGH2nA/Sl3i+l4b6iDDtGHR
         rUP190ccVveaSst1+NaFfyRnILaTfsn1H6UE4Y31tvbdLGpSYbvIx4PZodDzBJyaOziM
         0aQVaMWiHKWS+YuYFM+PDz+4Wob78Gz8hYgqEN6Az/Agpm0YNjgGTQKLnDhsxWTd60B9
         EX2NUUW69nLa+1k+NmReMuhd8JRcfeEA5dRr4k+IGKT1Xd0monist+ATlT8PQlvBrwLa
         F/Vh+qV/HGxU8SSwMronnrLzrAaXzW9LKUIJB3xfi4jhe+NfIvIRYwicOnt6KY78qmPl
         +qfw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794325665; x=1794930465; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=czf6TxvkDXLy/zkO0/xTOB61Eq7kaspeLRCs9D7lhNo=;
        b=I/Lw8i/bwk9+5IhcqVCZ//ULNLAb1ddsCuYGASvGUAtyPg5imkQGj7iIi6g9XzOHft
         BYd8pOWh//XX/U7aTv1AlumnSHl2fuaM336e/9B/kNktK/7WZQdorEuxWpAQETEf3v8l
         ZHO0/DHb/+jabyFywg3NjkTKHajEtGyJ/mmKwAr/U804Ezjph5uK8BSRbopqU+PfHJGg
         G1zQdTsvH8ZEma9FpollCfKMGD0QMGV25R4SD94smgtLwY3tp9Vwzmqc0dNmSvKjCBAq
         brmaxPH7SXPwJw9514sCKmzKCvZ5YxW9h8FSc6P8fRzgNGJvIM5b1dfu7Tj90kbhErfg
         Ajug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794325665; x=1794930465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czf6TxvkDXLy/zkO0/xTOB61Eq7kaspeLRCs9D7lhNo=;
        b=z6pGTzgqRB0cnBaehuPJaSEBp49zeWQoxLDTFIzClLCcLm1mSYHNl0R8ymWxAEXEKm
         8l/gZW0zuKluIAprK/3qSWkTEfCfr96w8F68zLM1qMrf7VH+Q1IFfn2sv/TJmtGIV0ct
         AHggiDpYNGZz2DLp8SH7bUnNtI6+BpBXM5Qe4riqVbSq3zo6IwJ062/aStxziLJrauRD
         TbGcKjMOmOv04BtqMbNd39TMMOwwhZWf+4ThbJMBR+F0mIWJyxVg6wpOHV8NQlhl9s1Y
         Qd6JORl1wWa+uSOtZbJw5tCOv8l1aCO93N+rv0h8q6tS5QyQKGT1Ab5bkYiV6Z6hNKNr
         kLeg==
X-Forwarded-Encrypted: i=1; AL+hErHwiLTSSM8BDXPEctkwdiDp44F8uiMxF3Ml+TdMXy7zHXqKaxk2pRC/C0C8R9aJCgwz3oDNNKXVcBU4@vger.kernel.org
X-Gm-Message-State: APuU4Z+HE1R8OztqZBBqH2CSK3K82hflMdEpHTEaSg6yQ0G7afd/Z76u
	gP5oi2AnWDzoz+zV2iEFnaf6UkB9VZExqzzi+L1WvsqgEJ9MWR/fScoxy71Z5YyV+55NcKmneyP
	Ue1fv1DmxE3BaGJmuX9GMjohYKXoQom8=
X-Gm-Gg: AYBFou0v8Q9srgZa9CkslTxg8+kbx9Hn/xxi67RlFsdLn6EWVnSxt3WSWnqkZegGK0O
	N8s6McXDIQPVn3iebGb9gn2O+yEsUnNU7uOxbfSoqhJUsd3BdWFZOBgdGyyzxxO3MoXWg3r0Zht
	XDJwurLjiaS1nuG4MpSNI3q4XxRaAuWNCxznpDnPqEYVI+Z96eYmE1BUvFNAruqYayS5Wz5EoRf
	9qbHRaK8cNQHJqAETNEskkgc1iWkZtqpgyZgwesXlO31YYfd8ksYpm2fidsnGfThv0lLhsnOmmv
	pdfhBJVRyh9O9ApKI0H4ywpsfeEe+KF8MWTKsIo4t9OWTRKYYUyMYQg2JE94t57+LcdFsLOR1bZ
	NQzam++2qHoJ5vdPUkLjuMsrX7xwW/tnzLC4P4yiLG4mYjbTB1ZG7Nbrdo05Tmk2gyK9dUhmJ8M
	qF4YX7p9Dq3VQYEa8u6IBAN/PbRrou6xvAW0Qt/g==
X-Received: by 2002:a05:6102:1606:b0:7d0:5688:f4fd with SMTP id
 ada2fe7eead31-7d301bdfadcmr1347648137.17.1794325665086; Tue, 10 Nov 2026
 07:47:45 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106185203.3326303-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261106185203.3326303-1-bsdhenrymartin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 10:47:32 -0500
X-Gm-Features: AclHuK-W2zfpJA0Fe0m-8dv7qSw468L0XRBR04aNiVAdKPvb2KSOSY4FgSHidEw
Message-ID: <CADvbK_daN6zZNPckkGh=r70ooNwTz59VViJy5jPp1w18SDPrzw@mail.gmail.com>
Subject: Re: [PATCH] sctp: fix skb_over_panic when adding addresses with a
 pending delete of another family
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, edumazet@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 1:52=E2=80=AFPM Henry Martin <bsdhenrymartin@gmail.c=
om> wrote:
>
> sctp_make_asconf_update_ip() accounts for a pending DEL_IP
> parameter by reusing the length of the address being added. The
> write-back side instead serializes the pending address itself,
> with its own address family. If the pending delete is IPv6
> (20-byte parameter) while the added addresses are IPv4 (8-byte),
> the chunk is allocated 12 bytes short and sctp_addto_chunk()
> writes past the end of the skb. E.g. on mainline (05441d697f7f):
>
>     skbuff: skb_over_panic: text:ffffffff84859c77 len:392 put:20
>         tail:0x188 end:0x180 dev:<NULL>
>     kernel BUG at net/core/skbuff.c:215!
>     CPU: 0 UID: 1000 PID: 379 Comm: poc_sctp
>     Call Trace:
>      skb_panic
>      skb_put
>      sctp_addto_chunk
>      sctp_make_asconf_update_ip
>      sctp_send_asconf_add_ip
>      sctp_setsockopt_bindx
>      __x64_sys_setsockopt
>
> Requires addip enabled on the endpoint (net.sctp.addip_enable=3D1).
>
> Account for the pending delete with its own address family, as
> the write-back side already does.
>
> This issue was discovered by Tencent CodeBuddy Security.
>
> Cc: stable@vger.kernel.org
> Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host=
")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 90de272842512..18947ec5ff9f9 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2886,9 +2886,17 @@ struct sctp_chunk *sctp_make_asconf_update_ip(stru=
ct sctp_association *asoc,
>
>                 addr_buf +=3D af->sockaddr_len;
>                 if (asoc->asconf_addr_del_pending && !del_pickup) {
> -                       /* reuse the parameter length from the same scope=
 one */
> +                       /* The DEL_IP parameter is serialized from the
> +                        * pending address itself below; account for its
> +                        * own address family, which may differ from the
> +                        * added one.
> +                        */
> +                       addr =3D asoc->asconf_addr_del_pending;
> +                       af =3D sctp_get_af_specific(addr->v4.sin_family);
> +
>                         totallen +=3D paramlen;
> -                       totallen +=3D addr_param_len;
> +                       totallen +=3D af->to_addr_param(addr, &addr_param=
);
> +
>                         del_pickup =3D 1;
>
>                         pr_debug("%s: picked same-scope del_pending addr,=
 "
> --
> 2.43.7
>
I think with no longer using addr_param_len, you can move the
if (asoc->asconf_addr_del_pending) branch out of this loop.

Thanks.
