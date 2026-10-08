Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4614E430F;
	Thu,  8 Oct 2026 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475047; cv=none; b=DtIA53p2bltGpyGh6noerGJKSMg2sQMM4qvgP/Qh7Mx83k9CKTPlMLslJOi+zVGJXAYnBILHzEKl4haSJP2OstWSe4a8IZappiIvCDDxXySHue5/HHtu+oq6dCWCsVdTO/7j3BKgNCRvyww3AdqOo3362AuU3Yb66T2rG2SgXok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475047; c=relaxed/simple;
	bh=9QpGYylqVU+dkG/hPow3ZQCYbNMa2H+zS0gjOW8ma6Q=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SwSMyPsuDdOCL9B3J8jqtCKT5sd/4ZagrXyUri3N/6pNIdFHu4BcweMJDD8TIdN7uGZXljVmwOVm1VM05i0Efr90ETuC/8f+cM01GrXvoZJnjUR4yZpV+GIVuLS2Dqau1l4fpTmOncbXKePDdbuXK5K+PN0TDAvRK9slJocyeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/tLX98W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/tLX98W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76AA1F000FF;
	Thu,  8 Oct 2026 15:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791475043;
	bh=oW4vd/fkJGW56OrO8Qa4BwDCUVbvSoixy58F/rnwivw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=I/tLX98WUWBFM/GWMZUBRtD63lFi/eWNv784tsfa3wqkWjSIibv4JwzaaoMuF99O2
	 w/8Z9HRLf5o7IbCnRHaPdUO1jcQHFqgsw/PisVIxl0AikeFt7yK7yPFAfl9kgDqydL
	 A9b6I6dn7l7U4yqqOj/yyloijjetwHJcdQEQcD+N5S/uKSWhXuYG6KDv7k21nKzvoG
	 zOwzc0VqW/7am3dzK3E6KZ1U7Nym67p9u+VNVBWH98dZ1qFzlto/Xe6JASkNZoWJ0h
	 LhH9Ueao60vaUh+F4WvkYnyM9hhgQus09E5F3q4W9tYMimTjAgsONsttY/CKheFQWA
	 pFnORDZWECA9w==
Subject: Re: [PATCH net v2] sctp: revalidate output stream after association
 connect wait
From: netdev-bot+sashiko@kernel.org
To: 4ncienth@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 08 Oct 2026 15:57:22 +0000
Message-ID: <179147504220.434549.18146896790420057417@kernel.org>
In-Reply-To: <20261007035739.3472432-1-4ncienth@gmail.com>
References: <20261007035739.3472432-1-4ncienth@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 (1) · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] sctp: UAPI breakage leaking -ESRCH to userspace on stream
  validation failure

Pre-existing issues:
- [Medium] Pre-existing ownership problem on the sndbuf-wait error path
  in net/sctp/socket.c, not introduced by this patch.

--

sctp: revalidate output stream after association connect wait

This commit moves the output stream range check and the extension check
into a new helper, sctp_sendmsg_check_stream(). It runs that helper again
after both the sndbuf wait and the connect wait in sctp_sendmsg_to_asoc().
If the check fails after the connect wait, the error becomes -ESRCH, so the
caller does not free the auto-created, already established association.

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index e35692dd8d303..321898f22d80d 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1786,6 +1786,18 @@ static int sctp_sendmsg_check_sflags(struct sctp_association *asoc,
>  	return 1;
>  }
>  
> +static int sctp_sendmsg_check_stream(struct sctp_association *asoc,
> +				     struct sctp_sndrcvinfo *sinfo)
> +{
> +	if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt))
> +		return -EINVAL;
> +
> +	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext))
> +		return sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
> +
> +	return 0;
> +}
> +

[ ... ]

> @@ -1830,10 +1835,9 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
>  		err = sctp_wait_for_sndbuf(asoc, transport, &timeo, msg_len);
>  		if (err)
>  			goto err;
> -		if (unlikely(sinfo->sinfo_stream >= asoc->stream.outcnt)) {
> -			err = -EINVAL;
> +		err = sctp_sendmsg_check_stream(asoc, sinfo);
> +		if (err)
>  			goto err;
> -		}
>  	}

[Severity: Medium]
This is a pre-existing issue, not one introduced by this patch. Does the
ownership reasoning from the connect wait also apply to this re-check after
the sndbuf wait?

The caller, sctp_sendmsg(), frees a new association on any error except
-ESRCH. It does not check whether the association is still CLOSED:

	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
	if (err < 0 && err != -ESRCH && new)
		sctp_association_free(asoc);

sctp_assoc_add_peer() has already hashed the new association's transport at
this point. On a UDP-style socket, another sender can find the association
through sctp_endpoint_lookup_assoc() while this thread sleeps in
sctp_wait_for_sndbuf() with the socket lock dropped.

A possible sequence:

thread A (creates the asoc, new == true)
sctp_sendmsg_to_asoc()
  sctp_wait_for_sndbuf()
    release_sock()

thread B (sends to the same peer)
sctp_sendmsg()
  sctp_endpoint_lookup_assoc()   <- finds the CLOSED asoc
  sctp_sendmsg_to_asoc()
    sctp_primitive_ASSOCIATE()

the peer's INIT-ACK shrinks asoc->stream.outcnt below A's sinfo_stream

thread A
    lock_sock()
  sctp_sendmsg_check_stream()    <- returns -EINVAL
sctp_sendmsg()
  sctp_association_free()

Would this tear down an association that the state machine now owns
(COOKIE_ECHOED or ESTABLISHED)? No ABORT would be sent to the peer, and the
counter and socket state would be left inconsistent. The commit message says
it avoids this outcome for the connect wait by returning -ESRCH.

The baseline already had the -EINVAL re-check here. The other
sctp_wait_for_sndbuf() errors (-EAGAIN, -EPIPE, -ERESTARTSYS) also reach
the same free. With this patch, sctp_stream_init_ext() failures (-ENOMEM or
a scheduler init_sid error) reach it as well.

Should sctp_sendmsg() check whether the association is still CLOSED before
freeing it? Or should this path remap the error the same way the connect
wait path does? Earlier commits c863850ce22e1b and 4f1da630d13de0 used a
similar -ESRCH remapping.

[ ... ]

> @@ -1848,6 +1852,11 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
>  				err = -ESRCH;
>  				goto err;
>  			}
> +			err = sctp_sendmsg_check_stream(asoc, sinfo);
> +			if (err) {
> +				err = -ESRCH;
> +				goto err;
> +			}
>  		} else {
>  			wait_connect = true;
>  		}

[Severity: Medium]
Does this leak the internal -ESRCH sentinel to userspace?

sctp_sendmsg() returns its result through sctp_error(), and
sctp_error() only special-cases -EPIPE. Whatever
sctp_sendmsg_to_asoc() returns here therefore reaches the sendmsg()
caller unchanged.

With this hunk, sending on an sinfo_stream that the peer did not grant
can return ESRCH. That happens only on the first send of an implicitly
created association with intl_enable set. The same request on an
existing association, or after the sndbuf wait, returns EINVAL. An
-ENOMEM from sctp_stream_init_ext(), or an error from the scheduler's
init_sid hook, is also reported as ESRCH.

ESRCH ("No such process") hides the real cause from the application.
It also misleads, because the association is alive and ESTABLISHED at
this point, and a later send on a valid stream would succeed. Since
this is Cc stable, the errno change would also appear in stable
kernels.

The connect wait failure path just above already returns -ESRCH to
userspace, but that case is pre-existing. This patch extends the
behavior to an argument validation failure.

The remapping only exists to keep sctp_sendmsg() from calling
sctp_association_free(). Could the ownership decision be made
separately from the errno? For example, sctp_sendmsg() could free the
new association only while it is still CLOSED. Alternatively,
sctp_sendmsg_to_asoc() could report ownership through a separate
out-parameter. Either way the original -EINVAL or -ENOMEM would reach
userspace. Or is there a reason the errno has to carry this?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261007035739.3472432-1-4ncienth%40gmail.com
