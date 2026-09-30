Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5E73DBD51
	for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 20:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790800189; cv=pass; b=fEgdpmQTOz1PaOCmgADvRZjuhbnPM2ZvjqOw0vHXD15sriDmhoBuURG2qNhESK+b1btMuJ8tm3l3jWcolESHTd4ppVy9QaBRWwRTndkBzwkulOswhKUqShP1p6fvzJqorLWySZmMtI9a3tJibiCYr1COmadHlFMGqheEri7ZgNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790800189; c=relaxed/simple;
	bh=BcHVFv0/2CTiuZtCyRliAm86ePsh0uPI4rajTwd6Axk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XMHC4a2/fIdAaxAViu51ML6MCQi5Fu3Liyu4wYul12gJ+A1e6+IfgRTtNhNGT4DGM+cT2c2263bN8+lieE0XfBWXkJHu+/12t766uHElOpCVYtmXuJjKXsdD7/pELbhH+8HCTUY72A1r9coj48Saooh7S6qi7kG2IMC1KOYn+KQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vv1XN1+q; arc=pass smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vv1XN1+q"
Received: by mail-pz2-f39.google.com with SMTP id d2e1a72fcca58-880fcd3790bso2082437b3a.1
        for <linux-sctp@vger.kernel.org>; Wed, 30 Sep 2026 13:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790800187; cv=none;
        d=google.com; s=arc-20260327;
        b=H0hSge1nXy7IzxEjeKqp/qH8/fYyq383I3dHI9qVr+Egs7PP6qmBuq/a4jN/qsZf4a
         iJ2vBs7Hta2Xw5CsV/cSzabxhJN1v4HN5y6tXqoq9W0Oh1basKEJg2ZzjdPlM9JBDc4Q
         6X0j/r0HZt9FgklaElgBgC+TQw0CTOs1lb5N8NO/RQUkvlLT6CivW6BqHg6fhSs7EPvU
         WHkdQ+6/0EtK4znMwzxfN6EJmGXX0/dUKc6wjqRuwoQiYJPXmvHILKg7ngE1B/QbW1MC
         JofeLG19bincENTtjuGrXVkcalgYfsronQQvMHe6qPfOBFB+Hoj5A2pDvS3ckYNBwRWh
         xw0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0qWiEREHyYEPUY00hgC8r7GMRIjMsgsKZRL/BAv6jKU=;
        fh=sDRT4Y6qfYycHBrYhzMGmjOnvVpsJ6q4t3rq2ns5AlA=;
        b=nvmNVg6vQ3a8sVHIXdF3IDzI4VC2cd4W259uunQ0UB+5IJMG3VlSPM/OgCeoNH6YTq
         QNUCqIt3zyEIaDmbs4/ADN5EVkXjgc+QMualVnclRwO+g35rXTORFShBIs52fMn5LJqi
         VpGcc1o/wXH9NXsioQxd7XErumAWx0OFAMDtDlza/nCSiE5tYG8KSx4hO48WhFD+5RSP
         WLB2/Y++kLBWe8nSEn9qA92CB+I0cdbuwVwr1hsGmxR+8EY51Io6bOa6yLgGfe8EyVgS
         OT8WswUdR6ivsghg98SE3FTW2+lc50VhnHW7a2MWsgfJJ0MthJqrsaG3ArCbtEEhnHII
         ndtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790800187; x=1791404987; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0qWiEREHyYEPUY00hgC8r7GMRIjMsgsKZRL/BAv6jKU=;
        b=Vv1XN1+qiISnGjHnmWGq2UxuFGQwS635Xjkvr55K2ZFdWHbkkElc8ivlC6NVMmT/0D
         VbYAOZOdhc/QFztL+oDmly6T2nJiD8Q0y9cqtH1li4sif8pGsAZw/ILhbtLuDlSjWj18
         FxQHxyJUOxeyuSmTABTW4KCPTy0NF8He190CNj6ursK36y6AEGsZIkkI3lD/NSs0ErVu
         nok0K0dNghMDshMM9gXEZUjrN9/GD9cbq1KRRpXeO5eGCv3hs1K1wVrUPBJDJfY3fyUz
         0sCJnibRj5wM0Br8MN8Yba/slOJhd52ss73dyvhqTJAz0YcIxOGSB4WS3DfxNYn1Gpnq
         Jzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790800187; x=1791404987;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0qWiEREHyYEPUY00hgC8r7GMRIjMsgsKZRL/BAv6jKU=;
        b=vG1ili1fJ7xI39cOfrjnHwYqEvF2ucfiVPoMONX1YO0/W1Ch1wK+M+6wRkzmBASoMU
         /EEr2vX1fFu9NblmTBey2owTA3vhztS7zkTHPS1RMhYgihsBjFm5TmVU6Uu2U6FSAUmH
         N5wFn8b0U7TkGyNOpOPoadThl0whMpWLAbNESUryCJv1OZ7EXOcnz8l/I31W/EnWOtn6
         Ip//Gv+/41AO1oooVYcoKxxjVYpfSxrLhdKfsICjOYSJUoWXGscAuKRaa9cIsfdsOg/c
         4liSps511uwz6ZnLibii505kgziHYBTDpmXNkCZpG37qz3RD0tyYNxRz+KJ+BHkmcU3T
         DQRw==
X-Forwarded-Encrypted: i=1; AKwUvBz2V95CxItOsmO1zboGp/j0nBN4rHksGaz4jF1Ru415f9uVDZ4LENkQqkW0rvDcXShdoFPijwc2srOJ@vger.kernel.org
X-Gm-Message-State: AFuF++nt6AuDJVWjeVhTHkM9nL8piyKF28AUplJ30stNCConOUcUZQKe
	uMjbdle7c+BH4wMtMCh9xQRY0yHy/hquxiyHp2HsITqH1QWcsjblqu0AAlV2/n0jOU1elQD5lJZ
	sIdGK/l2plwiSviiBPwXIiU/09lJKv4Q=
X-Gm-Gg: AYBFou1GtkA10Iy2vRxKresy+BeC7u13OE8N8bgWWEd8fiO/633z6KL7XUBkV+zNzI2
	+qGEizjFl/oHP9eDOMG4Zu3POfjAb/z9OY8lwu8DIr0kThQgJB6IOKK8LITzFnIL9tCH48XTWiK
	+MQmJPlpn14ftoV607TlyqUGlq1NIh19iABNJ14x/eQzFBMCcHnAQEZ90TwPWG1LBiWjM+il8Cd
	mv+JkExN6CrxACt4b2dqxfelPKpcHWeo5Jls7CVYdLI7ge7RgpwOWj52id0luoTAvJu8CRDtNqQ
	ejVy09Qyh38iuHIiviTkNE3roMP8PszxDL5lT2ORWGALOgu0TNWd89H0JMvSwkX1PPWR3iFU8v+
	b0/Kn+D6XZWbxeaoR0a9gYlKArrvhKBR5tXuFWYjyhJmhFQ/EXcJt7Q==
X-Received: by 2002:a05:6a00:b81:b0:881:e626:74a0 with SMTP id
 d2e1a72fcca58-8874c4dcd27mr1741017b3a.47.1790800187111; Wed, 30 Sep 2026
 13:29:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926095606.68601-1-juny24602@gmail.com> <179072989710.434549.611689946552220471@kernel.org>
In-Reply-To: <179072989710.434549.611689946552220471@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 30 Sep 2026 16:29:34 -0400
X-Gm-Features: AclHuK9rgle9CfYF9HG4o2DzoqMTbtzE58FML_p4_AtH4ltOARTYvFuLeb8C-Gs
Message-ID: <CADvbK_d1reO=rbAg9ND9d68LXHtTtnqKuPa51RtVqPOG8KTHNg@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: check RCV_SHUTDOWN after the sendmsg connect wait
To: netdev-bot+sashiko@kernel.org
Cc: juny24602@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, junvyyang@tencent.com, 
	stable@vger.kernel.org, corvus@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 29, 2026 at 8:58=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 (1) =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] In sctp_sendmsg_to_asoc() (net/sctp/socket.c:1847), the new
>   condition `if (err || sk->sk_shutdown & RCV_SHUTDOWN)` returns -ESRCH=
=E2=80=A6
>
> Pre-existing issues:
> - [Critical] This problem wasn't introduced by this patch, but it sits on
>   the same post-wait path the patch hardens.
>
> --
>
> sctp: check RCV_SHUTDOWN after the sendmsg connect wait
>
> On the intl_enable path of sctp_sendmsg_to_asoc(), this patch checks
> sk->sk_shutdown & RCV_SHUTDOWN after sctp_wait_for_connect() and returns
> -ESRCH if the bit is set. The aim is to stop the send from continuing wit=
h
> an association that was freed while the socket lock was dropped. That can
> happen when a concurrent SHUT_RD makes the wait break with err =3D=3D 0.
>
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index c7b9e325ec1cd..4652fd90d9a6c 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -1844,7 +1844,7 @@ static int sctp_sendmsg_to_asoc(struct sctp_assoc=
iation *asoc,
> >               if (asoc->ep->intl_enable) {
> >                       timeo =3D sock_sndtimeo(sk, 0);
> >                       err =3D sctp_wait_for_connect(asoc, &timeo);
> > -                     if (err) {
> > +                     if (err || sk->sk_shutdown & RCV_SHUTDOWN) {
> >                               err =3D -ESRCH;
> >                               goto err;
> >                       }
>
> [Severity: Medium]
> Can this reject sends where the association is still alive and no race
> happened?
>
> The new condition only looks at the socket-wide RCV_SHUTDOWN bit. It does
> not check whether the asoc actually died.
>
> One case needs no race: shutdown(fd, SHUT_RD) on an unconnected socket.
> inet_shutdown() falls through from TCP_CLOSE and sets the bit permanently=
,
> even though it returns -ENOTCONN:
>
> net/ipv4/af_inet.c:inet_shutdown() {
>     ...
>         case TCP_CLOSE:
>                 err =3D -ENOTCONN;
>                 fallthrough;
>         default:
>                 WRITE_ONCE(sk->sk_shutdown, sk->sk_shutdown | how);
>     ...
> }
>
> sctp_shutdown() does nothing for SHUT_RD alone. A later sendmsg() to a
> new peer then goes through sctp_primitive_ASSOCIATE(). On its first
> iteration, sctp_wait_for_connect() breaks with err =3D=3D 0 without sleep=
ing:
>
>                 if (sk->sk_shutdown & RCV_SHUTDOWN)
>                         break;
>
> A concurrent SHUT_RD that arrives after the handshake, on a healthy
> ESTABLISHED asoc, would also hit this check.
>
> Before this patch, both cases went on to sctp_primitive_SEND() and return=
ed
> msg_len. Now the data is dropped and userspace gets ESRCH. sctp_sendmsg()
> reads -ESRCH as "the asoc may be gone":
>
>         if (err < 0 && err !=3D -ESRCH && new)
>                 sctp_association_free(asoc);
>
> So the new asoc stays on ep->asocs with its INIT already sent. A retry th=
en
> succeeds because the asoc is no longer CLOSED.
>
> This also looks inconsistent with how other code handles the same wait
> result:
>
> - __sctp_connect() returns it as connect() success.
> - The non-intl wait_connect branch in this function sends and returns
>   msg_len.
> - The comment above sctp_shutdown() says SHUT_RD "Disables further
>   receive operations. No SCTP protocol action is taken". Disabling sends
>   is left to SHUT_WR and SHUT_RDWR.
>
> The commit message only describes closing the concurrent SHUT_RD + ABORT
> race. It doesn't mention the new errno from sendmsg() or the association
> left behind.
>
> Would a narrower check work here? One option is to hold the asoc across
> the wait and test asoc->base.dead. Another is to treat RCV_SHUTDOWN as an
> error only when the asoc is actually dead.
>
intl_enable case differs from the common case: chunks must not be enqueued
until the connection is established in sctp_sendmsg(). Therefore, we must
ensure the connection is established before continuing the send.

If shutdown(SHUT_RD) is called during the handshake in such a case.
sctp_wait_for_connect() may return 0 after seeing RCV_SHUTDOWN, without
confirming that the association reached ESTABLISHED. In this rare case,
it's safer to fail the send rather than enqueueing chunks based only on
!asoc->base.dead check.

So I would prefer the fix in this patch.

> [Severity: Critical]
> This is a pre-existing issue, but it sits on the same post-wait path this
> patch hardens. Can the transport pointer also be stale after this wait?
>
> sctp_wait_for_connect() drops the socket lock but only pins the asoc. It
> takes no reference on the caller's transport and never checks
> transport->dead afterwards. sctp_wait_for_sndbuf() does both.
>
> When the wait returns 0 because the asoc reached ESTABLISHED,
> sctp_sendmsg_to_asoc() goes on to:
>
>         list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
>                 sctp_chunk_hold(chunk);
>                 sctp_set_owner_w(chunk);
>                 chunk->transport =3D transport;
>         }
>
>         err =3D sctp_primitive_SEND(net, asoc, datamsg);
>
> This sequence appears to free the transport while the lock is dropped:
>
> 1. sctp_sendmsg_new_asoc() adds the primary daddr as SCTP_UNKNOWN through
>    sctp_connect_new_asoc(). Extra SCTP_DSTADDRV4/V6 cmsg addresses are
>    added the same way through sctp_connect_add_peer().
>
> 2. sctp_sendmsg() keeps the transport for TCP-style sockets, or when
>    SCTP_ADDR_OVER is set.
>
> 3. An INIT-ACK arrives from one of the extra addresses with the correct
>    vtag. Its address parameters do not list the primary.
>
> 4. sctp_process_init() removes every transport still in SCTP_UNKNOWN:
>
>         list_for_each_safe(pos, temp, &asoc->peer.transport_addr_list) {
>                 transport =3D list_entry(pos, struct sctp_transport, tran=
sports);
>                 if (transport->state =3D=3D SCTP_UNKNOWN) {
>                         sctp_assoc_rm_peer(asoc, transport);
>                 }
>         }
>
>    In COOKIE_WAIT nothing else pins the primary transport. So
>    sctp_transport_free() drops the last reference, and the transport is
>    freed after an RCU grace period.
>
> 5. COOKIE-ACK moves the asoc to ESTABLISHED. The waiter returns 0 with
>    RCV_SHUTDOWN clear, so the new check passes.
>
> 6. The flush that sctp_primitive_SEND() triggers reaches
>    sctp_outq_select_transport(). That function reads new_transport->state=
,
>    then does list_add_tail() on ctx->transport->send_ready and calls
>    sctp_packet_config() on the freed transport.
>
> A local socket needs net.sctp.intl_enable, SCTP_FRAGMENT_INTERLEAVE and
> SCTP_INTERLEAVING_SUPPORTED for this path. The INIT-ACK contents and sour=
ce
> address are controlled by the remote peer. The problem seems to date back
> to when the intl path started waiting for the connection before sending.
>
> Does this path need a sctp_transport_hold() and a transport->dead check
> across the wait, as in sctp_wait_for_sndbuf()? Re-deriving the transport
> after the wait would be another option.
>
Seung already posted a patch for this pre-existing issue:
https://lore.kernel.org/netdev/20260928152132.3705137-1-guncraft2000@naver.=
com/

Thanks.
