Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794522649;
	b=HwPV+fZHLetG1j14s42v/wJPt/U3b4om5sS7x9kGX/jR8qon7s6v4rzIOKE2JXFjDBsq
	 3q559/XGto5er2zNrMaG/tsPxvU6pSmQS7Z6LOs87wZyhseAXzv0P7JcQ7f56PuqlIYYp
	 5gZYer5CCtMCB5h7EuuDiiUirEXI9TVrndG9w4fSdeTWJTlZM3mSB57vSUDZAseUQalIF
	 jt1KEC0Nj/4UCp4txQYV+SISn3wRQw/9mL1rsLjtkxmNr2VvbwNdaQhE81q/u+2g87B0J
	 AbM984rThv5AebOhBXGGkbWN8TtteSOMEorhK4FCACpZiW8JfneTYMl2qNhquDyk9tg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=N84XYHzw7Esp327MYHF7QLXLFVZd1ok0Gm+vNi9+pP4=;
	b=icYkF/ITO/6D9Ay4EppR7gjhFHsMR1NaaTefnLsxE34Xn/Sapt52t/D+H4CpSMOJaItJ
	 xFzO2yOEsqFw4Dp+kfzHAflcdCi1zG8trnbtmQLM2BCKxxbFrHfMb/o6impp+TqeROD45
	 Z5lq0wDJkMUD8qwjbMsNpEzcNpDNyoQHjjkKn1wuQyG1T83FGizu8NfrYtFC872OSVjxZ
	 1lCE7CRC1P5R4d9UmidkjufGJDbjsPymTcYKqz+YHNVQx0EMoinme3mkcI2AzFVgprAJI
	 QboGElSAJ3rlZ8UWZOYSH0nUZHSkrdcLF9t6bsfh5JTKaPEKOixQ3WLGhIvtnrfj+SA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DunIrGgy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D44606A323
	for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 22:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00D44606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DunIrGgy
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a60f90a924so119165b3a.3
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 14:30:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794522648; cv=none;
        d=google.com; s=arc-20260327;
        b=U5mKq21yDSXCeNAk8bSwRz/HBXbyFTc2XIDl6ReUNmwM5V8yrQ5Wb96G8KyBbsEAHN
         /KhNFnAehkOfXM2wbmC7wyiUVDpgyahMIjxMXRBm1i6HamXQad00umUKj0R3vYY4cGg2
         PWWbRcVBnJ9bCR2zOAk8Lbt8gsuiZB7hjhEboH9odcQJ2oB/RMIHDXb5zaK5gyC+82+e
         gPO0qp8O6bBa8iCRSlknFl5v6NzJsywrDr2zbldW98eT3QPrl2RU6h2oI17558zCGwh4
         coXRzuFRqljVYAlFrz3rQ8iI1ETDOwFjX/18eXlSQn36mcuUYcD8HRPAORJttheT4rMe
         hVzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N84XYHzw7Esp327MYHF7QLXLFVZd1ok0Gm+vNi9+pP4=;
        fh=GafHMFURRjwwxNg7fdcKJ9MXu6hlCfEpwkhevCbXTjM=;
        b=Jm8yQo9SnHXDIKmrVDGBfSYZ6pb+wOI7fHHZA/dzfw6+ychMdk+D1Dp5845jcb00DD
         IbAB0qPvS83VifmlKjniRSZ+HxVKIVcmrsD1Oc9p1vD3mKhl20ypLm6+/QSbmKxVLijV
         DP1uJKUCvLG3Nx/savrf2+VhlRpF0zgjtWqZzWcNiCAsDpWfkJLocLD3aci11B+qnXAv
         VBcp3rQ4oVE8TCL/wyCncr9OEqrRgCacw5uDH3ng+d9Gpq8lHV673C2Cc0DxYQQLA7bi
         42LOeOTnOoVjHIb6B5lbG6y+Bj3PGVB2w8ZSEvrArLz7LrlHPQj/ZJqlb2frGmPdo5X5
         qyJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794522648; x=1795127448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N84XYHzw7Esp327MYHF7QLXLFVZd1ok0Gm+vNi9+pP4=;
        b=DunIrGgywXQ1a63BXE8e47oXawquHNDt1Xa0QoXzi1dP2Nz0XwH+GHWK/dSn3+rfP4
         Hj531DF9PhsHE0nHGqCtmoYgEq9tCawE0ynICeMQvQmud9ygaL4OySCv1FkYqR6+jQqh
         Z+W0fnn3mtRdJsSmVrTUg+BLdMS2Xh2sBg7UGn7Pxr7D3ad6Dm2Ufj2gXa8BoyPYA5I/
         Crs9bdBVNO/isge0mMsSiF/bs3MFJ2yOjpeY+GsWrFzH/DfZkmfZa+eJetNgeTeed/uq
         iClXTw/skoagGTq7kvGTfROWAB5zJaxkdfOCIVyvlP3KeyBfLteeE3APYgQAiva/vNBg
         VPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794522648; x=1795127448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N84XYHzw7Esp327MYHF7QLXLFVZd1ok0Gm+vNi9+pP4=;
        b=OyyQ1CpJeH5tbG0ffkmj2r/R7NLrjXLJQyO6ASoJzuJaqxxAaVj1LIIilWw84oN2JG
         yIlRVjBdZUWoMJIMDayQV6s5a0UcEpB5RrgoOftxCFwYL2Wb5+4TfKf90Kp4loL9mLjv
         Hgc3FgbIVuM/oPMePKMvkX5X3fmQB5VYhzlXqwjrD/Exb/9/n3vLWe3YqnIFNmf1f74r
         xJ+FlKSTfkDwfv6+6hZqcWhqvr8Rk0LB6mq5/f0UdFwFb7L/fN+SxeBIvgxHxOxAsRi3
         ay5NM2H6AIOhOY/ih0dJhvHF3X1kqvPjRZXdJJCcYcbvmJe/7e65SQE3QIqEGS9x7hUq
         MtMQ==
X-Forwarded-Encrypted: i=1; AL+hErENTTBtqAovbcorcKp+JPXTfgvf8pvP5+VEoJ5rvmBi/6XmOsv1JJBzyxLhKywTvWI3ZX/MQIcf+uDa@vger.kernel.org
X-Gm-Message-State: APuU4Z/rmj4YGFcs+2u4zwX6WC7BGrV38Ygo/sJYpRjlUH1ISzQVO/CB
	GVwHGC8zuGcP1g3SpJb+nSNAEC5GEs9V6Sa+aX6k8sjFxgxyim3QLuixzLruKb+QocJtBATDdO1
	wfKUUM1hzeB65SxXBAQaOtLqkeRvQjIM=
X-Gm-Gg: AYBFou3mE2qAemCt0HHCIHf5X1WJcatU7e8+cidSAvFLu2mlaGpGMDequWLTv3I0IgK
	pEUxBoExYbgju7XjGLKnm6EqO8MJKZX58fcmhdx1ZqjpwEg/v7VZLDh/v5NHnkQ35bNRjT4K92f
	x7Ncud4+svaYjzkLnrrYBQLMVO7p7kCpiEBqwNttNmC4FejktllKGsbpcfDE2VHg5oJORvQnYJj
	KWkKv0qfbhwDIQ+0wi4GlDUlMtGknO56D2MR7IA2teRPlnSeGx1BXAFVD3ecCTYTBSyVhk+sYoR
	UjV3/aYClSkzPzqwXJ2iGv5J/iFaPIEaNKdjZR5NYJnSkNQPo80aIqel+5nQSp+8oS5l8ZMuzen
	XAtSO+J6leX66zkdFVo6TkeuKEVojoZfmHrSObVVICk2xJYp4vrw4k+h0v/jWCmK0oECt9plMTU
	b9apKQTkw/sthtxHLC/lwJJAmugeRxGuMa7QC2E32l4kDoXNBqWmbx7Uq/2zHrjbzITTnXmg==
X-Received: by 2002:a05:6a00:8f01:b0:899:465d:c8ff with SMTP id
 d2e1a72fcca58-8beb53d9e97mr856084b3a.13.1794522647925; Thu, 12 Nov 2026
 14:30:47 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109024219.347985-1-18983559317@163.com> <179438669316.2199510.365044781249431849@kernel.org>
In-Reply-To: <179438669316.2199510.365044781249431849@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Nov 2026 17:30:36 -0500
X-Gm-Features: AclHuK8t8kqlu_92gb4zO32V1NyjmqbFjeNzohpibZDZktCfypmqIQtbOyoxZls
Message-ID: <CADvbK_fQBb2FTBOFiQ_4nmSGG7aQspD4X03bhENKb74prxorCw@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: fix race between addr_wq timer handler and
 backlog draining
To: netdev-bot+sashiko@kernel.org
Cc: 18983559317@163.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 3:44=E2=80=AFAM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 3 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] Kernel memory can grow without limit through repeated DEL_IP
>   ASCONF chunks.
> - [Medium] The new early exit breaks an invariant that
>   sctp_addr_wq_mgmt() depends on.
> - [Medium] One socket can now stall address-event processing for the
>   whole netns.
> - [Medium] The commit message says that sockets processed earlier 'will
>   see a duplicate ASCONF on retry; the peer reports that in an ASCONF-=E2=
=80=A6
> - [Low] The new sock_owned_by_user() deferral branch in
>   sctp_addr_wq_timeout_handler() (net/sctp/protocol.c) sets retry=3Dtrue=
=E2=80=A6
>
> --
>
> sctp: fix race between addr_wq timer handler and backlog draining
>
> This patch makes sctp_addr_wq_timeout_handler() check sock_owned_by_user(=
)
> on each auto-asconf socket before it calls sctp_asconf_mgmt(). If the
> socket is owned, processing stops and the addr_waitq entry stays queued.
> The addr_wq_timer is then re-armed to retry after SCTP_ADDRESS_TICK_DELAY=
,
> in a single mod_timer() shared with the existing IPv6 DAD retry.
>
> > Sockets processed earlier for the same
> > address event will see a duplicate ASCONF on retry; the peer reports
> > that in an ASCONF-ACK error indication, which the association
> > tolerates.
>
> [Severity: Medium]
> Is this description accurate for both event types?
>
> For an SCTP_ADDR_NEW entry, the first pass through
> sctp_send_asconf_add_ip() has already added the address with
> sctp_add_bind_addr(..., SCTP_ADDR_NEW). On retry the lookup finds it and
> skips the association, so no duplicate is sent:
>
> net/sctp/socket.c:sctp_send_asconf_add_ip() {
>     ...
>                         if (sctp_assoc_lookup_laddr(asoc, addr))
>                                 break;
>     ...
>                 if (i < addrcnt)
>                         continue;
>     ...
> }
>
> For an SCTP_ADDR_DEL entry, the first pass in sctp_send_asconf_del_ip()
> only marks the bind address:
>
>                                 if (sctp_cmp_addr_exact(&saddr->a, laddr)=
)
>                                         saddr->state =3D SCTP_ADDR_DEL;
>
> The entry stays valid until the ASCONF-ACK arrives. sctp_bind_addr_match(=
)
> only tests ->valid, so the !sctp_assoc_lookup_laddr() check still passes.
> Each retry builds another DEL_IP chunk and queues it on addip_chunk_list
> behind the outstanding ASCONF. That is one new chunk per retry, not a
> single duplicate.
>
> Could the commit message describe what actually happens on retry?
>
> > diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> > index 27c26e12f95d8..267dc9b7a0e73 100644
> > --- a/net/sctp/protocol.c
> > +++ b/net/sctp/protocol.c
>
> [ ... ]
>
> > @@ -645,16 +643,27 @@ static void sctp_addr_wq_timeout_handler(struct t=
imer_list *t)
> >                       if (!sctp_is_ep_boundall(sk))
> >                               continue;
> >                       bh_lock_sock(sk);
> > +                     if (sock_owned_by_user(sk)) {
> > +                             bh_unlock_sock(sk);
> > +                             retry =3D true;
> > +                             break;
> > +                     }
>
> [Severity: Medium]
> Can a single owned socket stall address event processing for the whole
> netns here?
>
> The first user-owned boundall socket in net->sctp.auto_asconf_splist
> breaks out of both loops. No later socket gets processed, and neither doe=
s
> any later addr_waitq entry, including events for unrelated addresses.
>
> Each retry starts again at the head of both lists. Every socket ahead of
> the owned one therefore gets sctp_asconf_mgmt() again on every tick.
>
> User context can hold the socket lock for an unbounded time. For example,
> sctp_recvmsg() holds lock_sock() across skb_copy_datagram_msg(). A copy
> that faults on a FUSE or userfaultfd backed page keeps sk_lock.owned set
> for as long as the user wants.
>
> The other async entry points defer per socket or per association: the
> sctp_rcv() backlog queueing and the timer handlers in sm_sideeffect.c. On=
e
> busy socket does not block the others there.
>
> Would it make sense to skip only this socket and track which sockets
> still need the event, instead of halting all processing?
>
> [Severity: Low]
> This isn't a bug, but the sibling deferral sites in
> net/sctp/sm_sideeffect.c log before they reschedule. One example is
> sctp_generate_heartbeat_event():
>
>         if (sock_owned_by_user(sk)) {
>                 pr_debug("%s: sock is busy\n", __func__);
>
> The DAD retry in this same handler also logs. Should this branch have a
> similar pr_debug() so repeated deferrals show up in dynamic debug?
>
> >                       if (sctp_asconf_mgmt(sp, addrw) < 0)
> >                               pr_debug("%s: sctp_asconf_mgmt failed\n",=
 __func__);
> >                       bh_unlock_sock(sk);
> >               }
> > +             if (retry)
> > +                     break;
>
> [Severity: Medium]
> Does leaving a partly delivered addrw on addr_waitq break the offset logi=
c
> in sctp_addr_wq_mgmt()?
>
> By this point sctp_asconf_mgmt() has run for every boundall socket ahead
> of the owned one, but the entry stays queued after addr_wq_lock is
> dropped. sctp_addr_wq_mgmt() assumes no socket has seen a queued entry
> yet:
>
> net/sctp/protocol.c:sctp_addr_wq_mgmt() {
>     ...
>         /* Offsets existing events in addr_wq */
>         addrw =3D sctp_addr_wq_lookup(net, addr);
>         if (addrw) {
>                 if (addrw->state !=3D cmd) {
>                         ...
>                         list_del(&addrw->list);
>                         kfree(addrw);
>                 }
>                 spin_unlock_bh(&net->sctp.addr_wq_lock);
>                 return;
>         }
>     ...
> }
>
> Take a partly delivered SCTP_ADDR_NEW entry, and suppose RTM_DELADDR or
> NETDEV_DOWN for the same address arrives before the retry. Both events ar=
e
> dropped. The earlier sockets' associations have already sent ADD_IP for
> the address. They keep it in asoc->base.bind_addr after it is gone, and n=
o
> DEL_IP is ever sent.
>
> The reverse happens with a partly delivered SCTP_ADDR_DEL entry if the
> address comes back before the retry. The earlier sockets' associations
> remove the address when the ASCONF-ACK arrives and never re-add it.
>
> Before this patch, the only path that left an entry queued was the IPv6
> DAD break. That break runs before the socket loop, so no socket had seen
> the entry yet.
>
> >  #if IS_ENABLED(CONFIG_IPV6)
> >  free_next:
> >  #endif
> >               list_del(&addrw->list);
> >               kfree(addrw);
> >       }
> > +
> > +     if (retry)
> > +             mod_timer(&net->sctp.addr_wq_timer,
> > +                     jiffies + msecs_to_jiffies(SCTP_ADDRESS_TICK_DELA=
Y));
>
> [Severity: High]
> Can this retry grow kernel memory without bound for an SCTP_ADDR_DEL
> entry?
>
> The retry has no limit and keeps no record of which sockets were already
> handled. Every SCTP_ADDRESS_TICK_DELAY (500 ms), the timer replays the
> same DEL addrw on every boundall socket ahead of the owned one:
>
> sctp_addr_wq_timeout_handler()
>   sctp_asconf_mgmt()
>     sctp_send_asconf_del_ip()
>       sctp_assoc_lookup_laddr()     <- still matches, ->valid is 1
>       sctp_find_unmatch_addr()      <- still returns another address
>       sctp_make_asconf_update_ip()  <- new skb and chunk, GFP_ATOMIC
>       sctp_send_asconf()
>
> While asoc->addip_last_asconf is set, sctp_send_asconf() appends the new
> chunk with no length limit:
>
>         if (asoc->addip_last_asconf) {
>                 list_add_tail(&chunk->list, &asoc->addip_chunk_list);
>                 goto out;
>         }
>
> Each retry also calls sctp_transport_route() on every transport of each
> association. These allocations happen in timer softirq context and are
> not charged to any memcg.
>
> The growth only stops when the owned socket is released or the ASCONF-ACK
> arrives. A peer that drops only ASCONF-ACKs keeps the association alive,
> because heartbeat ACKs and data SACKs reset overall_error_count. So
> sctp_sf_t4_timer_expire() never reaches max_retrans.
>
> A local unprivileged user with user and net namespaces can set this up:
>
>   - enable net.sctp.addip_enable in their own netns
>   - flap an address on a dummy interface
>   - filter ASCONF-ACKs
>   - keep a socket owned through a stalled user copy
>
> Before this patch, one address event produced exactly one DEL ASCONF per
> association.
>
> >       spin_unlock_bh(&net->sctp.addr_wq_lock);
> >  }
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261109024219.347985-1-18983559317%40163.com

Looks like we can't re-arm the timer in this case.

Can you try adding a list to struct sctp_sock to store the addr
entries and continue the loop when it occurs, and implement
sctp_release_cb() to handle them?

Thanks.
