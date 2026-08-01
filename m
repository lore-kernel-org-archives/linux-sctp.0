Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9F6357CE8
	for <linux-sctp@vger.kernel.org>; Sat,  1 Aug 2026 02:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785550476; cv=pass; b=P6fdnhOC4H8L84FLVeWxKOl0Vgp5uF1E/pmaeT8Izn323t+HuFf6XgfuWJL/FhvoAN+SU6ZU6LeJEpJzg+QI3taMnncx5ABEksrseVbHAOGBJ1ScmvIu1jZAgPFj3tTa35m168xlji2FnO0Jpfi8CUL+iSRyjI+byhO1MEUqWKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785550476; c=relaxed/simple;
	bh=AgYW+mxKNJlhpJk7XIIQJlgOiGBlZaulDKkwnnz10qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HNnYIDDi+Dnhiu+eo2gZYRxhwo3KwTz4/7mFbKRJ6kn5Qycf68H55TgWyWNq1PhZApu+c2G74dlfbSLg/XSPHwFnqx6cS6DDFVE9/qB5njvGvX4zMZWIVoJQjNes/KuCkIUar5A4hB9/QAvAhcfhghwu8zpli2NA1JfauU08uSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELeS7fHn; arc=pass smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELeS7fHn"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e507b079dso1206492b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 31 Jul 2026 19:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785550474; cv=none;
        d=google.com; s=arc-20260327;
        b=ntce+bRpXaz/NFO15giuKoLFBAJc0/ZJeLABIcb7s822IrJGyF/YEhIAYufjy77/31
         +7ell3UWGXBEtvKu4Y0/ZULdHng6bd7+5NZB/4m4+zv6QYuM+mbZcAoW/UOVc56QVd2R
         LXuRguVrFcokPGRZVxLE6j3oHTe9tVGTEonAjnoFujo3EK6MdAkB1JfpzpFvLRxLHQuL
         /a+VPn/FzHT4el789q2evaRa9sC51MnwScCa1loghXpQa+RwO1ccLeZZbKmii33POrwg
         w+Hjl0vqC3GrE0oB7Lril758/7Ua5J+jXHGTRGPgpQuJg+pjANsPCxeFcn+z9Wo4FwGd
         BODA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CyiwsKEwCuMEEHZXCUH2ShlE2WRhK30ZvpiRG3gOv30=;
        fh=RrvA7lnTV7oGAJuZKILD8Kovxc1TAmKSGx2tZ6Tz6M0=;
        b=Xgygj8rlr81m33Ibnqt92x76hUnpXsuZVELOMq96wktlK99j6yazPTPM1Qx17vUtXU
         yaAFQJEUaIE0evIcaS6gP3rNTj2UsgEHyV8iGj1rfkbstOFs9QnYM8OKPqCBcSDJnmwE
         YgNbFKynHZ1wIENSjQ/s8yf1OMmk2uHxzcru41RXMGAk9n65OWnnLOZ3q9G9czvKbOrv
         IuzR9ahNxOoqur1mq9MOARalZWKxeftaq17y4+H62hYSNSbXzJSEDyQrPPmbDLsOBysO
         29kA0UZOzIYT06U5fh4F0l2+H4Yzq8Bx2Hd/lsS4VP4EBi577jMtTUZhFL5oCsqA52+t
         bLQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785550474; x=1786155274; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CyiwsKEwCuMEEHZXCUH2ShlE2WRhK30ZvpiRG3gOv30=;
        b=ELeS7fHnMMlBDT+Xw7xbikrNHcwitllHj+l5LJJke3l4+7fIaXZ0hy1uqVVFY8q3Mc
         lpX8UdICrEJ4JgqZV3I/oQVajNdVyJOyqkEVTGfkfeojGcYwzDiQBiURMix1S0sG5NAG
         B9ZWxIQKThybDVpx4YBLh6tIPoDzhVn0YeNHLI8EiZaQtSxlmhjUON7dfFSUHv4OXKV8
         mN/eHheZ5CKplRg02ICXMSzKhgLQDycBWvlAFoRapvXEbjqBvZ9HR7RVP0uX4DJC3h+b
         H7H5jPlVJyGA+Iej2nLd71D07SvyBbJe/fzHhk300lHlIHlwFAhnMd1y5SScwf1/Yi1C
         xpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785550474; x=1786155274;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CyiwsKEwCuMEEHZXCUH2ShlE2WRhK30ZvpiRG3gOv30=;
        b=pETnRTc2yDHmRJnaOCUYLN7QFzOS9Y7PtOMqwi22di1T5u+pjTsvA/80JjCS7cvFSY
         KRTGSJootkCmFBnnadpmEnzeOXXLrEip7zbMHvOByb20zCuNcslYamM1oLFVCyrC/qH+
         faTadj/SZ7PAFq8nqkt9UqGGkZGISgoFDD0sJOPOivQz7I9YBu+cUerf9OPNH0/7U6fK
         IVwYrLN3rdMsWFv/e19W1rPu+U/yX4yGF4USHBAbPhyaniyERhk63VOEzNrER8B8Ze03
         S0p6VayzSxmcpo7TYaDOgCJxyBAmTqAAXuw2vaZn8xkgY9UOTTsOoeWNu1NxONYzUPuX
         hU0Q==
X-Forwarded-Encrypted: i=1; AHgh+RotVt+p2WBsslD4GhynDefrRB98qXz9+ZTNZRoCZlw4LzT7T92JKqnn413OSovjC6K2Oxj2/xmwwp1g@vger.kernel.org
X-Gm-Message-State: AOJu0YznECW1itPdQc4+7B989LEnLIxNnRJIFVYQAcTr8OAgqCpmybxc
	yHd3KJBEmrKkwq/ar9XoUSxYbDSx5BBN9DEu0MYUL4LfPBm7rxkOVckloKdllySlv5tEHPGK//N
	65Ihsd/b/XqpAfOor0u/Ttwq3vr5ifVg=
X-Gm-Gg: AR+sD10d44jXI/mY/9cV1Z/sqD/Md6PkYUSoaBgSRstGiPslEKnbLydex14EuGVWk0o
	7r1jSaHlWWbSvCFGRp97lBnRtq+gy6tX3989N3skvyOAhBQEvE+3ZmQK9ljlj2vG4LfE52Lg6Qt
	0w8E8x1EoNmnKG9+EsDFIKgiFsHEeuNbZwP5S3L/kBcEHJXQyQ9Rri/7jBTe6i7OkyYK8F1pOmU
	5kI7FjUv5+SQfcFVMO3hq0vZ18Why9mDQKKkhn4imqXAkw49QDcEzGi9gsgLRKeG4bgMijvuUAE
	/WMnB8IbRKh9OtFLEYyYo67q5J3p+4h2h8534jvPTmzGmIzDm1xhtteyZNzt5FPHswmZmAwIJrs
	pBSMy/l48Nfdj3a01oj1jqtq7myLcfhXM5gaDVCWgRRNg
X-Received: by 2002:a05:6a00:1799:b0:848:2e53:3f63 with SMTP id
 d2e1a72fcca58-84ee47d5335mr1677581b3a.21.1785550473945; Fri, 31 Jul 2026
 19:14:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730110554.41177-1-juny24602@gmail.com>
In-Reply-To: <20260730110554.41177-1-juny24602@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 31 Jul 2026 22:14:21 -0400
X-Gm-Features: AUfX_myjO2-LiRdrTqiLJc-lbp3_FRHlyuCt7UjIbByERrnQm5hxLmn7z9VXlYU
Message-ID: <CADvbK_eiuRw5g6T_Nk=cVZ1z=W=GYZ0y9DdDm6Gomgq0+McV3Q@mail.gmail.com>
Subject: Re: [PATCH net] sctp: re-point the GSO head_skb socket on association migration
To: Jun Yang <juny24602@gmail.com>
Cc: netdev@vger.kernel.org, Jun Yang <junvyyang@tencent.com>, stable@kernel.org, 
	TencentOS Corvus AI <corvus@tencent.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 7:06=E2=80=AFAM Jun Yang <juny24602@gmail.com> wrot=
e:
>
> From: Jun Yang <junvyyang@tencent.com>
>
> sctp_ulpevent_set_owner() stashes the receiving socket on the GSO "cover
> letter" skb as a bare pointer (net/sctp/ulpevent.c:90):
>
>         if (chunk && chunk->head_skb && !chunk->head_skb->sk)
>                 chunk->head_skb->sk =3D asoc->base.sk;
>
> That store takes no reference and installs no destructor, unlike the
> sctp_skb_set_owner_r() applied to the event skb just above it.
>
> When an association is moved to another socket -- SCTP_SOCKOPT_PEELOFF, o=
r
> accept() on a TCP-style socket -- sctp_sock_migrate() re-owns the queued
> skbs with sctp_skb_set_owner_r_frag().  That walks the receive, lobby and
> reassembly queues, but chunk->head_skb is on none of them: it is reachabl=
e
> only through event->chunk->head_skb.  Its ->sk therefore keeps pointing a=
t
> the original socket.  Once that socket is closed and freed, the dangling
> pointer is dereferenced on the very next receive, in sctp_recvmsg()
> (net/sctp/socket.c:2155):
>
>         sp->pf->skb_msgname(head_skb, msg->msg_name, &msg->msg_namelen);
>
> which for IPv6 reads sctp_sk(skb->sk)->v4mapped (net/sctp/ipv6.c:894).
>
> Re-point the cover-letter skb during migration as well.  The event lives =
in
> skb->cb of the event skb only, so this cannot be folded into
> sctp_skb_set_owner_r_frag(), which also recurses over fragment skbs; add =
a
> small wrapper and use it at the three migration call sites.
>
>   BUG: KASAN: slab-use-after-free in sctp_inet6_skb_msgname+0x633/0xb30
>   Read of size 2 at addr ff1100010aafc8e0 by task gso_uaf/6387
>   CPU: 1 UID: 1000 PID: 6387 Comm: gso_uaf
>    sctp_inet6_skb_msgname+0x633/0xb30
>    sctp_recvmsg+0x481/0xa00
>    sock_recvmsg+0x121/0x170
>   Freed by task 0:
>    __sk_destruct+0x39d/0x4c0
>    sctp_endpoint_destroy_rcu+0x8b/0xc0
>   The buggy address belongs to the object at ff1100010aafc380
>    which belongs to the cache SCTPv6 of size 1560
>
> Fixes: 90017accff61 ("sctp: Add GSO support")
> Cc: stable@kernel.org
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Signed-off-by: Jun Yang <junvyyang@tencent.com>
> ---
>  net/sctp/socket.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..ade413bbec56 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9522,6 +9522,27 @@ static void sctp_skb_set_owner_r_frag(struct sk_bu=
ff *skb, struct sock *sk)
>         sctp_skb_set_owner_r(skb, sk);
>  }
>
> +/* Re-own a queued event's skbs, including the GSO "cover letter" skb.
> + *
> + * sctp_ulpevent_set_owner() stashes the socket on chunk->head_skb as a =
bare
> + * pointer, with no reference and no destructor.  That skb is not on any=
 of the
> + * queues walked during a migration, so it has to be re-pointed explicit=
ly.
> + *
> + * Only the event skb itself carries a struct sctp_ulpevent in ->cb, so =
this
> + * must not be folded into the recursive helper above, which also visits
> + * fragment skbs.
> + */
> +static void sctp_skb_set_owner_r_event(struct sk_buff *skb, struct sock =
*sk)
> +{
Please use a consistent name with sctp_set_owner_w_migrate(), like:
sctp_skb_set_owner_r_migrate().

> +       struct sctp_ulpevent *event =3D sctp_skb2event(skb);
> +
> +       sctp_skb_set_owner_r_frag(skb, sk);
> +
> +       if (event->chunk && event->chunk->head_skb &&
> +           event->chunk->head_skb !=3D skb)
> +               event->chunk->head_skb->sk =3D sk;
I think 'event->chunk->head_skb !=3D skb' check is not needed, head_skb is
either NULL or the head skb of a GSO packet, and it should never be
queued on these receive-related queues if it's not NULL.

BTW, if you have PoCs for these four issues, could you also share them in
the corresponding threads? It would be good to include links to the
reproducers/PoCs below the --- marker, as Jakub suggested here:

https://lore.kernel.org/netdev/20260723103515.0059802b@kernel.org/

Thanks.

> +}
> +
>  /* Populate the fields of the newsk from the oldsk and migrate the assoc
>   * and its messages to the newsk.
>   */
> @@ -9571,7 +9592,7 @@ static int sctp_sock_migrate(struct sock *oldsk, st=
ruct sock *newsk,
>                 if (event->asoc =3D=3D assoc) {
>                         __skb_unlink(skb, &oldsk->sk_receive_queue);
>                         __skb_queue_tail(&newsk->sk_receive_queue, skb);
> -                       sctp_skb_set_owner_r_frag(skb, newsk);
> +                       sctp_skb_set_owner_r_event(skb, newsk);
>                 }
>         }
>
> @@ -9600,7 +9621,7 @@ static int sctp_sock_migrate(struct sock *oldsk, st=
ruct sock *newsk,
>                         if (event->asoc =3D=3D assoc) {
>                                 __skb_unlink(skb, &oldsp->pd_lobby);
>                                 __skb_queue_tail(queue, skb);
> -                               sctp_skb_set_owner_r_frag(skb, newsk);
> +                               sctp_skb_set_owner_r_event(skb, newsk);
>                         }
>                 }
>
> @@ -9612,7 +9633,7 @@ static int sctp_sock_migrate(struct sock *oldsk, st=
ruct sock *newsk,
>
>         }
>
> -       sctp_for_each_rx_skb(assoc, newsk, sctp_skb_set_owner_r_frag);
> +       sctp_for_each_rx_skb(assoc, newsk, sctp_skb_set_owner_r_event);
>
>         /* Set the type of socket to indicate that it is peeled off from =
the
>          * original UDP-style socket or created with the accept() call on=
 a
> --
> 2.43.7
