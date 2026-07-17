Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17A23603F6
	for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784312358; cv=none; b=uEE2LRCx33cWpjNrsRLRpU/3TwTegpPYV1mDywbfUsBlfjJZVuwPu+VvJAHJCU9WMMeSuZsMOrl9m8FLjtoQebJhnhafKui4J6Fh3EqIAwJmt60OZrpZmrxD1GQf7fcTts5HI2qClGCUZNFu1Q2JLPJKKrHspRouA8TiHBrk7lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784312358; c=relaxed/simple;
	bh=jd0V0MFdrrBAdXDg9zP1xaMqHYbPXVKt2e5sOzglh9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pwej88EN8iUCTRMZ1S48HmH2b6w/pFYjRYCB2OzNqbISJnDAzyV9km7LKFKQELqMY4LtoYSPYv6LRnKevhLaTPg94Pylz4JzbHkvLMAQVoJ5s1b5hKt0TaUIwPDscoUHtw+bVleZiMmEYmZFIc8Hx0YDBT3/D2ZXCWaFQ4Vjx+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g65uSrJA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g65uSrJA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493c733f15aso70531395e9.0
        for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 11:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784312355; x=1784917155; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tk2nGHCYfzwju+ihpkILs3avZ72pIN3My6xR/p7+cWE=;
        b=g65uSrJAwsWh3ncposWya7b6yJYfI2HvXMxLBlbYw324ZkdH0m5e6xgkfOv6n/kSM2
         sb+gHGPRMpf5nXHBW88zxWT/jz9KHEbxsLol/9VB/NGk5XB+Q34Fno0Ey62AS3sVF5tX
         lIUbQcMJwAyaCD3Xqg0V8tExDHCshFiggEyDMvGr8lkAjpZT3Y28nncV9CLNovb32IYk
         wtwrx5sV7++0oUUoUgXtwyS8/sJ5BK6a2q77uq2vzaGz9O/k+qOzPUKWkeaIZl7HzwWU
         jIV8jWp9GrKU1VuEuJjPMPdm9amuJjSLfe5fRhIv0jstFPKM+9GvHXRINW4ZeXmQkO8a
         /L4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784312355; x=1784917155;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tk2nGHCYfzwju+ihpkILs3avZ72pIN3My6xR/p7+cWE=;
        b=fHNt9dQw3pH9YiN92F7cICzUKSGFGDRsl4Me97tdSA1dYnQw91ElSX7LbMukcBJCyY
         JcFud/Cm+HpupyiMOyMfCb8Z12l+TU6QzVyvcCZ6n35Vbd0JctdgLA9YM1kLy4zQ8of+
         eoKoME4iQ7fjO3tP/EZNI+u7YjaYDY2hBPreCaXApIAXwlAiFfuU+d+SN84GhyoccQw3
         Ryw/8YlffKszOQGOdr5h5udEIwizELxuKZymmDGviz5ckJacwHSxF4G5kXuQpdGW08Hz
         KErTwYZBrccvEANa2/nsMwmvDa/Q85InS0/SL4LHPiyMSpkpKZyWN3JUDNhzZdzxhiHb
         05qA==
X-Forwarded-Encrypted: i=1; AHgh+Rph3obZ9U/AXj3hbypyNu0G6XsnyDuzBMtBg1wj+Oj84wydFVcOziRUEvV1Nc4A+IY9xMR34npz7ICm@vger.kernel.org
X-Gm-Message-State: AOJu0Yxjym1YkK+WkFwdIdkqSuB/xHN89pnqMrT0x0U/ewwVB3XQt0UT
	vJL12sw3fNcsuOkuMYhSfsB/31Mr/NEcYQx/wAfBZ56Eh98ShMm4x0BX
X-Gm-Gg: AfdE7ck1+UZCW5Rn2FwccjZ8N+G+f3HWIwDr1SPWsg796dvtql87bX6i+OkMmdP6Re+
	i36XXkOzE5lerx6wxhsG11xZ/YCu7+Dghlnk4jmAz43Aj/JB6gUDVCpa4XYiPYiNE4WqGp7+QhQ
	Gby7Xfn1HjVD8I6x+6XpCgmZq1Y7GniNtF/nfrL1cYgL/8UjHGPKlkwCz6QVL4PazylUTKW+nKe
	856L8YG9w+h4RtKHeBCLrnkbmlQvN+tm+AXGYXks3Ttt+wrMxYseaW36a4LHprwH5XzQfL2Q1Zh
	Fa0LYgOsQL4N7BpPjRmERnAo7v/kgt0TJGK1+H5H07cC8/wTzVC1Y8f2OLUCHjxBhkmWppo7xjA
	fQGU4xObOrhMnZ3/t0yqzsNpxI48Zt7KQywlgkhnY2bkj5va5tbiwGRXrExRxztVZNdHkWIssrD
	LaJb8bzk0eSLVf1cS2VQtfm1V8lBF5rstArNkkYqs=
X-Received: by 2002:a05:600c:574d:b0:492:4a50:41fe with SMTP id 5b1f17b1804b1-4954a405e58mr31399415e9.22.1784312354889;
        Fri, 17 Jul 2026 11:19:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm137976275e9.14.2026.07.17.11.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 11:19:14 -0700 (PDT)
Date: Fri, 17 Jul 2026 19:19:13 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: luoqing <l1138897701@163.com>, jedrzej.jagielski@intel.com,
 davem@davemloft.net, edumazet@google.com, horms@kernel.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 luoqing@kylinos.cn, marcelo.leitner@gmail.com, netdev@vger.kernel.org,
 pabeni@redhat.com
Subject: Re: [PATCH net v3] sctp: socket: remove unused 'err' parameter from
 sctp_skb_recv_datagram
Message-ID: <20260717191913.490e5d80@pumpkin>
In-Reply-To: <CADvbK_dHFt6cceHQ5BwPMWbF1j4i8BtYZ4Su067SvMeiiD6Rcw@mail.gmail.com>
References: <PH0PR11MB5902DBD696C30DB0A2308A49F0C72@PH0PR11MB5902.namprd11.prod.outlook.com>
	<20260717082048.948262-1-l1138897701@163.com>
	<CADvbK_dHFt6cceHQ5BwPMWbF1j4i8BtYZ4Su067SvMeiiD6Rcw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jul 2026 11:10:21 -0400
Xin Long <lucien.xin@gmail.com> wrote:

> On Fri, Jul 17, 2026 at 4:21=E2=80=AFAM luoqing <l1138897701@163.com> wro=
te:
> >
> > From: luoqing <luoqing@kylinos.cn>
> >
> > The 'err' parameter in sctp_skb_recv_datagram() is never used by any
> > of its callers. Both sctp_recvmsg() and sctp_ulpevent_read_nxtinfo()
> > pass the address of a local variable but never check its value after
> > the function returns, rendering the parameter completely useless.
> >
> > Remove the unused parameter to simplify the function signature and
> > eliminate dead code.
> >
> > Signed-off-by: luoqing <luoqing@kylinos.cn>
> > ---
> >  include/net/sctp/sctp.h |  2 +-
> >  net/sctp/socket.c       | 10 +++-------
> >  net/sctp/ulpevent.c     |  3 +--
> >  3 files changed, 5 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> > index d50c27812504..b86d50d6b146 100644
> > --- a/include/net/sctp/sctp.h
> > +++ b/include/net/sctp/sctp.h
> > @@ -97,7 +97,7 @@ void sctp_sock_rfree(struct sk_buff *skb);
> >
> >  extern struct percpu_counter sctp_sockets_allocated;
> >  int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
> > -struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int *);
> > +struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags);
> >
> >  typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_tra=
nsport *, void *);
> >  void sctp_transport_walk_start(struct rhashtable_iter *iter);
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index c7b9e325ec1c..3804382d78e0 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -2123,7 +2123,7 @@ static int sctp_recvmsg(struct sock *sk, struct m=
sghdr *msg, size_t len,
> >                 goto out;
> >         }
> >
> > -       skb =3D sctp_skb_recv_datagram(sk, flags, &err);
> > +       skb =3D sctp_skb_recv_datagram(sk, flags);
> >         if (!skb)
> >                 goto out;
> >
> > @@ -9082,7 +9082,7 @@ static int sctp_wait_for_packet(struct sock *sk, =
int *err, long *timeo_p)
> >   * Note: This is pretty much the same routine as in core/datagram.c
> >   * with a few changes to make lksctp work.
> >   */
> > -struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags, int=
 *err)
> > +struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags)
> >  {
> >         int error;
> >         struct sk_buff *skb;
> > @@ -9120,17 +9120,13 @@ struct sk_buff *sctp_skb_recv_datagram(struct s=
ock *sk, int flags, int *err)
> >                 if (sk->sk_shutdown & RCV_SHUTDOWN)
> >                         break;
> >
> > -
> >                 /* User doesn't want to wait.  */
> >                 error =3D -EAGAIN;
> >                 if (!timeo)
> >                         goto no_packet;
> > -       } while (sctp_wait_for_packet(sk, err, &timeo) =3D=3D 0);
> > -
> > -       return NULL;
> > +       } while (sctp_wait_for_packet(sk, &error, &timeo) =3D=3D 0);
> >
> >  no_packet:
> > -       *err =3D error;
> >         return NULL;
> >  }
> >
> > diff --git a/net/sctp/ulpevent.c b/net/sctp/ulpevent.c
> > index 8920ca92a011..8ed51a15c3a4 100644
> > --- a/net/sctp/ulpevent.c
> > +++ b/net/sctp/ulpevent.c
> > @@ -1061,9 +1061,8 @@ void sctp_ulpevent_read_nxtinfo(const struct sctp=
_ulpevent *event,
> >                                 struct sock *sk)
> >  {
> >         struct sk_buff *skb;
> > -       int err;
> >
> > -       skb =3D sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT, &er=
r);
> > +       skb =3D sctp_skb_recv_datagram(sk, MSG_PEEK | MSG_DONTWAIT);
> >         if (skb !=3D NULL) {
> >                 __sctp_ulpevent_read_nxtinfo(sctp_skb2event(skb),
> >                                              msghdr, skb);
> > --
> > 2.25.1
> > =20
> I think it's used at [1] in sctp_recvmsg():
>=20
>         skb =3D sctp_skb_recv_datagram(sk, flags, &err);
>         if (!skb)
>                 goto out;

Would it make more sense to ERR_PTR() etc ?

	David

> ...
>=20
> out:
>         release_sock(sk);
>         return err;   <------ [1]
>=20
> Thanks.
>=20

