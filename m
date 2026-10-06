Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519CA380FF7
	for <linux-sctp@vger.kernel.org>; Tue,  6 Oct 2026 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319410; cv=pass; b=uoA5lsjFmUmXWvP8dLspRgn+D/c7ubFDcnCJ27FafbPhHN2mnK/475MpUysaQ3IIMis/1Yv2tMvNoDpd+7atdr5PeJ7dxWqX6zr7eFK2Qolu8haSmeiVhVzfnIjlT2oVqZOWMsuX4qhzL54cPxivDo6an3YXPbuYcet1UPwzusI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319410; c=relaxed/simple;
	bh=XfDOqwl6Iw7dv6BhzcIBSwIFStzO1lcl+rnJERqVgQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EXHxQv9bLsQVs1xgNLtZcIlaG+K6n2xQoGD40/YJyJp5S28sd+LwYiYVPh9JZaKixwpt3uekWNx7vdNuaVovgswW4Nny5p3PR+OknV4NOOwycDWiX4bScc/kQEnKjX+Lc/uJdUXfRyoab7Eh5L995xVqyWuvyJus1A8ED6akc9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5S5XvZg; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5S5XvZg"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-88bf90b7f07so420818b3a.3
        for <linux-sctp@vger.kernel.org>; Tue, 06 Oct 2026 13:43:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791319409; cv=none;
        d=google.com; s=arc-20260327;
        b=SkiCf6K9BPU1XYD/H4HzJFw4ImoD+IJWijv9XdSnJ+WSYLv310Okbx0jj4Mq9Sp+kT
         3NQ+2OK3UaNmcx8l5eoJqDqHxdmuAmzhdOawtTf74w7zuvIzeDfiinhwYvbD0rsf6qfG
         fuitiKm2R0yk+cy/BQ/Om6cMWWkhyDW3EnqK1jCDntyY9vChdDyQTVOqef2TA/7cbQ6H
         I4gDIB31zQXFI4ZxRB+nw4Pqz7r9+bizEGhteW3AyRctZ3ik/n9HX4b5aRQW8v6RzZ/z
         KU5Xjp08sIfueux5laE2Fr/9L0cO57jQZ3Nu8dKVzOzVQ5iOBdHBF+YceodDoA86Br/9
         iynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pYLtJa497tb3khpaP4kumzUEgLsH3DJmAXssXxTU2u0=;
        fh=m/7Cb5XEZ7w77V7vR91sYWRjIBmYSBtGV1ZlMcKzE4Y=;
        b=aBxO3XwkCK29whRnQgzmLvOXwlHQ/DLIvQFhc/51j6dyQQYzUGxS5LU7yYUtTvZt+d
         JrHUyYicgvckjBKFHseLdQM/DAkMxgYR5fvPkCcT/oQkoMYnFvBMkShznnrI3J7EkTmB
         3dgWlXCIgZvg/Mgg44W7w89bRzH4JMjZXkdoy96p2X7VxIaDKOr5pGHDGXCoKYhmkGyp
         WRte3+ztIm75C5/wQqyvA8vv+LlfV2nHKb8r0azSG3UhuIS7k/41zZFd/WQIgI90UNfI
         hazmsmEkMnv9kgrOWFVAMx1DO7mz2TycaIflks75bTy2tXiGD936940bWbFjJgNhIy2Y
         QugA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791319409; x=1791924209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pYLtJa497tb3khpaP4kumzUEgLsH3DJmAXssXxTU2u0=;
        b=V5S5XvZgo8p3OD2UQE5HmB3owC4iF6nZhK0gwdQBeSuUzaHaOAmiPhuLeXa2ZRiqgV
         z57lVVHxrdlCGXD2W9nrUG41BnA7nIwR5YWUv3A6uqcGY+cUNFEBanbaYgdhUfkdZxnz
         YkIFS4WBrMaR3s93a7ST+8kyJjcOZ7TRhTroav9XXp6EKDcZGjHx1oJIXRvTxOu53HMt
         BazxFrkgAWzA4a+lVg8RpbHxDVcupTz5B3FGtgFZTZQZI4Kd2KoMfVpwLyA38bxR6IRB
         9zNWYEfZyMiO7M87dhvBrQOn4umqv7QvW8/7PBULbE0zc7SYfXJJzOKp0ewFcTz3Wffp
         ZRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791319409; x=1791924209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pYLtJa497tb3khpaP4kumzUEgLsH3DJmAXssXxTU2u0=;
        b=1sPueIrHtGBz5VYpj3+duXRxCouxfnoa+kjYOBDr15b8eA86q9Jue0qwE8Y6KxutVB
         lZfMU9JBqsO8RKVfYiNA78zMXba9Z8qZXxk7DgB3d2VJ+oJ+e2RwdKYB6AEgUoBmqsIP
         D/4FIuo0hECw5a4WHopm/ntOSuGPrCsHc4Q3exfRuEtUOWw59kFdCuTKcw9x817zEZSY
         k3T2BPTU3TPrJ89Cj4tWjvRRKx6oMJrV6S/xadLLqUIKuxUi1qQkofAP3eq5x5XMEHr+
         KkQXQxh06WO8Fc9V011gaiMeMvPHxDbIE+KsDpk+PUWLaU8GW0r2EoL0MfuHf+N0bNCE
         VEbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwN/sLo+KaORKT7iRnNbHLFPm6PBY7/oG4mCIP4ietYUxSPc94bRBxA5bO1slQup6EKvNFx+a7KggyD@vger.kernel.org
X-Gm-Message-State: AFuF++k/5z1QqZxwA1rfLvNswQmb9JFhYCgoXiZJxnUNXybXExu38rnt
	jIhSV2jf53jNFXbvwdTVF6g/gyUyygYxo4NsCFwyp+ALdpHPVOxgu5v8OpAS/XTWbtGO9cm8ZuG
	Ncg/wqY3gr0D6o0NNsLS8uS2EbSSmI7s=
X-Gm-Gg: AYBFou2L/srMxuHIxpEu4xfdtItz2gcVPNi1WvcNeh3hd7wFg0szySART7QPLeuxm4D
	/Uf1tdzDLmjXJpaF/dywdluInuOWNRtvZQobIQZpQW7pydg446mi0GAhuQuJSDpU0KzUYfquEmY
	bDPPn0ElecwCRRzMrQjbf+aKnx/xAP55MegoKrlcyuBOo7mmcOZrphMDxVwf477jHkDd0CD5n+8
	HbIjgKPV0SjZJkfVF9O8dzVMTl2kQTCjCjgipQRhRejp/LPkD1T1/31epvDOypuVlavAe2yMSRy
	us5s25SH0eDnhyUwfiAHo/oL5Fo2sNahN5i/UUVrp4e1CKKzw2AaRWfVEFzxQCbSl2WLATOnUcu
	EFlcrvI/JjIZ6KhIRXouWMtIZLXcC4OSwXdIRZFN/7yYUrHy4GMyIpg==
X-Received: by 2002:a05:6a00:32c4:b0:877:d02a:42f2 with SMTP id
 d2e1a72fcca58-891b1195350mr273315b3a.7.1791319408388; Tue, 06 Oct 2026
 13:43:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261002010449.3689454-1-4ncienth@gmail.com> <179124882160.434549.10169630192303444846@kernel.org>
In-Reply-To: <179124882160.434549.10169630192303444846@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 6 Oct 2026 16:43:16 -0400
X-Gm-Features: AclHuK97XPKuX_Iuayb6nolJMGLhL_ExO0TZyJKCzoxjc8sL4n8F-xIlo7P6KTI
Message-ID: <CADvbK_ed4ruZjf8CV_jGN=JPkJDHwwZ_9vx+q3zdHnFYiW8dLQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: revalidate output stream after association
 connect wait
To: netdev-bot+sashiko@kernel.org
Cc: 4ncienth@gmail.com, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 5, 2026 at 9:07=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] The patch only partly revalidates state after
>   sctp_wait_for_connect() in sctp_sendmsg_to_asoc()=E2=80=A6
> - [Medium] The new -EINVAL in sctp_sendmsg_to_asoc()
>   (net/sctp/socket.c:1851-1855) is returned only after=E2=80=A6
>
> --
>
> sctp: revalidate output stream after association connect wait
>
> This patch adds a check in sctp_sendmsg_to_asoc() after
> sctp_wait_for_connect() returns, for the message interleaving case. It
> compares sinfo->sinfo_stream against asoc->stream.outcnt again. The
> handshake can shrink outcnt and free the ext of removed streams while the
> socket lock is dropped, and that used to cause a NULL dereference in
> sctp_outq_tail().
>
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index 4652fd90d9a6c..394d31cb698e0 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -1848,6 +1848,11 @@ static int sctp_sendmsg_to_asoc(struct sctp_asso=
ciation *asoc,
> >                               err =3D -ESRCH;
> >                               goto err;
> >                       }
> > +                     if (unlikely(sinfo->sinfo_stream >=3D
> > +                                  asoc->stream.outcnt)) {
> > +                             err =3D -EINVAL;
> > +                             goto err;
> > +                     }
>
> [Severity: High]
> Is the bound check enough on its own here? Could the stream's ext still b=
e
> NULL when this check passes?
>
> The code before the wait checks two things:
>
> net/sctp/socket.c:sctp_sendmsg_to_asoc() {
>     ...
>         if (sinfo->sinfo_stream >=3D asoc->stream.outcnt) {
>                 err =3D -EINVAL;
>                 goto err;
>         }
>
>         if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) =
{
>                 err =3D sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_=
stream);
>     ...
> }
>
> Only the first check is repeated after sctp_wait_for_connect().
>
> While the lock is dropped, INIT-ACK processing can shrink outcnt:
>
> sctp_process_init()
>   sctp_stream_init()
>     sctp_stream_outq_migrate(stream, NULL, outcnt)
>       sctp_stream_free_ext()   /* kfree(ext); ext =3D NULL for sid >=3D o=
utcnt */
>     sctp_stream_alloc_out()    /* only lowers stream->outcnt */
>
> After that, outcnt can be raised again without restoring ext. One way is
> for the peer to send a RECONF ADD_IN_STREAMS request, either bundled afte=
r
> COOKIE-ACK or sent right after it:
>
> sctp_sf_do_reconf()
>   sctp_process_strreset_addstrm_in()
>     sctp_stream_alloc_out(stream, outcnt, GFP_ATOMIC)
>     stream->outcnt =3D outcnt;
>
> The other way is for another local thread to call
> setsockopt(SCTP_ADD_STREAMS) while the lock is released:
>
> sctp_send_add_streams()
>   sctp_stream_alloc_out(stream, outcnt, GFP_KERNEL)
>
> On that path, outcnt is also not rolled back if sctp_send_reconf() fails.
This is a separate issue to check.

>
> sctp_stream_alloc_out() only calls genradix_prealloc(), so the existing
> entry for the earlier sid keeps ext =3D=3D NULL.
>
> When the sender resumes, the new check passes because outcnt has grown
> back. Then this runs:
>
> sctp_primitive_SEND()
>   sctp_cmd_send_msg()
>     sctp_outq_tail()
>       sctp_outq_tail_data()
>         oute =3D SCTP_SO(&q->asoc->stream, stream)->ext;
>         list_add_tail(&ch->stream_list, &oute->outq);
>
> Doesn't this reach the same NULL ext dereference in sctp_outq_tail() that
> the commit message describes?
>
> Could the full pre-wait validation be repeated after each wait that drops
> the lock, perhaps in a shared helper? That means the bound check plus the
> !ext -> sctp_stream_init_ext() step.
>
> The existing outcnt-only recheck after sctp_wait_for_sndbuf() seems to
> have the same gap.
>
Please add a helper like:

static int sctp_sendmsg_check_stream(struct sctp_association *asoc,
                                     struct sctp_sndrcvinfo *sinfo)
{
        if (unlikely(sinfo->sinfo_stream >=3D asoc->stream.outcnt))
                return -EINVAL;

        if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext))
                return sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_str=
eam);

        return 0;
}

then add or replace the stream checks in these places:
[1] at the beginning of sctp_sendmsg_to_asoc().
[2] after sctp_wait_for_sndbuf().
[3] after sctp_wait_for_connect() in asoc->ep->intl_enable branch.

> [Severity: Medium]
> What happens to the association when this new -EINVAL is returned?
>
> sctp_wait_for_connect() only returns 0 once the asoc is ESTABLISHED. If
> the association was created in this sendmsg() call, the caller then does:
>
> net/sctp/socket.c:sctp_sendmsg() {
>     ...
>         err =3D sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo=
);
>         if (err < 0 && err !=3D -ESRCH && new)
>                 sctp_association_free(asoc);
>     ...
> }
>
> This frees a live, established association outside the state machine.
>
> No ABORT or SHUTDOWN is sent, so the peer is left with a half-open
> association. SCTP_MIB_CURRESTAB was incremented in sctp_sf_do_5_1E_ca()
> and is never decremented.
>
> On a TCP-style socket, sctp_cmd_new_state() has already set sk_state to
> SCTP_SS_ESTABLISHED. It stays there with no association behind it, so
> later sendmsg() calls fail with -EADDRNOTAVAIL or -EPIPE.
>
> The commit message says:
>
>     Return
>     EINVAL if it falls outside the negotiated range.  This matches the pr=
e-wait
>     check.
>
> The -EINVAL before the wait frees a CLOSED asoc that never associated.
> This one frees an established asoc. A peer can trigger it just by
> advertising fewer inbound streams than the chosen sinfo_stream.
>
> Failures after the wait from sctp_datamsg_from_user() or
> sctp_primitive_SEND() already reach the same free path. This patch adds
> another way into it, and the peer controls that one.
Please set err =3D -ESRCH; before goto err; for the check [3].

For sctp_datamsg_from_user() and sctp_primitive_SEND(), we should not
change it now, in case it may break any existing applications.

Thanks.

>
> Since the association is already established at this point, should this
> case be handled differently from the pre-wait check?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/20261002010449.3689454-1-4ncienth%40gmail.com
