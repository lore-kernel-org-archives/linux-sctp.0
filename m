Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5C0352019
	for <linux-sctp@vger.kernel.org>; Thu, 20 Aug 2026 15:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238266; cv=pass; b=u57pk9ZUY19JkdYsEUzZbst2JrbMZ5D0YDGs+f/9mL87S52g5Umu4OhiH8OR58U/TmRjxxwfaiigtcLK+OH4tof/zncJ2jHlZBC5uF+m0mt6UybKagtBy60eMe6SGgevXfINv/t7+ua1yNftsYLWxtOrV0zg3kcgk/kZhyACaJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238266; c=relaxed/simple;
	bh=1VOtg2a+mCLGrBHtCxL2dQjoQpaFwsB9mKlcltTUeBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ixjL9sLBeSztpX7J+ZzTiyOT4hurJd2NicvnZZl+d5cx/6JixisiD6TLMCNURlQQHaukwbkqsovs/SWs4rrg8nZZEWT29s5gk8m831NbPIqGEQbxuQvLB3Yj3IVDRhd6eaQxfyRVuTXTP9sz2KLPOY8935RDzkKMWpyaf0pPGds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdpAOTUp; arc=pass smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdpAOTUp"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8486672f03cso2180670b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 20 Aug 2026 08:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787238265; cv=none;
        d=google.com; s=arc-20260327;
        b=imhL1xzPZDF021Er8SyTQ8IsBNsD7F+h6vUsHr2v0YL4Ksxfz+V0sD7H79BlfeTBJA
         6hVZO+2G+qBEeWLL2VLEqREh5s8EEsH/9otPM3cPj8yIb3+oRGiAt1ZhOXop4ypkb591
         LxDLe+LyU2OsyXfNSo32u/tiCVjgBuk1Zsoj0YFwdDy5Ge9NNIVdqmqimiztxbWyfu56
         JHwoV47Z/GJHO8EC2b8oz2SAEEroZVW3+B7jM8tdJOG/2L6/q2D0lDHSMKVqN4AYfM1z
         5/Z4Fst8RfzuVRif/l/CuGC0EY+C2A8ND9ueVGXiKkkGCQZxxMPZXn21OShgiZH89/y+
         YJrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b2LmqCXxT7oGJVHwzHbpyF/RrL4Qmn8B2JsL8FziJJo=;
        fh=dkBtbRBo3JQvmgpD8Lov87t8IlWB47fB0mX2/4A3ob0=;
        b=iMkeJgEcizs8GDx900QC5CP6bW68DkgD8hgoFTWkwebbAOePMj0mh6mVLeibvJAWZ4
         hMNc6CE4lF/nQBgwLu7dKedtkFA9ABqDw/aOSj/4G8vZbMPRYEGy2GS7Oa3O2KjPY4bb
         U0YWl6wsyMaooi/tV1HJBktaovz/flC0M+GSTJsn8f89JlspG5k4P1ir9uCfwkZ+Gcbq
         Vw3g45YqgFComeEIwV98iQbG3iFxmF065TP4Yzmx72WmdqBdIyc2F8mmEq8wjXWctrnB
         cXdriwzV7tzhpVqz9x/vPTAwwNQVSYc3ujQ4VrrhAMPPtknQdXRBVSh1rxpFyJzaLxXI
         hv3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787238265; x=1787843065; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b2LmqCXxT7oGJVHwzHbpyF/RrL4Qmn8B2JsL8FziJJo=;
        b=KdpAOTUp55jXdRUpUrhbN1IayzL3AGVI/8/pSteT2FXn4SR1eKuaeH89b572ogaiiH
         8JA++kuoNDXkqF8OESTUYkj6TJQGb/9eerIINm+c+TQg70FGcB/Kb/gbaP11nG3AatJy
         +EdFLr6LNSfwNIJegAFiqxxSFVsJguY6BDTDWTyzKMdSstXUvG8FIA6WAioBzK79oB2n
         ph3MgjjQtro6UvIcNvtAGUvxVzfzlNGEC9ZKyDWQd9Evkh5u5+2yDzVgQAGWYboYw7nm
         qjddpd60KR/Afq4DJrVqPHDbcrmq5k8PzlQJovxKkCWtbcIuezAMs5KMMf3SIetPPKbD
         Am3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787238265; x=1787843065;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b2LmqCXxT7oGJVHwzHbpyF/RrL4Qmn8B2JsL8FziJJo=;
        b=VBijuK1F7pKY3E7k55DqxFJzOWoUAmuJG2YQg1OF0g9z+g2OpoXPMsn7r85cKTWM/K
         LNo4SFNQ8z3mpFPPvF3p54egkehfhEoM9UR8t666Z/UrUyvDgk9q2deEVoGojYlrcY00
         1qBHD25iKkix/2mgYx3bloYbMiaZ+GBAAt/Dixm+CBLHyW+mF/KqGNBRMQp2swxnqi3G
         rstEOzFaxixhwlBCTe094C5OSjXyycXj1mOH9K536mwc/7KMw+onIYuxKciHCJLcVKg5
         nQDEHB44dAXkoM5ymHKaRmaf7ChhaUZdE5CkCy0lRK+sRgEo6uH8N4oCdYBgFspzPuRZ
         BYYw==
X-Forwarded-Encrypted: i=1; AHgh+RqBdZdBa8lOXjCYf76C+2MxSrx/WWX/KctI+zZb5bKGXwTRc5HsVHSPH2yIFN5XWAweooKI9NDfaZ5h@vger.kernel.org
X-Gm-Message-State: AOJu0Yx48uEZ23yu50PezwpNtBdoPhkuSHrC+/vtgab5HVuyGSS2Z7bt
	uKMk3cvRq4i1uVlXHp2JNf9KUpKPWY7ejHbt9EZkOyipKbdX0QcLUH66iU45KOUwOILqZMOYFZN
	dlAGR7+Z8jUH7YmoDBxDJc/n6Aae2tBwYwWXa
X-Gm-Gg: AR+sD12qztw3bSs+8iDr+Qghv6zsqKBUuepN8QDfD5onW1v3za9yAM7oSs1xZ81K5aQ
	L9Spu3G8Oew+r4C95JKG9iDrNi7wgoNq1qDd7UdP6Q++2v4g5kwbnqMltROiP5Dcv2ImN3UlmPU
	7/EX5Akdr53YWu+xx7w0FIj4HgRUFCuDESZjd+uSE/IZZLYrVbzuO0kCu8ziwQXZ5QwKtSXLPkd
	OeE86PVPjp9btk+nt9bgL5AnHZIJ99x+SqyZB+ThlTIKwf8DMjF3GWX3z3PfOOeWH+mF4RSKDyA
	b5RgabRRlWFoG5VbHO29C8SrbHPs69SIAjNb/VM3vK8V7RIlDrZsKzaJ+78hkx+oVAdUFruhy7I
	yqqWph+g7VsO1NKZ3OP9citmiOChETZtXe3mqqaobQ6qhoG/3dbLys/YEacbx+h+h6URr0QKwPn
	ucOKLvI/0v7uE=
X-Received: by 2002:a05:6a00:a211:b0:845:e8b9:347 with SMTP id
 d2e1a72fcca58-851d3942b62mr21772245b3a.13.1787238264580; Thu, 20 Aug 2026
 08:04:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aoUJHQmxL0LFIMCw@v4bel>
In-Reply-To: <aoUJHQmxL0LFIMCw@v4bel>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 20 Aug 2026 11:04:12 -0400
X-Gm-Features: AcwNN1UQX2CmBEKT0N9riqZ158JDKHJxfGAvwlOJo89EtxNcXMCDtSApxsbWigw
Message-ID: <CADvbK_cG6yTabSSEXCmEJ0MrqFG3ESHAtctupGUdRQwmeUYihQ@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: drop a chunk if its transport was removed
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 9:38=E2=80=AFPM Hyunwoo Kim <imv4bel@gmail.com> wro=
te:
>
> sctp_rcv() resolves the transport once per packet and leaves it in
> chunk->transport. The lookup reference, or the one sctp_add_backlog() tak=
es
> if the socket is owned by userspace, keeps it around until the chunk has
> been processed.
>
> An authenticated ASCONF DEL-IP can remove it in the meantime.
> sctp_assoc_rm_peer() takes the transport out of the association and calls
> sctp_transport_free(), which tags it dead and drops the reference the
> association held. There is a window on both paths: the packet can sit on
> the socket backlog, and on the direct path the lookup completes before
> bh_lock_sock().
>
> The DATA chunk in that packet puts the removed transport back into
> asoc->peer.last_data_from. Once the packet is done that reference goes
> away and the transport is freed by RCU, so the next delayed SACK carries
> the pointer into the SACK chunk and sctp_outq_select_transport() reads th=
e
> freed transport's state.
>
> Drop the chunk in sctp_inq_push(), next to the existing rcvr->dead check.
> Both paths reach it with the association's socket lock held. The peer
> retransmits it.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
> Changes in v2:
> - Move the check from sctp_backlog_rcv() into sctp_inq_push(), so that th=
e
> direct softirq path and the socket migration branch are covered as well.
> - Correct the Fixes tag.
> - v1: https://lore.kernel.org/all/an-oGfEatacPTSX-@v4bel/
> ---
>  net/sctp/inqueue.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/inqueue.c b/net/sctp/inqueue.c
> index a024c08432471d..5f988b3a8814ff 100644
> --- a/net/sctp/inqueue.c
> +++ b/net/sctp/inqueue.c
> @@ -71,8 +71,11 @@ void sctp_inq_free(struct sctp_inq *queue)
>   */
>  void sctp_inq_push(struct sctp_inq *q, struct sctp_chunk *chunk)
>  {
> -       /* Directly call the packet handling routine. */
> -       if (chunk->rcvr->dead) {
> +       /* Directly call the packet handling routine.  Drop the chunk if =
the
> +        * receiver or the transport it was looked up on is gone.
> +        */
> +       if (chunk->rcvr->dead ||
> +           (chunk->transport && chunk->transport->dead)) {
>                 sctp_chunk_free(chunk);
>                 return;
>         }
> --
> 2.43.0
>

Acked-by: Xin Long <lucien.xin@gmail.com>

Note, this patch fixes the case when the transport is freed before the
chunks get processed. But the pre-existing issue reported in Sashiko-claude
[1] is the case when the transport is freed while the chunks are being
processed, which is very rare, the fix would be to set chunk->transport to
NULL instead. We need to confirm and address it separately.

[1] https://netdev-ai.bots.linux.dev/sashiko/#/patchset/aoUJHQmxL0LFIMCw%40=
v4bel
