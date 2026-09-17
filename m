Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C1C4E5359
	for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661939; cv=pass; b=ZnYjaumbf0MnozO5Wtu+eQEt1WWEPf+ua8FCTR8GILwZG1n0qkbp3fld+VFrlchoI2PquOL5yswkg/lPbNzcAY4CVrJ/RI5VrCfFGx72rWRUVh3HbBAnEa16dtoR+jEdEv9zoBvmnUUXdDBx3EhRVlUaCA6ySBFIwLaB9DAiLCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661939; c=relaxed/simple;
	bh=h4ajFiIAnobo6OzK48TcHiQYyqLnoWkafneZPNlxfGk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mcaKxx8wf1GMf7pWyN7omUgDKqevwZA1lze2/xCGV/mREs9J+bg3uu7+BUbr3oWPlmau/q3igC/BqiRcySmGSkSYukuWq1JOnlbc5A6LwMv+hzSM7GHXAKHxZQuycUxpgYgkZKzjGFSY+2cpVW9R+ijRhlbNnznW/9ZcypKPopY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com; spf=pass smtp.mailfrom=cellusys.com; dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b=WIKuLrAe; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cellusys.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cellusys.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cellusys.com header.i=@cellusys.com header.b="WIKuLrAe"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff15fadfso4263491fa.0
        for <linux-sctp@vger.kernel.org>; Thu, 17 Sep 2026 09:18:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789661934; cv=none;
        d=google.com; s=arc-20260327;
        b=Iyuev28fCh1P8DUW0tEQrHM4n0cXsDnjkKvscuYPe8ot7HRMgma4DI4rG5bcM0sxFG
         7xYeki1xwIu9TH7SU8otxn2gROK+xtayALHBsVW2sX5PAc/Wt8IXhVbvV+489n0A+TVI
         NkyisqgIU4Hli0u4Hu3ZVEu68w0uqx2U3FVbu19QSD8RMH64Xkk2lswZkx7D5oeaOA79
         zfI2V3bSRLCfBrg0HrvHT/mXmCTf2i+pdE6PM+6AVVDEbcAXwO1GBJ2hZ9E3TrXXz0lx
         ebd9HeuQG/BcZipNxRtGrpHos6ueM36Q/hX2WPaGUep8D7KViXhHq8AQkoNWSDU3ZNKn
         21xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AiaBcQ7GNz51lna3IcMfmZxJlAfBIgWOyX5H4prq3pM=;
        fh=r4p5zOIpevgF+et2PWvqMvHaozNBw9jYHA/ewTCYUwo=;
        b=LaWcRWZGdzwumn5ozYFieBZkzxCRmu9pyw/HuP6S7HCKifeGoOPJRWmAOxFqLmODhi
         Rr+7zi/84fpDCSlHIjPOeGlKmb/Wyb0VF2ArERwgOeAsqAvlMRYe5BzB+lHowqlmnFwb
         qr8SeR/mpfwH2hGFg+yeFb7jw92dFQf8Sz8nNfBIJtpwwSYMRPcErecaNGogCl2vhaQB
         7WXGSKZRg7wXUjeEYXRcUuwYGrj7ghjFzzLg6FIVkO0/MmzV5XLPYC/+PN2TYn91Lr0w
         7zA22valfaKhIMHEhWcRX9Tj2s3yh1D3Ave4Ge+8TefEEp3V9a133wrpLgWO4YklWx69
         nVOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cellusys.com; s=google; t=1789661934; x=1790266734; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AiaBcQ7GNz51lna3IcMfmZxJlAfBIgWOyX5H4prq3pM=;
        b=WIKuLrAeyvJkgTVrsTsBes8SagBJ3b5QBIGQyqEayTbn8rc4S64cPPSlAqKadZa/KH
         CXVfZk0fFT+c1S5SNVZhd/eEf2MDdWxrpzheOyXm0FRZYWBlEux0Ymn+IA1xQVCVWu3f
         JiEhGGuujJDJuAfnEL1vvk2e4d+agqMD2mALfsqBw0qRje+iAtEmKh5Uhrt5ukaEmL47
         FSuVpnfreDUAMzOZceiKuT4JXzCYY+NC/CBF6CMWWt/hsNBAXw8KRnWxu2FuBIsmMaME
         WnhLXsTx30qHHvLZn4pmVYhhZ+5uV4kMFQoK3jakW9/aP/NxOu3WfFHf5UNJGlydhlez
         1U8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789661934; x=1790266734;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AiaBcQ7GNz51lna3IcMfmZxJlAfBIgWOyX5H4prq3pM=;
        b=HaDavBdtAg0iYvwNBl1/AKhLjqnPWqczBu//uKgHci7KVRxGx+AzaVQ7uSg7+oTZ8o
         K7KxuC0dK3xeLeZl/FQphN/OLEF9247N26jxQaBdDSuc/wjcbVHiq+r484FIQRbUQ6+Q
         C9RCsJ+zah8mESPhJ3H7sEWTXWN07qY+9JKW6Sb/1dsZFvZllw9Mnmcq32W+SLw872rc
         8HLqKRR5+YjLvaXT42MDLidLX+w0ndMxY2YpgBx4DrAXzheAAjX9gorYBJarg5HimwGe
         0ONMfqpcKvu9rVZ8Fn6/7jP5YXn5glDpPo7+ECmvs+XT+MAVVuz8CPlIORU2vUh7Kjx0
         X41A==
X-Gm-Message-State: AFuF++mNK6gFq1EPGKVzdsAiWvRi7yfdycblZAKoIlBVKEP6HxQmFEoH
	Anb8zOZIZ0/8OoR1lTS92qpB4tGWS9inXw89fIxqCszVkt+oxqt5Qb9GWrOc81+wmDNZTD5O1lV
	az3oQrr33uYXoFjxwPGFg2M7cyEySwuzLVatfqjaJUg==
X-Gm-Gg: AYBFou09NkJ6KfCMi1TqByPcInB3/vhZlTJQp92wp/TkRUUEy3MZcoPd5NLvstyC4KH
	ZiEgUL3v45kwg9ryv4UB60FC84MfEwd0TYxm6iiOTuvmGOYbF9UTvXPlVTHik3RsBkQ/6nkNTiR
	CU8YoYx/KOig7nnxajpG2TWITEe+pJuytglbZe7q345PVdS2L5KOonq3pRCX04X2q03s6hNDBlT
	9l/eB915nDkFLH9heMh8LbTVX49wkTS3M6HApwm2CAs0jFatc+XBCLAAjjhCq6csrcnfYHlhKjo
	ZI+9/KUYOUA7z1GzLJw9Cgm6nGu5GpWWqxN8TLtEZ+iOFZ68CKGQEls=
X-Received: by 2002:a2e:bc10:0:b0:3a1:fa0f:5d21 with SMTP id
 38308e7fff4ca-3a5e71460b2mr8342021fa.3.1789661933468; Thu, 17 Sep 2026
 09:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACjaXw6GpV6E+G81qTtdYwPHBSrk1sDmgmOG1dGSryEF+kVVSQ@mail.gmail.com>
 <CADvbK_dNObq76nBsy+pHOYtw12m0Xi-3tvqevF4VjvK_SxzTQA@mail.gmail.com> <CACjaXw6s8prVMqN1tAkbiSZmSvjmxoNiXK1Ytc6GCrS0Hw-1gA@mail.gmail.com>
In-Reply-To: <CACjaXw6s8prVMqN1tAkbiSZmSvjmxoNiXK1Ytc6GCrS0Hw-1gA@mail.gmail.com>
From: Warren Briggs <wbriggs@cellusys.com>
Date: Thu, 17 Sep 2026 12:18:41 -0400
X-Gm-Features: AcwNN1X1XTvNn_tBnpZaQRy4G3D7E06x8WtWGv-XNgKwoN-G_irmlHcVt8REx9k
Message-ID: <CACjaXw5cNfXasafrw4MjG7F_L1g+KOq5LajmVxdyZ78s7LjJhA@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: carry peer capabilities across an INIT collision
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Content-Type: multipart/mixed; boundary="000000000000d022eb065bb023c6"

--000000000000d022eb065bb023c6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My mail client converted the tabs to spaces on the way out, so the
inline patch in my previous mail may not apply. The same patch is
attached as a file, content unchanged.

Apologies for the noise.


On Thu, 17 Sept 2026 at 11:53, Warren Briggs <wbriggs@cellusys.com> wrote:
>
> sctp_assoc_update() folds a temporary association into the existing
> one when an INIT collision is resolved. It copies asoc->c, peer.rwnd,
> peer.sack_needed, peer.auth_capable and peer.i, and nothing else.
>
> The remaining peer capability bits therefore keep whatever the
> surviving association was given when it was created, rather than what
> the peer advertised in the INIT that caused the collision.
>
> Forward TSN is the visible case. The INIT-ACK is built from the
> temporary association, so it advertises Forward-TSN-Supported; once
> the collision is resolved the surviving association holds
> peer.prsctp_capable =3D=3D 0, and the first FORWARD TSN chunk the peer
> sends is answered with ERROR "Unrecognized chunk type". The peer does
> not expect this, having been told the capability was supported.
> ecn_capable, asconf_capable, reconf_capable and intl_capable are lost
> in the same way.
>
> The three address flags fail the other way round. sctp_process_param()
> clears ipv4_address and ipv6_address and sets them from the peer's
> Supported Address Types, but only on the temporary association. The
> surviving association keeps the permissive defaults from
> sctp_association_init(), so it can believe a peer supports an address
> family that peer never advertised.
>
> peer.auth_capable is already carried, added by commit 1be9a950c646
> ("net: sctp: inherit auth_capable on INIT collisions") for the same
> reason. This extends that to the rest of the block.
>
> Signed-off-by: Warren Briggs <wbriggs@cellusys.com>
> ---
> Changes since v1:
>  - added ecn_capable, asconf_capable, reconf_capable and intl_capable,
> the missing fields identified in review of v1.
>  - also added ipv4_address, ipv6_address and hostname_address, which
> are set from the peer's Supported Address Types on the temporary
> association and
>    are lost at the merge in the same way. Said in case they were left
> out of the review list deliberately rather than overlooked.
>
> Testing. An INIT collision was resolved between two sockets on one
> host and the resulting association's peer capabilities read back, with
> a second, non-collided association created in the same run as a
> control, on an unpatched and a patched kernel:
>
> prsctp_capable   SCTP_PR_SUPPORTED            unpatched 0, patched 1
> reconf_capable   SCTP_RECONFIG_SUPPORTED      unpatched 0, patched 1
> intl_capable     SCTP_INTERLEAVING_SUPPORTED  unpatched 0, patched 1
> asconf_capable   SCTP_ASCONF_SUPPORTED        unpatched 0, patched 1
> ecn_capable      SCTP_ECN_SUPPORTED           unpatched 0, patched 1
> ipv4_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
> peer advertising IPv6 only
> ipv6_address     sctp_diag sctpi_peer_capable unpatched 1, patched 0,
> peer advertising IPv4 only
>
> Three of those were also confirmed on the wire. An unpatched kernel
> that has advertised Forward-TSN-Supported in its INIT-ACK answers a
> FORWARD TSN chunk with ERROR cause 6; a patched one accepts it.
> SCTP_RESET_STREAMS and sctp_bindx(SCTP_BINDX_ADD_ADDR) put a RE-CONFIG
> and an ASCONF on the wire on a patched kernel and produce nothing on
> an unpatched one.
>
> hostname_address was not tested.
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1126,6 +1126,14 @@ int sctp_assoc_update(struct sctp_association *aso=
c,
>         asoc->peer.rwnd =3D new->peer.rwnd;
>         asoc->peer.sack_needed =3D new->peer.sack_needed;
>         asoc->peer.auth_capable =3D new->peer.auth_capable;
> +       asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
> +       asoc->peer.ecn_capable =3D new->peer.ecn_capable;
> +       asoc->peer.asconf_capable =3D new->peer.asconf_capable;
> +       asoc->peer.reconf_capable =3D new->peer.reconf_capable;
> +       asoc->peer.intl_capable =3D new->peer.intl_capable;
> +       asoc->peer.ipv4_address =3D new->peer.ipv4_address;
> +       asoc->peer.ipv6_address =3D new->peer.ipv6_address;
> +       asoc->peer.hostname_address =3D new->peer.hostname_address;
>         asoc->peer.i =3D new->peer.i;
>
>         if (!sctp_tsnmap_init(&asoc->peer.tsn_map, SCTP_TSN_MAP_INITIAL,
>
>
> On Tue, 15 Sept 2026 at 09:50, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Mon, Sep 14, 2026 at 10:16=E2=80=AFAM Warren Briggs <wbriggs@cellusy=
s.com> wrote:
> > >
> > > When an association is established through the INIT collision path ra=
ther than through listen/accept, the capabilities the peer advertised are l=
ost.
> > >
> > > sctp_assoc_update() in net/sctp/associola.c copies only a small set o=
f values from the temporary association into the surviving one:
> > >
> > >         /* Copy in new parameters of peer. */
> > >         asoc->c =3D new->c;
> > >         asoc->peer.rwnd =3D new->peer.rwnd;
> > >         asoc->peer.sack_needed =3D new->peer.sack_needed;
> > >         asoc->peer.auth_capable =3D new->peer.auth_capable;
> > >         asoc->peer.i =3D new->peer.i;
> > >
> > > Of the nine flags in the peer capability bitfield, only auth_capable =
is carried over. ecn_capable, asconf_capable, prsctp_capable, reconf_capabl=
e and intl_capable are all left at whatever the surviving association happe=
ned to hold, which on the collision path is zero, because that association =
was in COOKIE_WAIT and had processed no peer INIT.
> > >
> > > The case is with PR-SCTP as that is one we are trying to support. The=
 sequence is:
> > > The peer's INIT is processed into a temporary association, so peer.pr=
sctp_capable is set there (sm_make_chunk.c, SCTP_PARAM_FWD_TSN_SUPPORT).
> > >
> > > The INIT-ACK is built from that association and therefore advertises =
Forward TSN, and the state cookie records the flag.
> > >
> > > The COOKIE-ECHO returns, sctp_unpack_cookie() restores peer.prsctp_ca=
pable from the cookie into the new association.
> > >
> > > sctp_sf_do_dupcook_b() calls sctp_assoc_update(), which does not copy=
 it.
> > >
> > > Note that asoc->c =3D new->c does carry the value, since prsctp_capab=
le is a field of struct sctp_cookie. So after the update the association ho=
lds the correct value in asoc->c.prsctp_capable and 0 in  asoc->peer.prsctp=
_capable, and every consumer reads the latter.
> > >
> > > The result is an association that advertised Forward TSN in its INIT-=
ACK, then answers a FORWARD TSN chunk with ERROR "unrecognized chunk type",=
 cause 6, chunk type 192. That contradiction is  that a peer that correctly=
 checks the INIT-ACK before using PR-SCTP is told the feature is available =
and is then refused.
> > >
> > > Use case:
> > > This affects any deployment where both ends of an association initiat=
e rather than one listening and one connecting, so that associations are es=
tablished through simultaneous open instead of listen/accept. In the associ=
ation that comes up through the collision path, the capability is lost.
> > >
> > > Reproduction:
> > > Establish an association through simultaneous open, so that it comes =
up through the collision path rather than through listen/accept.
> > >
> > > The INIT-ACK carries Forward TSN Supported. The peer then sends a FOR=
WARD TSN chunk, and the receiver answers with ERROR, unrecognized chunk typ=
e, cause 6, chunk type 192.
> > >
> > > Control: the same test against an association established by listen()=
 and accept() on the same kernel accepts the chunk and SACKs it.
> > >
> > > Proposed fix:
> > > Carry the flag across the update, alongside the auth_capable assignme=
nt that is already there. The value is the one the peer advertised and that=
 our own INIT-ACK was built from, so this restores what the handshake negot=
iated rather than changing it.
> > >
> > > --- a/net/sctp/associola.c
> > > +++ b/net/sctp/associola.c
> > > @@ -1128,6 +1128,7 @@
> > >         asoc->peer.rwnd =3D new->peer.rwnd;
> > >         asoc->peer.sack_needed =3D new->peer.sack_needed;
> > >         asoc->peer.auth_capable =3D new->peer.auth_capable;
> > > +       asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
> > >         asoc->peer.i =3D new->peer.i;
> > >
> > The patch looks good. You may also add the settings for other missing f=
ields:
> >
> >         asoc->peer.ecn_capable =3D new->peer.ecn_capable;
> >         asoc->peer.asconf_capable =3D new->peer.asconf_capable;
> >         asoc->peer.reconf_capable =3D new->peer.reconf_capable;
> >         asoc->peer.intl_capable =3D new->peer.intl_capable;
> >
> > Thanks.
> >
> > > Conclusion:
> > > This looks like an omission rather than intent. The auth_capable line=
 was itself added for the same class of problem by commit 1be9a950c646 ("ne=
t: sctp:inherit auth_capable on INIT collisions"), which fixed a NULL deref=
erence caused by the stale flag. The neighbouring capabilities were not rev=
isited.
> > >
> > > Observed on a 4.18 based distribution kernel. I believe the code is u=
nchanged in current mainline, and the diff above is offset against the 4.18=
 source.
> > >
> > > I have not built or tested the change yet, so this is a report with a=
 suggested fix rather than a tested patch.
> > >
> > > best regards,
> > > Warren Briggs
> > > --
> > >
> > >
> > >
> > >
> > > Warren Briggs
> > >
> > > Senior Software Engineering Specialist
> > >
> > >
> > > wbriggs@cellusys.com
> > >
> > >
> > >
> > >
> > >
>
>
>
> --
>
>
>
>
> Warren Briggs
>
> Senior Software Engineering Specialist
>
>
> wbriggs@cellusys.com



--=20




Warren Briggs

Senior Software Engineering Specialist


wbriggs@cellusys.com

--000000000000d022eb065bb023c6
Content-Type: application/octet-stream; 
	name="0001-sctp-carry-peer-capabilities-across-an-INIT-collision.patch"
Content-Disposition: attachment; 
	filename="0001-sctp-carry-peer-capabilities-across-an-INIT-collision.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mu5qgq0a0>
X-Attachment-Id: f_mu5qgq0a0

RnJvbTogV2FycmVuIEJyaWdncyA8d2JyaWdnc0BjZWxsdXN5cy5jb20+ClN1YmplY3Q6IFtQQVRD
SCB2Ml0gc2N0cDogY2FycnkgcGVlciBjYXBhYmlsaXRpZXMgYWNyb3NzIGFuIElOSVQgY29sbGlz
aW9uCgpzY3RwX2Fzc29jX3VwZGF0ZSgpIGZvbGRzIGEgdGVtcG9yYXJ5IGFzc29jaWF0aW9uIGlu
dG8gdGhlIGV4aXN0aW5nIG9uZSB3aGVuIGFuIElOSVQgY29sbGlzaW9uIGlzIHJlc29sdmVkLiBJ
dCBjb3BpZXMgYXNvYy0+YywgcGVlci5yd25kLCBwZWVyLnNhY2tfbmVlZGVkLCBwZWVyLmF1dGhf
Y2FwYWJsZSBhbmQgcGVlci5pLCBhbmQgbm90aGluZyBlbHNlLgoKVGhlIHJlbWFpbmluZyBwZWVy
IGNhcGFiaWxpdHkgYml0cyB0aGVyZWZvcmUga2VlcCB3aGF0ZXZlciB0aGUgc3Vydml2aW5nIGFz
c29jaWF0aW9uIHdhcyBnaXZlbiB3aGVuIGl0IHdhcyBjcmVhdGVkLCByYXRoZXIgdGhhbiB3aGF0
IHRoZSBwZWVyIGFkdmVydGlzZWQgaW4gdGhlIElOSVQgdGhhdCBjYXVzZWQgdGhlIGNvbGxpc2lv
bi4KCkZvcndhcmQgVFNOIGlzIHRoZSB2aXNpYmxlIGNhc2UuIFRoZSBJTklULUFDSyBpcyBidWls
dCBmcm9tIHRoZSB0ZW1wb3JhcnkgYXNzb2NpYXRpb24sIHNvIGl0IGFkdmVydGlzZXMgRm9yd2Fy
ZC1UU04tU3VwcG9ydGVkOyBvbmNlIHRoZSBjb2xsaXNpb24gaXMgcmVzb2x2ZWQgdGhlIHN1cnZp
dmluZyBhc3NvY2lhdGlvbiBob2xkcyBwZWVyLnByc2N0cF9jYXBhYmxlID09IDAsIGFuZCB0aGUg
Zmlyc3QgRk9SV0FSRCBUU04gY2h1bmsgdGhlIHBlZXIgc2VuZHMgaXMgYW5zd2VyZWQgd2l0aCBF
UlJPUiAiVW5yZWNvZ25pemVkIGNodW5rIHR5cGUiLiBUaGUgcGVlciBkb2VzIG5vdCBleHBlY3Qg
dGhpcywgaGF2aW5nIGJlZW4gdG9sZCB0aGUgY2FwYWJpbGl0eSB3YXMgc3VwcG9ydGVkLiBlY25f
Y2FwYWJsZSwgYXNjb25mX2NhcGFibGUsIHJlY29uZl9jYXBhYmxlIGFuZCBpbnRsX2NhcGFibGUg
YXJlIGxvc3QgaW4gdGhlIHNhbWUgd2F5LgoKVGhlIHRocmVlIGFkZHJlc3MgZmxhZ3MgZmFpbCB0
aGUgb3RoZXIgd2F5IHJvdW5kLiBzY3RwX3Byb2Nlc3NfcGFyYW0oKSBjbGVhcnMgaXB2NF9hZGRy
ZXNzIGFuZCBpcHY2X2FkZHJlc3MgYW5kIHNldHMgdGhlbSBmcm9tIHRoZSBwZWVyJ3MgU3VwcG9y
dGVkIEFkZHJlc3MgVHlwZXMsIGJ1dCBvbmx5IG9uIHRoZSB0ZW1wb3JhcnkgYXNzb2NpYXRpb24u
IFRoZSBzdXJ2aXZpbmcgYXNzb2NpYXRpb24ga2VlcHMgdGhlIHBlcm1pc3NpdmUgZGVmYXVsdHMg
ZnJvbSBzY3RwX2Fzc29jaWF0aW9uX2luaXQoKSwgc28gaXQgY2FuIGJlbGlldmUgYSBwZWVyIHN1
cHBvcnRzIGFuIGFkZHJlc3MgZmFtaWx5IHRoYXQgcGVlciBuZXZlciBhZHZlcnRpc2VkLgoKcGVl
ci5hdXRoX2NhcGFibGUgaXMgYWxyZWFkeSBjYXJyaWVkLCBhZGRlZCBieSBjb21taXQgMWJlOWE5
NTBjNjQ2ICgibmV0OiBzY3RwOiBpbmhlcml0IGF1dGhfY2FwYWJsZSBvbiBJTklUIGNvbGxpc2lv
bnMiKSBmb3IgdGhlIHNhbWUgcmVhc29uLiBUaGlzIGV4dGVuZHMgdGhhdCB0byB0aGUgcmVzdCBv
ZiB0aGUgYmxvY2suCgpTaWduZWQtb2ZmLWJ5OiBXYXJyZW4gQnJpZ2dzIDx3YnJpZ2dzQGNlbGx1
c3lzLmNvbT4KLS0tCkNoYW5nZXMgc2luY2UgdjE6CiAtIGFkZGVkIGVjbl9jYXBhYmxlLCBhc2Nv
bmZfY2FwYWJsZSwgcmVjb25mX2NhcGFibGUgYW5kIGludGxfY2FwYWJsZSwgdGhlIG1pc3Npbmcg
ZmllbGRzIGlkZW50aWZpZWQgaW4gcmV2aWV3IG9mIHYxLgogLSBhbHNvIGFkZGVkIGlwdjRfYWRk
cmVzcywgaXB2Nl9hZGRyZXNzIGFuZCBob3N0bmFtZV9hZGRyZXNzLCB3aGljaCBhcmUgc2V0IGZy
b20gdGhlIHBlZXIncyBTdXBwb3J0ZWQgQWRkcmVzcyBUeXBlcyBvbiB0aGUgdGVtcG9yYXJ5IGFz
c29jaWF0aW9uIGFuZAogICBhcmUgbG9zdCBhdCB0aGUgbWVyZ2UgaW4gdGhlIHNhbWUgd2F5LiBT
YWlkIGluIGNhc2UgdGhleSB3ZXJlIGxlZnQgb3V0IG9mIHRoZSByZXZpZXcgbGlzdCBkZWxpYmVy
YXRlbHkgcmF0aGVyIHRoYW4gb3Zlcmxvb2tlZC4KClRlc3RpbmcuIEFuIElOSVQgY29sbGlzaW9u
IHdhcyByZXNvbHZlZCBiZXR3ZWVuIHR3byBzb2NrZXRzIG9uIG9uZSBob3N0IGFuZCB0aGUgcmVz
dWx0aW5nIGFzc29jaWF0aW9uJ3MgcGVlciBjYXBhYmlsaXRpZXMgcmVhZCBiYWNrLCB3aXRoIGEg
c2Vjb25kLCBub24tY29sbGlkZWQgYXNzb2NpYXRpb24gY3JlYXRlZCBpbiB0aGUgc2FtZSBydW4g
YXMgYSBjb250cm9sLCBvbiBhbiB1bnBhdGNoZWQgYW5kIGEgcGF0Y2hlZCBrZXJuZWw6CgpwcnNj
dHBfY2FwYWJsZSAgIFNDVFBfUFJfU1VQUE9SVEVEICAgICAgICAgICAgdW5wYXRjaGVkIDAsIHBh
dGNoZWQgMQpyZWNvbmZfY2FwYWJsZSAgIFNDVFBfUkVDT05GSUdfU1VQUE9SVEVEICAgICAgdW5w
YXRjaGVkIDAsIHBhdGNoZWQgMQppbnRsX2NhcGFibGUgICAgIFNDVFBfSU5URVJMRUFWSU5HX1NV
UFBPUlRFRCAgdW5wYXRjaGVkIDAsIHBhdGNoZWQgMQphc2NvbmZfY2FwYWJsZSAgIFNDVFBfQVND
T05GX1NVUFBPUlRFRCAgICAgICAgdW5wYXRjaGVkIDAsIHBhdGNoZWQgMQplY25fY2FwYWJsZSAg
ICAgIFNDVFBfRUNOX1NVUFBPUlRFRCAgICAgICAgICAgdW5wYXRjaGVkIDAsIHBhdGNoZWQgMQpp
cHY0X2FkZHJlc3MgICAgIHNjdHBfZGlhZyBzY3RwaV9wZWVyX2NhcGFibGUgdW5wYXRjaGVkIDEs
IHBhdGNoZWQgMCwgcGVlciBhZHZlcnRpc2luZyBJUHY2IG9ubHkKaXB2Nl9hZGRyZXNzICAgICBz
Y3RwX2RpYWcgc2N0cGlfcGVlcl9jYXBhYmxlIHVucGF0Y2hlZCAxLCBwYXRjaGVkIDAsIHBlZXIg
YWR2ZXJ0aXNpbmcgSVB2NCBvbmx5CgpUaHJlZSBvZiB0aG9zZSB3ZXJlIGFsc28gY29uZmlybWVk
IG9uIHRoZSB3aXJlLiBBbiB1bnBhdGNoZWQga2VybmVsIHRoYXQgaGFzIGFkdmVydGlzZWQgRm9y
d2FyZC1UU04tU3VwcG9ydGVkIGluIGl0cyBJTklULUFDSyBhbnN3ZXJzIGEgRk9SV0FSRCBUU04g
Y2h1bmsgd2l0aCBFUlJPUiBjYXVzZSA2OyBhIHBhdGNoZWQgb25lIGFjY2VwdHMgaXQuIFNDVFBf
UkVTRVRfU1RSRUFNUyBhbmQgc2N0cF9iaW5keChTQ1RQX0JJTkRYX0FERF9BRERSKSBwdXQgYSBS
RS1DT05GSUcgYW5kIGFuIEFTQ09ORiBvbiB0aGUgd2lyZSBvbiBhIHBhdGNoZWQga2VybmVsIGFu
ZCBwcm9kdWNlIG5vdGhpbmcgb24gYW4gdW5wYXRjaGVkIG9uZS4KCmhvc3RuYW1lX2FkZHJlc3Mg
d2FzIG5vdCB0ZXN0ZWQuCgpkaWZmIC0tZ2l0IGEvbmV0L3NjdHAvYXNzb2Npb2xhLmMgYi9uZXQv
c2N0cC9hc3NvY2lvbGEuYwotLS0gYS9uZXQvc2N0cC9hc3NvY2lvbGEuYworKysgYi9uZXQvc2N0
cC9hc3NvY2lvbGEuYwpAQCAtMTEyNiw2ICsxMTI2LDE0IEBAIGludCBzY3RwX2Fzc29jX3VwZGF0
ZShzdHJ1Y3Qgc2N0cF9hc3NvY2lhdGlvbiAqYXNvYywKIAlhc29jLT5wZWVyLnJ3bmQgPSBuZXct
PnBlZXIucnduZDsKIAlhc29jLT5wZWVyLnNhY2tfbmVlZGVkID0gbmV3LT5wZWVyLnNhY2tfbmVl
ZGVkOwogCWFzb2MtPnBlZXIuYXV0aF9jYXBhYmxlID0gbmV3LT5wZWVyLmF1dGhfY2FwYWJsZTsK
Kwlhc29jLT5wZWVyLnByc2N0cF9jYXBhYmxlID0gbmV3LT5wZWVyLnByc2N0cF9jYXBhYmxlOwor
CWFzb2MtPnBlZXIuZWNuX2NhcGFibGUgPSBuZXctPnBlZXIuZWNuX2NhcGFibGU7CisJYXNvYy0+
cGVlci5hc2NvbmZfY2FwYWJsZSA9IG5ldy0+cGVlci5hc2NvbmZfY2FwYWJsZTsKKwlhc29jLT5w
ZWVyLnJlY29uZl9jYXBhYmxlID0gbmV3LT5wZWVyLnJlY29uZl9jYXBhYmxlOworCWFzb2MtPnBl
ZXIuaW50bF9jYXBhYmxlID0gbmV3LT5wZWVyLmludGxfY2FwYWJsZTsKKwlhc29jLT5wZWVyLmlw
djRfYWRkcmVzcyA9IG5ldy0+cGVlci5pcHY0X2FkZHJlc3M7CisJYXNvYy0+cGVlci5pcHY2X2Fk
ZHJlc3MgPSBuZXctPnBlZXIuaXB2Nl9hZGRyZXNzOworCWFzb2MtPnBlZXIuaG9zdG5hbWVfYWRk
cmVzcyA9IG5ldy0+cGVlci5ob3N0bmFtZV9hZGRyZXNzOwogCWFzb2MtPnBlZXIuaSA9IG5ldy0+
cGVlci5pOwogCiAJaWYgKCFzY3RwX3Rzbm1hcF9pbml0KCZhc29jLT5wZWVyLnRzbl9tYXAsIFND
VFBfVFNOX01BUF9JTklUSUFMLAo=
--000000000000d022eb065bb023c6--
