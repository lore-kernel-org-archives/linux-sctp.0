Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795530337;
	b=H8jRsDqegg1KYUuUpcFAljNx7tyWItHRp0Uj26zLnyYcJqPMsk/sHS9SnsWQdsn4pc+o
	 +o9LzHhlaWwz7ypUXjAH63N+A1yslKWyZ7UrEMAg2WDvEtvCZb0uGNnDePHSxw7e1h85R
	 tDMb8Lb764WzOrEuA0LdfDkxXllqxkc63UDYvyz3794ShiqVhHKnfeb08zbHAlLXuPeOo
	 IOLyXKlI7O6A6DHjdY+qBA15l6WDpna1bd96pRA/vedk1D3a2JYAgJHhw/nctU5TDSWHG
	 zuQnkOTMyAcno25FwEti5ztDBEMrAKMkknaF8Vt+2zUCQtvirCTOaiFWwtPNM1jZsow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795530337;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dF9Eh9RPsijpEV4u/u30zGzXT7uW3lnbZk/EegXl/U0=;
	b=w1ioeyaskFO4GhJvewX7iiBXeXgiU2lR638loSTCyukmOMND96sb9b+EU5p8X46mWhBm
	 hwiHq/RA/QEkqo7nO3YaJ3zAztfQ/vD77VRRZD244fwzYSO9pJuvqt/kuThRpD4xRscvq
	 mAhfR0BuV0ncftz9X9tzjMqHYroNc+eGMXatHuaKAMXdhKmrSJnr2LNaupq85JqNbpn1m
	 hkkcwktu8gkJ5wtJhBlcjMH0xOveGt9a5QcpCEbjdWhey5QkulDtwzvJJR9PH0zOiwuSB
	 EqQV5EyeYvOWFCEead+SonAia00kMau9IsdCInYymbsxpBBEXcMbc9YdNn+0JcAIwrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tbri3ZFl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.169
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29225606A32C
	for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 14:25:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29225606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tbri3ZFl
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so2219720b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 24 Nov 2026 06:25:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795530336; cv=none;
        d=google.com; s=arc-20260327;
        b=qQOQY51who1bTPEYyY2aViDXzDRGzusqiwDeH52xIONNBnihCHiIoCh7zDhuwZskUk
         86hplZMQa3XyGfnwqFJo1l8d4Tp2S9OqNthX/3CdJpTpdWS/KuKlpd3xiMkyDRNlC4F2
         zLJ2Mj4dCMMfKGa8M6fPPRHCH0gXPvIzmnNhDQjk1E+UPFHzluvNUrgcZ1ntFXBNnA6h
         Fsc5QblRsWpBKoZSZbNpWInbiYlMZVCgMgg8AmWlQV8kz/tNz5Wv6Sxf5jfvw94TINup
         AavaGY7789jG921fzXg0bMWOVzIeWWqgJctFAwD3HeDTAnqclHDBQFgjQBWb80bTJYHI
         EXiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dF9Eh9RPsijpEV4u/u30zGzXT7uW3lnbZk/EegXl/U0=;
        fh=DVWu7ZvTJ4Qh6i1hh3PRN61ZanFIXrk6nr4Ym8pi9YQ=;
        b=DISg8gu6Ful8WEYQ4TOiBCoKdiCBWu0DhurQdHPp0OsPWL08ap1ppald923tjUP5J1
         DlYAdtww4fNfrJnftIRE1SooxJjkWz8cxpbFW7222AuugNrCdEd1PFCOsS2J/5OwXt1u
         XQLI6Dnyf9Z2WVe41x2RgiOn93PGP/eHuf0Ay77Lvr3prgGnbzyiS1903K5jgpth702x
         2i6t/6ZKwKi0huf9nmOPrfTej1b+qeE7n4IPGXgpY6DncFIq8Diaxkcuv4gEjkjupFEF
         2fJTqPbtAy5JVOZk8TaZFf/OxC3zHU8r5GJ0l9gTloA2qT2ZdE/I+9WTDHh4YHG0cjBF
         0OLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795530336; x=1796135136; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dF9Eh9RPsijpEV4u/u30zGzXT7uW3lnbZk/EegXl/U0=;
        b=tbri3ZFlUrXTvmw515RCeHxH0sH7SQMgNgV4Hs5g+fAXiaTlyEH6gd8EcScn0kODl4
         kJSqhU98sY/p9sPCL3A8XWGexJBCuOudwaaHJQ4n6UHDmfqoxTcQO7/9he0guOX3+/QC
         QLBjRtZ0GELPj36h256GZZCXFGO+13FJ630OlVbTUXuo/Z6h/aUfS241CTLqXTMD8oNY
         XP7O81LK5PyurfY+LoA2n1dLA1wfegVhSfIifHrHGpv0aXMh8DMoDeOkcrsSxeR6/nga
         hgdQLMDO3G/MD7T+aiDqeeqHV1d/Nu6326difSM6CAkNrLI3P11MTXexSCBCAj+rxuti
         5mCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795530336; x=1796135136;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dF9Eh9RPsijpEV4u/u30zGzXT7uW3lnbZk/EegXl/U0=;
        b=u+4VBNZp6lT/vcr3f+/boq2IqNEbck4VSuAwRNau1l80aFcUfTm+IEY9RczA8dBdBz
         jYqxC5E13JFp7RBzvpgNSPSDtyJgi1SiG0ydnuvYNGndsBOzFCG6JeW3Coqa8QDfXZ4h
         yDcCUEJmhqH039MmfZMCdUozpjplUfkiL+Gt5NNNbIwtmqD++l0k6GlJ415XZENzQpI5
         qYyTTJdnPU3tzMgYZAuCef2WafhoYfWDC+xMT3O6ZYho+ZAV5HhgcQqUkyx0Tzcp5dOd
         BvwUUcCk4n2RAqNnAWEWuK1GOPRH0HyDSDcvTSxTwZ4LiT646ZkLuMEA+6WGXHHjJOhN
         IHEw==
X-Forwarded-Encrypted: i=1; AL+hErGdjid3w0hOIFxiYeKNdq0eISOgVj9S13VBTDdeCzKjEG7gFCsDtZba91jyKjpsHE4K6DXpaoGWDwkT@vger.kernel.org
X-Gm-Message-State: APuU4Z/i2DwPh2zEepUzX8lRSHvKJcIJTDxwaezPPEf+wimhYhkWG40S
	9B+Txt5hZ90QsuLD+FXv0ub1/3Nj0kROd9Decno1N19L4V6GSsBVX2Hhxmz+lPSi1g9XfvNpHF8
	7zrW6g+ewxGmMHoqDEbZepw+7KTLrB/g=
X-Gm-Gg: AZFdTZc8djdLsGsDhfowRYGTTJLZov+Smmg/23s8Yd8W4PzqamhNspICDDSE+O1wwWJ
	nJWx0yl+2Rf7UoXNYJn1XynQkEFkFAVw+gss1UkS2wbtpqYIZ7deM4sZwwe2y98wHnwx76FWjXJ
	XDXl7P5ozFyqJW7v0uyApvm4j2TP22EtJYC2dKo4MWz36VMX2PAUCJ3CN9FaOFuxoGBeZT3vEp1
	8m2zTA/8yp9tZ/VnHrSo9OqU4JHb4aEix98W3L8l9wLJEWIbatz/M94vVX7gWLwWXRk1tdlizcP
	dwfMa5+wXDSQPR5CibA62NC2IKd8NofrsYS/BLv5JjqHJi+mHT79rmgtd08/Wc5uTBipHc+cHzq
	JsB7AYu07MmTyKfbPShjMtUs/OmE5tzxMDwFUv6kZrufMGBpvmXRoneWgSRUY8gIQ8ac8KCSCG0
	f29L5DcXqbUUDIYdGAhQUs3svOsuBWXXaLPfdMtg==
X-Received: by 2002:a05:6a00:aa05:b0:8ac:3a71:38a6 with SMTP id
 d2e1a72fcca58-8c87d51b350mr14612611b3a.52.1795530336387; Tue, 24 Nov 2026
 06:25:36 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119170342.1508789-1-irogers@google.com>
In-Reply-To: <20261119170342.1508789-1-irogers@google.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 09:25:24 -0500
X-Gm-Features: Aa3M54q7cf8dGtPcbVzPYANJ8EMqW3ekx7jrSJiP6UuKtxdr80Wu8XceJYu_RHk
Message-ID: <CADvbK_fM=xmwthLnz=j7YqRghc6ncDo8ESVYgWYeR0t_Byubhg@mail.gmail.com>
Subject: Re: [PATCH net] sctp: initialize new_value in custom proc_dointvec
 sysctl handlers
To: Ian Rogers <irogers@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	Elkin Cruz <elkin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 12:03=E2=80=AFPM Ian Rogers <irogers@google.com> wr=
ote:
>
> proc_sctp_do_rto_min(), proc_sctp_do_rto_max(), proc_sctp_do_auth(),
> proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() point
> tbl.data at an uninitialized stack variable new_value on writes before
> calling proc_dointvec().
>
> proc_dointvec() can return 0 without writing to tbl.data, for example on
> a zero-length write (*lenp =3D=3D 0) or on a write at a non-zero file off=
set
> ignored by proc_first_pos_non_zero_ignore() (such as pwrite(fd, "1\n",
> 2, 1) or a split write where the trailing newline is written separately).
>
> When that happens:
> - proc_sctp_do_auth() unconditionally stores the uninitialized stack int
>   into net->sctp.auth_enable and sctp_sk(sk)->ep->auth_enable, both
>   corrupting SCTP authentication state and leaking 4 bytes of kernel
>   stack memory back on subsequent sysctl reads.
> - proc_sctp_do_rto_min(), proc_sctp_do_rto_max(),
>   proc_sctp_do_udp_port(), and proc_sctp_do_probe_interval() validate
>   the uninitialized value and overwrite the netns setting whenever stack
>   bytes happen to fall within range.
> - proc_sctp_do_udp_port() also stops and restarts the UDP encapsulation
>   socket even when the port number did not change.
>
> Initialize new_value to the current netns setting before calling
> proc_dointvec() (matching proc_dobool()), and skip tearing down and
> restarting the UDP encapsulation socket in proc_sctp_do_udp_port() when
> new_value equals net->sctp.udp_port.
>
> Found by enabling Clang's -Wconditional-uninitialized on an x86_64
> allyesconfig build, with AI coding assistant help to audit the warning
> and prepare the fix. Build-tested with Clang; not runtime-tested.
>
> Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
> Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
> Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
> Fixes: d1e462a7a5f3 ("sctp: add probe_interval in sysctl and sock/asoc/tr=
ansport")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  net/sctp/sysctl.c | 39 +++++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 16 deletions(-)
>
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 2b94c211427d..0c33f05fa532 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -425,8 +425,9 @@ static int proc_sctp_do_rto_min(const struct ctl_tabl=
e *ctl, int write,
>         struct net *net =3D container_of(ctl->data, struct net, sctp.rto_=
min);
>         unsigned int min =3D *(unsigned int *) ctl->extra1;
>         unsigned int max =3D *(unsigned int *) ctl->extra2;
> +       int new_value =3D net->sctp.rto_min;
>         struct ctl_table tbl;
> -       int ret, new_value;
> +       int ret;
>
>         memset(&tbl, 0, sizeof(struct ctl_table));
>         tbl.maxlen =3D sizeof(unsigned int);
> @@ -453,8 +454,9 @@ static int proc_sctp_do_rto_max(const struct ctl_tabl=
e *ctl, int write,
>         struct net *net =3D container_of(ctl->data, struct net, sctp.rto_=
max);
>         unsigned int min =3D *(unsigned int *) ctl->extra1;
>         unsigned int max =3D *(unsigned int *) ctl->extra2;
> +       int new_value =3D net->sctp.rto_max;
>         struct ctl_table tbl;
> -       int ret, new_value;
> +       int ret;
>
>         memset(&tbl, 0, sizeof(struct ctl_table));
>         tbl.maxlen =3D sizeof(unsigned int);
> @@ -489,8 +491,9 @@ static int proc_sctp_do_auth(const struct ctl_table *=
ctl, int write,
>                              void *buffer, size_t *lenp, loff_t *ppos)
>  {
>         struct net *net =3D container_of(ctl->data, struct net, sctp.auth=
_enable);
> +       int new_value =3D net->sctp.auth_enable;
>         struct ctl_table tbl;
> -       int new_value, ret;
> +       int ret;
>
>         memset(&tbl, 0, sizeof(struct ctl_table));
>         tbl.maxlen =3D sizeof(unsigned int);
> @@ -522,8 +525,9 @@ static int proc_sctp_do_udp_port(const struct ctl_tab=
le *ctl, int write,
>         struct net *net =3D container_of(ctl->data, struct net, sctp.udp_=
port);
>         unsigned int min =3D *(unsigned int *)ctl->extra1;
>         unsigned int max =3D *(unsigned int *)ctl->extra2;
> +       int new_value =3D net->sctp.udp_port;
>         struct ctl_table tbl;
> -       int ret, new_value;
> +       int ret;
>
>         memset(&tbl, 0, sizeof(struct ctl_table));
>         tbl.maxlen =3D sizeof(unsigned int);
> @@ -541,18 +545,20 @@ static int proc_sctp_do_udp_port(const struct ctl_t=
able *ctl, int write,
>                         return -EINVAL;
>
>                 mutex_lock(&sctp_sysctl_mutex);
> -               net->sctp.udp_port =3D new_value;
> -               sctp_udp_sock_stop(net);
> -               if (new_value) {
> -                       ret =3D sctp_udp_sock_start(net);
> -                       if (ret)
> -                               net->sctp.udp_port =3D 0;
> +               if (new_value !=3D net->sctp.udp_port) {
> +                       net->sctp.udp_port =3D new_value;
> +                       sctp_udp_sock_stop(net);
> +                       if (new_value) {
> +                               ret =3D sctp_udp_sock_start(net);
> +                               if (ret)
> +                                       net->sctp.udp_port =3D 0;
> +                       }
> +
> +                       /* Update the value in the control socket */
> +                       lock_sock(sk);
> +                       sctp_sk(sk)->udp_port =3D htons(net->sctp.udp_por=
t);
> +                       release_sock(sk);
>                 }
> -
> -               /* Update the value in the control socket */
> -               lock_sock(sk);
> -               sctp_sk(sk)->udp_port =3D htons(net->sctp.udp_port);
> -               release_sock(sk);
>                 mutex_unlock(&sctp_sysctl_mutex);
>         }
>
> @@ -564,8 +570,9 @@ static int proc_sctp_do_probe_interval(const struct c=
tl_table *ctl, int write,
>  {
>         struct net *net =3D container_of(ctl->data, struct net,
>                                        sctp.probe_interval);
> +       int new_value =3D net->sctp.probe_interval;
>         struct ctl_table tbl;
> -       int ret, new_value;
> +       int ret;
>
>         memset(&tbl, 0, sizeof(struct ctl_table));
>         tbl.maxlen =3D sizeof(unsigned int);
> --
> 2.56.1.708.g77570a6a1d-goog
>

Acked-by: Xin Long <lucien.xin@gmail.com>
