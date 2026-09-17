Received: from mail-lr2-f35.google.com (mail-lr2-f35.google.com [74.125.230.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021374CA787
	for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660436; cv=pass; b=XihP6sdid+OuTktRh3NG8cFokEZCWW1bKn0m58SoTZJzw431LRxVqAwZHYg3mnZhjqD+TouTyrngk7DsvFGhnulno7yGJRUT9WmuTRt1B+Q9cHT5258JIyyH5EW/YwHSteyCkVLOy6OJAzMw6OAZFLSL8GmvGA/bLb1UwQ7NEVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660436; c=relaxed/simple;
	bh=P6Rio0NiTqb8y1L4mKbBUiBgzqNneyELt/kyZcYYb98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p+q5sY2nYF2zlbw2mf/AOrqIZskpE2oCtKgGsRkvQBf5eNoGuKYAnBNOO2aLNTsIt8pAfp5fpvCpHpz8Z63m6naFFG/K8oBhGU+M5xaHwuXpfCfwsIZ/U60oGblOMfy2JOPIhSnbrkqzMUUH428I9RUEqgE9njbyn+5/S2UUgyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=DnwYiaxP; arc=pass smtp.client-ip=74.125.230.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="DnwYiaxP"
Received: by mail-lr2-f35.google.com with SMTP id 38308e7fff4ca-3a47f740839so8867741fa.2
        for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 08:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789660431; cv=none;
        d=google.com; s=arc-20260327;
        b=AYbK5ezDUJ78TPRe+pQ5Tz3d8C6s5Jbwls/ihsQyG3goCfu4Nm+1fMd0p5vO4M0wGF
         TpcRdO4F6L8NaV7aSVWyELiZbkhz1pevV7PedKXR5Zis199YQT2YDZERoIsSLTyNsQZO
         ltw5wJHwYTN9+3qnfLBwGDIfkW+zZqpoOPYYhf72OdTptVdO5i6J7HKBdFpAGudKf3Zp
         jkL6zregeT/aa02MDoQdMAmfMpvTLjFpBIAPSdU+UOfk42IJln1vguPhtWPQs7hxUvqC
         rtk3LW598xOUcFQvu72vQCSQdTbNP53KlXiP6PpVqEYzUbLejH5sYOyDG3NhDnYORABC
         /YmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=akmwIldhFiYd4AW4UUSG3NphIZT68DtHVfhbuJpkXG4=;
        fh=r4p5zOIpevgF+et2PWvqMvHaozNBw9jYHA/ewTCYUwo=;
        b=alMqZie+7MQ1HfqCvbivd644aiV/PFtWw9kEGYGadwvm+MQEnY7zoSSoRzAOH3N3rw
         CQHwad7Er4hu4lcWIjsL/jI8z0MXtbObFozuQIwu6CocHID1GaSpLOD/nF1/50DWldyW
         EE248Mvgo87LMGgsZQ5LqqrXVk48lX5Ia5XdilhOwUoQbwNEFDUtGdc8N1t9en8VXGyl
         7v+KYEmm/msPq3CUAK0KbCfh4lHJ6RGC2bHkt5WDhqOpCX+jB/gV1UmwQGyGup/RoyFf
         /QQntZ7vY6l8INLxez8wZsqdQ/uHAnTb5c5LxD9BRdzZPUrZKsMP1srbylHUgpViu06E
         C41Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1789660431; x=1790265231; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=akmwIldhFiYd4AW4UUSG3NphIZT68DtHVfhbuJpkXG4=;
        b=DnwYiaxPFUbN/qMCizbSJRqBSntjY3HQvMhknhq1batR3HZu/gQyrBQlahCOTOZg11
         to3WLlCsccy/xUecyhQ3+E8KoXQwe4boVEfIpTkfwsK/GJZp7QqyZikOkt51LQbz0bom
         IkE8hLRdIj9W5or5A/16CMR76BgobjpEbZuPlyLxa9rqBuNb5obesZITL65kqEv/ooR8
         THA3kNckXau+TNEKKbEWJeF5HHrLq1gArcktjZWoQ+Kb236UYPCz41mBO0+VBEEseu01
         xFOsHhqtfYIkQeVIF12cXnZs5rVuHO6+G76MW5iYTtoHclhvIU1A9NsNT5jlH/FLC87N
         8aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789660431; x=1790265231;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=akmwIldhFiYd4AW4UUSG3NphIZT68DtHVfhbuJpkXG4=;
        b=f2FREtVJwH+j2MFFpwcDfvYpNQrxGkIkO+Npu/Hih//ujF/5EbHsDpqWSg4iE6dOrx
         4212WA2bRqb/lPBiTuiUxxA9bGZiGK/Nmn7d3enDHsfiYlO4CdnBQAUkN/CicKZsd3aU
         7Zic3q/ORIs0vIqlFw8VJ83nLTp//IRHcbnGfTCyEJ6ylRDCDXsgQ6rznGdhRphkZKbo
         Zv+e+wyb/wbbOb2qG63T3KMFKn630cNFjuwA5g+AJRUGEs6xZdgjHy4fc321dj9FEElU
         R7Yhlg8tTpis5gue49Co03vJ/NgqO3wF4twLAqiO52PwEaTmYvMc4EYIR5eojMkBvP7d
         2cdA==
X-Gm-Message-State: AFuF++nzPU8O8HftWJVzLSAAwe7rFjCQejnzdpdOd2pRCXmStoQa2EWU
	vLJFSNazNEgJInD/+hyDC9cpRAQbn97mthhnfD4GgTP1uyrirCuSAtIswnPe4hIHE/w36pPenxm
	EQREkXX9DC/nS7Qd5Dqbc/xdLEhsTSL3tsejxUFl7nA==
X-Gm-Gg: AYBFou2+Bef2HSaNE7qK2DrC4Zhh2Dl3RKqxQeTeGw6kGPiFmtcgDgrYR30wJuIHxtI
	B/xar+uG3qmCuudKdwPyYwbIsYmf+G3bvZ4vTNGc2jE74mZWw/3RTYu2OUu3vPekqMg9Go1Y+8e
	ABVKoq64JH6905sUn+C0WXfiQQ7L/Q32b6YIHgil9+6lmGigEgVlkiTrNIqwVihy/TrmiC0YXIy
	6BuTMGBz0wKBGTIc8zSsoER2zvlJws5s/Lj02PXo4TngIFbozzcuWB+g5f6VIN6xMeAeTDL2xmC
	Gu9/YxT+TMgRkJNQZS3y/JruRBb/ok93WhbRXu75+ok1r0cpX7qLTzydJKmxYqBv7g==
X-Received: by 2002:a05:651c:a386:10b0:3a5:a139:528b with SMTP id
 38308e7fff4ca-3a5dc9d0091mr9797651fa.11.1789660430653; Thu, 17 Sep 2026
 08:53:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACjaXw6GpV6E+G81qTtdYwPHBSrk1sDmgmOG1dGSryEF+kVVSQ@mail.gmail.com>
 <CADvbK_dNObq76nBsy+pHOYtw12m0Xi-3tvqevF4VjvK_SxzTQA@mail.gmail.com>
In-Reply-To: <CADvbK_dNObq76nBsy+pHOYtw12m0Xi-3tvqevF4VjvK_SxzTQA@mail.gmail.com>
From: Warren Briggs <wbriggs@cellusys.com>
Date: Thu, 17 Sep 2026 11:53:39 -0400
X-Gm-Features: AcwNN1Xr0E_ys_dyor1j_pI7_LOBzUfGoIUcImjyBRmMWhVFKNL1vIMnJ55vYA0
Message-ID: <CACjaXw6s8prVMqN1tAkbiSZmSvjmxoNiXK1Ytc6GCrS0Hw-1gA@mail.gmail.com>
Subject: [PATCH v2] sctp: carry peer capabilities across an INIT collision
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sctp_assoc_update() folds a temporary association into the existing
one when an INIT collision is resolved. It copies asoc->c, peer.rwnd,
peer.sack_needed, peer.auth_capable and peer.i, and nothing else.

The remaining peer capability bits therefore keep whatever the
surviving association was given when it was created, rather than what
the peer advertised in the INIT that caused the collision.

Forward TSN is the visible case. The INIT-ACK is built from the
temporary association, so it advertises Forward-TSN-Supported; once
the collision is resolved the surviving association holds
peer.prsctp_capable =3D=3D 0, and the first FORWARD TSN chunk the peer
sends is answered with ERROR "Unrecognized chunk type". The peer does
not expect this, having been told the capability was supported.
ecn_capable, asconf_capable, reconf_capable and intl_capable are lost
in the same way.

The three address flags fail the other way round. sctp_process_param()
clears ipv4_address and ipv6_address and sets them from the peer's
Supported Address Types, but only on the temporary association. The
surviving association keeps the permissive defaults from
sctp_association_init(), so it can believe a peer supports an address
family that peer never advertised.

peer.auth_capable is already carried, added by commit 1be9a950c646
("net: sctp: inherit auth_capable on INIT collisions") for the same
reason. This extends that to the rest of the block.

Signed-off-by: Warren Briggs <wbriggs@cellusys.com>
---
Changes since v1:
 - added ecn_capable, asconf_capable, reconf_capable and intl_capable,
the missing fields identified in review of v1.
 - also added ipv4_address, ipv6_address and hostname_address, which
are set from the peer's Supported Address Types on the temporary
association and
   are lost at the merge in the same way. Said in case they were left
out of the review list deliberately rather than overlooked.

Testing. An INIT collision was resolved between two sockets on one
host and the resulting association's peer capabilities read back, with
a second, non-collided association created in the same run as a
control, on an unpatched and a patched kernel:

prsctp_capable   SCTP_PR_SUPPORTED            unpatched 0, patched 1
reconf_capable   SCTP_RECONFIG_SUPPORTED      unpatched 0, patched 1
intl_capable     SCTP_INTERLEAVING_SUPPORTED  unpatched 0, patched 1
asconf_capable   SCTP_ASCONF_SUPPORTED        unpatched 0, patched 1
ecn_capable      SCTP_ECN_SUPPORTED           unpatched 0, patched 1
ipv4_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
peer advertising IPv6 only
ipv6_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
peer advertising IPv4 only

Three of those were also confirmed on the wire. An unpatched kernel
that has advertised Forward-TSN-Supported in its INIT-ACK answers a
FORWARD TSN chunk with ERROR cause 6; a patched one accepts it.
SCTP_RESET_STREAMS and sctp_bindx(SCTP_BINDX_ADD_ADDR) put a RE-CONFIG
and an ASCONF on the wire on a patched kernel and produce nothing on
an unpatched one.

hostname_address was not tested.

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1126,6 +1126,14 @@ int sctp_assoc_update(struct sctp_association *asoc,
        asoc->peer.rwnd =3D new->peer.rwnd;
        asoc->peer.sack_needed =3D new->peer.sack_needed;
        asoc->peer.auth_capable =3D new->peer.auth_capable;
+       asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
+       asoc->peer.ecn_capable =3D new->peer.ecn_capable;
+       asoc->peer.asconf_capable =3D new->peer.asconf_capable;
+       asoc->peer.reconf_capable =3D new->peer.reconf_capable;
+       asoc->peer.intl_capable =3D new->peer.intl_capable;
+       asoc->peer.ipv4_address =3D new->peer.ipv4_address;
+       asoc->peer.ipv6_address =3D new->peer.ipv6_address;
+       asoc->peer.hostname_address =3D new->peer.hostname_address;
        asoc->peer.i =3D new->peer.i;

        if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,


On Tue, 15 Sept 2026 at 09:50, Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Sep 14, 2026 at 10:16=E2=80=AFAM Warren Briggs <wbriggs@cellusys.=
com> wrote:
> >
> > When an association is established through the INIT collision path rath=
er than through listen/accept, the capabilities the peer advertised are los=
t.
> >
> > sctp_assoc_update() in net/sctp/associola.c copies only a small set of =
values from the temporary association into the surviving one:
> >
> >         /* Copy in new parameters of peer. */
> >         asoc->c =3D new->c;
> >         asoc->peer.rwnd =3D new->peer.rwnd;
> >         asoc->peer.sack_needed =3D new->peer.sack_needed;
> >         asoc->peer.auth_capable =3D new->peer.auth_capable;
> >         asoc->peer.i =3D new->peer.i;
> >
> > Of the nine flags in the peer capability bitfield, only auth_capable is=
 carried over. ecn_capable, asconf_capable, prsctp_capable, reconf_capable =
and intl_capable are all left at whatever the surviving association happene=
d to hold, which on the collision path is zero, because that association wa=
s in COOKIE_WAIT and had processed no peer INIT.
> >
> > The case is with PR-SCTP as that is one we are trying to support. The s=
equence is:
> > The peer's INIT is processed into a temporary association, so peer.prsc=
tp_capable is set there (sm_make_chunk.c, SCTP_PARAM_FWD_TSN_SUPPORT).
> >
> > The INIT-ACK is built from that association and therefore advertises Fo=
rward TSN, and the state cookie records the flag.
> >
> > The COOKIE-ECHO returns, sctp_unpack_cookie() restores peer.prsctp_capa=
ble from the cookie into the new association.
> >
> > sctp_sf_do_dupcook_b() calls sctp_assoc_update(), which does not copy i=
t.
> >
> > Note that asoc->c =3D new->c does carry the value, since prsctp_capable=
 is a field of struct sctp_cookie. So after the update the association hold=
s the correct value in asoc->c.prsctp_capable and 0 in  asoc->peer.prsctp_c=
apable, and every consumer reads the latter.
> >
> > The result is an association that advertised Forward TSN in its INIT-AC=
K, then answers a FORWARD TSN chunk with ERROR "unrecognized chunk type", c=
ause 6, chunk type 192. That contradiction is  that a peer that correctly c=
hecks the INIT-ACK before using PR-SCTP is told the feature is available an=
d is then refused.
> >
> > Use case:
> > This affects any deployment where both ends of an association initiate =
rather than one listening and one connecting, so that associations are esta=
blished through simultaneous open instead of listen/accept. In the associat=
ion that comes up through the collision path, the capability is lost.
> >
> > Reproduction:
> > Establish an association through simultaneous open, so that it comes up=
 through the collision path rather than through listen/accept.
> >
> > The INIT-ACK carries Forward TSN Supported. The peer then sends a FORWA=
RD TSN chunk, and the receiver answers with ERROR, unrecognized chunk type,=
 cause 6, chunk type 192.
> >
> > Control: the same test against an association established by listen() a=
nd accept() on the same kernel accepts the chunk and SACKs it.
> >
> > Proposed fix:
> > Carry the flag across the update, alongside the auth_capable assignment=
 that is already there. The value is the one the peer advertised and that o=
ur own INIT-ACK was built from, so this restores what the handshake negotia=
ted rather than changing it.
> >
> > --- a/net/sctp/associola.c
> > +++ b/net/sctp/associola.c
> > @@ -1128,6 +1128,7 @@
> >         asoc->peer.rwnd =3D new->peer.rwnd;
> >         asoc->peer.sack_needed =3D new->peer.sack_needed;
> >         asoc->peer.auth_capable =3D new->peer.auth_capable;
> > +       asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
> >         asoc->peer.i =3D new->peer.i;
> >
> The patch looks good. You may also add the settings for other missing fie=
lds:
>
>         asoc->peer.ecn_capable =3D new->peer.ecn_capable;
>         asoc->peer.asconf_capable =3D new->peer.asconf_capable;
>         asoc->peer.reconf_capable =3D new->peer.reconf_capable;
>         asoc->peer.intl_capable =3D new->peer.intl_capable;
>
> Thanks.
>
> > Conclusion:
> > This looks like an omission rather than intent. The auth_capable line w=
as itself added for the same class of problem by commit 1be9a950c646 ("net:=
 sctp:inherit auth_capable on INIT collisions"), which fixed a NULL derefer=
ence caused by the stale flag. The neighbouring capabilities were not revis=
ited.
> >
> > Observed on a 4.18 based distribution kernel. I believe the code is unc=
hanged in current mainline, and the diff above is offset against the 4.18 s=
ource.
> >
> > I have not built or tested the change yet, so this is a report with a s=
uggested fix rather than a tested patch.
> >
> > best regards,
> > Warren Briggs
> > --
> >
> >
> >
> >
> > Warren Briggs
> >
> > Senior Software Engineering Specialist
> >
> >
> > wbriggs@cellusys.com
> >
> >
> >
> >
> >



--=20




Warren Briggs

Senior Software Engineering Specialist


wbriggs@cellusys.com
