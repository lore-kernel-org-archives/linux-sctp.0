Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1A03DDAF5
	for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745553; cv=pass; b=QEILjYyJpt11gKKmSFOy0pam0QPdgJ4VGGcd2vli9iAHdOpNN4RHBSk9YfnnwehmmlQ1ajt4UnL7wEZ6wv3qumb7uuyJb0BIKaSzFwErqC4mrGOG2hyPssPX3+vAeWlluaNHC3J1Xs6vlay+UgwHDBMV5EMhIqPYFmrTjryo0n8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745553; c=relaxed/simple;
	bh=ymSNiHBv0rxNjhBEBzAQ3e5pEXSbhOPJPBVgbAV4qGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ctd/Yn1elLSf2gmoeC+Q4gaZo6E49g3LTwUszLTP1ZhfIeyOF5o2oP221kO2gFDXLV5nfme04M+kS2uNd96M1jPXp29J/k5l78BxdGlLKJTzKpUuOHsf3bW3li/jQwfwJquM2IHJ/4to+0M2S45kf82IWeCSc4YpmkKjsmAi67o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y6O1VpwI; arc=pass smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y6O1VpwI"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8686f46e4adso795007b3a.0
        for <linux-sctp@vger.kernel.org>; Fri, 18 Sep 2026 08:32:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789745549; cv=none;
        d=google.com; s=arc-20260327;
        b=Na6aYsFDgtA1Z8VxrNh3/IHQ4lLLzk9Obn1DB/eqL7yipd61HozXYrqYdPUoge+9TW
         LD7k39SrQ8EcML54aB+OIJvS83It9AdF1wzlR/Pm6LkRxnS6AGrt5Q+NkdBknWmrCJ6l
         qHp4cSsMTQdQuuKQJHs7rLNxadXfEou4T990uTMdol/GIGK4kAQVKX+u6KlBxIVOmMJk
         Ueye08iLLfR1y6GqdN1Ps++rMCSQWdaJdKBuMbxhcEa+GHpuhrIv76QP7HyATh5lrqN2
         lbB0bd79FlGuYv5lz5hhkL8lYy8v7xMfWmfJ8eyT2cR7I91hk0AvEbpirKkQj8AXiih5
         LuZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W1ylXOncdQ/xqG+G6xMvP7qzdxs98+NQiLMh31Gq++0=;
        fh=NuVdQZm5K+n26iK0MvnqnCv44BLiGjQGYO8qp6LLFRY=;
        b=Nqs9FUuKcLjoNEig5EffU8r632hp5iRRTaJ+IrCQBg1YwfLqBm+qQvZ7AE/+hozCUn
         WPQCopRxk3O8sQdvc36A0hDahj54M1r3nAWUYmAYWmaSWTYTti5odeEuRHiUd9wLIyV8
         zdcOBHzVPhZbk7LxG//Y+zjlzeWsISuzcweiPlZgrFgNN+KzjtCDaCyegPwy/2+RECz5
         BkGMexWEuo1BGfkUOiupu/0uf365lVhu27E/hRH4ACKmcWD32tYzSl2fA0JZvV1oG9u0
         hfo+Dm+FIj1C1zWk8BHcuo2fHqS019a39CnWhOp8aX3NWb+/sqar/6wbudY66xfQcTMM
         BgJg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789745549; x=1790350349; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=W1ylXOncdQ/xqG+G6xMvP7qzdxs98+NQiLMh31Gq++0=;
        b=Y6O1VpwI3Meq1JdZzi31TXfQpcpanZ4wlV9iuXpd5sjIig7phQgfCU47aWyfR6vo5k
         fF5qI7YbZKJqfy+x8XAZFltiJon4GuQN8WBUzqUeSKaguTIN3WWM42KofwVy992IGB3D
         A/KwLB5orHlmqbo35PsAsbVq8pWeMtHNIK0XxYEMlpSTBYYH6K1HR6U62pwvfxU6uZZJ
         QX9pHkygNT6TFTQDXgl7UFGsE89L7ug/iJ1SDQBdIjMEx4okR95NWxfMUcFzo2x7Tnf3
         0vdbG2BYhFcpGWJ8wwNFfDRQ8xHV1NJxG+crmfcpyiZ5BtlOGzbEKTHAhPTV/xTWj6Tu
         LwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745549; x=1790350349;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W1ylXOncdQ/xqG+G6xMvP7qzdxs98+NQiLMh31Gq++0=;
        b=p3uVXhDKWEVZTwLNZFiBlip1PxyulbOoniLhNJMoGZmHi3Q11vlXxN6PuGd+BarIRN
         DG7B6YN+A1RM1/6UrGOcE6iN8jTHQes/TjUx0AXBwcEldI2DX5R3T2Qjwvm25AtfzhsV
         dzLnh+p/euwV8oU3XcVt631YYdzLRHq8eZyV1yXOmiqt4kPzdDS+s2KjTyOxdUM9NKX3
         +Y+HTemX/yzbJ6dEY4j9MwboskOIjcP4eZ16LfwzBHW65gmVCjKM2OX2xsfgfFUBOqmC
         grsRCFAgWvGQxyOEcM31iDZIjHkOD1x3XdiFJEJkfq/MQJYukC8hKMsasUA5Vg94FHp6
         mVwg==
X-Forwarded-Encrypted: i=1; AKwUvBwy19CaY8TF9zgdzYORaJv2Xay/oMT/nqsmu5aiF+AGn2T7Z3v5c+nCLhxo0CBa/CZ9hC5+FSudnN7r@vger.kernel.org
X-Gm-Message-State: AFuF++kyJdtw/eaoEOlHLyVezWZphMZYz8/lzZmxKsOiY6qtHmTVx6yv
	wMm1+vbQa3e7CdHORmmIGuF9vwzvEZxQC+0jPKmQiT64aFjMAkYU02yRGYJXrX5KShy3Hsys0Ac
	aYSG6wHsGTW6YS7wNMcBtnaXgwOM6flQ=
X-Gm-Gg: AYBFou3VuFMRUQl3a6uVPyz0H75Wv6jWvHSKsi6CS7Fl5oEegxgfbuRuLIoJYV7PQ5d
	ECzlMTD/A27TiGjoJ1SkVAabAsG9F2/ocpzccyPVv4yGBH1tNSBUoSDefs/Jg6AIJAc9US4Bo1d
	TT++vC+3FjYUJtsuY8ooy/T5p+vI3HYBIk+xn8cLQwJF5lhIVcfiMLI2olrjEZHQ4h8egM1Z5+l
	vFWo5n63gSrTcFHwUx1Aq7vlADew47iCJoLpjvCLGQO6x/AZslRM5zJWsY+IbIFBy3bQifk6CqJ
	XFhSuzMeAXfE+Lb18pAf7IcUiKfV1x0mESLYXoSz0FVfQwWLwnxOhYEP8q0ueBEYmmnIzFKFwfI
	78Eg0BmiEpdSFyOQomJ/6+gSWnDStT2pOOnvsWM/kUR2VoLAqJmP+kSFF
X-Received: by 2002:a05:6a00:300c:b0:86f:394c:5c68 with SMTP id
 d2e1a72fcca58-874dc0f8b8amr5619824b3a.13.1789745549406; Fri, 18 Sep 2026
 08:32:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918033942.85061-1-ndaugoing@gmail.com> <20260918033942.85061-2-ndaugoing@gmail.com>
In-Reply-To: <20260918033942.85061-2-ndaugoing@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 11:32:18 -0400
X-Gm-Features: AcwNN1WmYHIGdIjR33SQlazp2k78HvrE9WOuXYfeYWpG_Q_w2uIVAZW-9f1-pjs
Message-ID: <CADvbK_dQdro_x-=ma2=bRgosYf2cZfEaqrbpeg-8odoBHnzqVA@mail.gmail.com>
Subject: Re: [PATCH 1/1] sctp: check return value of sctp_get_af_specific in sctp_process_init
To: Yuchao Zhang <ndaugoing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 11:39=E2=80=AFPM Yuchao Zhang <ndaugoing@gmail.com>=
 wrote:
>
> In sctp_process_init(), when matching the source address of a COOKIE
> ECHO against the embedded address parameters of the INIT chunk carried
> in the cookie, the address family handler is dereferenced without a
> NULL check:
>
>         af =3D sctp_get_af_specific(param_type2af(param.p->type));
>         if (!af->from_addr_param(&addr, param.addr,
>                                  chunk->sctp_hdr->source, 0))
>                 continue;
>
> On kernels built without IPv6 (CONFIG_IPV6=3Dn) sctp_af_v6_specific is
> never registered and sctp_get_af_specific(AF_INET6) returns NULL.  A
> remote peer can reach this path by completing a regular INIT/INIT ACK
> exchange over IPv4 with an SCTP_PARAM_IPV6_ADDRESS parameter embedded
> in its INIT (ignored at INIT time by the address family gate in
> sctp_process_param(), but the cookie embeds the whole INIT chunk), and
> then sending the COOKIE ECHO from a different source address, e.g. a
> second interface of a multihomed peer.  sctp_unpack_cookie() does not
> compare the packet source address against the peer address stored in
> the cookie, so src_match is 0 and the walk dereferences the NULL af.
>
> This crashes the kernel with a NULL pointer dereference in softirq
> context, remotely and without authentication.
>
> The other from_addr_param call sites of the same family already check
> af (__sctp_rcv_init_lookup() and the ASCONF path in
> sctp_process_param(), fixed by commit e40607cbe270 ("net: sctp: fix
> NULL pointer dereference in af->from_addr_param on malformed packet")),
> which missed this one.
>
> Fixes: 0c5dc070ff3d ("sctp: validate from_addr_param return")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
> ---
>  net/sctp/sm_make_chunk.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 84a4c97d0f75..ff1c013e2575 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2381,6 +2381,8 @@ int sctp_process_init(struct sctp_association *asoc=
, struct sctp_chunk *chunk,
>                     (param.p->type =3D=3D SCTP_PARAM_IPV4_ADDRESS ||
>                      param.p->type =3D=3D SCTP_PARAM_IPV6_ADDRESS)) {
>                         af =3D sctp_get_af_specific(param_type2af(param.p=
->type));
> +                       if (!af)
> +                               continue;
>                         if (!af->from_addr_param(&addr, param.addr,
>                                                  chunk->sctp_hdr->source,=
 0))
>                                 continue;
> --
> 2.53.0
>

I think this is a dup of
https://lore.kernel.org/netdev/20260917030505.4176635-1-hdthky0@gmail.com/

Thanks.
