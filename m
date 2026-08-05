Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8D73749FD
	for <linux-sctp@vger.kernel.org>; Wed,  5 Aug 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785946466; cv=pass; b=YGo70JAinv57vZzqYTZqX5UCpxl2kNhoP12mTyCD2sNPoiD0f8w2BsAqzsC+9b7+ba0NgQKZF9zplExQAE7D1JVEkQPwexaqpTJnjAVkfmRrRPuYevrMoesPjN1wG1VluyAoyLIxLyrTW9/SBSBkQlIwfkLWKW9c4Xbu9NL4V1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785946466; c=relaxed/simple;
	bh=0Qk6cZq4o03gndyzZz+HNeDI3avPQbggjCc5GYVRIfE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMtXVHGJyvexQWDuFc1bUobKC+0pvCELmHxmx4OAsSIZws3yHhY46aTg7PCI8dEyG0GxyBMBOup7k27i2iIT8unK474+8PhZlsbQmnKs+M7Vm98ddpdmfGD0szOb/eCjfl3OCY85IVZZuy1v0q8Ojo2WFuSWuGlQM2odBZi1Yhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j27Op9UZ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j27Op9UZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1465845b3a.2
        for <linux-sctp@vger.kernel.org>; Wed, 05 Aug 2026 09:14:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785946462; cv=none;
        d=google.com; s=arc-20260327;
        b=psAGBBvs1NlgcJeGUVw0PTCnPyahNlQJXPh/N+I7vapJezorrK8qxcppLDUd/8hI84
         mteAFo36PNmrmxhI/NJTTxKH04C+icXRIWUpf9h06IMwc9VfAHEbkuzO3xlfPUsWUaAi
         RvPuj+W3gW10K1xyJ5rs8o3TGRA53uLo0qf9eTNTWfquJpBio/K/WLctEtTlpVCsghoM
         kJQooC2LE71Fc+Ot6zqrKMx5Ry9VV7WLuU1JQ/d/RVKIIYw4fQRRcpO67e+lneANvxRZ
         CtyewJMDmV1oBwwo9jg6Rhs6cuBrTlpLn0xWj6pFEBQVJVyvu1wTgAeX7Fd/Lelw6UGs
         crAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLlPuz3HFTtsHol1M3m1DfJwxywNL84sVaYKNwosCcs=;
        fh=vsEDk4vVNSL/TeqrxaWRVaFOHGFo32MpqRJRrvSfH50=;
        b=XfKTYHOb/PIGtobt6jVRbZHeQBTlzTk9dLAQMVNc09+MKIq2BvjPjHnNeb0IQWzeLQ
         4j7HLKLoNOjJTwUccCjwLXXWTpmzwo6l9II8ACRroE7NaDB6nBN0R1GKBG42zyneEbOQ
         jhthrj3kVQY1Iwgc+EL5B10Wvw5Ri+DqV2ujZ0wjoq3WZI0x43/nempkiLZy/PG9n6Zq
         LxjNWyGFwe/ZXW8sgRThhMfHRe+ztOB69capw62HMPwgbTdh/ePOkWLITGYMBWH896Cl
         M+fp9sWnVHM1s6YvW67/KQ2HWhxF0NE/5/bsK04LHIj3+am40cKXGBqh7wpgjZ+XVFW3
         n1YA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785946462; x=1786551262; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XLlPuz3HFTtsHol1M3m1DfJwxywNL84sVaYKNwosCcs=;
        b=j27Op9UZxecS4deYkncLbe4vpZPUJClRzy6njUPuRqmRT752ZnirDo8Tr7LnY/eEB8
         c7Cwa0/wnbkntQF8e9Ai8gpUNVvt2ezKj4CozuhRbeJVsxqSYdw2Y9WMp9Wkl3/Gpn5g
         RdKaVmR35P0I0MMZvTcNlirQRA9HzytxULB8DSwbm2v5lA6q4M8VIj+YHEKGKMjQGIJt
         xgXAYIQDI2r5KD6XTdzKib3OHJafiFmVWR8uuhFU/Qr2Tv3hjHXm/Qje7IdBbiIlHAM8
         o8c4ANYNPkVKLVndymnzDNi85jUT0l4ZmC5b764cc5rJ5xXqT0GK1bKQaz93BRtieRlE
         ADvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785946462; x=1786551262;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLlPuz3HFTtsHol1M3m1DfJwxywNL84sVaYKNwosCcs=;
        b=qOs7g5zOm7vaau0GnD3fueoYNDW7n5C2gOpVjJIhBcYG86ufMI6bXNww5FSZopnK+0
         kpkmrcYMOBphVowYOUbvCgPtdWbdwHDXl35LxIsU6npK0c4s1kd+0PF7mjs93dRrg3gH
         dIW9Xhdi6G7sB3WbGjD1Z/JhSE67vnmReM3V5asvRC1MBFY/brWvjwQ76pK/8rFVumrf
         G9K4bizdYVFiwZwfQlhst8Trvqm7MQA3Na+wBledY+6k47si2sSB2RqBYKKgYXkPaX3G
         sD+dr/QnEQ+t6Wxlaeket43vPEn8vU30YYSwsIEXdNz64JUkH3/6kGjE35i8my6Tjr+n
         Gi2A==
X-Forwarded-Encrypted: i=1; AHgh+RoRQyAWIZ1tJXakfguFfcUh2qK2zoNvsFyBSR74BW9ODHECIC2otpRLPWo0OUyjbX7hI8JtPGazBSdy@vger.kernel.org
X-Gm-Message-State: AOJu0YyKJc6XEWEueX9uvLsAc1gG5shKJtn4+pTaGSfFkjnV9qmIqweM
	wVt0lTdAeiHbEQKhy/MFWlXZlClWBK0p1b56idRYjZUdRYCqcKiRgQkxTk24qU+//KOJUwzrxtM
	jNpDzW8+x02Bm/awfe/cVjbIVUOf8SwiTipAor2A=
X-Gm-Gg: AR+sD13DfNnOuVFk0E1YRFKQ9aiMS+vmhhm2UGEjww5mht+crtf3yexpT2cCqWW+WtD
	MYdR9i7vVhaNbskzld5oJk9iKEYfGFowLIsggYXBgEdDJHkU8+gatDoUFLo03R4M0JIRdIKx+gY
	K0TrC345BNh2FhWqB3Hxwkox34wV0/Fgya7XIokKpQPVYsR6AQBHyIZ3pouCUnY3083rSiJ4IuF
	6uqgT5XoEU34/zh9w8HIatm1yYZMOWXykwTbtWaJ2k4k99fAbNESvYaBntztEM4968QXqjaDL+F
	GPO6+Q3iVP0+NLrWNtkLdY3JgyCFYH+oVROrCqCM9zWLYAV/t2b+zE/61nYojrQxRoZWQPHjpVu
	uMxfm6wjDV8Cg77SEaPWnwfH6ZIo32AWmRyGD2bMWUqqMbo4slIFrIogWMEl2hX1ySi6CVsFfN3
	uE9kx/JHvOYdEn
X-Received: by 2002:a05:6a00:440c:b0:848:487c:ce05 with SMTP id
 d2e1a72fcca58-84f2dfb4e7emr9608034b3a.7.1785946461780; Wed, 05 Aug 2026
 09:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804113100.37840-1-juny24602@gmail.com> <20260805123525.571744-1-horms@kernel.org>
In-Reply-To: <20260805123525.571744-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 5 Aug 2026 12:14:10 -0400
X-Gm-Features: AUfX_mwPOxXLgd0PmxDdi0zETIO4gRLtWA2w-9OvGMbWDwXuLDWRIjYIeGScDqU
Message-ID: <CADvbK_eCKN3KqmdLAbcUem7s9BH8R-JxVHj4rOtUu5OvZja-3Q@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix stream->outcnt underflow on duplicate
 RECONF responses
To: Simon Horman <horms@kernel.org>
Cc: juny24602@gmail.com, netdev@vger.kernel.org, junvyyang@tencent.com, 
	stable@kernel.org, corvus@tencent.com, marcelo.leitner@gmail.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 8:35=E2=80=AFAM Simon Horman <horms@kernel.org> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://sashiko.dev/#/patchset/20260804113100.37840-1-jun=
y24602@gmail.com?part=3D1
> ---
> --- Patch [1]: [PATCH net v2] sctp: fix stream->outcnt underflow on dupli=
cate RECONF responses ---
> commit 9a827b81b27b219603b09c1f04c9dbc9a6dd2368
> Author: Jun Yang <junvyyang@tencent.com>
>
> sctp: fix stream->outcnt underflow on duplicate RECONF responses
>
> This commit addresses a bug where duplicate RECONF responses could cause
> stream->outcnt to underflow. It converts strreset_outstanding into a bitm=
ask
> to track request parameter types, ensuring duplicate responses are ignore=
d.
>
> > diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> > index 34ffe6c945a4b..cb7543929d657 100644
> > --- a/net/sctp/stream.c
> > +++ b/net/sctp/stream.c
>
> [ ... ]
>
> > @@ -928,7 +936,7 @@ struct sctp_chunk *sctp_process_strreset_resp(
> >       __u32 result;
> >
> >       req =3D sctp_chunk_lookup_strreset_param(asoc, resp->response_seq=
, 0);
> > -     if (!req)
> > +     if (!req || !SCTP_STRRESET_TEST(asoc, req->type))
> >               return NULL;
>
> [Severity: High]
> Could the new duplicate-drop logic permanently drop legitimate responses =
when
> the sequence number wraps to 0?
>
> If a user calls setsockopt(SCTP_ADD_STREAMS) with both incoming and outgo=
ing
> streams when asoc->strreset_outseq is exactly 0xFFFFFFFF, it creates a RE=
CONF
> chunk with request_seq =3D 0xFFFFFFFF for ADD_OUT and request_seq =3D 0 f=
or
> ADD_IN.
>
> When the peer responds to the ADD_IN request with resp_seq =3D 0,
> sctp_chunk_lookup_strreset_param() handles it:
>
> net/sctp/stream.c:sctp_chunk_lookup_strreset_param() {
>     ...
>     if ((!resp_seq || req->request_seq =3D=3D resp_seq) &&
>         (!type || type =3D=3D req->param_hdr.type))
>             return param.v;
>     ...
> }
>
> Because resp_seq is 0, the !resp_seq check bypasses sequence matching and
> returns the first parameter in the chunk (ADD_OUT).
>
> Since the ADD_OUT bit was already cleared by the first response, the new
> !SCTP_STRRESET_TEST() check here would see the bit is cleared and drop th=
e
> response as a duplicate.
>
> This would leave the ADD_IN bit set forever, preventing the RECONF chunk =
from
> being freed and causing the association to hang due to endless
> retransmissions.

resp_seq =3D=3D 0 is a valid value and must not be used to indicate a wildc=
ard
lookup. This is a pre-existing issue, but it would be better to fix it befo=
re
this patch.

Hi Jun Yang,

Could you please address this by adding a 'bool match_seq' parameter to
sctp_chunk_lookup_strreset_param()?

After that, please repost this as a two-patch series:

1/2. Fix the lookup logic by introducing the match_seq parameter.
2/2. Apply the current fix on top of that change.

Thanks.
