Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794276634;
	b=gc3PRgC304hrnFpnSQZAak9CWIuC2RAx5AZEqDjvrlnJEL9kIel6ZtKwsBcJi+65llP2
	 53+H7LoVQIhriGjffmKhoABXEFS3F1RAL9MgAJEENKDkRdf9/gazyqbGkgwj721RNNXvE
	 xdEOvzsNiL+0/jR6mvDVKZlG+358supZhRiN34Dgl0raqUdii9TlNVAhWtXQSzrPVtmNG
	 Cnkxjr76se/e5427YV4fM6mPcagDwLYLhoXH+dAEwceB8hlKFKayvS7wNYXsNX5/UyV1w
	 KP7rQvN0qFLKG0en+bqRla/je9f2PqS7OIFl02vmRgkRaMGgvnd7n2sZh1onK2CimFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794276634;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=GU9EjYSQxV4eVGM8pi1wTcBqlYubWYJf24gfH5mqmRo=;
	b=wqGSqAb0gM1DMN2DURH/48HXZrjCR72RPoRZtIPLOlnKWSMzujnKkcxtilR3xbZ29Xrf
	 YBAMuq7QyXaEZh2nxEXLIbgVWBzHqkSKH1PNAPlMhwu/3PQYSV7T5yMiajAtrTlQLb4HR
	 S53ivzEtoD2uaYjF+ouNu8vSs0LugRiTM67SE3rhPQLE9XhjB+ma/LSD5yIJBLk1+E8JQ
	 jN78N7h6BEyZZsYCAi1PS406u7bbBBoleptLCpva9KwnZpBP6L29odr/XT3GJuE1tSil3
	 8/WuaZJnQTbYPl1HdfdOSHo/5//S2Mq5RGLDWsT1jHdJFXDuMw6lUNrfdYOTPdxzE9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jx6UBesi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90668606A325
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 02:10:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90668606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jx6UBesi
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so868868b3a.0
        for <linux-sctp@vger.kernel.org>; Mon, 09 Nov 2026 18:10:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794276633; cv=none;
        d=google.com; s=arc-20260327;
        b=VEN9r0NLFbqkEs+UuAY6lCxQQ8EMOBp5haHUtCWWFAbA/iwgTF+QDI5F02ZmNprXlz
         I4PBOdsAOMNUAg+PX9dFIEpqKx+F7OAmcfFZ+6ud4g3/pANZ5Km+xsBlgsm9CIrBTvdl
         83lkogDWVtFmKa3Zg7r1OBXmTR0MlePusKHMkRXV++KC+2r6M5Gwu5MwAydm+B6Xddz1
         oZyLUW5LOytqABsUXITBpa9Wrp9ksBDLLD+nj14pZfBQ1LQzrcsdrT0pyFneg5yFJ4qT
         LhA1OAnQRpfEzEWrlLrrGBH1aEVEwaTKC6ovB80KsqvcQLOESOYOPa4/4aq5f7lhp3Pn
         APqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GU9EjYSQxV4eVGM8pi1wTcBqlYubWYJf24gfH5mqmRo=;
        fh=iFBe1hZySXsOGAxN9y9kRssHs41OiRnrSB00fqGO5mE=;
        b=pDArvy/dv7ciB+Sv5QzfuenmonyUjYdncpb4zdY5bFWrNYiYXHunUuTCs54BBP3f50
         6Bc2MklUWLM65poefgSnna26deFp61IW5nNZGbDA1z+EXjtYZUUtpUCGLyO7Byd2gGY9
         nsdAX2X4lsNlful4DsgbANC5s8AZX71d57RvqYjjsyP4SLjntobEQRiHUPU291z/4Or4
         onaoVra+Fos8/6UygqtZNGrErw50NSRBtF3DcwOa7+3cNASJjWttD6/UzPYctt93b+92
         /aVxeZcjCdZnQnk9RMioed50w/TSOU1+sYEJtxCPR0OGu0KHoDyxFBChLL7gl9kcGKtL
         3yqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794276633; x=1794881433; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GU9EjYSQxV4eVGM8pi1wTcBqlYubWYJf24gfH5mqmRo=;
        b=Jx6UBesibvKmFXUbiN1heQ0gwpowE3/vZ86/WkwBWZjvZ5aRIqEPr5NCXsRZN9FkGq
         /zKHRJaBYarzlNszLkbDm7gBobre8/jK2rb9IaAb3Ip5Gusn+UHQFfXM7x8Mlia+QsZi
         AftAcFbmRg7+SOxFGhXLSxbcBgwWQ+Z8tQsg3n1UjTo90zNKNkWLQAhTUA2mnu4CFDNh
         a9z79bhvI7wmB3JBpmnURO9MvhIrCQ1jT6eiPCfDF1RlL+O2VSVeYn9iizYF2ynDoPYs
         qR1R5FnAorCK2qjBBEuK7/gIaK8DOZJFOWVdHQGSlTYqOFPyALOtlxhNA9ZtnIEPbaDS
         aoYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794276633; x=1794881433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GU9EjYSQxV4eVGM8pi1wTcBqlYubWYJf24gfH5mqmRo=;
        b=X9KHgOlDoRbg945wVu2QugGDnfGsK2obUZn/kgh8XpbRmz/LannEx5oFakJt8OWuum
         1OSrpo2s2ltGLYdm0HJga0g2Kd0jtPqXiQgt3/m8Xb3zSSe9ohgpIzIjP94g2AzM+YtG
         xWSu91gfyY81lrUM36TKlv8dFd2iCUhtFh6nWeKhD38iDpwpiGNT5+LB7ontQ8RpZYTG
         uvW/fx2EoOIQ9LhpNRSRHVNQbbId3OdtQKR14IlrPaRC8+MF5gCHI5VMgabudRVTnllA
         vo+f1ie+AUyBr75R+PFOqH4kcz09KqtR1zv4bJkvEtk1DrZ3Lcr49+GCTnf7ys5t1fX4
         nqSA==
X-Forwarded-Encrypted: i=1; AL+hErEzmdUIJ/5/5D0n8Fnv1S6U+lIM5ZEGnZ6y4oxMyIXzylPWkzdeHaG5uT5dbcc7M3KOCt/qKe0et/wr@vger.kernel.org
X-Gm-Message-State: APuU4Z+GwQrVkbiOxlRJfoAgbMm1YgaJ7IvDHhdLrzdFk3gX8WWzlFSU
	nlaEvZuqJ79MYLjcbiEXAlP8LYIwLyy/ZvNS2MoOuz+7UT+BiljzHJow0MydCF45g4wOqW9pcXW
	lGPTwi/nfeQIhIMmAKolkVgxpOFd3hJM=
X-Gm-Gg: AYBFou2DTjAM5WMxOU7NQxK/IcGBIkofvPAg/wSzcoAlvNmeMXYF3kxjELs+mvZVc2L
	ukSi9TNrmopi8VCiQlIWO8+GWvoCAYRWNgnGl6zeYCAclAdhdGaxdeYpHtjgLu4r6nVxaeg6fbQ
	qDEGhIA67fsaYrzyw+4K0KUe2nfV4N6Rs6QSJVjtaWdlnOo6OEBSo6xntJ5t6sh/OV+Zy2CzbZu
	zBCJTf8NB9ad4koqzHVKve780jW2DoHf+4Qqn99Ozh0StAer0h/x84paQLlQ0KuIeesnS0JlC06
	0V1cHOXIMtjZLzWrcI3qeeYKmyKwAa/Y3gdRMGGOOqO3CKkf/jaVfCZwLkqeW+Yye6rek2Aw1/H
	Ill77FDxV+jcl5eIUUpv9Mq64HcCxp3jmjsG/oTNKyOzU/bsNS4ySuQNFl/L+t1PplKMLPAutkQ
	Hx+n+91DlsrP1bOsYZtCDG3PThQ23UvzFOgw==
X-Received: by 2002:a05:6a00:391a:b0:8b4:b88a:c2d4 with SMTP id
 d2e1a72fcca58-8ba881e8931mr1491983b3a.59.1794276632703; Mon, 09 Nov 2026
 18:10:32 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
In-Reply-To: <20261106195126.1563231-1-andrey.misyrov@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 9 Nov 2026 21:10:21 -0500
X-Gm-Features: AclHuK_xDqAXw_TmBik1qZpjy57T3ZinrxmJok9KVaPZUDx9W2Oq2jkZuacmkfM
Message-ID: <CADvbK_dNcVHxMQ4NhqZqVFCcCy0R_ufW=QbXXyVFdhV9B7O43A@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix ASCONF address change on single-homed hosts
To: Andrey Misiurov <andrey.misyrov@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jun Yang <junvyyang@tencent.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 2:51=E2=80=AFPM Andrey Misiurov <andrey.misyrov@gmai=
l.com> wrote:
>
> Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
> DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
> located by, so that a later wildcard DEL-IP cannot use it after free.
>
> This also breaks the single-homed address change (RFC 5061 5.3.2). The
> host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
> is located by L, and DEL-IP L is now refused. The sender never gets an
> all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
> data, so the association stalls.
>
> Fix the wildcard DEL-IP instead: look up the transport of the packet
> source rather than reusing asconf->transport. Both DEL-IP paths can
> now free asconf->transport, and chunks bundled after the ASCONF still
> use it, so point it at a surviving transport: the packet source for the
> wildcard delete, the primary path for a plain one.
>
> Found by manual code inspection while reviewing a backport of commit
> 9b2854f86f0b; reproduced on a two-namespace single-homed renumber.
>
> Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-=
IP processing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
> ---
> v3: a plain DEL-IP of asconf->transport set it to NULL, but chunks
>     bundled after the ASCONF dereference chunk->transport (e.g.
>     sctp_vtag_verify()); point it at asoc->peer.primary_path instead,
>     as suggested by Xin Long. Reported by the netdev Sashiko AI review.
>     v2: https://lore.kernel.org/all/20261029193454.1028626-1-andrey.misyr=
ov@gmail.com/
>
> v2: the reworked wildcard DEL-IP branch could itself free
>     asconf->transport via sctp_assoc_del_nonprimary_peers() and leave it
>     dangling for a bundled DATA chunk (sctp_assoc_bh_rcv() ->
>     peer.last_data_from) and the following SACK; retarget
>     asconf->transport to the surviving peer. The pre-existing wildcard
>     SET_PRIMARY / sctp_source() point is left out of scope.
>     Reported by the netdev Sashiko AI review.
>     v1: https://lore.kernel.org/all/20261022163639.2566945-1-andrey.misyr=
ov@gmail.com/
>
>  net/sctp/sm_make_chunk.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index ddc31a5..9719464 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -3151,9 +3151,12 @@ static __be16 sctp_process_asconf_param(struct sct=
p_association *asoc,
>                  * packet MUST be deleted.
>                  */
>                 if (af->is_any(&addr)) {
> -                       sctp_assoc_set_primary(asoc, asconf->transport);
> -                       sctp_assoc_del_nonprimary_peers(asoc,
> -                                                       asconf->transport=
);
> +                       peer =3D sctp_assoc_lookup_paddr(asoc, &asconf->s=
ource);
> +                       if (!peer)
> +                               return SCTP_ERROR_REQ_REFUSED;
> +                       sctp_assoc_set_primary(asoc, peer);
> +                       sctp_assoc_del_nonprimary_peers(asoc, peer);
> +                       asconf->transport =3D peer;
>                         return SCTP_ERROR_NO_ERROR;
>                 }
>
> @@ -3166,13 +3169,9 @@ static __be16 sctp_process_asconf_param(struct sct=
p_association *asoc,
>                 if (!peer)
>                         return SCTP_ERROR_DNS_FAILED;
>
> -               /* Don't free asconf->transport; a later wildcard DEL-IP
> -                * parameter reuses it.
> -                */
> -               if (peer =3D=3D asconf->transport)
> -                       return SCTP_ERROR_REQ_REFUSED;
> -
>                 sctp_assoc_rm_peer(asoc, peer);
> +               if (asconf->transport =3D=3D peer)
> +                       asconf->transport =3D asoc->peer.primary_path;
>                 break;
>         case SCTP_PARAM_SET_PRIMARY:
>                 /* ADDIP Section 4.2.4

Acked-by: Xin Long <lucien.xin@gmail.com>
