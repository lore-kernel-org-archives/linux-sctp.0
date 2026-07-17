Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829E63C3F4C
	for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301036; cv=pass; b=Qc0CYegdNP0gqILmWUNJfsvHc6odolLsDaX9nTUqdscKqDkUSs4wlXxeeTTNDTndPNs8iBAyeXoyA+2eV2accZhRiLopvkw7Zf9nHFlPADN02NVwdVFlguqHyoR6ZMIntvZDKY0FqZwswYDtGnzyzfVDvXpU4MfAy0LsqR+nWpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301036; c=relaxed/simple;
	bh=wcCGQlsNXlrMToOsubdjJB0NNkuBzzYb4QD7vXreeOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0A8gIiilwdQ8ZRWZGezjPuQBgNoSlMRKOib32yfSF/1cXchZuvu4pFuKFtEPvBfo9H0XNdh7TYvFM+wTqMuKziW9a3ND5C0DRUOHc/ADPtPMBPvFYtltmvqZEJ7sC8ucPAGdDnVcPmf2tx+2/05Ikmty5xwhD/l2NeF5xRBZVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dAKx31UJ; arc=pass smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dAKx31UJ"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-848761b5897so4400657b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 08:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784301034; cv=none;
        d=google.com; s=arc-20260327;
        b=Hp1wCwF+SMjaxmHOpTOy6cYN+KOnaIEjSyz+bTXh9wT2mOUkbLSIa0Xzsh/avm9m/8
         pMEHfyCQu1LENBwhIq6nFJSBA3bNy/sEP1Hn4o93qD4mzeeA27nTIPbr7fAK/zQB3WXO
         beGRXHG61ccEj6ACfqXliKnh9m6UnGRghHaNHLjh3lBVydxTDX98HTfxcATBXHP6jSrO
         2f8GbJCbY+43GDeN0SV1ADGHA0Sc7SLUuXJaT9zUScXpZL2wOeLDX0QXLNXhkzMEZ37L
         uFx8aeHtEGClDKit3h0wDHFz3dxYq0O/E6QdbP93NyEorF3KkNNeDqbYT16Iie9ZmW9r
         Wtlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a8KKiUSAAAfYNoQY2TKOOy84qt0EoQc90vAlN/nOFgs=;
        fh=IAJ1OMYWvJVY0lLSs2ygP46DJpwEsCCs/dJYvfb9JPw=;
        b=bOeTH+2Dw17vd15FsgTTFoVskXc6kPtWU2zfDmSuvyo0hjrU+p5r+VmdE/XJfz/az0
         sit4XerW0t3WMabbrS3Ae5P+xglq2bWqzAsH4lnSyOzUjggC13zT9E7xozwAqCDCJGB6
         TDJMfomgAs/48PGfw4Q0V+vAE70SySv6HRi6qf5fx8JETnoMIdQs1yS48eTjwGGPypIJ
         PO4ivvRK9Sz5D+jqSeCeS38YfYBIFPImABuw4Ol0jlGzJZaJPO6//hZjmqUydsa+4pk7
         dUoRMa1usLvETQkuhPLJMv+njcJHhPLu+aTRWra+qkKOhvAlV+2gALl7jBz9sub7bJPw
         hw1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784301034; x=1784905834; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a8KKiUSAAAfYNoQY2TKOOy84qt0EoQc90vAlN/nOFgs=;
        b=dAKx31UJ3TJ7jS6spkZLQZnw0x6ZK0fUMb26MURFCVgMs7cm2SCqDOaScMaq6IpTBd
         MQKf+g6b9hdZfZLDxcfLVC1QAI8uHixbJC669PcWbGYxwUACgx88SnynurcSx35zQAXK
         9CK2lXKgwab2DYJGUtiGgoXMmovlJZFpKDAJe2xP0yB00LBMPnEOp1cPGzcggeaADeed
         JcBYCRq+ST8Px6mShSAwC+dinvlhy0FPDaZK7sz3DeZOxzgWKjZe2syc4NHIC9Gvu/h7
         FJUkTVYFpKpUonEnsdhaaZzuPTfPLdzGu0CteI3Z/kX10Z4O/00nGSKx2w94n0MXpbpQ
         Uo0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784301034; x=1784905834;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a8KKiUSAAAfYNoQY2TKOOy84qt0EoQc90vAlN/nOFgs=;
        b=FcpbCHr+ug4MlDXugYccmCEityMjkroIlcah+DHDc1jkaT8D2DoDQ/+N4CtVu7Ys7b
         MyTlf204w0JLzw1Z8K7CSEy/97T/1HFx/85Yshb0/BcrK5zWOGQKboXhXnIPwKVRO0NH
         ZK+3JH+bn+daxj91/jhmC4HsrgGqnXk6U237XLOCl7h9WCKzBaD6mGUAw9e/hE1lwofz
         YLVV1634uI0ILO6SNcakzt39QIVLjDEoxPdknvQgFIwnffMUbQ+Vp5U8xPKhcRuj870o
         1wCKEBFuI71V9ts02cn6eGhsRsPGkYuyoAA+GLXRaV68l4yY/i5bAbB2FDuvYJkUDMx9
         h54A==
X-Forwarded-Encrypted: i=1; AHgh+RrCSi1/NoXbRaSVOrm57fjvgdkVNa2aamjF2nVyDG5/dCwT+dV8/tHr0lELtKzn/8oZ+HuUR5el5OYx@vger.kernel.org
X-Gm-Message-State: AOJu0YwRIP9rsGcLdJQbx8tmHNf0QHiV/ySDRlNTWE7I4jtDxgwcslII
	idVYBzClKgCCWqPOk5Pya6knNcDt176BhRjgitwO/yKqnC1X7XDPxTbrS5YOZbXYbBTPVRiFTpk
	XpL78J+2yoNjM99JqTbJ4Tel3ZLPbb0g=
X-Gm-Gg: AfdE7cmXP6gCG8ehq8GBirTHNMZ6fL6fBWfYvq/YiuyjEDsx1FgDM5QX2irBCEVfE08
	+TSXQcYzeVhPQzXEILtbvC6L8czcAMt+cXJQM4Ig1mwdnCuLduAdZAG4OI6hNstMl4PD2n/HItJ
	pj0tmz4VK1+VfDWzg9SZuwoJV62nvf9FH24gg5mz5gY5c/2+AKh++DU3qMBxZjgCjr1NAGeRFmJ
	UMu1+M7O9imF+ctP1+CbvgqBz4eL4OXp9fknEYR3l4xzt+99ot47o3/BxOCawDAGnFFCDCGTlCh
	NQ8uG+0+vWtC5H/E+vG2qno6phUxlzI5boDT9+qs00X4hoz254dfQG9MfVLeiEx0WyHBC6gyww=
	=
X-Received: by 2002:a05:6a00:2e07:b0:848:44ae:47c1 with SMTP id
 d2e1a72fcca58-84c295457abmr3092687b3a.78.1784301033652; Fri, 17 Jul 2026
 08:10:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <PH0PR11MB5902DBD696C30DB0A2308A49F0C72@PH0PR11MB5902.namprd11.prod.outlook.com>
 <20260717082048.948262-1-l1138897701@163.com>
In-Reply-To: <20260717082048.948262-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Jul 2026 11:10:21 -0400
X-Gm-Features: AUfX_myqCK9tbAXuT_FWShGbILOMX3z2J31bgyB2pvDKMDN7OZwMZXzfFa5un8w
Message-ID: <CADvbK_dHFt6cceHQ5BwPMWbF1j4i8BtYZ4Su067SvMeiiD6Rcw@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: socket: remove unused 'err' parameter from sctp_skb_recv_datagram
To: luoqing <l1138897701@163.com>
Cc: jedrzej.jagielski@intel.com, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, luoqing@kylinos.cn, marcelo.leitner@gmail.com, 
	netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 4:21=E2=80=AFAM luoqing <l1138897701@163.com> wrote=
:
>
> From: luoqing <luoqing@kylinos.cn>
>
> The 'err' parameter in sctp_skb_recv_datagram() is never used by any
> of its callers. Both sctp_recvmsg() and sctp_ulpevent_read_nxtinfo()
> pass the address of a local variable but never check its value after
> the function returns, rendering the parameter completely useless.
>
> Remove the unused parameter to simplify the function signature and
> eliminate dead code.
>
> Signed-off-by: luoqing <luoqing@kylinos.cn>
> ---
>  include/net/sctp/sctp.h |  2 +-
>  net/sctp/socket.c       | 10 +++-------
>  net/sctp/ulpevent.c     |  3 +--
>  3 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index d50c27812504..b86d50d6b146 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -97,7 +97,7 @@ void sctp_sock_rfree(struct sk_buff *skb);
>
>  extern struct percpu_counter sctp_sockets_allocated;
>  int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
> -struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int *);
> +struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags);
>
>  typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_trans=
port *, void *);
>  void sctp_transport_walk_start(struct rhashtable_iter *iter);
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..3804382d78e0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2123,7 +2123,7 @@ static int sctp_recvmsg(struct sock *sk, struct msg=
hdr *msg, size_t len,
>                 goto out;
>         }
>
> -       skb =3D sctp_skb_recv_datagram(sk, flags, &err);
> +       skb =3D sctp_skb_recv_datagram(sk, flags);
>         if (!skb)
>                 goto out;
>
> @@ -9082,7 +9082,7 @@ static int sctp_wait_for_packet(struct sock *sk, in=
t *err, long *timeo_p)
>   * Note: This is pretty much the same routine as in core/datagram.c
>   * with a few changes to make lksctp work.
>   */
> -struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int *=
err)
> +struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags)
>  {
>         int error;
>         struct sk_buff *skb;
> @@ -9120,17 +9120,13 @@ struct sk_buff *sctp_skb_recv_datagram(struct soc=
k *sk, int flags, int *err)
>                 if (sk->sk_shutdown & RCV_SHUTDOWN)
>                         break;
>
> -
>                 /* User doesn't want to wait.  */
>                 error =3D -EAGAIN;
>                 if (!timeo)
>                         goto no_packet;
> -       } while (sctp_wait_for_packet(sk, err, &timeo) =3D=3D 0);
> -
> -       return NULL;
> +       } while (sctp_wait_for_packet(sk, &error, &timeo) =3D=3D 0);
>
>  no_packet:
> -       *err =3D error;
>         return NULL;
>  }
>
> diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> index 8920ca92a011..8ed51a15c3a4 100644
> --- a/net/sctp/ulpevent.c
> +++ b/net/sctp/ulpevent.c
> @@ -1061,9 +1061,8 @@ void sctp_ulpevent_read_nxtinfo(const struct sctp_u=
lpevent *event,
>                                 struct sock *sk)
>  {
>         struct sk_buff *skb;
> -       int err;
>
> -       skb =3D sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT, &err)=
;
> +       skb =3D sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT);
>         if (skb !=3D NULL) {
>                 __sctp_ulpevent_read_nxtinfo(sctp_skb2event(skb),
>                                              msghdr, skb);
> --
> 2.25.1
>
I think it's used at [1] in sctp_recvmsg():

        skb =3D sctp_skb_recv_datagram(sk, flags, &err);
        if (!skb)
                goto out;
...

out:
        release_sock(sk);
        return err;   <------ [1]

Thanks.
