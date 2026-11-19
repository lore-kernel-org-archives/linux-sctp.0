Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795107168;
	b=fEBcnWf5eLP7zuzCANAVhAsJJdWU+VtGv6SCGZmMHvAyIGRC0puMHvQEkJoBTrulYb85
	 bmmK/QQdujSacQEMW+Ktyt+aTFatDny3xXaznP+fbNAH37BoFb1mKNAaIdCR13djeiEV+
	 bIXjgTCYz4tqRvDcYqbwGmwr9afNnC+pNDVsEb+c7lLrSsBrQjMLKNbp5KZkzeTOY6RhQ
	 xHlAuiz01qlKdG0MA1rPk0ZfYxWT4Xg5UG43DfX5HhSx2jzbLsM8tprp8Tl7xUE+naq1w
	 M/rHWy2ROYgBTL119HjfsncAfIl9wsMjALU9izq8tHQWWE2YdFn70o4j/hA9QbZfAyg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AlVhwoqPVEfSQ+5fBg8Cjml6CljtON+tEw4OOYgtCl4=;
	b=PE0Y8xyXJphQKt3qpctk5TswPq7ptnx0cAUGOIJ9ZhMbzZE1V3I+53/6gxmK4tkHbsc6
	 ij+d3s0ILeNJweJYO4GvfxnWD5FsHzdD6wswfBrU9kkw5ul+7NLI2rW4Q0O+I9sFyagcv
	 muqcm7eRaptqF/iQGjf7cfsP490kjeHKxQN9T5qrNlepElJtdK/3Jae6jPlaX2jUt6gyd
	 TAbGMxT0RfnKbRFZeyUD/JEQM1HbAqxKp/KuDcE5sFcIjeh9me7z+Resyyg9mIS6e+o9v
	 EbUaVKtPCxDGhXLWXeQONfypk8QnS/EFbtHNqhkZOUtIVaBHPja/uUpreGRxXqy5rlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0PlnXRgh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.174
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEB9606A326
	for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 16:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EEB9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0PlnXRgh
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8a07078200fso15767b3a.2
        for <linux-sctp@vger.kernel.org>; Thu, 19 Nov 2026 08:52:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795107167; cv=none;
        d=google.com; s=arc-20260327;
        b=nn1qLEXvGpSlw6upIn58FdfA1ab8O3ULDEUkFoHN1OTxgXUdZbqNQNIZoKDUTpiUz6
         XkklZUUgWaXbfwkaI2SRjpr7sW9VtviPr9LTF/MBE910ktZiEgvTX9NgBtxG+SpQTopw
         FrdVQ7eVMhQQsBGZUCcTYoArOBkIfWkXEYNTN3nm9ujNjRqwg7bsQXGvB/eMcZbmAKGG
         Q/GAmXTEa3YEsEJmZUc77OcXDooXnPDZIbx2I6U030QUw092e0ZzxTEdA+niqk0rOgBm
         2rDbsbPKeus/E2hz5I0RXHFaJO4FbGmACOUMIxab8oMlU4DpdPR4JaRh2VedIIM9FWjJ
         Lr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AlVhwoqPVEfSQ+5fBg8Cjml6CljtON+tEw4OOYgtCl4=;
        fh=NXYCJRZZGscId0/1/XJ+XojvLfvEjHdCa/5w1r8VXnQ=;
        b=MSdnHbu7Tkp1iGer44fXkZDKEkOLLSntQZ+Vu4yntzlX35l8u6nJw8zvWdtw9H33nt
         OKdNpMqQV9DPj9GHZyhVD1rOHhsL0egtrfgnPVCEkNVPPw4squx+W6jC67aLyqO8/kgK
         zhvUxCPfmzcSpEZQ3cxoUvrYNxzNlEYZ1AdadboZjDWgAPYjELOZhaupHnnGMBfKFAoH
         OqSBZ+9UByRXjRuZieD1fntzaeFihaslcnYiFDTESukcxNZOHdlH3nljboSZZwFkOPOF
         7z6jPUpt/5CrcDDzMNd8ur4gyZRx0UCdzsGANtGfA4qtqv6WQ7eTunp24ytss4/skL3Z
         kVDQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795107167; x=1795711967; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AlVhwoqPVEfSQ+5fBg8Cjml6CljtON+tEw4OOYgtCl4=;
        b=0PlnXRghkRlUeFoM4+2Jm3VsmvikbZfKxMDTSeFxjn/0laokhultnNvHR2Rpws5RMj
         +EkLCBkUXxtuXgcJhMD+8iRmvhPtFxJ++ae83fR+J8BEfwC4Fec2tr1p5DP3pIJlNiB0
         Ay+MDJIQAnCdQqnZdBXiNEk5LvbnCd9rzBLACZfks0KioJn/1MdvuSSeJECT8A+m2EOZ
         v/2xEwt+lFu+ikffJBdoIQF7l44IFoQ+3RlZJmizLQd7T1p1WtbWOs7yBcSaeT/Ad0yO
         H9qtSkkFAyz6J4Iye3tv+l8ZwcWp76iIQHYwsZpvF5edGH6UskDm/3p7j3XDBnHdphGz
         KIhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795107167; x=1795711967;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AlVhwoqPVEfSQ+5fBg8Cjml6CljtON+tEw4OOYgtCl4=;
        b=rpreQBaL7GgB2wtQhhEArSgXFdsgF8owvPzxasY2wvCM+muP1HnCOKv7h95sB1SpYj
         6rbFFKIAFpktEjC3w5sqCX4acEfxYY4flbUmwS9NFiSGEkRjqRuvz6LrpMzESv1Ch493
         HeQxzfvTuk3RynHhx76Q7CapCC0DTcXi4JKcOqkqbeZfJ1V+PnvV0pFMVYCh4a8RJ5e8
         6GTQhKSvQJH18QabzoNqgylxScAqfOMpG4HdKbGGtDAdbKYHtqYDTTndlsoUDBfi+0tn
         Rs0+GlP7hmxn/gNh+zLHCwHMTcEW1rbA/hRuF0gVy3egCmz5AbS1sWlY8LJ3qbRJl5WK
         BSNA==
X-Forwarded-Encrypted: i=1; AL+hErHzwbM6wDDCZxqwqKMajRfpahdpE+DNhdPFLIVwqOb0m+OZJveTi8JV/Q00lrF4JCFNjL8ZT/zDU0b3@vger.kernel.org
X-Gm-Message-State: APuU4Z8To45cVgLNbCtusUJd5mLnLJcwAX12uHyx8kipivCj9EEBW1Vx
	LoFylfv9yQo+fW8wj0fPGLNNX+GiuZdRYZqDQRpCM2zKY2dEYZoggXq6hoNTgVkVec3eypDFMjc
	1QM7SZopknibOZp4+BnQDpl+/+nPTqLA=
X-Gm-Gg: AYBFou08NWaGweEcv7WWhPqjBGiT74qNqjGer8xOu2Wb6NWqz8uJsg1KlIfO9OFUan0
	5rjRwZJebuKldnxjFpwY8duMaH7bjnoJMDlxPPqtp9XPnSG7WYfE3aOJL1Tq/I73qDOUi1hyUKH
	N8M+4/G1MkhQn8aD9W5+pG9pm2iCUbpiQW9i17f/T9gh8kuZHpM/aZmBg+/JqAea9yQxdux4dIB
	yA0LofSvnXq0BARneGlSZHbLI0UiVtY0xj8qpvo0egGYRpai7dtuPHfSa9PjGGr6h4jAl5E+MSr
	n2X/EEIxw4X60D7OgyvOcV5W3s0QUi5vpxrD7xZTT4XCKB6o/OXE/YKOvO8ktA2ZuduO8b/cpOE
	lRe5aayM665WLwZo40laPonPUj8qbJ+Z77a3ImYgI4bmkHZ2QaSNkwpWFOSYVBPK4etZdhBrHAa
	sONU2QXAcn5WpxbOETYEz7N135Ua6SwY3Xs9mWmOKlZvn3WoQMS5bLIZO+8tt6UmN6Bzxr6g==
X-Received: by 2002:a05:6a20:a12c:b0:3fa:df6d:7d03 with SMTP id
 adf61e73a8af0-4014a274bf2mr266399637.1.1795107167291; Thu, 19 Nov 2026
 08:52:47 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116033855.1792036-1-pkfxxxing@gmail.com>
In-Reply-To: <20261116033855.1792036-1-pkfxxxing@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 19 Nov 2026 11:52:35 -0500
X-Gm-Features: AclHuK9-as1wTbFo891kSIKMQHM4dkn9fUoJ_KVP5SHbbz1GNMqfHaZuEpH2C-E
Message-ID: <CADvbK_dO0B156LN_05QRqyo-7wCmCT64BYxbThzXYzJdL6kLBQ@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix use-after-free after association migration
To: Yong Liu <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 10:40=E2=80=AFPM Yong Liu <pkfxxxing@gmail.com> wro=
te:
>
> SCTP timers and ICMP error handling can cache asoc->base.sk before
> locking it. If accept or peeloff migrates the association in between,
> processing under the old socket lock can race with an abort on the new
> socket that frees the association's queues. Transport and association
> references do not keep those queues alive. With mdelay() instrumentation
> widening the race, KASAN reported a slab-use-after-free in
> sctp_chunk_abandoned() from the T3 retransmit path.
>
> Recheck the association's socket after taking its BH lock and defer
> mismatched timer callbacks through the existing retry path. Pass the
> locked socket to the IPv4 and IPv6 ICMP handlers instead of rereading it,
> and treat a mismatch like a busy socket before processing ICMP errors.
>
> Use READ_ONCE() for socket pointer reads in these paths and receive/backl=
og
> processing, paired with WRITE_ONCE() in sctp_assoc_migrate(). Take the ne=
w
> socket reference before publishing it. The cached socket is protected by
> BH context and the endpoint's RCU-deferred sock_put().
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
> ---
> Changes in v3:
> - Update the commit message and subject as requested by Jakub Kicinski.
>
> v2: https://lore.kernel.org/all/20261113032805.1447885-1-pkfxxxing@gmail.=
com/
> Review: https://lore.kernel.org/all/20261115100933.75ae0534@kernel.org/
>
> Changes in v2:
> - Use Yong Liu for the author and Signed-off-by, as requested by Jakub
>   Kicinski.
> - Address Xin Long's review and the Sashiko ICMP finding: pass the locked
>   socket to the IPv4/IPv6 error handlers and their UDP encapsulation
>   callers, and revalidate it before immediate ICMP processing.
> - Use READ_ONCE() for socket pointer reads in sctp_err_lookup(), sctp_rcv=
()
>   and sctp_backlog_rcv().
> - Broaden the subject and commit message to cover the ICMP paths.
>
> v1: https://lore.kernel.org/all/20261110120212.1110283-2-pkfxxxing@gmail.=
com/
>
> Based on b3dfbde62cf1981c4638939c159dfd087b7a72e9 (Linux 7.4.0-rc2).
>
>  net/sctp/associola.c     |  4 ++--
>  net/sctp/input.c         | 32 ++++++++++++++++---------------
>  net/sctp/ipv6.c          | 11 ++++++-----
>  net/sctp/sm_sideeffect.c | 41 ++++++++++++++++++++--------------------
>  4 files changed, 45 insertions(+), 43 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 4521be3bd8..c5d520c8d7 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1088,8 +1088,8 @@ void sctp_assoc_migrate(struct sctp_association *as=
soc, struct sock *newsk)
>         sctp_endpoint_hold(assoc->ep);
>
>         /* Get a reference to the new sock.  */
> -       assoc->base.sk =3D newsk;
> -       sock_hold(assoc->base.sk);
> +       sock_hold(newsk);
> +       WRITE_ONCE(assoc->base.sk, newsk);
>
>         /* Add the association to the new endpoint's list of associations=
.  */
>         sctp_endpoint_add_asoc(newsp->ep, assoc);
> diff --git a/net/sctp/input.c b/net/sctp/input.c
> index 9494cfa511..e25c94ad08 100644
> --- a/net/sctp/input.c
> +++ b/net/sctp/input.c
> @@ -169,7 +169,7 @@ int sctp_rcv(struct sk_buff *skb)
>
>         /* Retrieve the common input handling substructure. */
>         rcvr =3D asoc ? &asoc->base : &ep->base;
> -       sk =3D rcvr->sk;
> +       sk =3D READ_ONCE(rcvr->sk);
>
>         /*
>          * RFC 2960, 8.4 - Handle "Out of the blue" Packets.
> @@ -217,7 +217,7 @@ int sctp_rcv(struct sk_buff *skb)
>          */
>         bh_lock_sock(sk);
>
> -       if (sk !=3D rcvr->sk) {
> +       if (sk !=3D READ_ONCE(rcvr->sk)) {
>                 /* Our cached sk is different from the rcvr->sk.  This is
>                  * because migrate()/accept() may have moved the associat=
ion
>                  * to a new socket and released all the sockets.  So now =
we
> @@ -226,7 +226,7 @@ int sctp_rcv(struct sk_buff *skb)
>                  * of the current sk.
>                  */
>                 bh_unlock_sock(sk);
> -               sk =3D rcvr->sk;
> +               sk =3D READ_ONCE(rcvr->sk);
>                 bh_lock_sock(sk);
>         }
>
> @@ -292,7 +292,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff =
*skb)
>                 goto done;
>         }
>
> -       if (unlikely(rcvr->sk !=3D sk)) {
> +       if (unlikely(READ_ONCE(rcvr->sk) !=3D sk)) {
>                 /* In this case, the association moved from one socket to
>                  * another.  We are currently sitting on the backlog of t=
he
>                  * old socket, so we need to move.
> @@ -304,7 +304,7 @@ int sctp_backlog_rcv(struct sock *sk, struct sk_buff =
*skb)
>                  * Otherwise, we can safely push the chunk on the inqueue=
.
>                  */
>
> -               sk =3D rcvr->sk;
> +               sk =3D READ_ONCE(rcvr->sk);
>                 local_bh_disable();
>                 bh_lock_sock(sk);
>
> @@ -377,7 +377,7 @@ void sctp_icmp_frag_needed(struct sock *sk, struct sc=
tp_association *asoc,
>              t->pl.probe_size + sctp_transport_pl_hlen(t) <=3D pmtu))
>                 return;

As the clashiko [1] reported, there's asoc->base.sk access in
sctp_transport_pl_hlen(), You can delete the !t check (t can't be NULL),
and move the rest check to sctp_transport_update_pmtu(), which is called
under sock lock, like:

        pmtu =3D SCTP_TRUNC4(pmtu);

+       if (t->pathmtu <=3D pmtu &&
+           t->pl.probe_size + sctp_transport_pl_hlen(t) <=3D pmtu)
+               return false;
+

As for sctp_addrs_lookup_transport() in the report, I think you need
to do something like:

-               bound_dev_if =3D READ_ONCE(t->asoc->base.sk->sk_bound_dev_i=
f);
-               if (sctp_sk_bound_dev_eq(net, bound_dev_if, dif, sdif) &&
+               sk =3D READ_ONCE(t->asoc->base.sk);
+               if (sctp_sk_bound_dev_eq(net,
READ_ONCE(sk->sk_bound_dev_if), dif, sdif) &&
                    sctp_bind_addr_match(&t->asoc->base.bind_addr,
-                                        laddr, sctp_sk(t->asoc->base.sk)))
+                                        laddr, sctp_sk(sk)))
                        return t;

>
> -       if (sock_owned_by_user(sk)) {
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
>                 atomic_set(&t->mtu_info, pmtu);
>                 asoc->pmtu_pending =3D 1;
>                 t->pmtu_pending =3D 1;
> @@ -410,7 +410,8 @@ void sctp_icmp_redirect(struct sock *sk, struct sctp_=
transport *t,
>  {
>         struct dst_entry *dst;
>
> -       if (sock_owned_by_user(sk) || !t)
> +       if (sock_owned_by_user(sk) || !t ||
> +           sk !=3D READ_ONCE(t->asoc->base.sk))

This '!t' check can be deleted, as the t passed to
sctp_icmp_redirect() can never be NULL.

>                 return;
>         dst =3D sctp_transport_dst_check(t);
>         if (dst)
> @@ -432,7 +433,7 @@ void sctp_icmp_proto_unreachable(struct sock *sk,
>                            struct sctp_association *asoc,
>                            struct sctp_transport *t)
>  {
> -       if (sock_owned_by_user(sk)) {
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
>                 if (timer_pending(&t->proto_unreach_timer))
>                         return;
>                 else {
> @@ -492,7 +493,7 @@ struct sock *sctp_err_lookup(struct net *net, int fam=
ily, struct sk_buff *skb,
>         if (!asoc)
>                 return NULL;
>
> -       sk =3D asoc->base.sk;
> +       sk =3D READ_ONCE(asoc->base.sk);
>
>         /* RFC 4960, Appendix C. ICMP Handling
>          *
> @@ -526,7 +527,7 @@ struct sock *sctp_err_lookup(struct net *net, int fam=
ily, struct sk_buff *skb,
>         /* If too many ICMPs get dropped on busy
>          * servers this needs to be solved differently.
>          */
> -       if (sock_owned_by_user(sk))
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk))
>                 __NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
>
>         *app =3D asoc;
> @@ -546,11 +547,11 @@ void sctp_err_finish(struct sock *sk, struct sctp_t=
ransport *t)
>         sctp_transport_put(t);
>  }
>
> -static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff =
*skb,
> +static void sctp_v4_err_handle(struct sock *sk, struct sctp_transport *t=
,
> +                              struct sk_buff *skb,
>                                __u8 type, __u8 code, __u32 info)
>  {
>         struct sctp_association *asoc =3D t->asoc;
> -       struct sock *sk =3D asoc->base.sk;
>         int err =3D 0;
>
>         switch (type) {
> @@ -582,7 +583,8 @@ static void sctp_v4_err_handle(struct sctp_transport =
*t, struct sk_buff *skb,
>         default:
>                 return;
>         }
> -       if (!sock_owned_by_user(sk) && inet_test_bit(RECVERR, sk)) {
> +       if (!sock_owned_by_user(sk) && sk =3D=3D READ_ONCE(asoc->base.sk)=
 &&
> +           inet_test_bit(RECVERR, sk)) {
>                 sk->sk_err =3D err;
>                 sk_error_report(sk);
>         } else {  /* Only an error on timeout */

As the clashiko [1] reported, this 'else' need to become:

} else if (sk =3D=3D READ_ONCE(asoc->base.sk)) {

> @@ -630,7 +632,7 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
>                 return -ENOENT;
>         }
>
> -       sctp_v4_err_handle(transport, skb, type, code, info);
> +       sctp_v4_err_handle(sk, transport, skb, type, code, info);
>         sctp_err_finish(sk, transport);
>
>         return 0;
> @@ -660,7 +662,7 @@ int sctp_udp_v4_err(struct sock *sk, struct sk_buff *=
skb)
>         }
>         if (hdr->type =3D=3D ICMP_DEST_UNREACH && hdr->code =3D=3D ICMP_F=
RAG_NEEDED)
>                 info =3D ntohs(hdr->un.frag.mtu);
> -       sctp_v4_err_handle(t, skb, hdr->type, hdr->code, info);
> +       sctp_v4_err_handle(sk, t, skb, hdr->type, hdr->code, info);
>
>         sctp_err_finish(sk, t);
>         return 1;
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 97390569c4..f96e79ca7f 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -123,11 +123,11 @@ static struct notifier_block sctp_inet6addr_notifie=
r =3D {
>         .notifier_call =3D sctp_inet6addr_event,
>  };
>
> -static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff =
*skb,
> +static void sctp_v6_err_handle(struct sock *sk, struct sctp_transport *t=
,
> +                              struct sk_buff *skb,
>                                __u8 type, __u8 code, __u32 info)
>  {
>         struct sctp_association *asoc =3D t->asoc;
> -       struct sock *sk =3D asoc->base.sk;
>         int err =3D 0;
>
>         switch (type) {
> @@ -149,7 +149,8 @@ static void sctp_v6_err_handle(struct sctp_transport =
*t, struct sk_buff *skb,
>         }
>
>         icmpv6_err_convert(type, code, &err);
> -       if (!sock_owned_by_user(sk) && inet6_test_bit(RECVERR6, sk)) {
> +       if (!sock_owned_by_user(sk) && sk =3D=3D READ_ONCE(asoc->base.sk)=
 &&
> +           inet6_test_bit(RECVERR6, sk)) {
>                 sk->sk_err =3D err;
>                 sk_error_report(sk);
>         } else {

Same here, change to:

} else if (sk =3D=3D READ_ONCE(asoc->base.sk)) {

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116033855.1792=
036-1-pkfxxxing%40gmail.com

Thanks.
