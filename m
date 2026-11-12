Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794498980;
	b=OT0v33DmU5ZmJtAVlSL2PTVYdaFHrFOr2qtVzqmxrCvQxp0T5yuTp3a0ggIH3yYnXsr+
	 YkqSA8lDQ8oyHTXrFiy1bccmSHlLSTlQfGLApR+s//VKKrDDGlHgjg1DAR0MFJVUJtx2k
	 yzIV3AMl+9cSk+IOpYAngtHUlldcUIw8N5OT+cxBcKQ6VOp1jbv0t7/ZM7YQsyxf1rii8
	 qzsCkXtSnSr5KvW+ZI64SJEVVXAMnLqmooJ/ww2qgc0EvnRzG3A3/w7UMAgvgP2ydh1I0
	 ANt+kkaGArlLO6iHnNq4h5bMo+GLF7pgW2KI6335j4b6dA6AzFZD+NotK5NFbCUr52Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794498980;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Q6vCcmO9UnueyWU0efgozjB5WIAOqxMCCYGcp8pVZSk=;
	b=g7tECFI7zYxpj0UKYv0CtClsRsSVLwEE0F7bXet9VWvRu8yw/NrVoqmEo1+XWmFjgtKo
	 OuHy1eXQ05qx8VT8BL9rJStgUyiG3FkmQk/K7IGIs7MEH4q726WjAz48ELoDvDzbb3S7V
	 1VNgMapGSGX5IUm0G7JfeZrdzPUvDUGtuLS96tILFHNwHSHO7ZC6wpYXxZ7Kfb+islLrG
	 gk0tVmVhu6Kht32YE18eN1JxMLnarFHlSS88SJLNg+UPM2bOftbO4iCOsP3Ijpc52j3dP
	 jezxOwJKGQ633P/ZCJEwxUwPewq5n75Imv2DUWybGsqaMJvOtfQoQM00YTPG+uOdvMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FMMQwfxn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C0C606A331
	for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 15:56:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01C0C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FMMQwfxn
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so896888b3a.0
        for <linux-sctp@vger.kernel.org>; Thu, 12 Nov 2026 07:56:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794498979; cv=none;
        d=google.com; s=arc-20260327;
        b=EpX2f2AhyhHfVhk7r10nxpXT1OSe0kEcXBI5cZwVvy8JzVM6t37aXjiMGXP4o1uBve
         VIHN0bJ2+QpXBJAvzqul0HqGsCTeYOnFHKfaNwQbZPa6FpQ5qOrkwIpVnlb1P7J6AW50
         rTaPaCUL0UTrPizpblpFA0GmzFZYVVTDNfZh8rcsJKaaMH7pSOHG95aPrUPzWUkbXwyi
         kYnETIqBfxKjwoeM1NyTj8ctiqvnSTEDPoyLj9mA58V7dnAc4MB880vnxw0iw/Yqm23K
         jxcfUNmUsg8qBD089ryOmKIHFbQ6S28Kn5FBe3ZLaytpYmBXq3LJureFJkSTmmYMfIHD
         2VYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q6vCcmO9UnueyWU0efgozjB5WIAOqxMCCYGcp8pVZSk=;
        fh=GJGTeMfsDRQGQXyxNGXreFfhOnP18ruqv5CTVeuIQho=;
        b=I2oA6TnAaRbifQp89VEY7WR9G8jHEHlNQsgyvDc3AL8TzmBGBBN/kgcPSDN7dkASK+
         7o8vRNEMTR7h+I7L1KJuvwJ6TXO1HLB0GAtpXj++lV4sL4G69QrpBK2pOxVAuOBmJ1HV
         BWZ1f4EU1mCCPPeGr4Ug++Hvrjzn/JO8nGYjkyogKvksttC2go5UPUe51lQuLYduWfPL
         ykee+UfLXqL7bwvZwxCC8L+EiZWm2+rQFJdIbUwp/4/gTkYE6GDIrE5KgK0jYLltpZWc
         sxmqXeQ48RQZjA9uYroZcZDkU9WYkc9thkUOFCF2Qm5a0XWPbVqC42oCEyFlm08gVnwp
         tZTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794498979; x=1795103779; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q6vCcmO9UnueyWU0efgozjB5WIAOqxMCCYGcp8pVZSk=;
        b=FMMQwfxnGhQl73SmXTmz3Uz/fR5DEkmGqGslOlDNHRgRQuERn1ilxuNemrRhzkBGqJ
         TC/nbvr3M/UlfSDu0l0pmWhaGHUZQekv6rpZTy/rK6iz00ZHta13GKrHNvKh5xfPuT5g
         I838dUJLIEB3vfrekuxhJlBI1FAwzgFDwVDPJ2h5ZKy4tpyqQv4/yAHUkstGe39jCV+H
         hIZKrD8EB+m1u4yeOLlXftBg2cduPxnDRmRczR9bKcrC8XSO++rYLTPEaF6he/OOqXBJ
         PudvFY1qdb4BbH/1pp3C/xdGCdyusJ5RrMhGcpEQ8k+UxMN+2bJLYbHbn1Nz3ew5b/e0
         8qXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794498979; x=1795103779;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6vCcmO9UnueyWU0efgozjB5WIAOqxMCCYGcp8pVZSk=;
        b=DNU3Mvj0EDwgZd2ZgcoZGdwBsIPKLHyeqvCJvSzm/LWPe7H9o9FbF8iwZ1pRAVPEdg
         zwAq1CnwQOp5bfH47D2/1PL4cZFQ2mFoyYUSbiipLNCia7eJni2CwY1tsqQgq+VlE+MX
         zRvLNtUHAb3SC+2qadeJiiv4UtqV5xS++Prk4D4fQScGK2bf+1e4V774Us2KEVGL1gfc
         ReyU8kVyBnfCy6+p1RpI6ZFx+7FcFY1Z5CMPRbRkk3YLxlp8hcSkNJTcoQxVWzsC20Ly
         pbe6NoIUsEnmL17Oef3BnUwU3miKRHX+LJmB8+60McYwwmH3EvWxbHByeHr9ygz5Xs0s
         AQHw==
X-Forwarded-Encrypted: i=1; AL+hErEqvCZkBF7+C/HorzW/n//KFXgZdntMvhXnl3k9ON1VvEjyXK3KZb5FY78AzXI9BiwSdPpp8TxgGIHr@vger.kernel.org
X-Gm-Message-State: APuU4Z+FPtcJRPyfkGagaKLjX2jVrkInJL/WmwRCUHBHgRM6YAf+F31F
	0zPvKrogUOtzqDIh9uHnzsFVbS+JR+oOvImv635jvWj3uQ3jvp0kQDrytLrB8+TRpBEnA7U7yPQ
	ZwODtlUn7KKvZWZMwBreSCpNb4uEd6Dw=
X-Gm-Gg: AYBFou1jyZF6zKks5vzOxW/Foaoq48wpo8mto6CFPnVRJAB16mlW0V7Jv0c5OrU6HsI
	g6C/JMSJCmNlHZv1Gv69aaydZk/8IXBtD5GeErOuVib7UFa5ebm07BvYeE97xyN7Qnyu7nJeFFT
	4XhaA/QL/jqEOq0ZpBKI8Ho3swMCke56sj1Bi0C6MLmIJo0jkQZYxy9Dghm3HY8onTcNllLL7JD
	ZlCwY3T39eGAaS1+ms+KpEMP2Wbu24FWOtX0Bt1sH03QpfdPqoNg7sTWoq1oiiaQ1awNkynwWSn
	aL3Xw/FH3Gw0rLXLl7LGClEbFVnoiY32Z1IU/JGdC4ALl6g2ZqCgcvHXGoHB7Yidr38u4jQvGc+
	GZZUPRTidvtsDZMJsHobV8cpABjoIw8M8dd6mFe5MSBxcIh7c0SQTL4etrSazDOLGqddLQ6AsN+
	5XdeQgLCvnpTt10FfzaVqIFocGUfM64paiSq1NFQ==
X-Received: by 2002:a05:6a00:13a9:b0:8a5:7006:1ecf with SMTP id
 d2e1a72fcca58-8bc1ca74f3dmr6405399b3a.39.1794498979018; Thu, 12 Nov 2026
 07:56:19 -0800 (PST)
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110224233.82977-1-yves.bieri@theori.io>
In-Reply-To: <20261110224233.82977-1-yves.bieri@theori.io>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Nov 2026 10:56:07 -0500
X-Gm-Features: AclHuK-WWnb_Avs24C603cZWJLj9kdWOrIpfiyA-Mg7U4Ik96B8IwVtXOHQS-lI
Message-ID: <CADvbK_edbUYvFXPGJzRspdG+RpV4ZnfP_WwuS4e4_sS2kbDAZw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: do not free a new asoc peeled off while sendmsg slept
To: Yves Bieri <yves.bieri@theori.io>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 5:42=E2=80=AFPM Yves Bieri <yves.bieri@theori.io> w=
rote:
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
> Tested on net at b71c101bbb98.
>
> The fix and this message were drafted with Claude, and reviewed and
> tested by me.
>
>  net/sctp/socket.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index b5a57f6..e7e14a0 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -2082,10 +2082,20 @@ static int sctp_sendmsg(struct sock *sk, struct m=
sghdr *msg, size_t msg_len)
>         /* Update snd_info with the asoc */
>         sctp_sendmsg_update_sinfo(asoc, sinfo, &cmsgs);
>
> +       /* sctp_sendmsg_to_asoc() may release the socket lock while waiti=
ng,
> +        * and a new asoc can be peeled off to another socket meanwhile. =
 Hold
> +        * it, and free it on error only if it is still owned by sk.
> +        */
> +       if (new)
> +               sctp_association_hold(asoc);
> +
It doesn't look nice to add another 'if (new)' check. Can you move
this 'sctp_association_hold(asoc);' to after new =3D true; line?

Thanks.


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
