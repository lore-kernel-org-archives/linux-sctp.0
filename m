Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4103B0ACC
	for <linux-sctp@vger.kernel.org>; Wed, 15 Jul 2026 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132156; cv=pass; b=eoF43E0DyAVjGV8RZmlixmHxs41Nl6C+0g9rrT7yRP9CDQc8H9sfJAjT0xc8WVPW+H6/RPsehMY2lp5iKy5F3eZqTnp4dd+Xl5MiOt0Eef1kNcn3ShK1Yp94lYYDVVozlzEC73Kk7xIKDsGhOpY274Me6kDGRCSc85f5V5bs+ms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132156; c=relaxed/simple;
	bh=FWxiQlTdycZ3hlyFTtfVocuTp0ZAD9+zUnnyMVWM3YA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SM2YM0w51SXk0aS5ZgB6kCDPyAPav/LojAtQFOS+VC+7oKWWwktwCEq62egVmezR5sZ2U8aLy0UK1fuB6JuyA3aS1a114w6s7LUVsQAfYCk6N7OK6PMTzCG3KlkgGzvzxCGsMzqE0sc23LN/Ugl8WNwQu4zPHpeNCqtLqgGigqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJkCsuZ5; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJkCsuZ5"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-848479c9bd5so1939703b3a.3
        for <linux-sctp@vger.kernel.org>; Wed, 15 Jul 2026 09:15:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784132153; cv=none;
        d=google.com; s=arc-20260327;
        b=qhwpZzkRKeMtyChqJoog++V/mKWYJd7tkqq/0+WgvFoTtfaabs4Rc5dE0O9mmaGdXe
         YJM/YmdI0Lq1epuGci2DZt7GsT7ZQiRyxBBrNcqix/5COW5Xqn+3KbwGUuNJwE0/u4fQ
         JQD+IbnbbEwHw+Hhmc464RK1Yuso09si5SDJosA3GcU1Yero/0w7rO4JY7y8RinXeguK
         4SyaufQ24yR/U7n6PAPJOe1Dp5vfdxnbBqgnEnLy7omapl6vJIMAtbmh+/RouJHJ1EP6
         Fd5y/42mWYx78uvoxz4ZWGmVR2B+AH7ra30iwcIEjJivw4R8fkKK7eS0D2eDsRc+/DVk
         1TkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=55U5jPSUwP069w7ruvqo1At+jwtU2ebGa6t3Zfz+ez0=;
        fh=+xrNCgM126b3saHmcGyLlpvQAYdaeXVGpwxiyu6S2tg=;
        b=AYZlfow+dgBr0SFd0CDXHb3wp/vgf2s53l3dBtmGP0/wLqKhezQx5y7L+D3+ZNRylF
         oOoiu7kpIgU/7D0RStL6XTezGJGT2mrt2X/gUD+OSWCa9Rz6GAPi2lHO/+1UxUXza5Ui
         HzQSo7OnXmkCB9Vlu+o4Tdfjb6fGQ5y+XbG6sdQfPMArTvs4LobrI9n3qvHJmnEH71sG
         ZfJosNY3tLcR9CpTJ8H4X4cq8swauOYJbv2lKz2LFCD6nvEdtWyvKqTRmLA9px6zCuN6
         yCGAgZQ3mi8VMcE7XfRVBFi5Zv31dalFdGGM+IIoTRM0YhyU8ynIfEMoEI5FiMrzqfOG
         lLGA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784132153; x=1784736953; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=55U5jPSUwP069w7ruvqo1At+jwtU2ebGa6t3Zfz+ez0=;
        b=gJkCsuZ5UQVwFiaMjQHDwxGR11gsOHa8WB+CZdbI5DxcyZUWGLC2oUllK/RAyajXQz
         7Rsn3mRu3MxwEXIzjklOlkPHEuxqYmfKzl7TCp+UHNHSr49OUXtE6UBN7GerfWa5PgCg
         E0PAPA6sqPxbo/lg8ygU6bXyG06906yuoORwfzTpY6bPUc+w59QPRefinlTPCuYc1d+p
         6/2HOwYc6gcixegPEaZLsVUqUyKz6BX+VqP3q4j9wxA+YRSjlQSlwmYXnUZ8VKkXNUq6
         4xAeS7znJdgwoJMr6AA3M+kBktQSktWidp5ohAvUnR131kHyv3vRizpZ8MFUP7Zbk3ac
         pI6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784132153; x=1784736953;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=55U5jPSUwP069w7ruvqo1At+jwtU2ebGa6t3Zfz+ez0=;
        b=sV0Ev8+toRAXn8U3fu/G3dPZJlpXSbtULA6bCyyK0QuzUPKaKQFf1RPwqNWHZfZF3c
         4S/0jTFv5W38eh+ipR2PQNI/joPbqmuqJYqZYzQhu2WOnomXquJBHMKmVDmXKiOCgco6
         Em+XYoQmW7RQxLomSzxomEiGBWfaMhZ2BMmhoHPSldY5UtedPprkWz3fEt5yRWmCoI03
         Hg8j3C9c0E6Gt8/g9KPBjwlDxpEoNKOT0NEvxwZQK72zXCXuFn1WBiugybjmrRRlYkXY
         HDYH+SPRaI8AXglYouMLXt0Pvzzq4WSORnGTG2VAhOqnUCKr1tD/GwoRF1cPOee//48Y
         iE2g==
X-Forwarded-Encrypted: i=1; AHgh+RomTy3ZZO5YOeZB+maSd90gqaJpaS7oJdQtZUIFyzrGSugo/LLG73g0QTQyr56KTGNrHkS78idVOll0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9fxO27vRlX+KqSMAqcfdza83qlnJ5+ep2JurN5mTaHP3rf4Qn
	l2WNTjNYXpO38Lesa7BhYxGbmSrKSUobJBrTPGhDIX/BHr6fymTLKbYgjvCIJMrliGFKXSRFFsS
	qNsKXUxiNQz3WmZnlwbYZsmMoelJZfvs=
X-Gm-Gg: AfdE7cmmO6l9Ew6c/L3pVFXsy5yD2D+mdN1ebAQukOnjW8szUkmKGdz3oVVZXjxL/qI
	cMUSYSqBSP7KPiG4lgpdhI2FTuxzaJsl99cG/9nTfoSi69x2UXNldgBn6q3JjTJUt29NkiJ1KYL
	3SG9HVGcwSId/PtLCG7g8Hb4JiWPbhtlwheISHYlWxMG/VpH6oGC99rhevxLHyBGvApuMNdiPj7
	M9HisiK/BOkSzV4dOUsIslLx9diVZxhbda2hQz573H7O92sleTFo5GeWLDBoCc2deB8NhulauHB
	LGPK8FKQ46WvJpMsUcZ6vUPX4hZ2XjzAQcVsxMpfreFMuo9GTLc0AqEXVLk/XRWInMjSeDA0
X-Received: by 2002:a05:6a00:27a5:b0:847:99bb:b6d0 with SMTP id
 d2e1a72fcca58-848896bf0bbmr16582991b3a.15.1784132153108; Wed, 15 Jul 2026
 09:15:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715033536.64963-1-omeux327@gmail.com>
In-Reply-To: <20260715033536.64963-1-omeux327@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 15 Jul 2026 12:15:40 -0400
X-Gm-Features: AUfX_mxyqRaNfNT_XTqID_5ulkJvqsCBG2mC6ONt8peeaiBkWktmOsu9fvIkJOc
Message-ID: <CADvbK_ew0KJjY5Ya64LTFgWastL34A7LNOBFqFjJUceGS+qHCA@mail.gmail.com>
Subject: Re: [PATCH] sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS
To: MingXuan <omeux327@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 11:35=E2=80=AFPM MingXuan <omeux327@gmail.com> wrot=
e:
>
> inet_diag_msg_sctpladdrs_fill() copies sizeof(union sctp_addr) (28 bytes,
> the size of sockaddr_in6) from each sctp_sockaddr_entry.a into the netlin=
k
> INET_DIAG_LOCALS attribute and then only zeroes the bytes from offset 28 =
to
> sizeof(sockaddr_storage).  The same pattern is used by
> inet_diag_msg_sctpaddrs_fill() for INET_DIAG_PEERS.
>
> The IPv4 address-filling helpers sctp_v4_from_addr_param() and
> sctp_v4_from_skb() only initialize the sockaddr_in portion (16 bytes) of =
the
> union sctp_addr; the trailing 12 bytes (offset 16..27, the sockaddr_in6-o=
nly
> region) are left uninitialized.  Those bytes are propagated verbatim thro=
ugh
> sctp_add_bind_addr() (which copies sizeof(union sctp_addr)=3D28 bytes) an=
d then
> copied straight to userspace by the diag fill functions, leaking 12 bytes=
 of
> kernel stack residue per local/peer address to any process that can issue=
 a
> SOCK_DIAG_BY_FAMILY dump for IPPROTO_SCTP.
>
> Fix it by computing the actually-initialized length of the address from i=
ts
> sa_family (struct sockaddr_in for AF_INET, the whole union otherwise) and
> copying only that many bytes into an already-zeroed sockaddr_storage slot=
, so
> the uninitialized tail is never read and never reaches userspace.
>
> Fixes: 8f840e47f190cbe61a96945c13e9551048d42cef ("sctp: add the sctp_diag=
.c file")
> Cc: stable@vger.kernel.org
> Signed-off-by: MingXuan <omeux327@gmail.com>
> ---
>  net/sctp/diag.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index d758f5c3e06e..12557e924cc2 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -85,8 +85,12 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buf=
f *skb,
>         info =3D nla_data(attr);
>         rcu_read_lock();
>         list_for_each_entry_rcu(laddr, address_list, list) {
> -               memcpy(info, &laddr->a, sizeof(laddr->a));
> -               memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr=
->a));
> +               size_t addr_len =3D laddr->a.sa.sa_family =3D=3D AF_INET =
?
> +                                 sizeof(struct sockaddr_in) :
> +                                 sizeof(struct sockaddr_in6);
> +
> +               memset(info, 0, addrlen);
> +               memcpy(info, &laddr->a, addr_len);
>                 info +=3D addrlen;
>
>                 if (!--addrcnt)
> @@ -113,9 +117,12 @@ static int inet_diag_msg_sctpaddrs_fill(struct sk_bu=
ff *skb,
>         info =3D nla_data(attr);
>         list_for_each_entry(from, &asoc->peer.transport_addr_list,
>                             transports) {
> -               memcpy(info, &from->ipaddr, sizeof(from->ipaddr));
> -               memset(info + sizeof(from->ipaddr), 0,
> -                      addrlen - sizeof(from->ipaddr));
> +               size_t addr_len =3D from->ipaddr.sa.sa_family =3D=3D AF_I=
NET ?
> +                                 sizeof(struct sockaddr_in) :
> +                                 sizeof(struct sockaddr_in6);
> +
> +               memset(info, 0, addrlen);
> +               memcpy(info, &from->ipaddr, addr_len);
>                 info +=3D addrlen;
>         }
>
> --
> 2.50.1 (Apple Git-155)
>
Acked-by: Xin Long <lucien.xin@gmail.com>
