Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA56496D3F
	for <linux-sctp@vger.kernel.org>; Tue, 15 Sep 2026 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789480230; cv=pass; b=q9G8uTrvgazYvzEJ3ui4gfbAmCiWHiKzy/Nyg0BMj4e6MyHUFnTuSKpr8UkCq81SiUrOXlEiH0hKIlZLA9oqP/FiHPRQRZuHqi4z6uOPvuAFs/uto3O9mwkUyYBG6pR6/CWhEwlE4NGP/PvrslyiaVw1s8PK9Gv2WvmOd/7QhfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789480230; c=relaxed/simple;
	bh=5w8FPLrUX8Cn5zNol70D5JJ9MXx+lzf6DejHhfWLzZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gx+DGUd0VMZEXn1c8k+dEqd9SkUQZnoaim20O3760ak8oS4tTSEuHPgbNgMCJHb0nc4RguSMnkW8basQ77jQ8u3Or35DyukxavycnVPb1hBTQF/F3EhI8wrYdDY+1saVOa474Y6umHO3eBsN0SIFAmMIDZim11pKCWSuR8I2Kzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUcvIgq4; arc=pass smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUcvIgq4"
Received: by mail-vs2-f12.google.com with SMTP id ada2fe7eead31-79189dbfb32so93602137.1
        for <linux-sctp@vger.kernel.org>; Tue, 15 Sep 2026 06:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789480227; cv=none;
        d=google.com; s=arc-20260327;
        b=POOEC5HStNV9mCbWFk8bySDCadKkwR0ePHqUkC5fbXd15vXBHme9ESSM2CVzWAaOFp
         YzvfO2xnhXUh6NWk5L7Piv5B5sG3zmOU+JpL00bvS0gnsJtj8VlezBgF/0hiLVYhe9yO
         Hlm4sEwe9GwO5U+HJx9V/SiRYRmp4P7YxtpeTtpUJaorQrxPfcwnYEGaYOv0oDon6BUl
         5dn2tTnBG2MgOBjzFG/DT6v+oO0emlREVrhqyImwVfemCMKXADH3j7mkdzvX1tWAoa80
         Kg+3I0slCIB/1ako4c8oeDayXau9ibcn7fZCa0wkgOczPx+5u/doYFaHgCJoZWplDbF6
         /M1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pBxDr3iy650BZpmfWGk+3mEVuj8taChB/Hfag/sa2LE=;
        fh=wlGv1i4fDAXcIz1cYwleohxscO34gRLB2x3yVSedHgU=;
        b=BgiibS7uqbsdPQfzNBNpoMqs3BpO8NauIBEykvIzFky097yFpNZ/DMte7bdqAr3r5+
         Fc+Opq1MjVloszIHuBhLhsRON1jZFzo8+846ykn7KGp69nTff2n7VohxnCujIZIm7dLf
         8oiGb7efXs2QoDQ4/LsD/3huFdjbGm62VwZgQXcsoX/p1HoeH45/+8EnvybHwMZ6LsDu
         +HQFBU01BqaDZ7yHkDXctgmpKGyY0avkHrf6ZEuErR6eLMfBfOpUSXUT+vdau6Q4/Kee
         rqpRAZPUyyBhLpod/F4Z/UEzsswTeQZjuEb6vmlDQznRAIBeOM808drap0J5Y+2pmoUf
         svgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789480227; x=1790085027; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pBxDr3iy650BZpmfWGk+3mEVuj8taChB/Hfag/sa2LE=;
        b=OUcvIgq4460b8MVe9wkHyQ8pIoGdcGig94KcbsCxMBR1TxYP2CyxV/RncFtqZb+Md7
         WUVVKVnN1jd/C44jRC90Fut1+AhI55s8suUdPXj6deTPFFrTqTm0RwrDV3GvR0PBeiAF
         btpgLoxEDP7pzebm/YK9DPhWKEEkusBqF7JScvi9ShZYrdW2yhqPmdELZ0Lcs140jy7X
         dujvO/58tUlgiOT35dmUM4R/NDjCGAnZJLgOSwbIorT379WMyg25x/YMxzuGYxfHOlbW
         4TpnVzyRlsbqqMY2cVNxOGFXuBZ0Ok6F39P1ot5QCUpSnz2vbLlYtp5hpD72XYBCskrA
         SVYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789480227; x=1790085027;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pBxDr3iy650BZpmfWGk+3mEVuj8taChB/Hfag/sa2LE=;
        b=k6ePhL2u+v2/aldnCeQUVZLaChdognvbhq2EE8LGuiEAHhuHG3puCl+e+32j6ldUwB
         RzOzzM+/w7aTiPP6b83G5dCfHmS7JOWLCNWEjBm6a+UV3hrOPC67gZpSeSNyA1NVIqQ0
         st8MfKkMZ2/k7KTq60BKzEHE5uEiQN2F4FHUb/jnHglzWDvowguTqbKzR2pKUs4ysvPD
         /buqZFEgV66S/aGQnCVhguY5HbIA7PLnVUMSsCR79Tg6jIsTEY+hwop1piTwD39ZoOUA
         8LxI91mWYZnaamPfoiKPgFaLLJaAcHbQgjF280NT6PPmM1LNUEoHcNkwq8PoKqNGE205
         f6Ug==
X-Gm-Message-State: AFuF++n8DigPKdfjauPC6KD1pzdFv4uz+CSj8LSAb4gLiqW9Jxq/7mVF
	EBDTBC6oA0l3cVpAvllwMrnqfPjptfG3LKftCypyfmetF7X2SOP04NCQV739UA141raV17/vlDD
	D1zDvMmqd1TIOUeEClR/w213ZoFvuzFxWzg+Azgzw5w==
X-Gm-Gg: AYBFou28niQk4q6iJBqrd5IqwRfkWJSVpb/V6dPZtRg1I2qL6y8Qhxmmnm9AHrndC/c
	ClEtE6tQsds8UBKHBZLTHj1P2x1uW+s+UbNVH21q/qmdml9GvzlQqVeCyw7ZZljhT3qsOnf0L1f
	5W306Z8zrcVOPmlcUR7TZ7SoMqwhnU7npwKc+nVB/pptUv9l5e2n9L0LDcQWneozTlsa1Rjz8Ir
	db9/UkzozLM0RL9+Ovt5bEYF4TLqhbocNR345VTn+sSRrK/G8X48mRiRcROlRCZF7upcpduZTAH
	a+n35vgTJGN/TDm4QmsHKqVd8OG2CxiFtxh/wRTi7i+P2B7/l4NXAPAEZxv3En3L3HpLEzGvTDy
	GLU9Cmk8/ybJin1R3TrMPt3nBYmVkpaNRU5NuTFkj7Tl9Wknc67yZ1Id5
X-Received: by 2002:a05:6102:5114:b0:77b:ae7:1bba with SMTP id
 ada2fe7eead31-79ed34ac59dmr1598366137.3.1789480227101; Tue, 15 Sep 2026
 06:50:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACjaXw6GpV6E+G81qTtdYwPHBSrk1sDmgmOG1dGSryEF+kVVSQ@mail.gmail.com>
In-Reply-To: <CACjaXw6GpV6E+G81qTtdYwPHBSrk1sDmgmOG1dGSryEF+kVVSQ@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 15 Sep 2026 09:50:14 -0400
X-Gm-Features: AcwNN1W-heuRtjONpJH7HyK5RcYxMC5appJUlUOY5X5GHNtdnwfQZQ7PFfOH0_M
Message-ID: <CADvbK_dNObq76nBsy+pHOYtw12m0Xi-3tvqevF4VjvK_SxzTQA@mail.gmail.com>
Subject: Re: sctp: prsctp_capable is not inherited when an INIT collision
 updates an association
To: Warren Briggs <wbriggs@cellusys.com>
Cc: linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 10:16=E2=80=AFAM Warren Briggs <wbriggs@cellusys.co=
m> wrote:
>
> When an association is established through the INIT collision path rather=
 than through listen/accept, the capabilities the peer advertised are lost.
>
> sctp_assoc_update() in net/sctp/associola.c copies only a small set of va=
lues from the temporary association into the surviving one:
>
>         /* Copy in new parameters of peer. */
>         asoc->c =3D new->c;
>         asoc->peer.rwnd =3D new->peer.rwnd;
>         asoc->peer.sack_needed =3D new->peer.sack_needed;
>         asoc->peer.auth_capable =3D new->peer.auth_capable;
>         asoc->peer.i =3D new->peer.i;
>
> Of the nine flags in the peer capability bitfield, only auth_capable is c=
arried over. ecn_capable, asconf_capable, prsctp_capable, reconf_capable an=
d intl_capable are all left at whatever the surviving association happened =
to hold, which on the collision path is zero, because that association was =
in COOKIE_WAIT and had processed no peer INIT.
>
> The case is with PR-SCTP as that is one we are trying to support. The seq=
uence is:
> The peer's INIT is processed into a temporary association, so peer.prsctp=
_capable is set there (sm_make_chunk.c, SCTP_PARAM_FWD_TSN_SUPPORT).
>
> The INIT-ACK is built from that association and therefore advertises Forw=
ard TSN, and the state cookie records the flag.
>
> The COOKIE-ECHO returns, sctp_unpack_cookie() restores peer.prsctp_capabl=
e from the cookie into the new association.
>
> sctp_sf_do_dupcook_b() calls sctp_assoc_update(), which does not copy it.
>
> Note that asoc->c =3D new->c does carry the value, since prsctp_capable i=
s a field of struct sctp_cookie. So after the update the association holds =
the correct value in asoc->c.prsctp_capable and 0 in  asoc->peer.prsctp_cap=
able, and every consumer reads the latter.
>
> The result is an association that advertised Forward TSN in its INIT-ACK,=
 then answers a FORWARD TSN chunk with ERROR "unrecognized chunk type", cau=
se 6, chunk type 192. That contradiction is  that a peer that correctly che=
cks the INIT-ACK before using PR-SCTP is told the feature is available and =
is then refused.
>
> Use case:
> This affects any deployment where both ends of an association initiate ra=
ther than one listening and one connecting, so that associations are establ=
ished through simultaneous open instead of listen/accept. In the associatio=
n that comes up through the collision path, the capability is lost.
>
> Reproduction:
> Establish an association through simultaneous open, so that it comes up t=
hrough the collision path rather than through listen/accept.
>
> The INIT-ACK carries Forward TSN Supported. The peer then sends a FORWARD=
 TSN chunk, and the receiver answers with ERROR, unrecognized chunk type, c=
ause 6, chunk type 192.
>
> Control: the same test against an association established by listen() and=
 accept() on the same kernel accepts the chunk and SACKs it.
>
> Proposed fix:
> Carry the flag across the update, alongside the auth_capable assignment t=
hat is already there. The value is the one the peer advertised and that our=
 own INIT-ACK was built from, so this restores what the handshake negotiate=
d rather than changing it.
>
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1128,6 +1128,7 @@
>         asoc->peer.rwnd =3D new->peer.rwnd;
>         asoc->peer.sack_needed =3D new->peer.sack_needed;
>         asoc->peer.auth_capable =3D new->peer.auth_capable;
> +       asoc->peer.prsctp_capable =3D new->peer.prsctp_capable;
>         asoc->peer.i =3D new->peer.i;
>
The patch looks good. You may also add the settings for other missing field=
s:

        asoc->peer.ecn_capable =3D new->peer.ecn_capable;
        asoc->peer.asconf_capable =3D new->peer.asconf_capable;
        asoc->peer.reconf_capable =3D new->peer.reconf_capable;
        asoc->peer.intl_capable =3D new->peer.intl_capable;

Thanks.

> Conclusion:
> This looks like an omission rather than intent. The auth_capable line was=
 itself added for the same class of problem by commit 1be9a950c646 ("net: s=
ctp:inherit auth_capable on INIT collisions"), which fixed a NULL dereferen=
ce caused by the stale flag. The neighbouring capabilities were not revisit=
ed.
>
> Observed on a 4.18 based distribution kernel. I believe the code is uncha=
nged in current mainline, and the diff above is offset against the 4.18 sou=
rce.
>
> I have not built or tested the change yet, so this is a report with a sug=
gested fix rather than a tested patch.
>
> best regards,
> Warren Briggs
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
>
>
>
>
>
