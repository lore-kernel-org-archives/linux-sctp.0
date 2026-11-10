Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794324709;
	b=ZCtiZYYc1vRyXY64Zsy6aqg2UOFY7DUM7XKzr4/uV6nbi6jLzTQPb1bU9l8pvffMuVRB
	 5qb0tbcjqdaQIt7x2Moue+ho2vC/mZwo+0h+pJIKFBtt6p0IE9NkxqTLRT2cYRI1oPwGq
	 y8y/LYalU8NKP9YPAMYc5nlznPpx23qtt0c7ftpqEAiK7nDu4vCpaEHWj1yoPWoqb8Nlz
	 hcZt9E1x+rPf+W92hef+qCHmauP12NbawveGYV9nDrfYMm4i4KYjcKkcgeuU3d7QHqt3p
	 HBl1ULQQBpPtrDxRlH2FeyC8L+AlI4JiKvavCfH2RqoAug0Lrt186rAllPg2NYnjprA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794324709;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=K1/d2NyIuCP6NUn/LZuS44tPxEN2bj+/f16ojUcHMk4=;
	b=tlYZnVuNyD4vIlbbWh5VOhEZCebsgXc1S/LjnvXzeUDAUnjRUPtWxMTNogBt5NBg9gyT
	 soJyY9j5RBDFrgTF9M1kkDPmVb61p779d574KF/qvGs+ciIeJ0amdm0Dvoql3zOjQFg/h
	 KfWySGOGQ1kscbEv8d++HylrnvyV7DkybJO+7dHmNr0ly79vetd9Ibsty73dI1i2z3xZx
	 YglLjfl2BGDQsiFOAuXTEBcI2S/opBq1BSxrq/xE5Lhtznjs9tWtemF8ooXM+qUx3Z2/u
	 JL2HJrJ8CCAU6Zz7O7r/8zUlev1JNucHBS8fz7ryNfRpjTRp6WqCGK1h/76fzJQDFEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sOnALV4R;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEE460A2618
	for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 15:31:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DAEE460A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sOnALV4R
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d2db6408cfso1188799137.1
        for <linux-sctp@vger.kernel.org>; Tue, 10 Nov 2026 07:31:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794324708; cv=none;
        d=google.com; s=arc-20260327;
        b=s08w4FttFlUhh/hKihzQk2rE3d6B7Av8jfcSLwXG3r1Zm/xxkimK3F8FVErbKGXibv
         XnSCZ0xjW7CqIs5pX2QHSVgeEB0na4bVVWOC7LhNMjcHgLfaQximxGUVE69tIJN/0kz7
         MUIkNeKArFCLzR40zJ9pW0GBRj64C2hBBQ8qwYDkMiEn1D6N8HGmD4zqF39Uar6kVfNY
         oJN6WXc6OrMOEMcsGGdQFpl+ulAJbsubL7rPQvmVp5PiKCmWMTuffv3JOZqH6XnNiTeD
         alxV3vBJ/7cMxcdwP0cM/3TQWdB0Wg5lpCAl4UT0EYtAxXdZnA581vmXJ0Zu2ibwGPnA
         pJwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K1/d2NyIuCP6NUn/LZuS44tPxEN2bj+/f16ojUcHMk4=;
        fh=CPxu1SsL6jyLWklqskK9td+yCIJYNhrC5wXl8l24M6U=;
        b=Ii8kBnudNI4tyl9JfQhsWUGUCncX3lmOp6QqFdAjyOqXiCX9LkLZpf+epKZWQQ5H9I
         DR0cqCsPzxTA4Au1mpO6M+AzSKdK6J4iYLbhEFFbHrsG974fv5/8dMar4rpH82QlCGvk
         KLMnERL+aQyWXhIxxKO7nO/TqHmI9crWu9dpcQRJLb40iFAeefAF0jzHuRl91TfmLGN0
         qppdUym1fRZljpRCcBiRSbASB9o98vO9GMT8F6KExAIxrV3mFVdJYWkEBlrmjfrSdD4g
         gDUJxC+cqhCDhqM46hXtMG60q/2q+/sG7frzYyPt+THue8vZkG/DhpSGuvvIBjbNiwE2
         tDQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794324708; x=1794929508; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K1/d2NyIuCP6NUn/LZuS44tPxEN2bj+/f16ojUcHMk4=;
        b=sOnALV4RabTW7TXx7rjmDTNsf5tHHAYmUXJwgfUDq5UM5W3BHjN5iBQXvAvIlZdHDT
         RunsTaxFGOmPsBVI/UWUQRUU61lGTeSOTV7Ls4oDevMfljfbDaejNb2p5o/je/oUzQVN
         ODiTECjiawd9dA5ApJKl1GPG+snrlUdzTJMDx8+vzHyuEIH8h5PdZF+FRvrol+Yj/3gJ
         vRHo4q1oHwQ11AsQGydfRlFpUdIMf33G3Tui7lBp/+FbxkDoWkLiGS2AisC+jeSvVL+J
         uMeijdhrcOXb3WUOVkGaNpFRye90vYvFGNsOPsPzp+zSZMQDurT6HH2hkHYZo/OmfCgj
         omvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794324708; x=1794929508;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K1/d2NyIuCP6NUn/LZuS44tPxEN2bj+/f16ojUcHMk4=;
        b=xyPDTKZPhTYVLT/HiawXFHDwcpMB28kyuZIHj4+JRWd3stPFq6QtiaAkgZSg3D/e+f
         DsO+GGdPoL5qwvJr/06vGYwbHrYr/KGzWZtj0l0LF9HfCCST1HCSdgW+Prz4QItCAsze
         +UXEyBqiVYC/DrBvxFCPG1ZPwpRFKBrENPXMsavQQ/9nq1CaQXjONHxLrsAvqCy1SDNf
         UwJ/93vpMAfjaHTV1M35DYK3T+LvXIo4qqeCofKdUS+tp4/6oQ7iiWSGOb6TbSdtCUZV
         DexZ2bObNiQ/hGgmsORHF/UYIgx5Mb2Lh2ff6XEtNWpo5JtgRlRz79GsRJssq/tpT3YT
         5IhQ==
X-Forwarded-Encrypted: i=1; AL+hErH1LqdhY8MiLoeGG4NiNPHTQfbwOpXjBJSi1dYnjT88pkfyWTubvT0tZkNn2kvf/WYv+MFixyLXb45p@vger.kernel.org
X-Gm-Message-State: APuU4Z/v67xaUYbb0fYjyDZwovnWDQItuV97tnttDrR8488bdzK9cMog
	4xjILKzctFWEtPEww9JTWCNOGeM3Vn7arsbXTLkUaaoAUPEqcNis7dd5d7IuWbzKr7K7uaywQUz
	teJCfGEMFwIxgc+ogyVXPwkRZlNU5h1M=
X-Gm-Gg: AYBFou0Hm16GZXldEgJGx69dTGCoLKBvFa/QNOCl91WMfLop6EvXm7XwA0CnhDy+50f
	3VvC4X72ZRClG6msUZiOhCCojRaCvHYmbb+j5YPA7K6mDQFCjPDf1fyJayvJFjsZ4FtuFd9IhFQ
	xrpy0ZV/vq67NKjTeVWSKr1oif5j52UZPPSn27DtSC6Fv6tuUFbP2Af+7pi+0qBTQ96PamjJg86
	QZHABZ6NVVz48ad8n6eWxxN6tOCvux0cpBpwNdjnDw2sYTFnVm026kKHMzFQg4Bp6yO2DmFPwwQ
	6KQ1BQn0q5qF+TLReH7RcYMMhKG5FNo0VvUHqxY4D1QmQ2tN5Kax6yDJd27Du8BzM7r/dxQChZz
	OO2GFBM6SZXDhsOZ+78zUylG51TBWYvkPAtv534T0YlGKdqDqlglAqN2UOUCpXyZhcyD02w3A15
	Hwa/siuO1rPKrTdWS8YFVKOQgpRMNodMxlDdNs0w==
X-Received: by 2002:a05:6102:1629:b0:7a7:19aa:8a88 with SMTP id
 ada2fe7eead31-7d301c1ac50mr1147212137.35.1794324707817; Tue, 10 Nov 2026
 07:31:47 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261108161149.2774119-1-bestswngs@gmail.com>
In-Reply-To: <20261108161149.2774119-1-bestswngs@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 10:31:35 -0500
X-Gm-Features: AclHuK9iYVUMVhjgMP1YORbw_EmIVcS02-pRhlLXyvezE7vMUFhkCvMgT7r-RmU
Message-ID: <CADvbK_fGfv2k5rB1Q4Q-OwzJicXbKzs1ofW48F2prx6Z15CQZg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: reset stored flag for each association
To: Weiming Shi <bestswngs@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>, 
	Michio Honda <micchie@sfc.wide.ad.jp>, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, 
	Xiang Mei <xmei5@asu.edu>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 8, 2026 at 11:12=E2=80=AFAM Weiming Shi <bestswngs@gmail.com> w=
rote:
>
> sctp_send_asconf_del_ip() walks every association on an endpoint. The
> stored flag records that the current association took the single-homed
> deferral path and therefore did not allocate an ASCONF chunk. It is
> currently scoped to the whole function. Once one association sets it,
> later eligible multihomed associations allocate chunks but skip
> sctp_send_asconf(), leaking each chunk and its skb.
>
> Reset stored for every association so only an association taking the
> deferral path skips transmission. In an A/B kmemleak test, the
> vulnerable kernel reported 210 leaked objects from this call path and the
> fixed kernel reported none.
>
> Cc: stable@vger.kernel.org
> Fixes: 8a07eb0a50ae ("sctp: Add ASCONF operation on the single-homed host=
")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>  net/sctp/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..ed91ceff45a9 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -771,7 +771,6 @@ static int sctp_send_asconf_del_ip(struct sock       =
       *sk,
>         struct sctp_sockaddr_entry *saddr;
>         int                     i;
>         int                     retval =3D 0;
> -       int                     stored =3D 0;
>
>         chunk =3D NULL;
>         sp =3D sctp_sk(sk);
> @@ -784,6 +783,7 @@ static int sctp_send_asconf_del_ip(struct sock       =
       *sk,
>                  __func__, sk, addrs, addrcnt);
>
>         list_for_each_entry(asoc, &ep->asocs, asocs) {
> +               int stored =3D 0;
>
>                 if (!asoc->peer.asconf_capable)
>                         continue;
> --
> 2.56.0
>

Acked-by: Xin Long <lucien.xin@gmail.com>
