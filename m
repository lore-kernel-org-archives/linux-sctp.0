Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795192668;
	b=C6zEokQHecp57JR9zsKAgCjAbBgIWVwic3ULG1frHQIAP+qgWpgmb3BZ8ZAzSJRcHZmE
	 9c0wYfwybu/KQtsrYqDvysgdDyxK8JWUt+ghEkeZ4BFzvt/IIj2hmssCczfpiajnThrf7
	 tcTD/4UdYu8XCmHUoziK4igQyQjESidwdr0i/q+CqEV8N23Rdu1JxVDzS41RENdZtPmwH
	 8Qki0yi/jYx8mepuQusxa5ISy34aPoNftU3CixzavaAyg8Hn6Wkpwuwmzubybk2fmPGRH
	 9NQcpIgKEUNrCbPx2AIcoaTXcCXYQ/iAKKcloUkQcC/1WIoCCo2rxBp9Li+qmGq/nYw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795192668;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=8gVVdRXDHaBUhqI8CsaDjorE6ggyqAZgC0sVv6G0dYk=;
	b=HuvkBjMloGgBOD6IIAYomiCzpvNX6V5iu0n694XMLxDSXB0AoY4Vi+TknWG3EcEkWP4A
	 yqDp4r+L3jhrEnpHMhlsuY1fp8xyVn8K+NrUndQsnge45CpvpLfDEifPCX343ovzBRItu
	 T4wAHqQm9ecA92ZGfPlDsPBQ/rZ52ux5eCpdzE+E8VhzdYuUbrcgsEZyUBfQTxWkECz7c
	 VHgXrShiHhh2bIwGueYVb/qOpqcAi5VjAMRiqtGqPct5YW3lP20OECr/SGMFaWgur9pcg
	 ucTtf18oBuJVJNQ/aQ1SGSazWXYv8S0gNOpR8xMkD5Wb00E6byYvaeQanNxbtJPx8Wg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOiu824+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54843606A331
	for <linux-sctp@vger.kernel.org>; Fri, 20 Nov 2026 16:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54843606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZOiu824+
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so790980b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 20 Nov 2026 08:37:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795192667; cv=none;
        d=google.com; s=arc-20260327;
        b=SEE00xNblY8ip/cRB36qOPwlBb6PzhMz9xpwpOa/EzDi74iGkr1qUuk6DB/4VjkzBJ
         3Vf07UUCMyb7gYy3+Cd51xYrT013bGMSLmfpImRX/vqut6mRw+MmpnvlYtPIn9ceqw8I
         KXMzI3/cLN8TfNMHtaWAOKMPoVuLIuSUNuDgxKnaACJcXtgIpXm0mgOqS9Nx3EAhrhhM
         g+sS9BhDtwzkL4Grtw5pMnI0dqt+3bGzEZpLR0CL9X27qA4RqoLUmBBvru3jLfk4tPRF
         U0EBS7Lrb+1DJUCTqg88wavapRO1mNP3Dpdg4Ob/ie+N9a7VvBk9Fk2ehKiLOgryzxWm
         m4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8gVVdRXDHaBUhqI8CsaDjorE6ggyqAZgC0sVv6G0dYk=;
        fh=QFZ1e8GM7UjkBNgxSGNNJdK67lx182/6umsDQPm1GWY=;
        b=Ka18CGp0nfK95DK/eFXUWGNEomn3Nb4HE6xnrGkRebzwAwvaa4qBc4+oxNOsepLZKC
         WmrvayDqBX3O/dSFj5x+SRXSxSESjTfyc7fKx7yE29YxjAsLUQFlom95tYvs1ELapvII
         sEuUrgqg2IEoC54q5u/Onx+ui0bDXHybX76Zgzry674mmzdjtnJt15zdskYpvcBLoU8f
         PZ1YGaIfalAmKNxHV7qNB2W7Mxev2zIyILD1Vwgnt7AwiUbIXGqRvq5D+6SroVq3ZkWf
         GVgkScTPgg5OO5fjspBepEOQ7fZi/dEaL1GQVDXtXKFeeF1vFCVz0+lGGKn+ODzOx7LC
         7dYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795192667; x=1795797467; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8gVVdRXDHaBUhqI8CsaDjorE6ggyqAZgC0sVv6G0dYk=;
        b=ZOiu824+Qzybi4tCeLzrG2HfbR7LqOAvhjxtrLtycpDDlq5EvcJyn4toRCyBscyObG
         2F3FyeyAse5cYOzzflbdnEcBAXNCHUklhH0M3CNUJAJBrGiheGthMtGLB+4AzMK7voLO
         3PNSaKexaTcyBJ9ErwP0nWqVCqJK9Ai9tuRUpEKVZ3UGeYWKQsG/09x3la4TqHdesoHm
         N+BqgDqothmocsIqqDFAcl0OcZpKk9P6XH99DiiPzydVWtUDABK982SCGULWGF/s6B5C
         VPAUJhGNRfpKZg8aLC3X87wtQ7eL1lmIEUl50SFmUp+DbAGAyoKjf/abnBqXwUaKPuZD
         srEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795192667; x=1795797467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gVVdRXDHaBUhqI8CsaDjorE6ggyqAZgC0sVv6G0dYk=;
        b=1TS3DFCcnPIfg8Zw25iFfvXF+mMCo5/FbMHLUrjpOL5/6NFKs0wNsiQy1jzILR0rML
         CDrlBamNEYnJMnTFcpaj1eIAMx/tUbRup8eTpMPrJ7r2wT21EyCEim0edCvOASaiGM1q
         BZ2IMlRXcNrIOrzB5rJxojQkHIu21+JBdlqVZDt0Eyt58TdCrL7pFEmqPP8SKpnph1uP
         JhnzeTJ1FxuyEwnnvffbjcpWIGKGofwp8lr+G/JNOiKAeZE/AerlPt4DbbNfYcmWYJ3s
         UJDcg5CifmEHMmGm9HI9iXvK882tg9mBEpoMdirLIVPwPCUm/IrjpCOrzMG70CWjEtsi
         mVig==
X-Forwarded-Encrypted: i=1; AL+hErFceRDPp/Vm6O5fZDSJIdwZl14HlQUw8XGkHl/oh7xJ1A2fqwzJvRB0T+yHZroacGQwJ0RC6ms6G5CI@vger.kernel.org
X-Gm-Message-State: APuU4Z+yN0BVSnGazxYt8F+kQ9DBAwBXEbW93Zez7IoOeVwAXxMISoaZ
	4YscQBGPhpL3HAdACqQe7G47z/Vpgp4y938xiEaefUz+m4m+lbLH3odtwhNuqbgviojT/ihL0Kg
	ebfdGRXoPkrnQOmzRU/Ew/xIZBIN9r/0=
X-Gm-Gg: AZFdTZfWMuK6GxeOM1V/bW3wWJN0Gaw+GiKgjo1xhrw4OHUVkrJU7mJWDLY0Tb+A/Sl
	LpbAV0YeZzR52bR0UVtel/CvDU0netY9tjKcxIQRZ03CLbfiTTJob+Ez08cwLAozlyx/vuLCkin
	+qFZxDSJwDskBWbZdUDYJsxcba1dwHrnjZKZArqrKJs1yr8FOmqjclNSfSMDEzGm6aaMu2mVX0c
	LfEve+6x03oNeZ62k4uvKouXZX2KPYjy9QxiHsNqJjYMWd1IIpCY2+hxDXMnP3quclcIFn8kBeV
	wzzbiJLcX2TxUs6aXJaA7HCLoIfjDiJA0exoNlSthN8eUI6Suc4118eyI9VUiMpkPtpZpDNDgej
	UuaICtDEG/l34Z7HnD45XU5ge5JX8UYS5jrXoF9SPUt9I2AaIVKWJ7BThT4koFEUOD+x+Aj4bsP
	gD52C4Y9842PVMg7Zs3oKxGmYTdHn2PtT990txrQ==
X-Received: by 2002:a05:6a00:2987:b0:8b6:3e44:8aaf with SMTP id
 d2e1a72fcca58-8c87b4ee9c0mr3361079b3a.20.1795192666568; Fri, 20 Nov 2026
 08:37:46 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120050108.426545-1-xuehaolin@uniontech.com>
In-Reply-To: <20261120050108.426545-1-xuehaolin@uniontech.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 20 Nov 2026 11:37:34 -0500
X-Gm-Features: Aa3M54qNypMyBmyBYevUfk0cK2R-oXwezfsszARlwdxXW7NeEApwkkiP6N3Sz0g
Message-ID: <CADvbK_fKB1P4c3KkZobQwGc84snyZG-b7NYXi7xPwN04ojcW9g@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix race between sctp_sendmsg free path and peeloff
To: Xue Haolin <xuehaolin@uniontech.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 20, 2026 at 12:01=E2=80=AFAM Xue Haolin <xuehaolin@uniontech.co=
m> wrote:
>
> From: Haolin Xue <xuehaolin@uniontech.com>
>
> sctp_sendmsg_to_asoc() may release the socket lock while waiting for
> sndbuf space (sctp_wait_for_sndbuf) or connection establishment
> (sctp_wait_for_connect).  During this window, another thread can peel
> off the association to a new socket via getsockopt(SCTP_SOCKOPT_PEELOFF),
> which migrates the association by setting asoc->base.sk to the new
> socket and moving it to the new endpoint's association list.
>
> When the waiting thread resumes, sctp_wait_for_sndbuf() detects the
> migration (sk !=3D asoc->base.sk) and returns -EPIPE.  However,
> sctp_sendmsg() still calls sctp_association_free() on the migrated
> association when err < 0 && err !=3D -ESRCH && new.  This frees an
> association that is now owned by the new socket, leading to a
> use-after-free or double-free.
>
> The connect-wait variant was fixed in commit f14fe6395a8b ("sctp: fix
> race between sctp_wait_for_connect and peeloff") by adding the same
> sk !=3D asoc->base.sk check that sctp_wait_for_sndbuf already has.  This
> patch applies the analogous fix on the caller side: guard the
> sctp_association_free() call with asoc->base.sk =3D=3D sk, and hold an
> extra reference across the guard check so the association memory
> remains valid even if the new socket is closed concurrently.
>
> Note that the sndbuf variant of this window predates the connect
> variant: the unguarded sctp_association_free() in the sendmsg error
> path existed before the sctp_sendmsg_to_asoc() refactor, and the
> sctp_wait_for_sndbuf() sk revalidation check was already present in
> v4.14.  The Fixes tag targets the refactor commit because that is
> where the current code structure (sendmsg calling sendmsg_to_asoc
> which sleeps) was introduced; earlier kernels have the same race in
> a slightly different code layout.
>
> Discovered by manual code inspection, following the public report of
> the SCTP local privilege escalation (Xint "NGINX2Root", 2026-11-18).
> The issue was not triggered here and the fix has not been tested
> against a reproducer; compile-tested only (make M=3Dnet/sctp).
>
> Fixes: f84af33138a8 ("sctp: factor out sctp_sendmsg_to_asoc from sctp_sen=
dmsg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haolin Xue <xuehaolin@uniontech.com>
> ---
>  net/sctp/socket.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b5a57f61ee6d..0039c54a55d6 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2082,10 +2082,29 @@ static int sctp_sendmsg(struct sock *sk, struct m=
sghdr *msg, size_t msg_len)
>         /* Update snd_info with the asoc */
>         sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
>
> -       /* Send msg to the asoc */
> +       /* Send msg to the asoc.
> +        * Hold an extra reference for newly created associations so the
> +        * memory stays alive across the migration check below; see comme=
nt.
> +        */
> +       if (new)
> +               sctp_association_hold(asoc);
>         err =3D sctp_sendmsg_to_asoc(asoc, msg, msg_len, transport, sinfo=
);
> -       if (err < 0 && err !=3D -ESRCH && new)
> -               sctp_association_free(asoc);
> +       if (err < 0 && err !=3D -ESRCH && new) {
> +               /* sctp_sendmsg_to_asoc() may have released the socket lo=
ck
> +                * while waiting for sndbuf or connect, during which the =
newly
> +                * created association could have been peeled off to anot=
her
> +                * socket.  The hold above keeps the association memory a=
live
> +                * across this check.  If the association was migrated,
> +                * asoc->base.sk no longer matches @sk and the associatio=
n is
> +                * now owned by the new socket; freeing it here would lea=
ve
> +                * the new socket referencing freed memory (use-after-fre=
e /
> +                * double-free).
> +                */
> +               if (asoc->base.sk =3D=3D sk)
> +                       sctp_association_free(asoc);
> +       }
> +       if (new)
> +               sctp_association_put(asoc);
>
>  out_unlock:
>         release_sock(sk);
> --
> 2.43.0
>

I think this is a dup of
https://lore.kernel.org/netdev/20261112172149.27355-1-yves.bieri@theori.io/

Thanks.
