Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794577740;
	b=zD1Jbn16pLdogEnu+AibSulxPa9+yWQpME82w127/q9YtLuYKKtCKc6LUO4l1lkYo8ki
	 8DhUSl+TpHfVIK16dJibhVGnxIm5hxz5mNYd7ddC3HapfnBOAHKNLzitQ254BZ6Lq73iF
	 O7BdcH+KIgYL0l1nlBJk7FykGW1v26y6KhK7K3SaRePOLxveksXjBXAAtVzrM2dooOuuf
	 itpSN/gN+MWXa/F58/N9m99x+bRbsSVJWDSZnUY15uQ/A9B1Q23FwD2NlIJDJvCLAxR8u
	 dNAIjHvb6YkszLiW1DlSTBaoYuDcb6wFAqKv7W+16rg3+PHRAd1Zy6TfTCA4SID60tA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794577740;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1bhPViXt1pRD/+G0cozJg3X1gM1h4MG3wea7XTuXsrc=;
	b=04QRxuX3bGhpkaC1JfI2qiX9g6e8l+qRSHzK9K2y2JJ8WvPsfpupoTahJd4RTSM/rdAx
	 SqTe9bNhmL/AuWcKUzAiLqWd1L5aegfdh49Ts9lMQBV1EFBx7bjAp6UlsYuSA2z+FBKlh
	 LgOelr823sX70xVOumZeIQh/bRVY4QRshggDW0bq45viUy667Uh0tIPByoqbQ5J0FpdtY
	 nLK7lViThRzfACkvbHz1HN4bC9nXhcpUCBySUDTwYzLEMlsppKNd5CtXNXVYx/l7AGrFs
	 yi78OHfOxGi+cLXXyId70GU9iOwDlcAfXxT5AtBiVA8KP5+FpCZB1mms35D03qYpO7A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDaBJi6E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE5E606A32D
	for <linux-sctp@vger.kernel.org>; Fri, 13 Nov 2026 13:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BE5E606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IDaBJi6E
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a0673d9bd2so1120871b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 13 Nov 2026 05:49:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794577739; cv=none;
        d=google.com; s=arc-20260327;
        b=WrjbdQB8pVOIcC2L8khysDFGkjE5tRfgr4V/+EgSB5w45q1wukTmX59u9sPnmCB41z
         rLRx1HmLcjA/0gPCggDPt79OcUGsM6pJdCxs0eOVNnFvDvKzyI6M04Arn/7evcm3hMO/
         w+51JyQYID3QFToSkqvt/cVvvwDrM3GJOGahquhL/lYlGkiSMuubh+bBxGUonyTqcg9m
         XDixYEB9PfObMNefLZKJqRxENfydeWj/TuUJDBnTJqb3BTJ21lPLRmUtbFKRXV/CpXWr
         4y84PWJt4MQ1j56bojVuozNK+USOeBM+xyOMCblfndEZFgmgdpkNew8aj7VvV8zU3ndV
         bwEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1bhPViXt1pRD/+G0cozJg3X1gM1h4MG3wea7XTuXsrc=;
        fh=s2MZA/kyD869I0QhF1ezmK5zeEeVx1XG4bEeOBbX+QQ=;
        b=edBtl/Dpmb4YhRA3Z8oMuF0aSSakfnzxIxJ7icgz9L/09zxIJN+mQs9srHj+HzROOI
         nmhizs/OzGm+8Wyv3/dpOTJ0cdCHHdwmXtMUsoyZDeYSQldtujwsYm8E/Nc7N+TC/7XL
         lX9sbX/uj75rISROWaFER4zMfmr3xFivm7DBwRHLfTnXAMBoKTo/OeWFsN/Eeq9clhnJ
         nMFrHQsQet/nHVDeJL1tnntAS8rjpF3bNAyRPQw9aL7K1NWCsv2vyHy31iwNTpXv6jOb
         6D1AWh2lYCpLUNHOfouOxuEOmjVc6fpF3/mP2U1tjviugtt4z92diZIu7jsP2FAwg0Ul
         97qg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794577739; x=1795182539; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1bhPViXt1pRD/+G0cozJg3X1gM1h4MG3wea7XTuXsrc=;
        b=IDaBJi6EnzYWBbfLMiIPr0Hr9fUbFucDOD5m0rjktHtv4g65mORdut5ERKbwL3+WdB
         Ebh98AmvbnRMDB5UNnyQWh0hqd6x9Lv/vmnaDNCw0JqxFBUeoDpXKz4lTndlo/XHrvpi
         N/I7ww+bA3R+GVpMMfkFGheCSAaZ/BG1iIfgs8r+xIG0umJ8Q2Mmh1VpTOBS07jjZqTz
         nAJgyVzCIyaklyNxiek0OKHskIrA+FjsbNJgYwzHgxK7+Wl8x/c1WAVZPZpkcAVL+/sS
         xZLCb4uuHJ40hxymUgOM3U1c328PfYaV0Nj9Q5mB0ZEffdzBeJ/uyt01pd2SwV5StXSr
         l6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794577739; x=1795182539;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1bhPViXt1pRD/+G0cozJg3X1gM1h4MG3wea7XTuXsrc=;
        b=CAmB5VDG5JKljYZOM8BvbtNOsbBR4+Z4c7sD7ekVtX8O7i4HsTcRGmuDLQbDmPFHN7
         Jq9g6NKB4U9Ut+0Ggz4pmbJ3Uc3yOZwS52VGaQ2mHolPmLOwNKbKgu00pBmNRto7G2M0
         YRkwQgQaONnLkagp1rxazxmnLb98TgaOko8W9J2GhtW3VN3GGCZpmlXXnde4lAsnUrC8
         ZEQoiu8lOshODlGdO7mCQ2TTFU4w62+V0AaYM/Y9gs8O+5Wp3Ik2vyOA2DAcsbbIHiFl
         aWiLdqCrfEnNziB2IkvOId8kVValQzxOcCkgWbKnegbyxtNassrv7wwhaD+el6vsGmCt
         XtIg==
X-Forwarded-Encrypted: i=1; AL+hErEc/yfyVoqBaDQN8kpLH8B6+TTqkiM1q50KZJFu3T9JsAFRGEJP5qxdIEYiqjaM/K1BDdWx4Vk/ULot@vger.kernel.org
X-Gm-Message-State: APuU4Z+dDOUU+nBK+jBa7bFPtZVR9gArbZNtrkjIZtKlOdsXv+C+faZz
	mMiOJfr7I4/uxT7almGGSlT6MNtHM36lx4AO7IHPsi4rOVcvMjYzGD0bxZ4KJfkbSNU8BzZ0GuL
	RpNq6Elg/s9kUHxStRiYQUl+VfMbfMYA=
X-Gm-Gg: AYBFou3G28aS0dA5uTmMOUvmqru/Mr69psGaE9d4Zp/3Z6eJs4JeH+lCCwbMrCXVac8
	rbuhmi+swb+z4STNfDBK9LvW/3mkTp0esadj7ffVFxDFshwEsqbKvdUjF9KtXf1IwIukz2s4i0M
	GI2UIaaxRNs4go2XBfZ5jY+1D/XQFMu3iaGSGGtkrk0BQ0R9nDLAxgTA7a1aBU0NnLC4Wv7Nv19
	UJ2fsobJNv/c/UhR7iP4YdWa3Xi1Hy1khbeA2Cz6CyDYx8NcPHZ+syCDAKEAuw3kKlm9AbN59pn
	JcfdnMZQ5Yxl0Ab5zpnCKJw3nhRwf90yQLXxIO0F3vE/Lka+AeQjd+V/ea6V6YNlJxr7loYbRxC
	hpWg5Gb0yl0kDknpt6PaDjrFq4GHqJj54j4UQnvmhO3qjH055/WW+7lfJJIDWbvk45pInVj0ALX
	zLQKDjYV2zzRryVHzdKCPCMeoQCJ9+vKg+Kdn3PdWFSK4dldJVjgupub+n
X-Received: by 2002:a05:6a00:893:b0:8bb:1b05:dd39 with SMTP id
 d2e1a72fcca58-8beb58bcc45mr2934303b3a.11.1794577739414; Fri, 13 Nov 2026
 05:48:59 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112172149.27355-1-yves.bieri@theori.io>
In-Reply-To: <20261112172149.27355-1-yves.bieri@theori.io>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 13 Nov 2026 08:48:47 -0500
X-Gm-Features: AclHuK8PfN4ou0sIEU-hFGhRyxEEh94jLa5NJ3yVhQe-fdSo_K9CA5s6bPZ98fo
Message-ID: <CADvbK_cetnuX7=VDEh9hE4db3BdYWr9es28jVorMXOQsTfrxGQ@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: do not free a new asoc peeled off while
 sendmsg slept
To: Yves Bieri <yves.bieri@theori.io>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2026 at 12:21=E2=80=AFPM Yves Bieri <yves.bieri@theori.io> =
wrote:
>
> When sctp_sendmsg() creates a new association and sending on it fails
> with anything but -ESRCH, it frees the association. The send can
> sleep in sctp_wait_for_sndbuf(), which releases the socket lock, and
> meanwhile another thread can peel the new association off to a new
> socket. The wait then returns -EPIPE, and sctp_sendmsg() frees an
> association that now belongs to the peeled-off socket, without holding
> that socket's lock.
>
> If the peeled-off socket frees the association first, e.g. on close(),
> sctp_sendmsg() frees it a second time. Otherwise a syscall running
> concurrently on the peeled-off socket can use it after sctp_sendmsg()
> freed it. Both are reachable by an unprivileged user. The double free
> on net with KASAN:
>
>   BUG: KASAN: double-free in sctp_tsnmap_free+0x5c/0x80
>    sctp_association_free+0x1eb/0x750
>    sctp_sendmsg+0x15ff/0x2020
>   Freed by task 836:
>    sctp_association_free+0x1eb/0x750
>    sctp_primitive_ABORT+0x85/0xe0
>    sctp_close+0x22a/0x8d0
>
> Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
> sleeping on it") fixed this double free by denying the peeloff.
> Commit cea0cc80a677 ("sctp: use the right sk after waking up from
> wait_buf sleep") replaced that check, and commit a0ff660058b8 ("sctp:
> return error if the asoc has been peeled off in sctp_wait_for_sndbuf")
> reverted it to return -EPIPE, without restoring the check.
>
> Fix this by holding a reference on the new association while sending
> on it, and by freeing it on error only if this socket still owns it.
> asoc->base.sk only changes in sctp_sock_migrate(), which runs with this
> socket locked, so the ownership check is stable. The reference keeps
> the check safe if the new owner frees the association meanwhile.
> Userspace still gets -EPIPE, and the association stays with the socket
> it was peeled off to.
>
> This was found by Xint Code, an AI code review agent, and reproduced as
> an unprivileged user on net with KASAN (trace above), without modifying
> the kernel or using error injection. With this patch the sender gets
> -EPIPE and the association keeps working on the peeled-off socket.
> Without a peeloff, a failed send that created the association (EAGAIN,
> EINTR) still frees it, and a peer ABORT while the sender sleeps still
> frees it exactly once. The SCTP selftest sctp_vrf.sh passes. The
> reproducer is available on request.
>
> Fixes: a0ff660058b8 ("sctp: return error if the asoc has been peeled off =
in sctp_wait_for_sndbuf")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yves Bieri <yves.bieri@theori.io>
> ---
> v2:
>   - move the hold to right after the association is created (Xin Long)
> v1: https://lore.kernel.org/netdev/20261110224233.82977-1-yves.bieri@theo=
ri.io/
>
> Tested on net at b71c101bbb98.
>
> The fix and this message were drafted with Claude, and reviewed and
> tested by me.
>
>  net/sctp/socket.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b5a57f6..6ed184e 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2063,6 +2063,11 @@ static int sctp_sendmsg(struct sock *sk, struct ms=
ghdr *msg, size_t msg_len)
>
>                         asoc =3D transport->asoc;
>                         new =3D true;
> +                       /* sctp_sendmsg_to_asoc() may release the socket =
lock,
> +                        * and the new asoc can be peeled off meanwhile. =
 Hold
> +                        * it, and free it on error only if sk still owns=
 it.
> +                        */
> +                       sctp_association_hold(asoc);
>                 }
>
>                 if (!sctp_style(sk, TCP) && !(sflags & SCTP_ADDR_OVER))
> @@ -2084,8 +2089,11 @@ static int sctp_sendmsg(struct sock *sk, struct ms=
ghdr *msg, size_t msg_len)
>
>         /* Send msg to the asoc */
>         err =3D sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo=
);
> -       if (err < 0 && err !=3D -ESRCH && new)
> -               sctp_association_free(asoc);
> +       if (new) {
> +               if (err < 0 && err !=3D -ESRCH && asoc->base.sk =3D=3D sk=
)
> +                       sctp_association_free(asoc);
> +               sctp_association_put(asoc);
> +       }
>
>  out_unlock:
>         release_sock(sk);
>
> base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
> --
> 2.43.0

Acked-by: Xin Long <lucien.xin@gmail.com>
