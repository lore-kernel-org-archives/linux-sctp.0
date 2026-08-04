Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBAE442B18
	for <linux-sctp@vger.kernel.org>; Tue,  4 Aug 2026 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879528; cv=pass; b=tibrZOq3cnYIegUeJ9tE799sth83f88/gR9FaKYpQjh93Iv/zalCNrWKAKCF18ZyKi4sEmGLAoZdaMiQhgum/5+eFG4pcrv6FT/CfQV8fpao4U1KAs+8hfoSWyAuMk5363QSFHpVqQrO2MH10aL70T5ehOZq/u1FIDMnqOZpcXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879528; c=relaxed/simple;
	bh=HPw67P1JaDyf+3Qi++4bTv49ZviLpxGpA5izJb9AyCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gefYmtrtP/k4BybInXO3HBN7qTRwWEcBjWKFxNBdaf0sExpJSAe+oMECYIe8UaB4gJAvbD4Zk8gq/OJwT4jhQ3aHrs31tOj/54qF2UOZ1FeK+G1bc71PzLoKWDSQPQ3IP1R6CqBAUu8W07KTa66CQFaIKiZh8zWd9SxIt1oSik4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aW8O/Z1V; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aW8O/Z1V"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84e04df8c46so343367b3a.2
        for <linux-sctp@vger.kernel.org>; Tue, 04 Aug 2026 14:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785879527; cv=none;
        d=google.com; s=arc-20260327;
        b=ipDzKUTCP2m0+6WwM5C8BnTza8ne78x946DBO87Coo/2T9FlGDGRNezSkNmJVQMu/m
         4IG6d7LZq9pWKvVYBtG1WYR4Sifr8ji3SUoEtWvwfrDHMWNdw0GTWE15ls8VOEkzDM2Q
         VX6mQuHRJ+Kjd/Q3WrCSqH9Uv8G5TaWpzf8bAt0Mt+ChRxL7K+t4/hsn6efWo37DxXP1
         4VqEtaE4fPUnRro4kf8uMfq5WuHMKrSmHbwGr8eWOHYG7YVzuDtI1pdXZDjKZSt3Jx46
         Zqde72OIpN058LtZDkS/KuEhzUxHg68ZfqCTNUmmE7CmgOrp5O/RkZ4F5ObnEPRGldfZ
         uo9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B6KIbQNVhd86qsyAZv144/o6xQEuZj0wYuM2h/vplZ8=;
        fh=Z3Qiy1IwYCVHiar4FzNdoaKDbHfoXacMATwxqP5Za6s=;
        b=PN0HYN9uxD933a6kL6cjs7Qw/MDZGhlMLnVQ1qnVZ4A1Wh4eOAWPRhr4uRBPIFZvdk
         8MlZOFBFna8EQTaqRrmRNS4eONsKlU9QVXUlkD4JlHUAatDiijqEJeYXokMN78cUkoOH
         5t1gXyO06pothdhXX/DeUrxtdtZh0Wkbfbyr1/gVnTERHRKh/ga60+Vt2bvPlpeVbaQU
         zj06J26ucrWNUyXKSoxFPl+X5DPv3zgc3lq7sde4sNoKO52lfK4sRoOWmSVwbyjcesdw
         +vtbDMZWpRoq3k4GnqUg7dTG1OiKEunwNKvPJPI7qcoIEq+p3ZDD5Niw6FnyvwXFqiSV
         if4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785879527; x=1786484327; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B6KIbQNVhd86qsyAZv144/o6xQEuZj0wYuM2h/vplZ8=;
        b=aW8O/Z1VCyJTc71MHaqI03EH4TJJPsZiwy8yLbJW6MDdV8EBl7iWUCxzISCQJrTkhP
         ZhUsRhmQQgQvDYGV9fwUYcqQEshx2C7AE9B4CA9yWhb2SXJBFH22MxMdo1a+7aVHsTdC
         ava6AEnTM8JzEDrd8Sxwk2pAxdgWTlartVZwWQyR1jabaxoAjAiDVLbSmhCt5eCK4Dmq
         kBmlsMSlGT3wp9+Qxa8PixFrTxA7uPXbJ7pAolL14IOybFlwwGatA4hjJDjIb8eRN8rq
         NmwTlIqJLT2lS4TZRNzZ+V9hEnIqLb/7rNTik2KyG7LmRrkTAYgJsn/MIJRfItTH2tkt
         7M9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785879527; x=1786484327;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B6KIbQNVhd86qsyAZv144/o6xQEuZj0wYuM2h/vplZ8=;
        b=QoIgRD8Nn1IrlJ/9qXePgdvPPA7r9nrUAmM9+L1fABxvMy9PKgzK+UjTlPs1MvJLtu
         JibYqn0USPnG/Tnp+YLIrQriyK8Xf30VOaqrah990ane3/LEUrFnXy0OuL9tEi7c3EEi
         Yqe/n1hcY5D4NCv7IOzPJEEPNTPzeZCtin0IbpI3rdvM/2CsMP7sTszvhyvTJxnIsbvO
         6YlqtwfpaTKUXETz+54I43MszFXRfqx9P7UBwu+Ew24Ej4nEcUJ7hBcvBy2kw8MH5jib
         sOv1t9v9uM2w2oHz7nxiU24isMoH5uJ4URlfjQpSvK4CKD8+edpPA3BAXOKrjVxOGh9T
         dRgQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq3KcTMy3RE7CYQujQN74FZvLZHKyaCyvPZZWroRZa6n4FtzrH5q079JA0sl/VjmLrAOjO8LtJ13Gw3@vger.kernel.org
X-Gm-Message-State: AOJu0YwGPJecCBBNvObuul6BVlPECkEMG4kOBN1CYALl2+cVflzhvBcf
	MleEMdT69f7zklSlL3WVGzJjqtQNaxpyG2G8cEGfqt1eVIcRM7+VB4Yk+3JatliecEdRt9/bjXa
	TsFqHjsU/6Hz9oB7poCiLqQKzCs7tsMw=
X-Gm-Gg: AR+sD10OZRs+i74m8DbU/EPMNIiiHPE338Uo1ssxpdKHKwOmdp4cRsh1h1RyIxOMHHW
	O0DHo9dzVr8ZmcGxThyVgPWYeLKFUpqnXGD4jTunzhUUSs333pmdpZUfaEXqFwm15yItRXIsUrG
	8uSDMwAGTylqNF/MBTwN3ddYzW5bXA+tNuCFTMNKANXvIkWe3pHuP2rGBu0w21V6nPXIYe/Op4b
	lD3uSy1UTXuW5Ohv3iDAanuj54hDhVU3OJXiBSdKIN2DntvlLp7Vm1IUXCwSky+fOnVwZeey+f8
	YWkJFhCLayuxAGGT54Te2peAnjjDtYssfbEvEn1oD63a1sVso3OkVnWGC1lqBtXdcTHqQ/GATIR
	fF5Bzf3pLDhptAdtHtVjuXaiV5HKE1bsqktTMMV4GR0Y=
X-Received: by 2002:a05:6a00:3016:b0:848:6895:b754 with SMTP id
 d2e1a72fcca58-84f2dff6cc9mr1867806b3a.28.1785879526616; Tue, 04 Aug 2026
 14:38:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730023309.21654-1-omeux327@gmail.com> <20260803233718.2336399-2-kuba@kernel.org>
In-Reply-To: <20260803233718.2336399-2-kuba@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 4 Aug 2026 17:38:35 -0400
X-Gm-Features: AUfX_mx0qsQi4XvAs8sThQUkRgCKrDkD_PKPxvhHU85HH2SPOTpO3L4PvjQUwMA
Message-ID: <CADvbK_f6qcqPj=YqFDfkgYzzw+wJp9k5fkH1jjgM6xn1rQggJw@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS
To: Jakub Kicinski <kuba@kernel.org>
Cc: omeux327@gmail.com, marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 7:37=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> This is an AI-generated review of your patch. The human sending this
> email says "AI seems to have spotted another related stack leak, and
> suggests an alternative fix."
> ---
> sctp: diag: fix uninitialized stack leak via INET_DIAG_LOCALS/PEERS
>
> The patch changes inet_diag_msg_sctpladdrs_fill() and
> inet_diag_msg_sctpaddrs_fill() to zero the whole sockaddr_storage slot
> first and then copy only the family-dependent prefix of the stored
> union sctp_addr, so the sockaddr_in6-only tail of an AF_INET address is
> no longer exported through the netlink attributes.
>
> A few questions about the changelog and the placement of the fix.
>
> [Severity: Low]
> [Finding: main-1-2]
> [Sources: opus-5]
> The changelog says:
>
> >     inet_diag_msg_sctpladdrs_fill() copies sizeof(union sctp_addr) (28 =
bytes,
> >     the size of sockaddr_in6) from each sctp_sockaddr_entry.a into the =
netlink
> >     INET_DIAG_LOCALS attribute and then only zeroes the bytes from offs=
et 28 to
> >     sizeof(sockaddr_storage).  The same pattern is used by
> >     inet_diag_msg_sctpaddrs_fill() for INET_DIAG_PEERS.
>
> Can the INET_DIAG_PEERS path actually leak anything?  transport->ipaddr
> is allocated zeroed and only ever written with sockaddr_len bytes:
>
> net/sctp/transport.c:sctp_transport_new() {
>         transport =3D kzalloc_obj(*transport, gfp);
>         ...
> }
>
> net/sctp/transport.c:sctp_transport_init() {
>         peer->af_specific =3D sctp_get_af_specific(addr->sa.sa_family);
>         memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);
>         ...
> }
>
> So bytes 16..27 of from->ipaddr look guaranteed to be zero for AF_INET,
> which would make the inet_diag_msg_sctpaddrs_fill() change hardening
> rather than a fix.  Should the changelog say that instead?
>
> The changelog also says:
>
> >     region) are left uninitialized.  Those bytes are propagated verbati=
m through
> >     sctp_add_bind_addr() (which copies sizeof(union sctp_addr)=3D28 byt=
es) and then
>
> sctp_add_bind_addr() copies a caller-supplied length:
>
> net/sctp/bind_addr.c:sctp_add_bind_addr() {
>         memcpy(&addr->a, new, min_t(size_t, sizeof(*new), new_size));
>         ...
> }
>
> Callers such as sctp_do_bind() pass af->sockaddr_len and store nothing
> uninitialized; only the callers that pass sizeof(union sctp_addr) do.
> Could that be spelled out so the scope of the stable backport is clear?
>
> > diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> > index c2a0de2adf6fd..610c937deffd7 100644
> > --- a/net/sctp/diag.c
> > +++ b/net/sctp/diag.c
> > @@ -85,8 +85,12 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_b=
uff *skb,
> >       info =3D nla_data(attr);
> >       rcu_read_lock();
> >       list_for_each_entry_rcu(laddr, address_list, list) {
> > -             memcpy(info, &laddr->a, sizeof(laddr->a));
> > -             memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr=
->a));
> > +             size_t copy_len =3D laddr->a.sa.sa_family =3D=3D AF_INET =
?
> > +                               sizeof(struct sockaddr_in) :
> > +                               sizeof(struct sockaddr_in6);
>
> [Severity: Low]
> [Finding: main-1-1]
> [Sources: opus-5]
> This isn't a bug, but the AF_INET/AF_INET6 to length mapping already
> exists as struct sctp_af::sockaddr_len, and the exact "zero a
> sockaddr_storage, then copy only the valid part" idiom is already in the
> tree:
>
> net/sctp/ulpevent.c:sctp_ulpevent_notify_peer_addr_change() {
>         memset(&addr, 0, sizeof(struct sockaddr_storage));
>         memcpy(&addr, &transport->ipaddr,
>                transport->af_specific->sockaddr_len);
>         ...
> }
>
> Would sctp_get_af_specific(laddr->a.sa.sa_family)->sockaddr_len in
> inet_diag_msg_sctpladdrs_fill(), and from->af_specific->sockaddr_len in
> inet_diag_msg_sctpaddrs_fill(), work here?
>
> Also, the else branch hardcodes sizeof(struct sockaddr_in6) as a stand-in
> for "the whole union", so an unexpected sa_family copies the maximum
> length rather than the minimum, and the constant silently diverges if
> union sctp_addr ever grows a larger member.
>
> > +
> > +             memset(info, 0, addrlen);
> > +             memcpy(info, &laddr->a, copy_len);
> >               info +=3D addrlen;
> >
> >               if (!--addrcnt)
>
> [Severity: Low]
> [Finding: main-1-0]
> [Sources: opus-5]
> Does this leave the uninitialized tail sitting in the bind address list
> itself?  The residue is stored by the producers, and this hunk only stops
> one consumer from exporting it:
>
> net/sctp/socket.c:sctp_send_asconf_add_ip() {
>         memcpy(&saveaddr, addr, af->sockaddr_len);
>         retval =3D sctp_add_bind_addr(bp, &saveaddr,
>                                     sizeof(saveaddr),
>                                     SCTP_ADDR_NEW, GFP_ATOMIC);
>         ...
> }
>
> net/sctp/bind_addr.c:sctp_raw_to_bind_addrs() {
>         union sctp_addr addr;
>         ...
>         !af->from_addr_param(&addr, rawaddr, htons(port), 0)
>         ...
>         retval =3D sctp_add_bind_addr(bp, &addr, sizeof(addr),
>                                     SCTP_ADDR_SRC, gfp);
> }
>
> In both cases only 16 bytes of the 28-byte stack union are written for
> AF_INET, and sctp_add_bind_addr() then persists all 28 bytes into the
> kzalloc'ed entry, so offsets 16..27 of the stored address stay as stack
> residue after this patch.  The second path is driven by peer-supplied
> INIT/INIT-ACK address parameters.
>
> Would zeroing the union in sctp_v4_from_skb() / sctp_v4_from_sk() /
> sctp_v4_from_addr_param(), or clamping q() to
> af->sockaddr_len, close this for every present and future consumer?  That
> seems worth considering given the Cc: stable tag.
>

Instead of only copying the valid address length when dumping entries from
address_list, the comment suggests that the unused bytes should be
initialized when the address is added to the list.

For transport_addr_list, the path:

  sctp_assoc_add_peer() -> sctp_transport_new() -> sctp_transport_init()

already guarantees this:

  transport =3D kzalloc_obj(*transport, gfp);
  ...
  memcpy(&peer->ipaddr, addr, peer->af_specific->sockaddr_len);

However, for bp->address_list, sctp_add_bind_addr() relies on the new_size
parameter to copy the correct address length. There are currently three
callers passing sizeof(addr) instead of af->sockaddr_len:

- sctp_raw_to_bind_addrs()
- sctp_unpack_cookie()
- sctp_send_asconf_add_ip()

These should be changed to pass af->sockaddr_len to sctp_add_bind_addr(),
as shown below:

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 31737f144c7f..1b9bfac17816 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -294,7 +294,7 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr
*bp, __u8 *raw_addr_list,

                if (sctp_bind_addr_state(bp, &addr) !=3D -1)
                        goto next;
-               retval =3D sctp_add_bind_addr(bp, &addr, sizeof(addr),
+               retval =3D sctp_add_bind_addr(bp, &addr, af->sockaddr_len,
                                            SCTP_ADDR_SRC, gfp);
                if (retval)
                        /* Can't finish building the list, clean up. */
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index b472565fc7f2..8da6d97b6062 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1861,8 +1861,11 @@ struct sctp_association *sctp_unpack_cookie(

        /* Also, add the destination address. */
        if (list_empty(&retval->base.bind_addr.address_list)) {
+               struct sctp_af *af;
+
+               af =3D sctp_get_af_specific(chunk->dest.sa.sa_family);
                sctp_add_bind_addr(&retval->base.bind_addr, &chunk->dest,
-                                  sizeof(chunk->dest), SCTP_ADDR_SRC,
+                                  af->sockaddr_len, SCTP_ADDR_SRC,
                                   GFP_ATOMIC);
        }

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index e4ea57a642c1..1f934a9b2e5a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -634,7 +634,7 @@ static int sctp_send_asconf_add_ip(struct sock
         *sk,
                        af =3D sctp_get_af_specific(addr->v4.sin_family);
                        memcpy(&saveaddr, addr, af->sockaddr_len);
                        retval =3D sctp_add_bind_addr(bp, &saveaddr,
-                                                   sizeof(saveaddr),
+                                                   af->sockaddr_len,
                                                    SCTP_ADDR_NEW, GFP_ATOM=
IC);
                        addr_buf +=3D af->sockaddr_len;
                }

Note that the same issue does NOT exist in the following functions:

- sctp_copy_local_addr_list()
- sctp_copy_one_addr()
- sctp_bind_addr_dup()

Although they use sizeof(addr), the addresses being copied are already
entries from address_list, where the unused bytes have been properly
initialized.


Hi, MingXuan, can you give it a try to fix it in the proposed way above?

Thanks.
