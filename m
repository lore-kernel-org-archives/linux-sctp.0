Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718093;
	b=LMxwEN6eyio8FMiV8c/4oZSMLNOailb/QX32KB2Or75EM+q0hBulDA9JGym/D/cK4UIU
	 JMc8oDQ+/N6aBPwKonSZcfz5MWS2KFDVnjbVBXwJ3HawF8nyoYE1FkXph4mMGx+CGh536
	 HWHnVhOj5ReLejYyeSilFdAP4Nr2JG710esNyfeU/CNOju6FjRpZvtIAS8/gftLwpO43V
	 mRziPHLfJLFE5ls+AibUaP3Z44+7MGP8cMvI8wSr/ysPMuhCYwt/R79UbTjcbVTYEdey1
	 gDpfoYUKft6QMSC5HfZ4Ox4rF/GWyYR797SA/vNQ0+jW8L4zgCQEMAz8PjxxnWZsh4w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718093;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=C5z4M29UxeONpK8o8OLGczvOOTRjyuOm2u6SOdS+0pI=;
	b=lCv3KjvvqitdtxmcVpb6YbCiqcZP548Rw1ZgqKcjCuKH0/+qyR2lwwtw8YtGKaD/Ku4B
	 Q2jY6BO1r3m+dSi49EVks+Ojiy4PmYL4Bv0MdWroSWGrKDBmRPPmaZkuDD6jWzzCbj0Dl
	 B3OS7Oc8GCeLuZ/k11IbLWO5A9JkR6TvT/41otpDuLsM1axZvR3xdjX8nTf2/Qn0sCV8F
	 n3b+kUcxLmogcPfQ/SPUSC35jHfedgxVI6GNbWbNSTrpEtHZTa1+Yb3YV85mD+/GlbZX8
	 qrC/JBTga4IWmVxu8xM0g045/p+zCwvCUPGKIIUXeIgg+OCMSZuW6tNLVq/vNsG/0Rw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="zeu/ko8D";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.52
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73246071C01
	for <linux-sctp@vger.kernel.org>; Tue,  3 Nov 2026 15:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B73246071C01
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zeu/ko8D
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so2267796241.2
        for <linux-sctp@vger.kernel.org>; Tue, 03 Nov 2026 07:01:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718091; cv=none;
        d=google.com; s=arc-20260327;
        b=PsO1wo+OeuO+tG/yf3lCMpn5eAGnG952GbtSLX5Qo8LwBJ5UrYPJaOgXhPtIbw0Shl
         klwMg7iAqkgKEHw8TiZ7GOX9fxnCgB39AdD9U70q5Tm3uElWd1TLvgtFwzzjRLExYatD
         eNO3t4mWZLvPBGa3q7e48yrZUxWRwwiH/fuvhrdZVsHpAZpNLMOicKXQ969GzkKzAsVM
         rDbS3OZVRCkjcr8HffpQ8wNXF1z0Q6/x+U7oCTcYfKbe8uS6Yy7C79Xk7qoHp/aBn0me
         E4tlU+PVKp0QsoIsPmakL9bQgNrB/S91YC4umUu8RSlSrSr48MqDMKKcgeCtX/h6TkEa
         GKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C5z4M29UxeONpK8o8OLGczvOOTRjyuOm2u6SOdS+0pI=;
        fh=nenkeG2Y1HfWNNPsHqf/+I97l9pv3FjJpkPaOKqm3q0=;
        b=a2HG91OWwcSBSL3yxW00y8vTSRmCikbaxXYo9zYU37jsLF4DPiJHlXOZWj40FvglVQ
         W/avtdN7w1nL2kEN0+o8+f8EeM8r07G2hQxVVoR/8rKf7CQ9sKunbMtI8OxTDt6FOY1c
         dOtLNu4jBDQVHjWOuFLheTwl3YxEcmLqQ5M4EWuQWC8aJoTrvhhi82AhENcn1NMSuvO2
         AVMW//u+WdJgc7kr3tV+mppe9mxbbgwGkLtaHqmPx+Nc/WgFpHpPx1t85fWulWDJiaqd
         PhEhFdIIUmavh2thQkB8G7C6DaWL2KzCZybGG2qU/jfbIa6JM6yXqbvC5LZQXv7ohcUi
         9Z1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718091; x=1794322891; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C5z4M29UxeONpK8o8OLGczvOOTRjyuOm2u6SOdS+0pI=;
        b=zeu/ko8DkS5rKNStf2MC93UcGfZbVP4uaoIt/BxP4yh5fKcoofKYazpLw1iRdh4Hc6
         lBQQOPUz8KJK7M/V6FBAp3wNnNA3NWoOh++0wBPgNw8VluaRTz4fZJnr2P3NRNOWGCwX
         3a5yjceA8ZM5Nxo6MHbYAetTo8JAgOoMwe3qhLwzrdqn8AGmIW/tm7mGrIcS9pl+52d1
         /zdUtCr0WDE6fcdEObwzSH+S3sri0cMB4LWHUZgnsK6c6eoDhiILmJpxyatrvdc61xZY
         oIPtrdD5JEpYDL3zhUGlUHnJ1Yf6THnbIcE96nUDMnVY3kb1wGlFuWpqqNgjfsnntGNq
         +yOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718091; x=1794322891;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C5z4M29UxeONpK8o8OLGczvOOTRjyuOm2u6SOdS+0pI=;
        b=hDCQuRXz9otrgBNQ2prKl5/H8hvA9YIm0gILikcswA0b0tOthLmCQvIk0450h2Gkll
         rIrFxwCMylj1ViyRr5c7WrgQt5fvEJZGMTfraFN/gN+p3ZBpBdhHfkE92FfvAYRzPDB1
         II1k5/Gq4e8VSNAapNKBURk0GCaFlBzq5sErN8m+dbVROqArb8EGP9mH/A8kZdCx2IAx
         cm3RZKfIvbfI30OGzuXEmayTjOhDqFn8H2+iGWns+LSfU9UBDwDhlxH4IguyhWSHuEhF
         DS3GJbEQLRRiG79GnRBNuL402DF8VOFUDPRqk6eAL/KLL3D4NfdTO3tGVB5HPBIl1iWk
         F6qA==
X-Forwarded-Encrypted: i=1; AKwUvBxAgRxPzP5PEByNZZJXPiecxYMAP8oK29dR402IPZymId0PsUZfou6tBHbwNQZVmqnixEw41TRMHBzU@vger.kernel.org
X-Gm-Message-State: APuU4Z8FFPDvCXBhyUdqHqCZLdIlXx/VywlFJJIoMG34yDpUcoz0BdrL
	sacSIKv6r/yKBfJ/p9SL0EVvZlT6yfhRGEV4Arf2ndZ5+ym0fuA/8w3WNHWSXUbWi140qcTQ6zA
	tfqPiE/Ro0I0qkcGY9nYbFwsAiZvENDE=
X-Gm-Gg: AYBFou10S9CyG8VZoRGu+olINYvLwGk1yYHB7HJeNOqOZHHifrQ+Pde78OaxILOsvzX
	fZDI3MGyaHQ5rXj4uRbxVMoNXFQYoWUIOnLkHEmLfeG8uK8dP2RhwyBlkn3eD8+jy+Hxy/jMJbd
	caGMp0ji2Wn+xoKLLD2CfOF9+NjYWoVxswWrmPFlf7gLEgSO44N8jQkz/nOHEFay3ECDYYit/+W
	GXmjtn/zjO9+HkJdxg5zENi6nlAQG+gHfJoAcVt4FuGpH/GZhQWZ54NojVIUZUt+Y/2vX1WyWnq
	17baAJQ60PSej/5WiyzXzKkURLJlCg63njHTRrmykUX1CcpbRbzGkSMA2hipi7x7NhP4+UzyBIq
	TFANjvHYGJuhnqmmjP1XNujI615b8F2sNcJx6fvxCSRBoyocHoGkuW259Rud11cJs7YEOJOZBkr
	BkgvBHJF9zuo0MY7EJBOg9CEclkbGId6pDLkxs1A==
X-Received: by 2002:a05:6102:c13:b0:7be:25d4:7ff0 with SMTP id
 ada2fe7eead31-7d072247a9cmr4891903137.4.1793718089861; Tue, 03 Nov 2026
 07:01:29 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029193454.1028626-1-andrey.misyrov@gmail.com> <179365071111.3131.11060798860349203804@kernel.org>
In-Reply-To: <179365071111.3131.11060798860349203804@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 3 Nov 2026 10:01:17 -0500
X-Gm-Features: AclHuK9nfSNUyCyqoDyvo9sP8tF53Z1JcsckJk3ZwF841Id_BliZCishdgjDQdY
Message-ID: <CADvbK_ctB+uPFZzpNF7dszEqyEQAK+GZJGtMo-tehoWUDQyeXg@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix ASCONF address change on single-homed hosts
To: netdev-bot+sashiko@kernel.org
Cc: andrey.misyrov@gmail.com, marcelo.leitner@gmail.com, junvyyang@tencent.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:18=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 1 =C2=B7 High: 0 =C2=B7 Medium: 0 (1) =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Critical] sctp: NULL pointer dereference in sctp_vtag_verify() after
>   plain DEL-IP
>
> Pre-existing issues:
> - [Medium] This problem was not introduced by this patch, but the
>   wildcard SET_PRIMARY branch of sctp_process_asconf_param() does not=E2=
=80=A6
>
> --
>
> sctp: fix ASCONF address change on single-homed hosts
>
> This patch changes DEL-IP handling in sctp_process_asconf_param(). A plai=
n
> DEL-IP of the transport that located the ASCONF is no longer refused, so
> the single-homed renumber case from RFC 5061 5.3.2 works again. The
> wildcard DEL-IP now looks up the peer by the packet source, and
> asconf->transport is either cleared or pointed at the surviving peer, so
> no freed transport is left behind.
>
> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> > index d64c3ae33298f..0f9538f8040f2 100644
> > --- a/net/sctp/sm_make_chunk.c
> > +++ b/net/sctp/sm_make_chunk.c
> > @@ -3153,9 +3153,12 @@ static __be16 sctp_process_asconf_param(struct s=
ctp_association *asoc,
> >                * packet MUST be deleted.
> >                */
> >               if (af->is_any(&addr)) {
> > -                     sctp_assoc_set_primary(asoc, asconf->transport);
> > -                     sctp_assoc_del_nonprimary_peers(asoc,
> > -                                                     asconf->transport=
);
> > +                     peer =3D sctp_assoc_lookup_paddr(asoc, &asconf->s=
ource);
> > +                     if (!peer)
> > +                             return SCTP_ERROR_REQ_REFUSED;
> > +                     sctp_assoc_set_primary(asoc, peer);
> > +                     sctp_assoc_del_nonprimary_peers(asoc, peer);
> > +                     asconf->transport =3D peer;
> >                       return SCTP_ERROR_NO_ERROR;
> >               }
> >
> > @@ -3168,13 +3171,9 @@ static __be16 sctp_process_asconf_param(struct s=
ctp_association *asoc,
> >               if (!peer)
> >                       return SCTP_ERROR_DNS_FAILED;
> >
> > -             /* Don't free asconf->transport; a later wildcard DEL-IP
> > -              * parameter reuses it.
> > -              */
> > -             if (peer =3D=3D asconf->transport)
> > -                     return SCTP_ERROR_REQ_REFUSED;
> > -
> >               sctp_assoc_rm_peer(asoc, peer);
> > +             if (asconf->transport =3D=3D peer)
> > +                     asconf->transport =3D NULL;
> >               break;
> >       case SCTP_PARAM_SET_PRIMARY:
> >               /* ADDIP Section 4.2.4
>
> [Severity: Critical]
> Clearing asconf->transport here can leave a NULL transport for any
> chunk bundled after the ASCONF in the same packet.
>
> sctp_rcv() allocates one struct sctp_chunk per packet. sctp_inq_pop()
> reuses queue->in_progress for every bundled chunk and does not reset
> chunk->transport. The asconf seen here through sctp_sf_do_asconf()
> and sctp_process_asconf() is therefore the same object that
> sctp_assoc_bh_rcv() passes to sctp_do_sm() for the next chunk.
>
> Once this branch sets asconf->transport to NULL, the next bundled
> chunk reaches a handler that calls sctp_vtag_verify(). That covers
> DATA, SACK, HEARTBEAT, a second ASCONF, or even an unknown chunk.
> sctp_vtag_verify() does this:
>
> include/net/sctp/sm.h:sctp_vtag_verify() {
>         if (ntohl(chunk->sctp_hdr->vtag) !=3D asoc->c.my_vtag)
>                 return 0;
>
>         chunk->transport->encap_port =3D
>                 SCTP_INPUT_CB(chunk->skb)->encap_port;
>         return 1;
> }
>
> The vtag matches for a legitimate peer, so this is a NULL pointer
> dereference in softirq context. For a bundled DATA chunk,
> sctp_assoc_bh_rcv() also stores the NULL into
> asoc->peer.last_data_from just before that.
>
> The trigger is the case this patch is meant to fix. The peer
> renumbers from L to S and sends [Address Parameter L] [ADD-IP S]
> [DEL-IP L] from S. __sctp_rcv_asconf_lookup() locates the association
> by L, so asconf->transport is the transport for L. The ADD-IP raises
> transport_count to 2, so D7 does not refuse the request, and the
> plain DEL-IP now removes L. Any peer of an established association
> can bundle another chunk after that ASCONF, so a remote peer can
> trigger this.
>
> Before 9b2854f86f0b this path left a freed transport in
> asconf->transport. The patch replaces that use-after-free with a
> NULL dereference for the same bundled chunks rather than closing it.
>
> The v2 notes already handle the bundled DATA/SACK concern for the
> wildcard branch by retargeting asconf->transport to the surviving
> peer. Should the plain DEL-IP do the same? One option is the
> transport for asconf->source when it exists, which it will after
> ADD-IP S. Otherwise asoc->peer.primary_path could be used, since
> sctp_assoc_rm_peer() has just updated it. Or do you prefer to make
> the receive-path users of chunk->transport, starting with
> sctp_vtag_verify(), tolerate NULL?

Looks like ->transport can't be NULL at any point. I couldn't find anything
in the RFCs about this, so setting it to asoc->peer.primary_path should be
good enough.

Thanks.

>
> [Severity: Medium]
> This is a pre-existing issue, and this patch did not introduce it. The v2
> notes already put it out of scope. It does interact with the new
> asconf->transport updates above, though.
>
> The wildcard SET_PRIMARY branch just below says it uses the packet source=
:
>
>         case SCTP_PARAM_SET_PRIMARY:
>                 /* ADDIP Section 4.2.4
>                  * If the address 0.0.0.0 or ::0 is provided, the receive=
r
>                  * MAY mark the source address of the packet as its
>                  * primary.
>                  */
>                 if (af->is_any(&addr))
>                         memcpy(&addr, sctp_source(asconf), sizeof(addr));
>
> However, sctp_source() returns the transport address whenever one is set:
>
> net/sctp/sm_make_chunk.c:sctp_source() {
>         if (chunk->transport) {
>                 return &chunk->transport->ipaddr;
>         } else {
>                 /* Otherwise, extract it from the IP header.  */
>                 return &chunk->source;
>         }
> }
>
> If the ASCONF was matched by its Address Parameter in
> __sctp_rcv_asconf_lookup(), asconf->transport is the transport for L, whi=
le
> asconf->source is the real packet source S.
>
> So if [Addr L][ADD-IP S][SET-PRIMARY 0.0.0.0] is sent from S, wouldn't L
> become primary instead of S?
>
> The ADD-IP wildcard branch, the D8 check and the reworked DEL-IP wildcard
> branch all use &asconf->source. That leaves "source" with two meanings
> inside sctp_process_asconf_param().
>
> This patch now rewrites asconf->transport partway through the chunk. As a
> result, the wildcard SET_PRIMARY result depends on parameter order:
>
>   - after a plain DEL-IP of asconf->transport (now NULL), it picks S
>   - after a wildcard DEL-IP (retargeted to the peer for S), it picks S
>   - otherwise it still picks L
>
> None of these orderings uses a freed transport. Where the result changes,
> it moves toward the behaviour the comment describes.
>
> Would it make sense to have the wildcard SET_PRIMARY branch use
> &asconf->source directly, like the other wildcard branches, either here o=
r
> in a follow-up? That would make the result independent of parameter order=
.
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261029193454.1028626-1-andrey.misyrov%40gmail.com
