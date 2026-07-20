Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33E432BD4
	for <linux-sctp@vger.kernel.org>; Mon, 20 Jul 2026 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559695; cv=pass; b=dkB+PbGy7V/FoDhkncIvDJajVWrQm4JhqRTJmmH/FEzYHwf2MowpvdKyRM3JpOKhKaqIWxhLPkxz91LnUn+EFLYOqTxoVb6riN18Y1UaGPScD5Z3LBp5sZUmL63eovasuR80u85UF7pMLjP9SbDSbYPfcAFU7JaRaMLwz7gZfZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559695; c=relaxed/simple;
	bh=jpui7mS1l60KF8BZG4imXnON4Z1oeWMtfnskce7L3bU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N+Cvs+LdFypO8MBVSqfV0abJA6TobvfrYgjEaVG1X3KTotiGplDr7saa5aMnqdYfEp2k80ljIliIqQhj6vUbAOhvbOYXMapSe75VIwOhj6rvhzagraoY05N7CGOTbG252a4O2I/kXDY/u1pzutoX7G9ZBd61GcAKaqJWqZxvYe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRIzpKHZ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRIzpKHZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-848595b338cso11650094b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 20 Jul 2026 08:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784559693; cv=none;
        d=google.com; s=arc-20260327;
        b=E9La6As35wBarqJD+5IlIWuOiWgHOXh9+TBkF30tu3TuPnu1xZk5dUVzRKfe5uQKrk
         QEy/RO9Db7NP+vQ4Yup4D26zkVqi9LxYt2CQDaAIQ2IT2pthbjLncwAMOXb0ECTIjtp2
         1dNN9VFsKy+AvF5VdY09bnyuyVWLCIazuxdwQ1HZ+A+O60/BdIGO+J1/MB/Fv7gWzk8B
         0YDrkhf1YvQZJVVrfsBilFv9//L4pl65e+wIeeIFcivvoTCoo6AtIwUeflTn6yYS71sa
         I6SkRIQKCW1JoKovjWO9Csxg6fCWKC10Z9p1SH9ZegB8WIh821ee2oVg51DAZQqsVBWg
         AY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nP3yamt7KAtvw2RvSt7fIcItLSn/byKqW3ak1QRty9A=;
        fh=QOtawXOZeNSLb0Ea5krtkTEFTXtmvaOWw+jbXJh6WO8=;
        b=pMoTp2K4Syb5ONTP+yNl/vMwRc02W+mlpNedvsaOJiK+9AAday0wn45qug060mvqe4
         V39OpZbWkwrSjNi/llzwGtZdrV/KV6JW1zyLzWobGBo8dcXdV7ZbMEf19CmVjej6Z8+N
         WKLMqIEWH5fPgIlPXZNsaBEqvgQVeehLeYD/HKzoZ/hG0JIX0W2VQhK6xQcSswHZv3JX
         WRPTOPvqx9V8wc3iuPdDRzf6OFhhDi07XOlHFhI+qk4GKVmzI0N7gjCSht/V8nbl0X9a
         JjxlXVUCzqpkCZ6uozxe1LtELETM8P6ka/mhkFQC5NQ26g/E7u9MJgdCICV//3+VhKMf
         /IdA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784559693; x=1785164493; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nP3yamt7KAtvw2RvSt7fIcItLSn/byKqW3ak1QRty9A=;
        b=lRIzpKHZdackHHxA8oh8Y8G8AhM/eOlWAZyOjLTRguKbj5B8e4huERdbm5eMlkRRuq
         rW407D0Kdj/4J7kMPMywkq/NgrWXWQTSuEXgc8h8ra4/6M9SbyvVt/38xTsHUSs7xWtz
         6tiPtdHQS9YUBJHM9vhaPHo24zV47MciQKK+fkKTFI7XuNPm2e3GPdhqc7Rrtu9Xdc4r
         /m5JkibRmnX7AtnXMEXQeWAqsxycKn0pJGDCOHgx2K+6CYI357C6dtFIa6+YYcmhf8a/
         QnRCTJ9wwhKFttJkwsoln969/zOjk/oqg6ZBdhPLPHUVTvoxSd9VEXHmnrkCQiLAErfw
         cvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784559693; x=1785164493;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nP3yamt7KAtvw2RvSt7fIcItLSn/byKqW3ak1QRty9A=;
        b=KSWHjrDwzg6hhNwh1RvfgUjCQPweNo6AnAj2XPwKHm75SCY3AzjTFKjN5DEieFTe3t
         kLC01IElk1mP0+V4Zkcz4VPv5hcqOFw5djofCG4bBZhZhBYXHhlxPnpGOQNZ1kPzQI8z
         Otl6PiKiU1Pqgd1sYxkGivhZcMcwdKRfeLd+b7H69LjcJzhLaYM7GiUkaldsHFpTt0bD
         1E94RZrQLIr8C4j5c4IQcyVRSb23cXAQ35WTVCwCcrnQZnrui+5wqV9bhM9zObm7y/Tx
         pq8ZgHnvW6UJktzvob9AQGTb3mWSfQc8io/bR2ZYClidcJIjaVPGEODhNBUvihMPlZxw
         XxFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq5Rs/IelYVFrIff1Ppo1Hul7qZ7djx1EwoWKaVN8r7+57aKhXGE1qSxQOufF9j4W8H0JXt+OZ9++IL@vger.kernel.org
X-Gm-Message-State: AOJu0YxVfO6YBNkVb5WHxBviIeL4gCBEFG+REqHO/GRkL7YWbuexKeqA
	Z81s1/6BKNIkYbNUFIxuCQqIv+zqGlUqRTQi/2GCf9pQUastkYTtEKGEIv1qt8u6A2imJnxlbig
	KpXQl8pPHIUo2y9jn+dJyHNJuSsuOvmA=
X-Gm-Gg: AfdE7ckUchf5a0OtFgpP+Yv2rO+w9NIzlhaWg/AJzuMzV/K2ZzME9fAQTsbj06Wqaf+
	LQBCd9IwQ5Hr44DYqvUaWZcfjcrXhltximI6slUVaXyeVUFK1PW1H62njYcwfw8peMFKwT5a4H1
	lBeFwSZHq8KQYqDLPaOawY3mQ+dVPYS+VwMcSuuUpt4tyKDBdlcTSS9cuht8uphu41z5FJ97vGu
	f6Yby57vot/wR8s62tiXeXALQ60BqX9jbBC1suM8mjnRYkKbpxU0Q/1wLbMw6K3bjM5s7rXqW6Y
	1utzJCOXiw94p8JgkESkd9qduzUj4a4qesLJ6ye8umjFMtcBq6mYI1VItoiGVfo=
X-Received: by 2002:a05:6a00:448e:b0:847:7f3c:b5f5 with SMTP id
 d2e1a72fcca58-84c292a0e65mr14458556b3a.11.1784559693396; Mon, 20 Jul 2026
 08:01:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260720093116.1266202-1-l1138897701@163.com> <20260720093116.1266202-2-l1138897701@163.com>
In-Reply-To: <20260720093116.1266202-2-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 20 Jul 2026 11:01:21 -0400
X-Gm-Features: AUfX_mxBQqA3EA0De1-OitCm2ZaqI2zMeblEvIQTk-aPQOrr1iC_PA6GzNXl3Bo
Message-ID: <CADvbK_eS=uhupgD4wcHwaqtYNCxRaio8SL5xNfNaQcsn+RuwSQ@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] sctp: auth: verify auth requirement when
 auth_chunk is NULL
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 5:32=E2=80=AFAM luoqing <l1138897701@163.com> wrote=
:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> sctp_auth_chunk_verify() currently returns true unconditionally
> when chunk->auth_chunk is NULL, which means authentication is
> silently skipped. This is incorrect in two scenarios:
>
> 1. skb_clone() failed in the BH receive path, leaving auth_chunk
>    NULL. Although the previous fix avoids setting auth=3D1 in this
>    case, the chunk can still reach sctp_auth_chunk_verify() via
>    sctp_endpoint_bh_rcv() where asoc is NULL for new connections,
>    bypassing the early sctp_auth_recv_cid() check.
>
> 2. No AUTH chunk precedes COOKIE-ECHO in the packet. In this case
>    skb_clone() is never called and auth_chunk remains NULL. Again,
>    in sctp_endpoint_bh_rcv() the early check cannot catch this
>    because asoc is NULL and sctp_auth_recv_cid() returns 0.
>
> Fix by checking sctp_auth_recv_cid() when auth_chunk is NULL:
> if authentication is required for this chunk type, return false
> to drop the chunk; otherwise, continue normally.
>
> Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of A=
UTH chunk")
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
>  net/sctp/sm_statefuns.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index d23d935e128e..89ed618b1de3 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -642,7 +642,7 @@ static bool sctp_auth_chunk_verify(struct net *net, s=
truct sctp_chunk *chunk,
>         struct sctp_chunk auth;
>
>         if (!chunk->auth_chunk)
> -               return true;
> +               return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
>
>         /* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-ech=
o
>          * is supposed to be authenticated and we have to do delayed
> --
> 2.25.1
> >> A better fix would be:
> >>
> >> Add a check in sctp_auth_chunk_verify() at the point where the COOKIE-=
ECHO
> >> chunk is actually being processed:
> >>
> >>
> >>         if (!chunk->auth_chunk)
> >>                 return !sctp_auth_recv_cid(chunk->chunk_hdr->type, aso=
c);
> >>
> >> This ensures that if chunk->auth_chunk is missing while authentication=
 is
> >> required for the COOKIE-ECHO chunk, the verification fails and the chu=
nk is
> >> dropped. Otherwise, when authentication is not required, processing ca=
n
> >> continue normally.
> >>
> >> Please give it a try.
> >>
> > Also, please add a extra Fixes tag in your next post:
> >
> > Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification
> > of AUTH chunk")
> >
> > which introduces chunk->auth_chunk and calls skb_clone() in
> > sctp_endpoint_bh_rcv().
> Hi,
>
> Thanks for the review. I=E2=80=99ve reworked the fix into two patches:
>
> Patch 1/2: In sctp_assoc_bh_rcv() and sctp_endpoint_bh_rcv(), only set ch=
unk->auth =3D 1 when skb_clone() succeeds.
>
> Patch 2/2: In sctp_auth_chunk_verify(), when auth_chunk is NULL, check sc=
tp_auth_recv_cid() to decide whether authentication is required. This cover=
s both cases from the review.
>
> I=E2=80=99d like to discuss whether Patch 1 is necessary. Patch 2 alone i=
s sufficient for correctness =E2=80=94 even with auth =3D=3D 1 and auth_chu=
nk =3D=3D NULL, Patch 2 catches it at the verification point. Patch 1 only =
provides semantic cleanliness (not setting auth =3D 1 without a valid auth_=
chunk), but closes no additional gap.
>
> Should I keep Patch 1 as a defensive cleanup, or drop it and submit only =
Patch 2?
>
I agree that adding the chunk->auth_chunk check makes the logic clearer.

However, the intention behind skipping chunk->auth =3D 1 is to drop the
packet earlier. During the normal handshake path (sctp_endpoint_bh_rcv()),
asoc is NULL, and sctp_auth_recv_cid() always returns 0. As a result, not
setting chunk->auth =3D 1 does not actually achieve the intended effect in
this case.

Given that, I think it would be better to simply break the loop in both
functions:

if (!chunk->auth_chunk)
        break;
chunk->auth =3D 1;

Can you move forward with the 2/2 patch only for this issue? and post the
1/2 patch to 'net-next' as an improvement.

Thanks.
