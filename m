Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F0D233946
	for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 15:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784300560; cv=pass; b=OYBLp/T8MbK985UbJEeukIR7AFMYyLZpvj4WxunGKk4+4wYVN+7f+T2l0j83VbH/65E0/OXXmjkg/upMywbWN5YlLkLoeztIofuWJWrcqY4aGxS/l4qbHl4HzIRPjrerM7c/g2EiWywbsavUfutkC1HZk6IJeIlEU5s2lazUHrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784300560; c=relaxed/simple;
	bh=qEEbW5Acjjjf6Q9/Oa8dExLb3VE6TgkjYNNxPelfcwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DutWnxzgzaUx4EMQfqrLUNfW/fpJYtS9KI0wlm+nLX1Z1rWL8MJIwO+EGICPDMAlcgpfwz82ZMFvpk/x6my7luqffCDs2L5EVOt2C4qdKSMvjxiKDC50VHphrFfpP+6lf/rR5uwR0jr0VkGMVz/WbvG6rOejCamwSMXxlsBEQr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDdecdVA; arc=pass smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDdecdVA"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848479c9bd5so3639966b3a.3
        for <linux-sctp@vger.kernel.org>; Fri, 17 Jul 2026 08:02:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784300559; cv=none;
        d=google.com; s=arc-20260327;
        b=WJEIIMt4ozAQ27YlwZZashdkbonaRsO4e9s9NkVN0G8oftqikU927zz+YZ05xX18lz
         p263u0hpV66/mWIZkocDj0nj56qi19eFvbUugazWCsqgQdB9B1XaJk0d1O/h4WrJ7vqn
         gWAyOt1QJBa0nRA1eNo1nxot2/Ty7Q71uxlUwrLAl8g0CAC/Mf9ETyZDqERuiYntazz6
         h9KSynhcxknVAKeEW0e3MHc7qgdxwU0hgdkXV02siq5B8RUs96LXQuUwR3/ufWlZT6YC
         yc4HSwtOaOWwYSJbfbdVVQtRWMjA43NGnntcSVmWN5bQ32RLUon+8bw4jf4WYTzDG0VC
         BKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lsvXjKCWrpF297T2YIQKbIODIw6O/FQfqb+0PfdFweQ=;
        fh=cATaA8f79F/0PBTQsKXRk8Qp14uHsCF870Z84BLE96E=;
        b=F1TSevYVVxsXtdZvidBV+JmT9jK99pPslOCY+Pz9d6YqyXr4I7E0Zw2/7LW3xQhB/0
         FozMrzsog65XJiSYSRSUgXlJxrvYJO04a4Om5eGg7IfBAhrgCPE3dZOJlnNMPXMUG1jx
         VCntS4vSNiP5+54WR4fd9Tuf3HmIdaGQoyOUMN/oQLmthSxFZk3INJzlVRtqqSA0Cc8D
         60oRLhgdw3aklKlFt96Bouj8+TnWhf4OFa/e5nL6P41gX478/IAOMGUMOcJecVLSkTj1
         ULFemDQtzCGvZeUvvJ6qUim7s+6tW6ZAY9CP+jdiufizKHvl9f1bUiJLQe1k2sQ9QUlH
         irjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784300558; x=1784905358; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lsvXjKCWrpF297T2YIQKbIODIw6O/FQfqb+0PfdFweQ=;
        b=EDdecdVArLYAYOav4DcUhtwNlaTsIkRgP+y9F3gMfvXnWX35iDMFvL1GuKeUy/YGS1
         3Ooo0C/yugZvwqiZJi+RM4KvFiULKqcI+MVQ2j/toKicCvqMAJQ4yBrXsi3EL8F6hGAT
         6+X8II4Xqx4cF0CRnZMqkAmj5bAbHOdyOA0xrsG9NBuUCWHOg7cAAyhvPXrg9Um+iyRj
         b/wror0MzYBfrTlAg4TXCF/67PJEaUYVC12mr+vZqWp7PLMIcW0lT1jLWJyc7JcqD21d
         7T8eiclv1zG49f2VloJYNaZx0Q+CZPDeZrzkoLM3LqJTCAHDVuCT0c3GikezC96jXMkd
         WxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784300559; x=1784905359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lsvXjKCWrpF297T2YIQKbIODIw6O/FQfqb+0PfdFweQ=;
        b=ZTWaDXZojrP9xkjTdPQCzmbhN+XuboZJmbveDjZXijG4mjSB+7Vsl2l+8JBjhurtC6
         TSEwPdtSU+PEPE9zXzPFjyM+53ZqGyoemuPhwU2XTldSgvwV7LUKC3lSRpiE82hs3OPR
         yucQdHwVrN+wN29ViooXZaNIds410PFnqGmX+cZZdWsGL6kVAR+0K/5NCxPpCnq26cFZ
         KVOpSvYDSaA4+LxdEAwfFW9Z1xA/5WfNJJOFNS/TWSVWyMM6B9HnR2FElwoparSD6TjT
         mpVm64vztSkuyi6OnHuA5djqVhwoS0MNe5iIXIM5o4pLceFY8DAxSadFFKX3NSfn0wZH
         aLjQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro7L3f1TuqbDxWbWwtG9tLhuNpj6W5m6kSRdIfQKKckm0Ot+kYttBqntyhVhQr/UVN3ksA0O6+HWbHX@vger.kernel.org
X-Gm-Message-State: AOJu0Yzru+NpEGcHCyX07xgrXIP96myD9oh+rg4VOO4igG7GpVW9k9tG
	5ZdeKdiIZeFcewcOA/nApOBiFiYTY8Sc9j2N2Sh7QDJZDI8gJ5aE00r5ksMVH1ePgTKlZ2PVuFs
	AQbVP1g288j1VYEqC9k8g7tR43OMj8s4=
X-Gm-Gg: AfdE7cmGGhxCYIXrtD5gZ384/AntZ1Ls7XfvUN+HGPRuMzblV/b44KBs8XSAgTwXgDe
	k1j/sHhNKq3uYFZ40i9k48j1s3VU5i1kQe2rmX/mLMGZiSyXR5tIrZY4XsFvcfNMmMhA6E1Bjfo
	LdkuVXQfgi5hNl+vG/KyuHGE9ZFHyPpsCplrWB5HWwNeUhDb2UmHjtrH1hk7dxwAQ18XKdHXDDi
	1r2EHdL2XjK4cZnPrzUhpF+CuCqjJK/Is1o5PfleVjLuUiynQA90itt7ffIMmblz4y7lP1swh+S
	SxIDTXtYkJD9vyYv/NbH0VdxUhhlpI7LggCJesYnTU1PoY/3biOlMYzJhoY+KbVBcqw5Hwntuw=
	=
X-Received: by 2002:a05:6a00:139a:b0:847:9315:fb8b with SMTP id
 d2e1a72fcca58-84c2922a528mr3225540b3a.6.1784300558445; Fri, 17 Jul 2026
 08:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260716100407.1490724-1-l1138897701@163.com>
In-Reply-To: <20260716100407.1490724-1-l1138897701@163.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 17 Jul 2026 11:02:27 -0400
X-Gm-Features: AUfX_mzacL41_5RI_8RBYLDXx8x6p-ZqvJM8aDbApEfo8clW9MVUixLT8Q53joM
Message-ID: <CADvbK_e4StN7-vSRjYC_FPMN-_3xjwhCxYUb+Jddz-akO-ryPw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: sctp: socket: Fix uninitialized error on
 socket shutdown
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luoqing@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 16, 2026 at 6:05=E2=80=AFAM luoqing <l1138897701@163.com> wrote=
:
>
> From: luoqing <luoqing@kylinos.cn>
>
> When sctp_skb_recv_datagram() detects sk->sk_shutdown & RCV_SHUTDOWN,
> it breaks out of the loop and returns NULL without setting *err.
> This leaves the error pointer uninitialized or with a stale value,
> which can confuse callers expecting a clean shutdown indication.
>
> Compare with the generic __skb_wait_for_more_packets() in
> net/core/datagram.c which properly handles shutdown by setting *err =3D 0=
.
>
> Fix this by setting *err =3D 0 before breaking when the socket is shut do=
wn,
> indicating an orderly shutdown rather than an error condition.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>
> Signed-off-by: luoqing <luoqing@kylinos.cn>
> ---
>  net/sctp/socket.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..ea7050b27715 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9117,8 +9117,10 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock=
 *sk, int flags, int *err)
>                 if (error)
>                         goto no_packet;
>
> -               if (sk->sk_shutdown & RCV_SHUTDOWN)
> +               if (sk->sk_shutdown & RCV_SHUTDOWN) {
> +                       *err =3D 0;
>                         break;
> +               }
>
>
>                 /* User doesn't want to wait.  */
> --
> 2.25.1
>
This patch doesn't really fix issues, please drop it.

Thanks.
