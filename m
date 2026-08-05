Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F087438333F
	for <linux-sctp@vger.kernel.org>; Wed,  5 Aug 2026 18:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785953231; cv=pass; b=ZgsRkL0JTghUm1AiXju3JUkX+j1sV5upD8cNrdY/GD4OJzKq1YA8xYWfazWscsAM59KssgDWdFOd0m+bgn8IDCShrEPhDGU18niArRFfQL2NZNc9e39WT0mTWwUwmjIDa7xFaDzT/lSvnlJoWPuHL71aOVzzQSvtT23CCaaipWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785953231; c=relaxed/simple;
	bh=RDzGscm0X3YxJSsPbUghpZ2/iTgonupjuK3hHZUzURY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VqeOGlBwylPR5efNfFje0G7DCJV2GBe2GbWoN65wih0oQnsgC8jlDDi9Lv9z99bztuOSv9hi9qXkxbm+8Y2Z9MoprdBxPZ3U8znTwEJg51dy9BMJEBvHarMkHok/6L3KWJ9Sh77xrZ7oaBiK0nxn8KSN/tgwz7/WpC8+E3P8L9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjJGmjT+; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjJGmjT+"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8487088510aso1777887b3a.0
        for <linux-sctp@vger.kernel.org>; Wed, 05 Aug 2026 11:07:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785953229; cv=none;
        d=google.com; s=arc-20260327;
        b=Ky8rWzDppX1fj52qbOLuAsbQXB90GNuIW3mUiHEeg9YqNtxFCSw0uS61OvXBYrzzhH
         G8/7CcpNIO3eSzy6ixlnFAnwUMyGeC5HEvKPuYrrCiKY+rXXaHz4z9962zp0HRvPixTj
         gfVDkuI8YOfVY2gzt/hXEr4dkB3lH/uLJm5LVGGmFYjBBrcAGXjO+zGTYhF9iY0B1pNo
         JLG9nvMr0/ShoO8RVPEe/PnHtyGQfFa6ntXPS1b79PwdroeJQG7LTkPZ8Azjc4dv9gnL
         Uxch3Uuj0/tfCU4Rfl/cPD0kTSXzKkF5U8LAXG/Hcwt+zNw4JQbJFdGk0Jx+km9piibw
         QF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z/60jsXozMozOdmDAKiYW/857TDcNo0le3GW6i4YHHc=;
        fh=JNpn8sykKtjBTnbgwA/qLyv4ta72oXKgfkSicHVXmX8=;
        b=UAonCLQG/UPLtYERgG1PCrPiOhRG2R0TmNfKwp06irz1E+bH1r6nkfog/BfhgR3XCC
         FPlFgF4PJdf/SKiV0Xwj7JUJFgnPqOs1OPoydJfbWnvA6fuhshipm4UtihR8O9t2S/jB
         MhQxRRV36Aq8FS0C3P9Dqm6SMQ3V7CMchRB2VlM8pgQojWC2vhm2UEOLr7WVYA5yBWiL
         YiJRGMCsvT++G3nGkuVxg+BbbUaPIiz8jxofdF7ByPI/ZyL2K0KK8MNG/BpN4S1SNrt3
         1o46FmksBx6Jeo3aDH9pWtVRn+EgWbpU9R7sy/PvI4UG0KAsoPfTvPi1Gpq2Oz8h+98y
         Upmg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785953229; x=1786558029; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z/60jsXozMozOdmDAKiYW/857TDcNo0le3GW6i4YHHc=;
        b=SjJGmjT+Z6jYNbPy8W7UIlHco4JlTSrD448Nv363snYBZjB1XxfdUzKc+Ss1bqPvaO
         9ydCBDLdwDmi4qqCrschoqx3C3YdUaQV2RJyqhkZVRQFCRRClO6s8o8kSBsWDINvVlkW
         PcSzwIqQqYETy908PcB7B4D9IZKx23+D84pVBHi9J7TUCZdBot1eelEr3JL+QOIJBHit
         GxnjQ3Rnmy29WYU/nFh9YmxaQgdX9H+tTeb4HVd2uE2NfWWcN9rcEOuwFc2cvdy9vMgw
         gxZzJj1N7yv+hw8b83FKQUNOen/HKjz9mLSjwNKkplH1DFz02XkI4NQvK/FZiqn7PNB9
         tXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785953229; x=1786558029;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/60jsXozMozOdmDAKiYW/857TDcNo0le3GW6i4YHHc=;
        b=IP1QJY3MFUJO/j4rGd+a9EoEMeYbalvTPboz9Rxp6c/EhVpz48YBzVY9INLUWFYq7N
         HebwsKnoE6iZwV+8u7Iv00+ha8Dx7Uv2+VOmTk8KJKMXdxRlskLc3/FEKopEB6aqX0Se
         v9iaRkVtvBTO1gUSAhFuhhoSUTk9giuor6OMr5U8IQLGTrourKKGMzyeixd3mLuRaNyH
         wx5FwbB6YKe6V6glpBZGehfPCPGGMxaRasBFS+DAU87kC9A8bBWlYwucYnV7S9iX3pZ2
         woF3NYWIdkWtBgj++K2jDf8HvO2JZt46vzS8Wi2v9iyQr9UJYkKVKxw1IB2YcnmgvZQy
         FhXw==
X-Forwarded-Encrypted: i=1; AHgh+RqX2nODqtmw3owvNHhK5PilhRTpUu7mZKG7TOQsEDHLpQ54kZYfk+LkTAPNtSyBGsU5YBoQX2l0iowR@vger.kernel.org
X-Gm-Message-State: AOJu0YzzAIm/4bman5TZmvGLFP3ZBiOhi1j2okCkRY3NxkK5tAYqBBii
	oG0lTq16m2n13XVvYP08HFiVRNeX+Es+chmUuMtFkIcuCSMHlN7DAEdNq8aolAc2TbfkwXjtIut
	wzEzuzFA9MsGIIYfJHBcA6WeAVPfSt18=
X-Gm-Gg: AR+sD10i8LX4Wuk58pk2yq3TovZHh7TYDnN0lNl41yz2W6t9Ueh10tKim4mTHBXR7Y0
	gmxnWI72mOtd7tpWX8zBOn3qndX2MxyGz0ptnp7EXLYSAWbI2Wg3MzCd1wgI8hg/Dvsg24j6Ua1
	Kkj8fkPC+OTE4RCTzGJQg0ceU2LKZ8crpdtao2HTwDwTHbwsxsIc75ezsrIxMS7cMI8m7DVtDpd
	CEwneNVaryF6SHgKfelG2ChtloPzruDbzGaOTG9r+xb+brNrbUazxf8brH5vBG5It0arb0yEVku
	at2liD2r02e40AprAAfD8aiqBQsojcLO19hZc3QgbCtFK64Au9Tv7XBcYUEX2WMHXSGoJQ+1F+D
	yXNjn5BLKQpbNWFOKYFrQHNv+bLrof/b60iLqG6UU9saowgH/0ayRMvuZrJd4IocnTH1XYZ0ijw
	q/0SiMP/4GsaU=
X-Received: by 2002:a05:6a00:230a:b0:848:2e7e:353a with SMTP id
 d2e1a72fcca58-84f2dea7014mr9138898b3a.0.1785953229192; Wed, 05 Aug 2026
 11:07:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804065036.618869-1-l1138897701@163.com> <20260804085827.843042-1-l1138897701@163.com>
In-Reply-To: <20260804085827.843042-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 5 Aug 2026 14:06:57 -0400
X-Gm-Features: AUfX_myvFevMg8AB45U41YP_SpJTG3EQGWrftIDNW1KNT6kkpq0k3Ip4EYD5nbM
Message-ID: <CADvbK_f24Ci-ffmwdegyJnbPS5rdAfmQJH5GxQ60SUEmPA3QNw@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: auth: propagate HMAC calculation errors to callers
To: luoqing <l1138897701@163.com>
Cc: davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, marcelo.leitner@gmail.com, 
	vladislav.yasevich@hp.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 4:59=E2=80=AFAM luoqing <l1138897701@163.com> wrote:
>
> From: Qing Luo <luoqing@kylinos.cn>
>
> sctp_auth_calculate_hmac() can fail when building the association secret
> under memory pressure, but its void return silently leaves the HMAC diges=
t
> zeroed.  On the receive path, sctp_sf_authenticate() compares this zeroed
> digest against the peer-supplied one using crypto_memneq(), potentially
> accepting an all-zero HMAC from the peer if the allocation failed.  A pee=
r
> can reach this path with a configured but non-active shared key id, so
> association setup is affected too.  Although the allocation failure itsel=
f
> is not attacker controlled, the incorrect acceptance is a security issue.
>
> Fix this by making sctp_auth_calculate_hmac() return int:
> - sctp_sf_authenticate() returns SCTP_IERROR_NOMEM instead of accepting
>   a zero HMAC.
> - sctp_auth_chunk_verify() propagates the ierror so delayed COOKIE ECHO
>   and other paths see NOMEM vs BAD_SIG correctly.
> - sctp_packet_pack() drops the packet on failure instead of transmitting
>   a zeroed HMAC that the peer would reject.
>
> Update the declaration in auth.h accordingly.
>
> Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM:code-review
> Signed-off-by: Qing Luo <luoqing@kylinos.cn>
> ---
Please add a revision changelog here describing the changes since the
previous version, similar to:

https://lore.kernel.org/netdev/20260729160028.54546-1-baul.lee@xbow.com/


>  include/net/sctp/auth.h |  6 ++---
>  net/sctp/auth.c         | 10 ++++----
>  net/sctp/output.c       | 12 +++++++---
>  net/sctp/sm_statefuns.c | 51 ++++++++++++++++++++++++++++++-----------
>  4 files changed, 56 insertions(+), 23 deletions(-)
>
> diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
> index 6f2cd562b1de..eeb3297fe97d 100644
> --- a/include/net/sctp/auth.h
> +++ b/include/net/sctp/auth.h
> @@ -83,9 +83,9 @@ int sctp_auth_send_cid(enum sctp_cid chunk,
>                        const struct sctp_association *asoc);
>  int sctp_auth_recv_cid(enum sctp_cid chunk,
>                        const struct sctp_association *asoc);
> -void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> -                             struct sk_buff *skb, struct sctp_auth_chunk=
 *auth,
> -                             struct sctp_shared_key *ep_key, gfp_t gfp);
> +int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> +                            struct sk_buff *skb, struct sctp_auth_chunk =
*auth,
> +                            struct sctp_shared_key *ep_key, gfp_t gfp);
>  void sctp_auth_shkey_release(struct sctp_shared_key *sh_key);
>  void sctp_auth_shkey_hold(struct sctp_shared_key *sh_key);
>
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index c901d373af80..6de66f56c41c 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -613,9 +613,9 @@ int sctp_auth_recv_cid(enum sctp_cid chunk, const str=
uct sctp_association *asoc)
>   *    zero (as shown in Figure 6) followed by all chunks that are placed
>   *    after the AUTH chunk in the SCTP packet.
>   */
> -void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> -                             struct sk_buff *skb, struct sctp_auth_chunk=
 *auth,
> -                             struct sctp_shared_key *ep_key, gfp_t gfp)
> +int sctp_auth_calculate_hmac(const struct sctp_association *asoc,
> +                            struct sk_buff *skb, struct sctp_auth_chunk =
*auth,
> +                            struct sctp_shared_key *ep_key, gfp_t gfp)
>  {
>         struct sctp_auth_bytes *asoc_key;
>         __u16 key_id, hmac_id;
> @@ -636,7 +636,7 @@ void sctp_auth_calculate_hmac(const struct sctp_assoc=
iation *asoc,
>                 /* ep_key can't be NULL here */
>                 asoc_key =3D sctp_auth_asoc_create_secret(asoc, ep_key, g=
fp);
>                 if (!asoc_key)
> -                       return;
> +                       return -ENOMEM;
>
>                 free_key =3D 1;
>         }
> @@ -654,6 +654,8 @@ void sctp_auth_calculate_hmac(const struct sctp_assoc=
iation *asoc,
>
>         if (free_key)
>                 sctp_auth_key_put(asoc_key);
> +
> +       return 0;
>  }
>
>  /* API Helpers */
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index 23e96305cad7..3d7ead9d40e1 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -517,8 +517,14 @@ static int sctp_packet_pack(struct sctp_packet *pack=
et,
>                 }
>
>                 if (auth) {
> -                       sctp_auth_calculate_hmac(tp->asoc, nskb, auth,
> -                                                packet->auth->shkey, gfp=
);
> +                       if (sctp_auth_calculate_hmac(tp->asoc, nskb, auth=
,
> +                                                    packet->auth->shkey,=
 gfp)) {
> +                               sctp_chunk_free(packet->auth);
> +                               packet->auth =3D NULL;
> +                               if (gso)
> +                                       kfree_skb(nskb);
> +                               return -ENOMEM;
Returning 0 here is fine, as its only caller, sctp_packet_transmit(),
currently always returns 0. sctp_packet_pack(), on the other hand, returns
the number of packets it builds.

If you'd like to improve the return value for sctp_packet_transmit(),
that can be done in a separate patch targeting net-next.

> +                       }
>                         /* free auth if no more chunks, or add it back */
>                         if (list_empty(&packet->chunk_list))
>                                 sctp_chunk_free(packet->auth);
> @@ -619,7 +625,7 @@ int sctp_packet_transmit(struct sctp_packet *packet, =
gfp_t gfp)
>
>         /* pack up chunks */
>         pkt_count =3D sctp_packet_pack(packet, head, gso, gfp);
> -       if (!pkt_count) {
> +       if (pkt_count <=3D 0) {
>                 kfree_skb(head);
>                 goto out;
>         }
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 708fa07d5fff..e19881c90b49 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -637,13 +637,17 @@ enum sctp_disposition sctp_sf_do_5_1C_ack(struct ne=
t *net,
>         return SCTP_DISPOSITION_CONSUME;
>  }
>
> -static bool sctp_auth_chunk_verify(struct net *net, struct sctp_chunk *c=
hunk,
> -                                  const struct sctp_association *asoc)
> +static enum sctp_ierror sctp_auth_chunk_verify(struct net *net,
> +                                              struct sctp_chunk *chunk,
> +                                              const struct sctp_associat=
ion *asoc)
>  {
>         struct sctp_chunk auth;
>
> -       if (!chunk->auth_chunk)
> -               return !sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc);
> +       if (!chunk->auth_chunk) {
> +               if (sctp_auth_recv_cid(chunk->chunk_hdr->type, asoc))
> +                       return SCTP_IERROR_BAD_SIG;
> +               return SCTP_IERROR_NO_ERROR;
> +       }
>
>         /* SCTP-AUTH:  auth_chunk pointer is only set when the cookie-ech=
o
>          * is supposed to be authenticated and we have to do delayed
> @@ -654,7 +658,7 @@ static bool sctp_auth_chunk_verify(struct net *net, s=
truct sctp_chunk *chunk,
>
>         /* Make sure that we and the peer are AUTH capable */
>         if (!net->sctp.auth_enable || !asoc->peer.auth_capable)
> -               return false;
> +               return SCTP_IERROR_BAD_SIG;
>
>         /* set-up our fake chunk so that we can process it */
>         auth.skb =3D chunk->auth_chunk;
> @@ -666,7 +670,7 @@ static bool sctp_auth_chunk_verify(struct net *net, s=
truct sctp_chunk *chunk,
>         skb_pull(chunk->auth_chunk, sizeof(struct sctp_chunkhdr));
>         auth.transport =3D chunk->transport;
>
> -       return sctp_sf_authenticate(asoc, &auth) =3D=3D SCTP_IERROR_NO_ER=
ROR;
> +       return sctp_sf_authenticate(asoc, &auth);
>  }
>
Please drop the change to sctp_auth_chunk_verify(). This patch is intended
as a fix, and code improvements should be submitted separately to net-next.

Thanks.
