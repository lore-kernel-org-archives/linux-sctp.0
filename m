Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D2214900E;
	Tue,  6 Oct 2026 01:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791248824; cv=none; b=X+UhY5bVKkpxVXY7Yc9FaXtCEW1Omz4hcQVedKgzfL9lM+PjwOtn9q9DeEJFW2FAu0aqxXDn++fELK+F2XN4It7iHgFCX1qOvbf4PqU6U1t8JLGPDXWBOkOsmIoekxUPyP/jrpT/KrACg7X5uH8Cq7qEcErWgBQbiRHvm2Ykljk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791248824; c=relaxed/simple;
	bh=9mSqLl5eCp1HLl3EW3EBfDc5o7WISaMzpbDaFH/ioJE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WWym+glMpM/IvHPTP7C0gMIJ/Mg0TbePxlmlC1maA12efl8kXlJTRY0BzO6J/7ZwdPWGFoUoiPt6UfAb3n7UwX5k1KI3+NjNep1jpibqogMLst4BPdE4H/u5ZCU+KKn8jQr3Ktcos27u0TK+CfWdemLMZXV0g5jAf793bzpQ1jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pwnp5XJK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pwnp5XJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E21F000FF;
	Tue,  6 Oct 2026 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791248822;
	bh=vcfWdNBCzriuE7//36wM6D8nESzaeGEOhXz1ApajVtE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Pwnp5XJKUmipAWvrw/w3BlRcH7KDwkqmSZ0u/QSe+B5W8yB3ml9XAmpWMxTVekiWJ
	 G9JNEk5IFLh559fgQ9/Q5T2ZiLyeRPLPayK0G1K924RKFIjvxOIY+StUUxOztkyz9o
	 LZ5MkY8fjZeYZJq/FDM+YsuSwcQvSAQLL3Q6m8jTaKgPOUMgnJx2/V9m8KE6HsZxXp
	 zG8SrbYobucq5lArUBxvBesYK77+4OQpUcP9lXCna8PoXQGan2ULOj8B2whsfKTsn3
	 fCm2OHPaPFtUac3s8ueLSF1qpWIfsq2sE2H5j3DZKXEUSWuG3hlSrUvDokjYbtoIab
	 3sNkZ+TjatKwQ==
Subject:
 Re: [PATCH net] sctp: revalidate output stream after association connect wait
From: netdev-bot+sashiko@kernel.org
To: 4ncienth@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 nhorman@tuxdriver.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Tue, 06 Oct 2026 01:07:01 +0000
Message-ID: <179124882160.434549.10169630192303444846@kernel.org>
In-Reply-To: <20261002010449.3689454-1-4ncienth@gmail.com>
References: <20261002010449.3689454-1-4ncienth@gmail.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch only partly revalidates state after
  sctp_wait_for_connect() in sctp_sendmsg_to_asoc()…
- [Medium] The new -EINVAL in sctp_sendmsg_to_asoc()
  (net/sctp/socket.c:1851-1855) is returned only after…

--

sctp: revalidate output stream after association connect wait

This patch adds a check in sctp_sendmsg_to_asoc() after
sctp_wait_for_connect() returns, for the message interleaving case. It
compares sinfo->sinfo_stream against asoc->stream.outcnt again. The
handshake can shrink outcnt and free the ext of removed streams while the
socket lock is dropped, and that used to cause a NULL dereference in
sctp_outq_tail().

> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 4652fd90d9a6c..394d31cb698e0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1848,6 +1848,11 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
>  				err = -ESRCH;
>  				goto err;
>  			}
> +			if (unlikely(sinfo->sinfo_stream >=
> +				     asoc->stream.outcnt)) {
> +				err = -EINVAL;
> +				goto err;
> +			}

[Severity: High]
Is the bound check enough on its own here? Could the stream's ext still be
NULL when this check passes?

The code before the wait checks two things:

net/sctp/socket.c:sctp_sendmsg_to_asoc() {
    ...
	if (sinfo->sinfo_stream >= asoc->stream.outcnt) {
		err = -EINVAL;
		goto err;
	}

	if (unlikely(!SCTP_SO(&asoc->stream, sinfo->sinfo_stream)->ext)) {
		err = sctp_stream_init_ext(&asoc->stream, sinfo->sinfo_stream);
    ...
}

Only the first check is repeated after sctp_wait_for_connect().

While the lock is dropped, INIT-ACK processing can shrink outcnt:

sctp_process_init()
  sctp_stream_init()
    sctp_stream_outq_migrate(stream, NULL, outcnt)
      sctp_stream_free_ext()   /* kfree(ext); ext = NULL for sid >= outcnt */
    sctp_stream_alloc_out()    /* only lowers stream->outcnt */

After that, outcnt can be raised again without restoring ext. One way is
for the peer to send a RECONF ADD_IN_STREAMS request, either bundled after
COOKIE-ACK or sent right after it:

sctp_sf_do_reconf()
  sctp_process_strreset_addstrm_in()
    sctp_stream_alloc_out(stream, outcnt, GFP_ATOMIC)
    stream->outcnt = outcnt;

The other way is for another local thread to call
setsockopt(SCTP_ADD_STREAMS) while the lock is released:

sctp_send_add_streams()
  sctp_stream_alloc_out(stream, outcnt, GFP_KERNEL)

On that path, outcnt is also not rolled back if sctp_send_reconf() fails.

sctp_stream_alloc_out() only calls genradix_prealloc(), so the existing
entry for the earlier sid keeps ext == NULL.

When the sender resumes, the new check passes because outcnt has grown
back. Then this runs:

sctp_primitive_SEND()
  sctp_cmd_send_msg()
    sctp_outq_tail()
      sctp_outq_tail_data()
	oute = SCTP_SO(&q->asoc->stream, stream)->ext;
	list_add_tail(&ch->stream_list, &oute->outq);

Doesn't this reach the same NULL ext dereference in sctp_outq_tail() that
the commit message describes?

Could the full pre-wait validation be repeated after each wait that drops
the lock, perhaps in a shared helper? That means the bound check plus the
!ext -> sctp_stream_init_ext() step.

The existing outcnt-only recheck after sctp_wait_for_sndbuf() seems to
have the same gap.

[Severity: Medium]
What happens to the association when this new -EINVAL is returned?

sctp_wait_for_connect() only returns 0 once the asoc is ESTABLISHED. If
the association was created in this sendmsg() call, the caller then does:

net/sctp/socket.c:sctp_sendmsg() {
    ...
	err = sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
	if (err < 0 && err != -ESRCH && new)
		sctp_association_free(asoc);
    ...
}

This frees a live, established association outside the state machine.

No ABORT or SHUTDOWN is sent, so the peer is left with a half-open
association. SCTP_MIB_CURRESTAB was incremented in sctp_sf_do_5_1E_ca()
and is never decremented.

On a TCP-style socket, sctp_cmd_new_state() has already set sk_state to
SCTP_SS_ESTABLISHED. It stays there with no association behind it, so
later sendmsg() calls fail with -EADDRNOTAVAIL or -EPIPE.

The commit message says:

    Return
    EINVAL if it falls outside the negotiated range.  This matches the pre-wait
    check.

The -EINVAL before the wait frees a CLOSED asoc that never associated.
This one frees an established asoc. A peer can trigger it just by
advertising fewer inbound streams than the chosen sinfo_stream.

Failures after the wait from sctp_datamsg_from_user() or
sctp_primitive_SEND() already reach the same free path. This patch adds
another way into it, and the peer controls that one.

Since the association is already established at this point, should this
case be handled differently from the pre-wait check?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002010449.3689454-1-4ncienth%40gmail.com
