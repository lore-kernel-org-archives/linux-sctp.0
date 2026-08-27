Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0AD3803F7
	for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 17:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787851112; cv=pass; b=sm5g+7BZDQKjZ+bsgGIGGBoEwXmeUyAuQ5q6RR5n2+LJ1+R2SlXPk5Sn/y7cyTWOeO0NkSaE1yCgn4oGXqJxozAmxBS8HNWOBdUofqnSXcCHlL15YNfAhBZ4YTAvjXX9H67C0jri3BrUhPUrHJ4bIiH3U96lVxRXzzaOx2Kp7g8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787851112; c=relaxed/simple;
	bh=dBUBPexRlyMLsVoGjr+3rtevSBmSG8Ic9FKpcxX/rGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h1qq0y2lOKyR08KU7Ggii60SLDaZc2YUw5TucREJbynT+On1TtjQoFKqv6Wn6dMVlVMrgjt1sPyaTViVPj9iWgeOMW9CJadmfK9iaZkR9f2BL1CmNW4bg+lA4a0NGLNWTtuvKkvGrf3XTln/DWzCaDgLuW+Bc3JbWbm8JC57lK4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sn4TZopR; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sn4TZopR"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso22653b3a.1
        for <linux-sctp@vger.kernel.org>; Thu, 27 Aug 2026 10:18:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787851110; cv=none;
        d=google.com; s=arc-20260327;
        b=RFisV8T+sjU1Zvsiit1rY9GmSSsRiE28AyrqyL39tGkc8qbPfuxCFPnTYYGd4371i4
         JedfxoGYueF9Ds7VPNBAf5ppx932vwfgDCtq+hrTX3Jjopdhloj2uDCfOf1VxInYpMqF
         t9IIhCyY7kL2T8suDjsKgpM196I5KeO3vdwBSXa2Bwt5rJT5X3Qq32NydE/gOFMfBVwA
         vI2cY6sHCBKYMMnUlKwqhRQw0uVnjvUw4+Kh2d7Na3jygoLpwt7IkRm1Xly86ZpIY808
         nCgeZ9r8Uv6n5e6QmZG14bqtzbzhFrpHC2iZzB/GJ5pYueuE7mu2voOkAHnIq5x/Yy4J
         sdcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YEtozXouVWJGqO6lpvX2FbcKxusT+Eqsv3MS9X7Ic+0=;
        fh=iAzEH6mBXaLSyaw/cgrLyti2xtMw1+lXGbS6lgsuKOg=;
        b=eZ1mS88CiVNUKNJFrJ2pCTX1QPi5foCK+9W0uraBNagJTRgbrM4UTJOcA2VQq25dk4
         PE6B8zm6ilu7C/Kj//Mm9i4zATdlky2Ild1hsZ0dVdVphO9owt6p/jO/eEoFpORJPooB
         dARWx6rKRlBubb1Jwc+2Zg6SaWQQrLpxEPccjmwUaJbNIraB0XAPhhUAUcOhN5q9PRGr
         8zy3U7/crMZKbhgwnZOPCuKzJ0bm2OgLHQh5m00Lt7KpcbWUavtN/BzMbLs5HU69cYyk
         ErXpp7GpA5tHWg625o6ZHwlsZcZkqS1sCTPAwq/LqPOw3R3mv6c/ARef+5/v+yOkTr7l
         XRvQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851110; x=1788455910; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YEtozXouVWJGqO6lpvX2FbcKxusT+Eqsv3MS9X7Ic+0=;
        b=Sn4TZopRyCYsnz8ga/aG3HyirHTm6zbi5Gy8J8e+Zw/OLjgMbxi2LgutE5yv4r8uQW
         D+RxU+hsIgDPFC+UCm0z8hJo7vw0wY8brvOTay40wqAovwKzaeGb3UCvRW6vwvTy1fgv
         70Ymzt5j7t07ZvEnvfWr5qO8adsU9V3hSXxaOfKe54DEapdHyXc5x+ApgxdZCJTKv92D
         912OjktLIOsl0zljMbxUbPqV4ivQ5RHe/8iymoNQZbkW+vJaftme+viFFqgTu2sWlpRP
         OIC4Fa3q6nFmsWb/gyY+nibwlfFSdDIJA9kyrlkVJSU06imQ78/5kiymAOr7PAEDAk0f
         SpdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851110; x=1788455910;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YEtozXouVWJGqO6lpvX2FbcKxusT+Eqsv3MS9X7Ic+0=;
        b=crE8MF94Jbbo3oqCcMcDQT1bWJOT0rdZYUKpJ7op1qE2nYrI/SWMV3DV7aULf2vbpy
         xPzDA6101T5YUaCcjT4JcZglLUunwXO+SrK0EGLYAWmeuShNl8y7mTKFTjkGMR80ZGaA
         9GdPi1CAh8ND/k+skV766GzAwQ/iDZZp8FQBsUFTqDSest4cuXmYqMoRBwqY8x+U8Mpq
         5vI/kMA6IzfepzAT5jQFT4FE3es+pxbIAKmunIPTBbbS6IYTpVgh2mxCuDvHdxNBfw+/
         Vkzx1h6EFtycFbZhc9SiBNZg1yWLpZVhvknZ6umi1uI9XCqHsvH3Fh/9xcNLZsK+kIuU
         kCng==
X-Forwarded-Encrypted: i=1; AHgh+RpvxkMUqlz8cvSxnC6ALlYpbTF3QFCnUK0P5eak26b4cibG0DtbnAQUAdWToBYe5Ut4TjZXhG5swSID@vger.kernel.org
X-Gm-Message-State: AFuF++nggesk2TR8F0VD42nH21W5IY9xHLCnREFe+D6P7zDt3FiyVe33
	+M9GfvSBo80NzmV4dn63a7MbSz7LyoMA5ibbGosjtNTfunK9chO5iXo+NBb+EdhgGClJsfrS5PR
	C7uqp7GIzm/qqWlF7tdb09Vbrn103GBI=
X-Gm-Gg: AR+sD11kexLIz4C61tsh0MQOUewM8Tgqf2DhcLlQvc1qOv6qR0GVG4Np8/xXyx1YKIm
	OyE3gjpWYV9nrs6uyHEfef875CR0RnE3Dq7+1EQc1ZQB1RDUoPgjJeWyoH0mfEdoSr1gp351/cd
	mCHtNRuCOxiE/qXun2iYG+tI8mORYWQR6LpaOKjcDtL3nmp3wa8p6T64P9ZLBr/v5/DWkMxWuxF
	UttpwAnpLTd3p/iuENg7br1CqZgWZxqwosXxq9aYDMZ3e9RmQqE0dsLX7ig65X5sUYJ4rnz3hOm
	V63IhUCOm+44A1NT5wVVNn+etnL3pNeWStJm/cvr6X/7LnyEZnMHCIMvjF6HXOfR+G/0vv9woMn
	+iXzoq/klZdnJFy/G+9WoKFcR1BUpodYY8gdlyRCUrTQ=
X-Received: by 2002:a05:6a00:929e:b0:854:2071:be08 with SMTP id
 d2e1a72fcca58-854c6b7fa20mr9813220b3a.6.1787851110067; Thu, 27 Aug 2026
 10:18:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827075006.3979566-1-sunyiqixm@gmail.com>
In-Reply-To: <20260827075006.3979566-1-sunyiqixm@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 27 Aug 2026 13:18:18 -0400
X-Gm-Features: AcwNN1UYlSeUhyVnikOguDNaDeElz5rpDvHHe4_oAp-JS77cqmlR8-ikFEzZv5Y
Message-ID: <CADvbK_dFoagLs1c4b-3aFqsbDueu3VO0t-8S93+6GgevuoRBLQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: avoid livelock while updating retransmit path
To: Yiqi Sun <sunyiqixm@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 3:50=E2=80=AFAM Yiqi Sun <sunyiqixm@gmail.com> wrot=
e:
>
> sctp_assoc_update_retran_path() walks the association transport list from
> the current retransmit path's successor and stops once it reaches the
> current retransmit path again. However, the loop skips transports in
> SCTP_UNCONFIRMED state before checking for the wraparound condition.
>
> This makes the loop non-terminating when the association contains only
> UNCONFIRMED transports at that point and asoc->peer.retran_path is also
> UNCONFIRMED. One way to reach that state is through ASCONF wildcard
> DEL-IP processing after an unconfirmed address is selected as the
> primary transport. sctp_assoc_del_nonprimary_peers() then removes the
> other transports one by one; when removing the current retran_path,
> sctp_assoc_rm_peer() calls sctp_assoc_update_retran_path() before
> unlinking it. If the remaining candidate and the current retran_path are
> both UNCONFIRMED, the loop repeatedly continues before it can observe
> that it has completed a full pass.
>
> The same reproducer that exercised the bug fixed by commit 9b2854f86f0b
> ("sctp: don't free the ASCONF's own transport in DEL-IP processing") can
> still trigger this CPU stall after that fix is applied. With the UAF
> prevented, the ASCONF processing no longer dereferences the freed
> transport, but it can still reach the retransmit-path update described
> above and spin in the all-UNCONFIRMED case.
Please share the PoC with maintainers.

>
> Fix this by remembering whether the current transport is the original
> retran_path, still considering it as a candidate when it is not
> UNCONFIRMED, and then breaking after the candidate logic. This preserves
> the existing fallback semantics while making the full-pass termination
> independent of the transport state.
>
> Also restore the NULL guard around the retran_path assignment. In the
> all-UNCONFIRMED case there is no eligible replacement transport, and
> installing NULL would leave later retransmit-path users and the debug
> print with a NULL path.
>
> Fixes: 4c47af4d5eb2 ("net: sctp: rework multihoming retransmission path s=
election to rfc4960")
> Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
> ---
>  net/sctp/associola.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index c0512c827d0f..6f19eb0b01e2 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1272,6 +1272,7 @@ void sctp_assoc_update_retran_path(struct sctp_asso=
ciation *asoc)
>  {
>         struct sctp_transport *trans =3D asoc->peer.retran_path;
>         struct sctp_transport *trans_next =3D NULL;
> +       bool last =3D false;
>
>         /* We're done as we only have the one and only path. */
>         if (asoc->peer.transport_count =3D=3D 1)
> @@ -1289,18 +1290,20 @@ void sctp_assoc_update_retran_path(struct sctp_as=
sociation *asoc)
>                 /* Manually skip the head element. */
>                 if (&trans->transports =3D=3D &asoc->peer.transport_addr_=
list)
>                         continue;
> -               if (trans->state =3D=3D SCTP_UNCONFIRMED)
> -                       continue;
> -               trans_next =3D sctp_trans_elect_best(trans, trans_next);
> -               /* Active is good enough for immediate return. */
> -               if (trans_next->state =3D=3D SCTP_ACTIVE)
> -                       break;
> +               last =3D trans =3D=3D asoc->peer.retran_path;
> +               if (trans->state !=3D SCTP_UNCONFIRMED) {
> +                       trans_next =3D sctp_trans_elect_best(trans, trans=
_next);
> +                       /* Active is good enough for immediate return. */
> +                       if (trans_next->state =3D=3D SCTP_ACTIVE)
> +                               break;
> +               }
>                 /* We've reached the end, time to update path. */
> -               if (trans =3D=3D asoc->peer.retran_path)
> +               if (last)
>                         break;
After removing the continue, I think you can keep using
if (trans =3D=3D asoc->peer.retran_path) here without 'last' needed.

Thanks.

>         }
>
> -       asoc->peer.retran_path =3D trans_next;
> +       if (trans_next)
> +               asoc->peer.retran_path =3D trans_next;
>
>         pr_debug("%s: association:%p updated new path to addr:%pISpc\n",
>                  __func__, asoc, &asoc->peer.retran_path->ipaddr.sa);
> --
> 2.34.1
>
