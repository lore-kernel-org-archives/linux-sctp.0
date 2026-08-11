Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585003B42D3
	for <linux-sctp@vger.kernel.org>; Tue, 11 Aug 2026 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786463103; cv=pass; b=PidMBlgPL56fPJXifnAjl8feizrly6ApUfi5VjaKEuSj+FEA+pnPyk2koPZfmYngU8rFKKTCNaW6DhOy6IPfrSI9a0gWFvOkUSjYNbiCBuLU5MfnYAu4LHRSlVB2BXOWFNe8NIGrk+y/8kA8+oWVZLMe0ZizraT610oL/Ks6uOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786463103; c=relaxed/simple;
	bh=kiBeJRw3F0UCXM6tUWHubLSiJlh1qedjzGoqp1q+qD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVpoYhnfoi8sctsK4REz607nqXLTxGSjCzZ7o3VLVoK2pinl58fvEmNMlTTu0qv4pd4y12CjhOkb9f+PkuyErM1m8NmVsw/9LbKPRFN8du70AFqe3zw6MBVSReTiGtAMVEeAZLT/u3ALrikf3xUS8yFCv6tlhLcV3C+5ty/nCe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYHCYE+K; arc=pass smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYHCYE+K"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-848643382fcso9640b3a.1
        for <linux-sctp@vger.kernel.org>; Tue, 11 Aug 2026 08:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786463101; cv=none;
        d=google.com; s=arc-20260327;
        b=dSeXF8Y+xnKWPIO1n6qE4AwgzJCQYjhihcXsBNQsKeSZK+3g+lL4Bn5ci8rWxQzI7t
         xoU2fsdGaaOwrZHvYiiYHRVQjXUs+1CMtI9M8qbxgxcvIUGsz/dAodVd9GjcmN/JLFTo
         0mgSKO8GCi5l+pl5gTl7k8x/RTRlFr3R4TdeMa2P1AyoyUMBi2XTPVXq7ChQwDg4IQAQ
         ZNtbgJ9cwUrC+PT8ZJZ+BgGlIj2tFPzpKImCiWlrULbma4Lz7YTi9pIihh7s03Ia1sAw
         2cTwyCoLjxfNTRmRH68zutjtMAdvBFqTsGDamiSythRzf0fGn5NDra+RRqM/L/h8/sJq
         FIuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4gtUlPd4QXnv5aJSE6TKQZzjopWrXWWTIrsnHYKRiVU=;
        fh=xmKd5ULEubo20/snb/ASqT6g5vbrLA67K2f2YOsF/VI=;
        b=lelfzmQHvyqnIoY9ojMXKRrOsnjqkK+GM4vJR0zXUwhYT5dg4FttTWzJFA9OSvL5f5
         dWK5dQqhlAu2tiWTv5YBsHRtoyim68X433YZ7Ddi6/roCtSAh01GXxcfg/Ulw95vPUDg
         jLGX+mID20xoFYD8jaFujIqu9mHOPga/vNTDDsFRwUQPKhKbMWfDszyz+8tpEtCaRV9a
         AZPixH/uiuHWWKA4iuEVC9sbdBISgjuGzgwV0FxB0kxnP39pVbkLyeG1LJfGm+99VFp2
         Dd5k77r5V0vL/kdX1t/ZlWnfZLw0iLK2IQGWhlibkqoG8p4lHwM0aaJmaFMLLDEXxlqJ
         q+8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786463101; x=1787067901; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4gtUlPd4QXnv5aJSE6TKQZzjopWrXWWTIrsnHYKRiVU=;
        b=nYHCYE+K93wg5yhBFxoAnHVK2YzFGdIbZ3sqpsHErwga52haBlJBzdIe/0Jgn9Oj0e
         zTDxuXz6XvM76hSsDd/t9RM4zlF4Fb6UCZwed98yo1rZikQc/OaBSbeTVF3S8+jnUnAP
         Q267m4mHNKZ2EQgPjjmJ/OZIH691TUbLQ0q46JqCfE1IWlgSKcDsQ2Dovtz18Pe2IXzV
         MBqtV43rxFtSIujgqo1+8S6jOrQD7qY6hJ+eN7rfGL49LdVDziiHDzZ4VegU5ZtvoNjK
         sQcDrVoxtCB3YAQR+UnVHUToJYs7YjlsRA7Qu5ldJU09QizTtPybuaUyezz8EERfHwpp
         oVcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786463101; x=1787067901;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4gtUlPd4QXnv5aJSE6TKQZzjopWrXWWTIrsnHYKRiVU=;
        b=Px7/drf3GfdR2lIxnV5FqEvYc6F1jQTnW+2rxd7/1rydGBTTUgQZhvebNSULn4g5Br
         zfJY7PNlCNl9o1hqEIUQcZGaBIy2ALPmkxEgSPfGQSBk3j22MsdloC9KP9WPPHzh2naX
         0/FLGyTnRS94KWxamiwOC0zIJEFzVcx5t2ubMqBrvLOd8PQHvTJV5spPhrtA/RHJQ4Cu
         Ise6xcTigkc+MOMDbV2nNcaZS1B1kxnwHQTYr4iaZ1U8UgqhzTo4oAOILTCIWT5AaaTS
         fdXGQJ7Qc24sdjZMPP0k+UZDFWByXSAfuzAPFSz5tR8hJd1Ccc//v9uVwrEM40VqYwTu
         HDtA==
X-Forwarded-Encrypted: i=1; AHgh+Rpobuz+TGc96Mzl9BsypYWgQ3gYevNzRaKsWsM3k3Rb5P3413ZOEM8rJliMYf9S/6namyt1EZfJ9iO0@vger.kernel.org
X-Gm-Message-State: AOJu0YxjMnD0dDpsu9lvh4r4H9IULRqRYp6Pi2aKJIo2flgxaGu2ppYj
	BWQmxxiekIcC0qukpv8S882ZGnNp1+E0a3W/u0s+ZWFUxRIrBeZIpFg98TY3q1Yekw1Yow+3dlN
	Gw0+JVSf/mU7vhfE4B5ARiz8X4hS3sa4=
X-Gm-Gg: AR+sD100lnKSZLu1KNgOnEK6Z3PgargJVGPR8VXSklfUwABnau7B+p+ZIHmT6eFjiqt
	kNbST25XjK/40qWHyHqlsky6QKteweigbZjZKWoyk/Dk7VdiGOBSsZbXKRST7VovOjGNpIYm/9b
	fBukni42qiBhjlYdvuURSccCkjZGBnbG5nZ95hNwBVjpOAfeFA4U0LJ3D7sPegLP2vs8jANOlmq
	Njz5vjWCUtOP8riY0hGrFtyzBRAiSKWW1FNPUZyfzpb8sduUfSA1r55ZAiqReJYlizjBCabQxNR
	RmnwCH6IAH6h2ZVaKOdKOh/ju7MDC6eI0h5UFf5uud//5VkJsAhpgktjV0yS8mpTXZBxb0TMaav
	WY83/TX7JhIQJzBmqIu6sfrNRZLyF1NmUHtafncELDC7u
X-Received: by 2002:a05:6a00:3686:b0:84e:1a9d:d879 with SMTP id
 d2e1a72fcca58-84fafa00b17mr1347220b3a.28.1786463101312; Tue, 11 Aug 2026
 08:45:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811152803.5629-1-a0yami@mailbox.org>
In-Reply-To: <20260811152803.5629-1-a0yami@mailbox.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 11 Aug 2026 11:44:49 -0400
X-Gm-Features: AUfX_mxJP8h_5PE3kHQzF7Hk7Dth_b-NuFIjAwOMUfCbiQUPxt95mvRzMhw8ci0
Message-ID: <CADvbK_d8r56n6FHFEeyz0cpmdoFJ5HXJ4m0XipQqYXTiL-YLjw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: clear new_transport when removing a peer
To: Qing Ming <a0yami@mailbox.org>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Michio Honda <micchie@sfc.wide.ad.jp>, linux-sctp@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 11:28=E2=80=AFAM Qing Ming <a0yami@mailbox.org> wro=
te:
>
> sctp_process_asconf_param() stores a newly added peer transport in
> asoc->new_transport. After all parameters in the ASCONF chunk have been
> processed, sctp_sf_do_asconf() uses this pointer to send a HEARTBEAT to t=
he
> new transport.
>
> An authenticated ASCONF from a remote SCTP peer can add a transport and
> remove it again with a wildcard DEL-IP parameter in the same chunk. The
> wildcard deletion preserves the transport on which the ASCONF arrived, bu=
t
> removes the newly added transport through
> sctp_assoc_del_nonprimary_peers(). The removal does not clear
> asoc->new_transport, leaving it pointing to the removed transport.
>
> sctp_sf_do_asconf() then creates a HEARTBEAT whose chunk->transport point=
s
> to the removed transport without holding a transport reference. During
> local address replacement, src_out_of_asoc_ok keeps this HEARTBEAT on
> control_chunk_list. After the transport is freed by RCU, a successful
> ASCONF_ACK for the replacement address releases the queued HEARTBEAT and
> sctp_outq_select_transport() reads the freed transport's state.
>
> The issue was found during a static audit of SCTP objects. With an
> authenticated peer, the reproducer triggered the same KASAN report in 2
> of 2 unpatched runs on a KASAN-enabled netdev/main kernel:
>
>   BUG: KASAN: slab-use-after-free in sctp_outq_select_transport
>   Read of size 4 at addr ffff88800b9bd95c by task python3/197
>
>   Call Trace:
>    sctp_outq_select_transport+0x549/0x8b0 [sctp]
>    sctp_outq_flush+0x306/0x2c60 [sctp]
>    sctp_transport_immediate_rtx+0xaf/0x260 [sctp]
>    sctp_process_asconf_ack+0xa48/0xf70 [sctp]
>
>   Allocated by task 197:
>    sctp_transport_new+0x68/0x650 [sctp]
>    sctp_assoc_add_peer+0x258/0x12a0 [sctp]
>    sctp_process_asconf+0x5e9/0x1090 [sctp]
>
>   Last potentially related work creation:
>    __call_rcu_common.constprop.0+0x77/0xb70
>    sctp_assoc_del_nonprimary_peers+0x7c/0xd0 [sctp]
>    sctp_process_asconf+0xd9c/0x1090 [sctp]
>
> The first invalid access was a four-byte read of transport->state at
> net/sctp/outqueue.c:833. The same reproducer completed the full
> authenticated ASCONF and local-address replacement sequence with this
> change without a KASAN report or oops.
>
Could you also post the reproducer, at least to the maintainers?

Thanks.

> Clear new_transport when its peer is removed, before it can be used to
> create the HEARTBEAT.
>
> Fixes: 6af29ccc223b ("sctp: Bundle HEAERTBEAT into ASCONF_ACK")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5
> Signed-off-by: Qing Ming <a0yami@mailbox.org>
> ---
>  net/sctp/associola.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 5b0ae616e1ff..c65c83638cce 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -543,6 +543,9 @@ void sctp_assoc_rm_peer(struct sctp_association *asoc=
,
>             asoc->addip_last_asconf->transport =3D=3D peer)
>                 asoc->addip_last_asconf->transport =3D NULL;
>
> +       if (asoc->new_transport =3D=3D peer)
> +               asoc->new_transport =3D NULL;
> +
>         /* If we have something on the transmitted list, we have to
>          * save it off.  The best place is the active path.
>          */
>
> base-commit: cba9ccb47e9fa4cc77692fb896cc5ab57a667882
> --
> 2.53.0
>
