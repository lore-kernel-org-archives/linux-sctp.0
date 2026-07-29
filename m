Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32440453A56
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785336219; cv=pass; b=qqidXXqgga+3bVxabC92JOdoHcKcmoQPDIEI6NIF85uAii/aGlRHNcoMQ0E9SFWaq7YOm2BIagfXsFeuezQDLdkY30NVDEGWgJpgqD+K4DlPVbuq4ydmc1EXk91gO4sLEdcDJ4OSE9WaETl4cVJ3ds2CeWsc9TjmHJ2ReTBMYRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785336219; c=relaxed/simple;
	bh=bO30GBdigpLpXr8G01gVY3c3cMypTioYacQIgy7BQwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s2f0eVJ6BYWcg8Hs36pZ8cySdDioZ3jMfyV6cWfvu9rSH6gR96Y3ewhfErWv1HzZmyIEBY7RUjWPowCjSivU6SMvnIAHKLqtmW3EEfP+rRUV0OKPqA2jotSFcqg0Sj3OVqbChYRCyRwgg05MJ5DiydBM0n25Y0MRY3u2huO54h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fd+nxQIM; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fd+nxQIM"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e27035206so1169787b3a.3
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 07:43:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785336217; cv=none;
        d=google.com; s=arc-20260327;
        b=B0H5IlcvpCBX3fGK6RQspmzVcWEUzOLrwv1ebSomptYvjqbwUuYtDsK+pT7VUS3bRp
         XMQSf9w10ZYgVaU5m5jghzpiOUV2A/DfonWSetvo+298nBcpxXzuMZUB38RwYVn7vEAC
         kb67rugch+LTPz/IsCUF8PfEzfcnxxV86evi6PxV1INxErefEKyWpEFAjK8sSOgMlMlN
         W9IdC/YahKMrY0ZF/m95Jl7nrC0zAz4XCfkmv2o9dQ7ZWeBJC67zPb2fRWYwRQ5pRLii
         VdwT8xXVEmEomCmTGIiexU6NieFa7Cdz80E1ObRr4T7lGVqew8czJ+RoY2GQbWaivHCN
         hD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SWVLK5NfeZSfuYOjxWPGReqguFO0C9gVVig1mZn9FwQ=;
        fh=RUDoUTmbleghpMtii6tjYBE5PV6ZF/janEMVlAk0PRo=;
        b=C3cOH+NTwWb2awvKWmmfrEdTcLmYPBBc7S7T6fyy/P4ykrdC62NxaEDaDyYIvIT9vP
         kmZfk3UWq0rI8dUmTG1EfyHDMhXWP0m1dXw2ME87Q7j+fMfYYV0TvcrKttuPc7NDKf0X
         6Ql0rIsTcOUI7n+bVMD+GQrTEqcLVModJBJMCkgZnF3JpmKouFBdKKpdUd0iNmUj8Vpi
         gOYXrIS0jAeCUx4jbrFuTWxfkwwT7tcW3mOnPYukgizwghFQuc2IDp5/lQeTv0Yrkkku
         sm3OdkhsVddTiVwxz1nc5g8+Qx8DRSiHhsB9HVaqRrHlW6R13/PA3x4/zp3be1eKUmbt
         vBRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785336217; x=1785941017; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SWVLK5NfeZSfuYOjxWPGReqguFO0C9gVVig1mZn9FwQ=;
        b=Fd+nxQIMcfaNLq2rpnnBLp+39h4colGbDZd3IFfNiCshwi+RIAJdXfiLvwL6loK7RM
         98Oha7t8j7cD+Dl7LeQdiQGZ4kxxOp6qSDI4MmdAR8+XT/mBrN3e10edvi/wOBFyhE1c
         dusuE0V48tnTfwOvlHNhHpuTLc3FU7OIJ+9265GJETQoPeigQwQqvvrXn+p7jnvbqZhZ
         Rj0AqfTPkSX72NxdebG2eDg2SxH1IIjZci254xm38+zjhYsZI79nLOI1HHXuHEHFs/PS
         oBG/LJxlS/A1F3bNG8mnZn1fqMePx3jkUE4C+ZrpvNMT/T99FvT0YzNMy1SLiybOhL8D
         ZtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785336217; x=1785941017;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SWVLK5NfeZSfuYOjxWPGReqguFO0C9gVVig1mZn9FwQ=;
        b=G9QS3vvVXn3D4YAZBuo2t5rMWAGJNsp3vEmkN9P7F4M6iFpI9Vy0s5XwvfZkPYqICx
         JH9BXUxJnUpf98OBCaoyICVD59pkU8BUc6+NqZqJQ36h2zGwrqNzU49tTkUMPBwcm61o
         kfoSixeKtv0Rfiu2l7lnEY189CmM4VBcO+Bpc//Kn3tt37SKE0zpSLTSGySv4kkg7/d4
         jNZP5BJ1ik9D5/6LtQmPHuPize/Dig/RN1aEuUS4988Mq7bbw2CnAaop/Qxhq3nY89kr
         bldhAIQ8cUO8zfLzcl9RlW2ytjO5Azcgi9vpqV8DmS2EO4xq1yHXpvVnh5NhCIz6BdNz
         /OOw==
X-Forwarded-Encrypted: i=1; AHgh+Rr13/7CNoAGmx0AIZxibdZnfYQijromzQ3whEEKoZcOQW+rkDi2fidy2Z4+87Pks8Uo58nM31+cjz1b@vger.kernel.org
X-Gm-Message-State: AOJu0YxeaEpkTNvP6KPbtV2JOLoGwVALl3E6Zm0Pb0Y7pLzg67RGcRUo
	SLuJpA/5p+FHUFcKEqWS9LEBLgxr0hTsaGMu9LyK+3gEKSedF8pKMBbiTMAh80EAQiI684OIzhR
	zrZOE0s+mWOdQOl+RR0zope0oucQ6PRA=
X-Gm-Gg: AR+sD11eITkqep38Mzjm47ItypiM8unVzy+opG1BX5zk3hwqFLqsuvQ7bPZ1Ebf+Udd
	3u3afnYzRFDeX0n45Wtp5UVSV9GbLwZUnmeK1lPrInDdxsp96eaKqKPlawgkFfJPwedGNqldkIA
	byPU7Cv0dDzMGD7rh73tQr+msGjRgptXt6DDfeHDmJ6Z905Sg04vYm+P3aYti+B877vQXm8eXBb
	wS04FLgzcLhqhYTdNFPoriKPuAQ/ZXIWrlz31X9e0g6I7D/kJq5OqodhrS6MJ7XGuj0UJMVnWMV
	ITkcOnbMvQwx/5uh9BsLPBa4IiMNCzzfJ5bmlKmDcGGFJRjOtCxVYgw9rmC4CMNUaBv1ngxCbmP
	GF39tmorGNc2OPOncpSKf1B47J01IjuFNfLodEB+ylPM=
X-Received: by 2002:a05:6a00:bd09:b0:847:8ccc:d7c6 with SMTP id
 d2e1a72fcca58-84e931844b0mr7932333b3a.31.1785336217592; Wed, 29 Jul 2026
 07:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
 <20260723061107.384106-1-l1138897701@163.com> <20260728182359.3cd3acf6@kernel.org>
In-Reply-To: <20260728182359.3cd3acf6@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 29 Jul 2026 10:43:26 -0400
X-Gm-Features: AUfX_myvjigZq3pCCyct8kGwuVqsXaVLLMpSYVzV2Vvf-myxU1YKYy0bIhWF4kQ
Message-ID: <CADvbK_cAR8qZwA1pAN1Kov+v-Whg_P19VK-Fzpztxc5fiwA+Pg@mail.gmail.com>
Subject: Re: [PATCH net-next v5] sctp: auth: discard auth_chunk when skb_clone fails
To: Jakub Kicinski <kuba@kernel.org>
Cc: luoqing <l1138897701@163.com>, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org, 
	marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 9:24=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 23 Jul 2026 14:11:07 +0800 luoqing wrote:
> > From: Qing Luo <luoqing@kylinos.cn>
> >
> > When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> > due to memory pressure, chunk->auth_chunk is NULL. The original
> > code still sets chunk->auth =3D 1 and continues, leaving the
> > COOKIE-ECHO to be processed without a valid auth_chunk for
> > deferred verification.
> >
> > Discard the AUTH chunk early via pdiscard when skb_clone() fails,
> > so that the receive loop can continue processing remaining chunks
> > in the inqueue instead of stalling the entire packet.
>
> Hi Xin Long, should we apply this or it's no longer worth it after
> 8e04823c120b ?
>
Apply it to net-next.git.

Acked-by: Xin Long <lucien.xin@gmail.com>

So sending patches with wrong in-reply-to doesn't require repost?

Thanks.
> > diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> > index 62d3cc155809..a5f2835dbe0f 100644
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -999,6 +999,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *=
work)
> >                       if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
> >                               chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
> >                                                             GFP_ATOMIC)=
;
> > +                             if (!chunk->auth_chunk) {
> > +                                     chunk->pdiscard =3D 1;
> > +                                     continue;
> > +                             }
> >                               chunk->auth =3D 1;
> >                               continue;
> >                       }
> > diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> > index dfb1719275db..a15b599b20b7 100644
> > --- a/net/sctp/endpointola.c
> > +++ b/net/sctp/endpointola.c
> > @@ -368,6 +368,10 @@ static void sctp_endpoint_bh_rcv(struct work_struc=
t *work)
> >                       if (next_hdr->type =3D=3D SCTP_CID_COOKIE_ECHO) {
> >                               chunk->auth_chunk =3D skb_clone(chunk->sk=
b,
> >                                                               GFP_ATOMI=
C);
> > +                             if (!chunk->auth_chunk) {
> > +                                     chunk->pdiscard =3D 1;
> > +                                     continue;
> > +                             }
> >                               chunk->auth =3D 1;
> >                               continue;
> >                       }
>
