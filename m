Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322C3BB68F
	for <linux-sctp@vger.kernel.org>; Tue,  4 Aug 2026 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785855355; cv=pass; b=Od8wVLsmSzn+QDMvRbsRSSYoOTGZzJF876FaX9byi+E1V21vojAdKty56W7jcb5cb/0g/78I6meK5ACndV+MS7TphUOKYzI4KVQiI7odqroJB5bArxiKJTIz26LftWuXTsIANxI7DbUczHqtfH/bzqWNP6E8wYnl7zUPX8ZsJ2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785855355; c=relaxed/simple;
	bh=xXZsXGMdOeVDMiHp4vHerDw61+liqUOvH+hFrD8ixrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=so6teEQOhdtRgKtL5RNW5mQDYk5cnvuU2S1QUfACGB3izVFqWT5hJAz5/hcHcjV36Xmt0TlNOs0DxVgn45LIkUVZlicb09q0/OsL1FgBCYmJaHe6lIhZOse0RlwgW9kI/7QXNlNSVH6rAjJWE6BPkd1Dtsa3bL2k67iV9ke1Rws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mpwvEmlZ; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mpwvEmlZ"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so3960384a12.2
        for <linux-sctp@vger.kernel.org>; Tue, 04 Aug 2026 07:55:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785855354; cv=none;
        d=google.com; s=arc-20260327;
        b=LL0Z/ykSolE0mMjNP4e6nE6E+yP7b/GXVAmCjZTYh510O3y6yFhqNzeEzU3xbkaOgZ
         VIeNW5ZkXf44GZF1VUxQcjVNNgtpFN2tJDn77euOCFl7JdSVic7B0UoRDe7HsPQNgOj5
         TUVDLfbaGBEpRJs+NWMNvNSZAr8F0jXnO/Dv2U3CKA4OTov12PkO8aJwhx6wvp8s1GZ8
         BDBSr0CIoFOzPn0WJRcymyvE8zWp6c53XZQrvWXHidFWEshYmaMauwusAN20TocE8hij
         CKLdOVGhD/MSbnC5VD/y0J1n63V95hkGTAk7Dcu8Sm+2BP1ptUQg1K9jmFaFAmC6vTRJ
         pZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=anpq0fKk64NKEEVvvyxDatqldKxXjznL4AokdJd4HWE=;
        fh=A8eBn1RsEi0C1OxiXqIqkwLT1kQ2y64Xh3Zd7Yowrm4=;
        b=G1rRZ4K++MyIR7KeKoeVK9BfFQEDiQnqyf39OpDMo9+yOfoqLqSJNuLOp9jaJ38bZA
         yk1acPr567X2syPAGSD9JJtzc4klzwEuW2i9HBT/7tdytgNnCrZG64jCVa+Hbxv4s6Hk
         dKUwhX/8SGr9N9K7BPiA5FwowzyUjAxgw5QGnCcrqkMbnmmOli2n3askKsglH+cA85Y0
         NDyirnJ8olbUe59vzosxICyLAji7pd1ZnhIFS6cBOeGxVp1KH69SBnd9pbFqKHbavpGx
         d5YkmxqtIz3gqrMKG8yWevA9VXAiv0uTM6srJ+LawIBqSyuTzXXNrYZ0dYZozo89ttOI
         MO/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785855354; x=1786460154; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=anpq0fKk64NKEEVvvyxDatqldKxXjznL4AokdJd4HWE=;
        b=mpwvEmlZkO1PWAoDq8UNW+MOSHantShE7fO56v5+8NKG68QLwXuvIKnKy7ln3pZNfr
         QAa0yYK+Xp9/q5KNHtitoctAJwqPftsdpLNl7Y+QawrG25ig243xxupe0YcTfPMzntPS
         5KYEm4PKWZYBQLXwiazWLhMx0QIInm3vyuy/5aY4rJPMwmdTt+L6erIx+08n6lCw8/C9
         ssx8UGpMIenS+Z25jA8s05nebcaCXWR8TdK0Ltyo9W81v50I5+t6KdUEWVwxNRQjBOoF
         jp0VABJWb7MdzLZlQyzj4Nsk5NkwBNFxHrj1lSfu/qhnUc/Bm3Vj8xF0dItpdURWYh6n
         2qRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855354; x=1786460154;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=anpq0fKk64NKEEVvvyxDatqldKxXjznL4AokdJd4HWE=;
        b=da40iGglzDoQX2whC2K3MJDUr0a1rKxXT3DjrHvvQxGsQ/wCseHrWK35j9w+o8OgX3
         YtDTSNJFEpOwjjAZUVJMrZxJW1xfWxk6VrBbi2McDpM5weXIrmb8YZGQU0rFJ2cykDy/
         hVVE2LhPHuykLU1mLofcekdbrP3iwxvXVljL7Yfee7d0Y6Xh82eRZ/RWb8cNA/Eb4MQL
         3PVOCq0E7ovd1SU51oV/6yf3IHe6c6jyRnKXsQlbMBXL+Wei2OBmVRLtqvDDTi8yVQQj
         8g4Hi5v/v/wxn2YiRutDMPfXcNzWS0DCui671nFYGkHgcLDlGyWWn5tCyP4Y/lgCZ82H
         /JCQ==
X-Forwarded-Encrypted: i=1; AHgh+RreYPZkvbTkaAD8OA+qtrqgWhXSXaGV9HMOs6JtOtWqp+BTZE4BzYdvHkRJTLtod4hjUpuZutceZPyu@vger.kernel.org
X-Gm-Message-State: AOJu0YxqZIpoL7zoUipgRzNKp8oVAcnjJKdzEfCxpvGe2TNAwiNQ9iFG
	ZV7Nv+adAhmLzS7Y/W95my7AQqX5w+I3rGF32ZwxgyY/YgK2wMVoZhTqGGTcPKFgmyrr3IMk9b7
	/kZwmEwwwzg39SI26P1Kf5IghUtMu/LOq+gf3
X-Gm-Gg: AR+sD12My9e89qrmjvm1gs7mI0dilj3jeCcl5fbc6dbNX8J3hTGc4ZntfJW1K0Yj6sm
	PpXuqzSEHK3fUf7n8cnyt+j0fqoLlL9Y2lToaKkcBz5ZhlHVa2pHed/HWaaRTcvrm88dlNItBrU
	8kfvErgb8tIY2gDs2caaaetEwh8upwIME4lufdPPQNE+2vjP+brmQppuOASodVURqG38bzyGDqC
	WbrSuBacPYKwQ/y/3uGp1AM/F53sKfGgIVz+hl6wyGnkH0JaO7Er1qil88HOUnA5IUt3vD4YYWt
	9fW4N7L4ySD+XTjHYUnjAtxGaofbkG4WUenQeFddWuTigz/wCeRcHPZBaj5jeqIjhFfq83ZDa8R
	DkzmjPUQkiop9G/97dWjKDjfkv90uNG/3B4AWguVAxLsF
X-Received: by 2002:a05:6a00:3986:b0:845:e1a3:1080 with SMTP id
 d2e1a72fcca58-84ee49069bfmr13397193b3a.55.1785855353665; Tue, 04 Aug 2026
 07:55:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730090149.24040-1-juny24602@gmail.com> <CADvbK_fx=1mQZ4LaSvQj=3jW+=1zCUuAf1xZpiez7Mag4e_GDw@mail.gmail.com>
 <7402d0e3ade541f18d764ca6ecc037fc@ssi.gouv.fr>
In-Reply-To: <7402d0e3ade541f18d764ca6ecc037fc@ssi.gouv.fr>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 4 Aug 2026 10:55:41 -0400
X-Gm-Features: AUfX_mw2PO15vOwZ3fkplUdmdA9PhnnGQm9UK03AVlc1NCefoKnE5Fw5MMPvtsQ
Message-ID: <CADvbK_eGUBd0SZdViGZhfjcOn6vxQV1fchgJsC=ZBjfg+QNRtA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: bound the auth_chunks copy length in SCTP_LOCAL_AUTH_CHUNKS
To: JEAN Jeremy <Jeremy.Jean@ssi.gouv.fr>
Cc: Jun Yang <juny24602@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	Jun Yang <junvyyang@tencent.com>, "stable@kernel.org" <stable@kernel.org>, 
	TencentOS Corvus AI <corvus@tencent.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Vlad Yasevich <vladislav.yasevich@hp.com>, 
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 3:48=E2=80=AFPM JEAN Jeremy <Jeremy.Jean@ssi.gouv.f=
r> wrote:
>
> Dear all,
>
> Attached is a proposed fix that relies on a code suggestion from Xin Long=
, but reworked to better handle all cases.
> Does this look ok?
> I verified experimentally on 8ba098e6b6ff that this fix solves the two bu=
gs I reported.
>

Hi, JEAN,

I think the fix only needs to add sctp_auth_verify_cookie_params() and call
it from sctp_unpack_cookie().  Since the reported issues are caused by
tampering with the cookie auth parameters, I don't think the other changes
in net/sctp/auth.c and net/sctp/sm_statefuns.c are necessary. Could you
please confirm?

Also, you may consider renaming it to sctp_auth_chunk_id_forbidden(), so it
can be reused later to replace the existing open-coded checks in
sctp_setsockopt_auth_chunk() and __sctp_auth_cid() in a separate patch.

Nit: In sctp_auth_verify_cookie_params(), too many lines for these u16
variable, please merge them into 1 or 2 lines, like:

u16 hmacs_len, chunks_len;
u16 n_hmacs, n_chunks, i;
bool has_sha1 =3D false;

With all the above comments addressed, please send the next patch to:

# ./scripts/get_
get_dvb_firmware   get_maintainer.pl
[root@wsfd-netdev64 net-next]# ./scripts/get_maintainer.pl net/sctp/auth.c
Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> (maintainer:SCTP PROTOC=
OL)
Xin Long <lucien.xin@gmail.com> (maintainer:SCTP PROTOCOL)
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING [GENERAL])
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING [GENERAL])
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING [GENERAL])
Simon Horman <horms@kernel.org> (reviewer:NETWORKING [GENERAL])
linux-sctp@vger.kernel.org (open list:SCTP PROTOCOL)
netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
linux-kernel@vger.kernel.org (open list)

Thanks.

> Regards,
> J=C3=A9r=C3=A9my
>
> -----Message d'origine-----
> De : Xin Long <lucien.xin@gmail.com>
> Envoy=C3=A9 : vendredi 31 juillet 2026 17:27
> =C3=80 : Jun Yang <juny24602@gmail.com>; JEAN Jeremy <Jeremy.Jean@ssi.gou=
v.fr>
> Cc : netdev@vger.kernel.org; Jun Yang <junvyyang@tencent.com>; stable@ker=
nel.org; TencentOS Corvus AI <corvus@tencent.com>; Marcelo Ricardo Leitner =
<marcelo.leitner@gmail.com>; David S. Miller <davem@davemloft.net>; Eric Du=
mazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni =
<pabeni@redhat.com>; Simon Horman <horms@kernel.org>; Vlad Yasevich <vladis=
lav.yasevich@hp.com>; linux-sctp@vger.kernel.org; linux-kernel@vger.kernel.=
org
> Objet : Re: [PATCH net] sctp: bound the auth_chunks copy length in SCTP_L=
OCAL_AUTH_CHUNKS
>
> On Thu, Jul 30, 2026 at 5:02=E2=80=AFAM Jun Yang <juny24602@gmail.com> wr=
ote:
> >
> > From: Jun Yang <junvyyang@tencent.com>
> >
> > sctp_getsockopt_local_auth_chunks() copies ntohs(length) -
> > sizeof(paramhdr) bytes out of ch->chunks without bounding the count.
> > For an association ch is the fixed-size asoc->c.auth_chunks[] array
> > (sizeof(struct sctp_paramhdr) + SCTP_AUTH_MAX_CHUNKS bytes), whose
> > length field is restored from the received state cookie by
> > sctp_unpack_cookie() and is not validated against the array size.  A
> > cookie carrying an oversized length makes copy_to_user() read past the
> > array (out-of-bounds read).
> >
> > Bound the chunk count to SCTP_AUTH_MAX_CHUNKS before the copy.  That
> > is the most valid chunk bytes either source can hold, so legitimate
> > output is unchanged, and it also covers a stored length smaller than
> > the parameter header, which would otherwise underflow.
> >
> > Fixes: 65b07e5d0d09 ("[SCTP]: API updates to suport SCTP-AUTH
> > extensions.")
> > Cc: stable@kernel.org
> > Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> > Signed-off-by: Jun Yang <junvyyang@tencent.com>
> > ---
> >  net/sctp/socket.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c index
> > 9a6da4e0d741..3e9dacb772a0 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -7109,6 +7109,12 @@ static int sctp_getsockopt_local_auth_chunks(str=
uct sock *sk, int len,
> >                 goto num;
> >
> >         num_chunks =3D ntohs(ch->param_hdr.length) - sizeof(struct
> > sctp_paramhdr);
> > +       /* asoc->c.auth_chunks[] holds at most SCTP_AUTH_MAX_CHUNKS byt=
es but its
> > +        * length is restored from the state cookie and is not bounded =
here;
> > +        * clamp so an oversized length cannot read past the array.
> > +        */
> > +       if (num_chunks > SCTP_AUTH_MAX_CHUNKS)
> > +               num_chunks =3D SCTP_AUTH_MAX_CHUNKS;
> >         if (len < sizeof(struct sctp_authchunks) + num_chunks)
> >                 return -EINVAL;
> >
> > --
> > 2.55.0
> >
> The issue requires sysctl net.sctp.cookie_hmac_alg=3Dnone, right?
>
> If so, Jean Jeremy has reported two issues caused by the missing validati=
on of the auth params in the cookie. We may need to validate all auth_rando=
m, auth_hmacs and auth_chunks in sctp_unpack_cookie().
>
> Let's wait a bit and see if he proceeds with the fix I've suggested.
>
> Thanks.
> Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=
=A9es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=
=99ex=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=
=A8rent dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessair=
e =C3=A0 cette relation. Si vous souhaitez faire usage de vos droits de con=
sultation, de rectification et de suppression de vos donn=C3=A9es, veuillez=
 contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message pa=
r erreur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9dit=
eur et de d=C3=A9truire le message. The personal data collected and process=
ed during this exchange aims solely at completing a business relationship a=
nd is limited to the necessary duration of that relationship. If you wish t=
o use your rights of consultation, rectification and deletion of your data,=
 please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this mess=
age in error, we thank you for informing the sender and destroying the mess=
age.
