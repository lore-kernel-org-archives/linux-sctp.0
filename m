Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794518051;
	b=RdCkth+0y7RZLeyMIZLUzDy7j0AaBe6NMBopLbNNS79Y736i5QVAnYmSAURgXN1P4b1B
	 vwV2xnzHh3LleSSimfQ2hthn2rNjl2OSfIaAW33r/T9E1dKoutqEySBHJx3UUoYv+0pI5
	 C4tZNrBUW4ZBUbJHpXtsgHxItCimHSUC3552eEjc8Zjtrw/OtFrfxUJnXK4PvLHIuAmCd
	 1cXxK5E5SyJR6WujyUJ9m9ArM13dWKWcvJfDSmzH7+oW64tyqKQhlMAgtk6S+iOoSlMSN
	 uJgD1uahAi4NCr4160S0YXTnZd531Rj/gjKLemvKZQskEX/xJ6mZ2icD9ZR2CTd1lUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794518051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PrfXz08H+34PFhR+mDKWipfCfKpSe7p7ek5/2sq7ELs=;
	b=WkV96eiUpQUCgK7Q/54lqw/WvoDjBs1D8eApmmDnpF0pOteYWwyR8BW041GmUAeW/zkw
	 y1XaUuSwELEWq1BuyC9G+aatC5EkP2F+S+iKI+zvI4F2oJfJqaC9gSDqvSfYPT/AsBnZm
	 7uUvvYmvokn3oM0awc/iFNwMV3OLoYGwxch1Uj5JDPXhdzzVwChQjlKmud28fHwDLj//7
	 Mnu803Z8kyYh4wxty3ffkHRzEhtdFqqjhCJs1K3ZRzWyw31xf8f2B981GtRaTJF4s1ir7
	 18Kzm9BipNkXsszvoZ62SniGiTmJMfuIZNz4jfYCKiZEM8qQWyIP80+8qTNz/mdQXPA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WcBHXqCn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B26D606A330
	for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 21:14:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B26D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WcBHXqCn
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so284935b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 13:14:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794518049; cv=none;
        d=google.com; s=arc-20260327;
        b=S92/sQtNzCH9ZfPRU2QQAtxkFU8ZeXSum37K8CdMSWRpWsW5T8yW0X1bYEcDlwXzub
         /fONfv+eyOCixZJcWZPZgtyYqZMKptINOoPZ3bT3XUAaj4I5Vx5dPO9lJv3FwZy9pkCR
         p8RAM/K8P5bKKB0Qqa6XZ7F+xl3iNl5PlKb9XpUANFjbn8OXJKBnRBrUFwynd4hnzmsu
         ecUTEyIKX3uymSaosHYUGobCzJ6mU4fCcIjU08bnRtw399B+UrWFNKAjbgmywHg5mgBP
         ICYJHgJ++/Pw3oZ9Cj2viUNFjv6WNW1osfFt7C5lmkGVvo6s4wnnFQLIhK1c/aCMRslH
         lyAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PrfXz08H+34PFhR+mDKWipfCfKpSe7p7ek5/2sq7ELs=;
        fh=ZtjmUOIUKV0vb95+Ld0EO33lpGFQYyEyCvkrIszm8AY=;
        b=BdaIqS8VaeQCCQhI5W/T50GcPZan5XrkzeR7UThRQ6xxaZHqd9WlWzo0JrjCWedKz8
         XXK6TSNpXhhDBxbXS6xUZRvSq6labaPJv3bX3g4MpeYOnY3bex+TrWlH6lai2kHBauwh
         HPeEiwN9/LjEOVJRflsvHpGkxfkaAhiSAmTuIeJ5bXvkG+CxzO0RPTeAO+40uDJBLJcK
         yttB6hB1HYdKduJIwqCW5DCUY8vIIMpFD27jaOswP3cRnYno9yYEbQKfufyK5RmvBGZX
         ZzeY9WVzRixXpvzIxC2tGM4ETUwhDxWWgZBiuL5Xl0ARsrKnpnI2DLNmpqxw5FP+od7l
         CVEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794518049; x=1795122849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PrfXz08H+34PFhR+mDKWipfCfKpSe7p7ek5/2sq7ELs=;
        b=WcBHXqCnx04AgsRRw+B9o59yp2jyEV1UiqvXVnqHdIt5kuB0FmrnJjWM33pISB72n+
         QLfzexQSV6KYXC6u/e5ecjNr/vOnIaAox+ghv42a6me77npj6BqhlmhXDtKXV/Zkg4rM
         utOxFtup3mHOIaz2bHCU23D3ksUbwi8jHLV+F5Fh8oILCQurqEBRzLEebYQh82cUk9ZY
         8LjEOQh1/4uWqWZ+rSMroLhSn7NGWOQTwm3B1RNvGbxShpMZGM9++aEeYs30VMswGvsj
         hDWHsXkMvmYY7rYyeRNJJs7o4E09heEvTdDasSvAliBjoZgk/PFzXphtt+n76mUMuA/C
         OWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794518049; x=1795122849;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PrfXz08H+34PFhR+mDKWipfCfKpSe7p7ek5/2sq7ELs=;
        b=v6ri14bp+1EpOv6aUy/cr0W4Xme2/FBmbmgq+w533iBOqvJmw18YC1B1kYX7peVucA
         7fiWdypHx8Alz6O3nmQHJJeOL79OPEyBbNFLP0MMDnNqXkbrQPm/i99sBLz3/aEqoP9j
         lmDslYX2/AnerxIhnaRlA8ao/n7BDRUpSX2EalIVxcsdt4cRhC2Swr0tEiWQZZnpRzd6
         nz/vghIISlBKSVqqdAKr3kXE4lom6URVNUNfnQUywmo0wmVqrmsC96Y7eXDqzgpqIq1S
         aR3pQjPQ1FJEO5p6fqSH7/O32fUyhcrtdpggdBBB+e+BB9Jte6KSAGfhdXwS7RLhWhPY
         rlrw==
X-Forwarded-Encrypted: i=1; AL+hErG7j8/btTCJEtjXOqfp3c3lAAevD+XNhFbKeKmIxi+pMn9iQpHRvmPQ0RiuoUs33V9tG5OAaiH0xd5b@vger.kernel.org
X-Gm-Message-State: APuU4Z/Q3t8ewckrmB9K3xT1vs/IOjHeTAS5WQp60bBYU07VwL9JGk2f
	5gohOYtrQ1QKDtZRbohUiR4trPsYoSn+gCIpaKQ2TcGyHJhRb5i7oxPQhWNTAE1fPBJFZ3JRN5W
	kX6K8x6Do1LTTjvhpTpWKxa+chQnZUjY=
X-Gm-Gg: AYBFou0Yg1Si/iMK9jww8kR3RVtXxBbXR8o7HQjNUnYWbK+zA3ymZLWBj9F8158FGBC
	5pj10yBGzdOlRXW4SdTRnvgWd5bFD/TJYbNs2Qqqx/pG+ekIM/4XBQ9fC/ZWHYSGYBu3Df704Lx
	SYQH/hVRagFaY3AM8I6zuisvvU6mTMvFPXnUVWetWJ4m56LDDrD8UD+YpZlu5snwRBiaPqDpfj6
	Yd+XGNLOSSelOW5+rLfrht3h/8kQVkR8/ojhPNX2wsV+oLrudHCpHC0iPlR4/OIDgaYZhFyvYZw
	tCcJ4yckJJUhUGMrHOr9nh4cA8U1/QF2CUVhp2GT7QsmQ/kqiV48HljSn28mRXXa0sROdjqmag8
	lzrjRIzE0cWjKWyaUmmU4DsYGZqFobBkWg7rGCxhVjdYTKe4VjBnCsX7Z9RzCplq75N/GeuoD9k
	JdvAUnbICoQdu98RJxHOSN4GXItqPFXi/ClpH4ln9iQrReloBpcbZ6ni+2Crir02lRaZQb/Ftq/
	sb5TpTxlkxDzaDxdso=
X-Received: by 2002:a05:6a00:2311:b0:891:3e34:e06f with SMTP id
 d2e1a72fcca58-8beb7539e7fmr667897b3a.44.1794518048547; Thu, 12 Nov 2026
 13:14:08 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110120212.1110283-1-pkfxxxing@gmail.com> <20261110120212.1110283-2-pkfxxxing@gmail.com>
In-Reply-To: <20261110120212.1110283-2-pkfxxxing@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Nov 2026 16:13:56 -0500
X-Gm-Features: AclHuK8r89MZhNaP-FJ80tjfRygA5rIFvNd4P4o3dAcP_IW4NOz1scQ_2zf5I0s
Message-ID: <CADvbK_dYGutb+-D+Q6pA2MSJr6WZGQUrD+6haS1NoMqaxZ5a5Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] sctp: revalidate the association socket in timer callbacks
To: liuyong <pkfxxxing@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 7:03=E2=80=AFAM liuyong <pkfxxxing@gmail.com> wrote=
:
>
> SCTP timer callbacks cache asoc->base.sk before acquiring its BH lock.
> An accept or peeloff can move the association to a new socket in between.
> The callback can then run the state machine under the old socket lock,
> while an abort on the new socket tears down the association's queues.
> The timer's transport and association references do not keep those
> queues alive. With delays inserted to widen the race, KASAN reported a
> slab-use-after-free in sctp_chunk_abandoned() from the T3 retransmit path=
.
>
> Recheck the association's socket after acquiring its BH lock. Treat a
> mismatch like a busy socket and use the existing reference-counted timer
> rescheduling path. The next callback reads the current socket again,
> preventing state-machine execution under the old socket's lock. Retain
> the user-ownership check to handle a migration already in progress.
>
> Apply the check to the T3, association, heartbeat, protocol-unreachable,
> reconfiguration and probe timers. Their BH context and the endpoint's
> RCU-deferred sock_put() protect the cached socket during the callback.
> Pair the socket pointer reads with WRITE_ONCE() in sctp_assoc_migrate(),
> taking the new socket reference before updating the pointer.
>
> The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
> system.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: liuyong <pkfxxxing@gmail.com>
> ---
>  net/sctp/associola.c     |  4 ++--
>  net/sctp/sm_sideeffect.c | 41 ++++++++++++++++++++--------------------
>  2 files changed, 22 insertions(+), 23 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 4521be3bd8..c5d520c8d7 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1088,8 +1088,8 @@ void sctp_assoc_migrate(struct sctp_association *as=
soc, struct sock *newsk)
>         sctp_endpoint_hold(assoc->ep);
>
>         /* Get a reference to the new sock.  */
> -       assoc->base.sk =3D newsk;
> -       sock_hold(assoc->base.sk);
> +       sock_hold(newsk);
> +       WRITE_ONCE(assoc->base.sk, newsk);
>
>         /* Add the association to the new endpoint's list of associations=
.  */
>         sctp_endpoint_add_asoc(newsp->ep, assoc);
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 35f540fb15..bd6b23369f 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -233,15 +233,14 @@ void sctp_generate_t3_rtx_event(struct timer_list *=
t)
>         struct sctp_transport *transport =3D
>                 timer_container_of(transport, t, T3_rtx_timer);
>         struct sctp_association *asoc =3D transport->asoc;
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>         int error;
>
> -       /* Check whether a task is in the sock.  */
> -
> +       /* Defer if the socket is busy or the association has migrated. *=
/
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy\n", __func__);
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved\n", __func__);
>
>                 /* Try again later.  */
>                 sctp_transport_hold(transport);
> @@ -271,13 +270,13 @@ void sctp_generate_t3_rtx_event(struct timer_list *=
t)
>  static void sctp_generate_timeout_event(struct sctp_association *asoc,
>                                         enum sctp_event_timeout timeout_t=
ype)
>  {
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>         int error =3D 0;
>
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy: timer %d\n", __func__,
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved: timer %d\n", __func_=
_,
>                          timeout_type);
>
>                 /* Try again later.  */
> @@ -362,7 +361,7 @@ static void sctp_generate_autoclose_event(struct time=
r_list *t)
>         sctp_generate_timeout_event(asoc, SCTP_EVENT_TIMEOUT_AUTOCLOSE);
>  }
>
> -/* Generate a heart beat event.  If the sock is busy, reschedule.   Make
> +/* Generate a heart beat event.  If the sock is busy or moved, reschedul=
e.   Make
>   * sure that the transport is still valid.
>   */
>  void sctp_generate_heartbeat_event(struct timer_list *t)
> @@ -370,14 +369,14 @@ void sctp_generate_heartbeat_event(struct timer_lis=
t *t)
>         struct sctp_transport *transport =3D timer_container_of(transport=
, t,
>                                                               hb_timer);
>         struct sctp_association *asoc =3D transport->asoc;
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>         u32 elapsed, timeout;
>         int error =3D 0;
>
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy\n", __func__);
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved\n", __func__);
>
>                 /* Try again later.  */
>                 sctp_transport_hold(transport);
> @@ -418,12 +417,12 @@ void sctp_generate_proto_unreach_event(struct timer=
_list *t)
>         struct sctp_transport *transport =3D
>                 timer_container_of(transport, t, proto_unreach_timer);
>         struct sctp_association *asoc =3D transport->asoc;
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy\n", __func__);
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved\n", __func__);
>
>                 /* Try again later.  */
>                 sctp_transport_hold(transport);
> @@ -454,13 +453,13 @@ void sctp_generate_reconf_event(struct timer_list *=
t)
>         struct sctp_transport *transport =3D
>                 timer_container_of(transport, t, reconf_timer);
>         struct sctp_association *asoc =3D transport->asoc;
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>         int error =3D 0;
>
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy\n", __func__);
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved\n", __func__);
>
>                 /* Try again later.  */
>                 sctp_transport_hold(transport);
> @@ -492,13 +491,13 @@ void sctp_generate_probe_event(struct timer_list *t=
)
>         struct sctp_transport *transport =3D timer_container_of(transport=
, t,
>                                                               probe_timer=
);
>         struct sctp_association *asoc =3D transport->asoc;
> -       struct sock *sk =3D asoc->base.sk;
> +       struct sock *sk =3D READ_ONCE(asoc->base.sk);
>         struct net *net =3D sock_net(sk);
>         int error =3D 0;
>
>         bh_lock_sock(sk);
> -       if (sock_owned_by_user(sk)) {
> -               pr_debug("%s: sock is busy\n", __func__);
> +       if (sock_owned_by_user(sk) || sk !=3D READ_ONCE(asoc->base.sk)) {
> +               pr_debug("%s: sock is busy or moved\n", __func__);
>
>                 /* Try again later.  */
>                 sctp_transport_hold(transport);
> --
> 2.43.0
>
Please check the sashiko report:

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261110120212.1110283-=
2-pkfxxxing%40gmail.com

I think you also need to use READ_ONCE() in sctp_err_lookup() and pass sk
to sctp_v4_err_handle() and sctp_v6_err_handle(), and then add
sk !=3D READ_ONCE(asoc->base.sk) check next to sock_owned_by_user(sk) in th=
e
functions it calls like:
sctp_icmp_frag_needed()/sctp_icmp_proto_unreachable()/sctp_icmp_redirect().

Also, use READ_ONCE() in quic_rcv() and sctp_backlog_rcv().

Thanks.
