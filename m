Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039876;
	b=qnhTPTKH4yICq5C5CV5pPWw1sjPZ6GeT5eZjS62goEdWderO8dUL/unDiHlK8rpzXnk4
	 1bZenJx8fpnabknlA9irbKGwKTxHwA/6BwllYUy2Oou4AIT5ejsBX73+rnOfQXfRU7RZ/
	 CsQoi7Jjxle4e4SBXZ65CxkHC1DN4zCd4NilEOA/Jz3blaAEBuy4W75V5em2I+7KffYGJ
	 9OlAEID0swHwciG4XwZYJYJGF3pJZYcfE3eOHz4PdB2UiqtPMX0s1/ICEuh5NTV7a/s97
	 2Rw7KMyFkJhi6oOjd/K8jW75SBwJ7OWJSP8O/K9sL8fzzxLePEr84RGS+S0smMKjX5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039876;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=bzjwCVP4SEToK/imQer4KQFKqGoTb9aCYir+nCxEg2E=;
	b=ZqITqd+bOkGAm06mX2qM6pZ+zAAFnVbXEQX5gFxWwNamWiyKia9cILqPVL7wubMBmbyt
	 evJ7/yPUvV+UwTvH1e9gkH3IVFQRQF5MpXJu6xFowTkeZH1aXVdcSEYPcgpv3oiLAVEUm
	 Y2sCBCRjAfGbDNDvy5IDtBBItC2+6a8Rd+EAf6GM/Q+QrstpUlrzXoW0mkv3xXu6AnWWv
	 bFINkjhdlxgc6yYknTMFoaw+J6hy/EMmX3hNGHwTAURe/c1c780Vc3B5qov2YmUyxgKBc
	 KnWdBP+lzjbMLfOtkvFQyMa+pGwg3faWStj9i4xCTpALwO31aajpxQxsi00UcITg6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=knHv8aSH;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A699606A334
	for <linux-sctp@vger.kernel.org>; Wed, 18 Nov 2026 22:11:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A699606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=knHv8aSH
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so10380795e9.0
        for <linux-sctp@vger.kernel.org>; Wed, 18 Nov 2026 14:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795039873; x=1795644673; darn=vger.kernel.org;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bzjwCVP4SEToK/imQer4KQFKqGoTb9aCYir+nCxEg2E=;
        b=knHv8aSHZiR2i4XpbS6MAICu4cmODaAXFCmN5MSZDot+rw1cN2qYVjs5fHk1cLAW+r
         9m917eTgv4PP+f249uvlsFkUBYO/ksXafejTCE+2sUzt0ALpnv352ZmmSfmhJzqyrxcA
         PlPmP0m5sC/KO8KAJEEitDrejpfyAyOjd3UvzG1h46iThaRB/bt8j6cdWOLNDBufHxFO
         Z0nLfq/ZgqwsbOF8p8hgOswfaXPR5mbecyV26Es81YLEcJmv7xk7mho83zsMa+PL1mxO
         JM3ot2joemn0JzIxAb+Cbos2aokVUYm6EWHLJWiFA3Yc/iv3C4RQywvUb8GKYUh3PPb4
         /JEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795039873; x=1795644673;
        h=content-type:content-transfer-encoding:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bzjwCVP4SEToK/imQer4KQFKqGoTb9aCYir+nCxEg2E=;
        b=XVw5mFD8VB4gAeNUnCPH51IPUgUaWFTmbJmygcUQqF4Q+DQyqqd5LgE8qDAvnbiG/D
         mOB+aVfuwwreLX+11e127XotwK3J7hTqLbcSEmjUWjNTxgEpG3VqKLnqwk2/Sbkt9NEc
         L6fY4CXHgYmWff811COt7UZHTnO+xJaQZmQknspOUu3PKXoJweF/R2cQihaccq7gYj9b
         zOKTlVuORj78RsTGmTf8sycL35UJgDRHMIkLVSAA1RonRfxjpWn9cX15aSiU1pn6f11j
         Wf6Fpa8Hdq2epZN3XHEQxdvVkuyWlaOAmomiSAiz7Flf6wJKLd68yCETKAVK0O6nZINC
         R39Q==
X-Forwarded-Encrypted: i=1; AL+hErFy7bh0oIEhLKzPtTd9itu1ZcJmyq7exJ72JrJ8npnx/qBR/VBjzjnLx+m+rcjot3jzakMA5ShYf4y9@vger.kernel.org
X-Gm-Message-State: APuU4Z8iK8T162W/C2DzYWWxyqIvdhVLw58B5brYDFxmz2yP2N0R6e4c
	hx5d/Kx2r090b1+nWACiqry8jKtGuS9pMlLe0Bdf05TzB10L3H4l2YOa
X-Gm-Gg: AYBFou1xUJejqU7ZY3pLUQCVAIemxFOOIevpY1ddl8AvUncdgozJli6+So3wdTcf9es
	iQnH3ehyryZ16GiO6YfkU9+LqKA8Kpx9tY9/QWfdn8AprnB4+pXCL7qP+PwWbNYUqSLE5bMlyYl
	IVcbKUSpPXnqoMqaEqkebSzKzJNpqEWKsNPMu5b8rHegtpB2bQSqoMzgsWg6/qVIWEOv1V+eLta
	k962mVIKlO5uiKlS6eecjBkMXcqvN+R3dNql15/s3B9wY3U2/hWApYDH+myDh8zKDIqhQ4d+yab
	UgqaaUt/ha1zZjo/75f9x15cFU0YvTuWkBVtg8M8coqv5XKwfw1K+qdw8WzVZim4tEz+Z7Ok2km
	/Upp5yyL265drELZHv619lSSyCvpkUmDR18UrlCOVfCFe6dIOaTE2PChGGx/CEjNly1z5LLzpAy
	Cg2kygoyHHJqLaz7i5+KJ3SO9X+SGn40XjvJOIMzGD+V3a28JxRTywHyEqaLxn+movNcJ/Fzdub
	MrkrJgpfs+mxwUw26srSguXYkcdhHWUKynjIojH97cjWvz9UXp6Nm+3qUr2jFXi5jTyLuto0n+5
	lqcy7kR4NLUaZdBFvkyiA+RkJCW2DlWbh805U81jewtiq/+KuAPtvAM/8Yfx/pzkUlRXzbQ7ouI
	VLfDs2FBn
X-Received: by 2002:a05:600c:a55:b0:4b1:2026:6b41 with SMTP id 5b1f17b1804b1-4bb7da2bd37mr75678035e9.30.1795039873293;
        Wed, 18 Nov 2026 14:11:13 -0800 (PST)
Received: from archbook.localnet (46-126-188-148.dynamic.hispeed.ch. [46.126.188.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a65499752asm6720364f8f.11.2026.11.18.14.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 14:11:12 -0800 (PST)
From: Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, linux-sctp@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yves Bieri <yves.bieri@theori.io>,
 stable@vger.kernel.org, Yves Bieri <yves.bieri@theori.io>
Subject:
 Re: [PATCH net] sctp: do not free a new asoc peeled off while sendmsg slept
Date: Wed, 18 Nov 2026 23:11:11 +0100
Message-ID: <GldWrQHQT5-PC10gNmItEg@gmail.com>
In-Reply-To: <20261110224233.82977-1-yves.bieri@theori.io>
References: <20261110224233.82977-1-yves.bieri@theori.io>
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Dienstag, 10. November 2026 23:42:33 Mitteleurop=C3=A4ische Normalzeit Y=
ves Bieri wrote:
> When sctp_sendmsg() creates a new association and sending on it fails
> with anything but -ESRCH, it frees the association. The send can
> sleep in sctp_wait_for_sndbuf(), which releases the socket lock, and
> meanwhile another thread can peel the new association off to a new
> socket. The wait then returns -EPIPE, and sctp_sendmsg() frees an
> association that now belongs to the peeled-off socket, without holding
> that socket's lock.
>=20
> If the peeled-off socket frees the association first, e.g. on close(),
> sctp_sendmsg() frees it a second time. Otherwise a syscall running
> concurrently on the peeled-off socket can use it after sctp_sendmsg()
> freed it. Both are reachable by an unprivileged user. The double free
> on net with KASAN:
>=20
>   BUG: KASAN: double-free in sctp_tsnmap_free+0x5c/0x80
>    sctp_association_free+0x1eb/0x750
>    sctp_sendmsg+0x15ff/0x2020
>   Freed by task 836:
>    sctp_association_free+0x1eb/0x750
>    sctp_primitive_ABORT+0x85/0xe0
>    sctp_close+0x22a/0x8d0
>=20
> Commit dfcb9f4f99f1 ("sctp: deny peeloff operation on asocs with threads
> sleeping on it") fixed this double free by denying the peeloff.
> Commit cea0cc80a677 ("sctp: use the right sk after waking up from
> wait_buf sleep") replaced that check, and commit a0ff660058b8 ("sctp:
> return error if the asoc has been peeled off in sctp_wait_for_sndbuf")
> reverted it to return -EPIPE, without restoring the check.
>=20
> Fix this by holding a reference on the new association while sending
> on it, and by freeing it on error only if this socket still owns it.
> asoc->base.sk only changes in sctp_sock_migrate(), which runs with this
> socket locked, so the ownership check is stable. The reference keeps
> the check safe if the new owner frees the association meanwhile.
> Userspace still gets -EPIPE, and the association stays with the socket
> it was peeled off to.
>=20
> This was found by Xint Code, an AI code review agent, and reproduced as
> an unprivileged user on net with KASAN (trace above), without modifying
> the kernel or using error injection. With this patch the sender gets
> -EPIPE and the association keeps working on the peeled-off socket.
> Without a peeloff, a failed send that created the association (EAGAIN,
> EINTR) still frees it, and a peer ABORT while the sender sleeps still
> frees it exactly once. The SCTP selftest sctp_vrf.sh passes. The
> reproducer is available on request.
>=20
> Fixes: a0ff660058b8 ("sctp: return error if the asoc has been peeled off =
in sctp_wait_for_sndbuf")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yves Bieri <yves.bieri@theori.io>
> ---
> Tested on net at b71c101bbb98.
>=20
> The fix and this message were drafted with Claude, and reviewed and
> tested by me.

So instead of sending a v2 after the review comment on the 12th, you
went on a publicity tour that easily identifies this patch[1]? Nice
going. You even left in the same task number as in your redacted
backtrace on your blog post.

[1]: https://xint.io/blog/nginx2root-remote-code-execution#6-analysis-of-th=
e-linux-kernel-lpe-vulnerability-22

>=20
>  net/sctp/socket.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b5a57f6..e7e14a0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2082,10 +2082,20 @@ static int sctp_sendmsg(struct sock *sk, struct m=
sghdr *msg, size_t msg_len)
>  	/* Update snd_info with the asoc */
>  	sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
> =20
> +	/* sctp_sendmsg_to_asoc() may release the socket lock while waiting,
> +	 * and a new asoc can be peeled off to another socket meanwhile.  Hold
> +	 * it, and free it on error only if it is still owned by sk.
> +	 */
> +	if (new)
> +		sctp_association_hold(asoc);
> +
>  	/* Send msg to the asoc */
>  	err =3D sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo);
> -	if (err < 0 && err !=3D -ESRCH && new)
> -		sctp_association_free(asoc);
> +	if (new) {
> +		if (err < 0 && err !=3D -ESRCH && asoc->base.sk =3D=3D sk)
> +			sctp_association_free(asoc);
> +		sctp_association_put(asoc);
> +	}
> =20
>  out_unlock:
>  	release_sock(sk);
>=20
> base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
>=20




