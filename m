Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E0B42464A
	for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208725; cv=pass; b=aXOhyR3xw+K42nLIJTK4+tgSLl1J/zi9wmLU9TWyVMer8DggD/ymujyIsf0l8NzxhoNH7UsWxTPtVjDGiRPaE7zcVXZswWjIpWwBu+489ROOKSqfmBsLH8N4Nby79mTvAAyZc8hVzBvYLt/BjESe4kGidhgo+ulGqumGbFfbcGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208725; c=relaxed/simple;
	bh=WUOL/WHziYXuwjEH8wV6S0ndVw9mg6KTRcK5kUefc80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ChZ3Y8Stm91DnWNrlK09iFSGB8RHeGjvdedcXvvqZq/gvHPdVrzytOUyAJx9NNRKbMU4+9Kd+6B9rct/5FmHq3DDGR4dV+6PKEuc4gDiC2mjB/mfYjrAnhIEYNsT90JpSas/0ArADWl6PZw933J/72paR9Hhdbn+oVerH7G8znI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9/AcyAE; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9/AcyAE"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-845b6d9bf39so589933b3a.1
        for <linux-sctp@vger.kernel.org>; Thu, 16 Jul 2026 06:32:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784208722; cv=none;
        d=google.com; s=arc-20260327;
        b=dAeKLuWPoUbp1hYgS69vF+Oczu0Rpymb9WIgjP0TuxPUPcBwpG86hEHbqyUMJ8jwp8
         SYnLXzihgY3Bzl3yujJ4CMSHFg5u09CwUOOl2al63mepYaTnpI4Aq3eGhnHrT5V9A3fU
         bDC4CDb0yoBySst+EfyBCRqMJmkCwKSSHn3fJRgK5CrD0Q80Ftj4kdaETDgRbEVtY3rT
         a7m1adg9J1kht5Bppb4FtAi2MTeFLeBRQDg9pUzZfNkbdkpqrDwTFhnS2SOvgW9FO209
         d8v36Q5tPu8+9NjS6BiLdTL9ZyS8iN+FhQVnE1st2Djf6FnWnn9anCkEaEqUtl1Uv+bQ
         OjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uGHHs+3P3MchxCub/aaBCj8RgZEQL9E4cXnFGeoA6bg=;
        fh=1HThs3M8Odt4AmaMv+Inw5eFIR8fTMoNhoo1C/4ea7I=;
        b=okAJqpnbxGj9rhlZq1Wmivh027GWbDGBGugFK9jDSxHcPxkegGMWgQVjB3f1g/8+h4
         cjR3YEvI6j78w+NqswxMvbNzVXm9mPCySHiLxmHSNwuiHsvmYsynZokewiWePybHVNWR
         Isqowu3J1OUe22Rdv3UhJ+bVyDGSA+NR0QzLkpMTiUyP6UOlO7LoJEyOy7HDdACZqOxJ
         IaL35kHChtqRMWo48LnueqUnrto5ExUQ+d/pAZlxNOfqG3OX4nI+gpNtWlIQ6Sat4lS0
         x7pjSIu6f5p+6FdKH7lAHttCY1XjdFRrQRbnd46S+15Rvq7MsCoy3MSkfd1StmL1AmIu
         8VVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784208722; x=1784813522; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uGHHs+3P3MchxCub/aaBCj8RgZEQL9E4cXnFGeoA6bg=;
        b=K9/AcyAEB1Q14M4Pe6qjpaNzcqri01mYzFB/483wa6QuDPEssRteeDeU423K3sF9Rv
         m5EH35S3RygviApYJmnS8sqgzBhxj+NP5H/brmtB08RW45KTC5K5mit01hYE8BDS9xYR
         fPdntY1BPl/Mwf4Rq+jMWnEP4+tgxLYf9vqRajfpa1kzP+SYeiMrisu4jMWDfTE2sBoW
         Pg1dNbwuX6siRHrrjj/lCIwwHIFsLKBXHhc7ZntsmqCqgDp0L4Zz7WPitn6H0B8MumyY
         CocvTzmIoA5CZ/XB+BIlK8lZU9UeD9HUqV8l8NVbgCmlSQLBFI3ClZxvQWcsAizT0hes
         wHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208722; x=1784813522;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uGHHs+3P3MchxCub/aaBCj8RgZEQL9E4cXnFGeoA6bg=;
        b=pHuNSGUas2+BwiCSqrRV5NHIWn0iDnkLUK6BOFo16B2lxMZNACVqmCoTvJlsOCDlgt
         x+8NjKep7Xd2bJOasd2M9gGuUTAZW6/TWIldUO93BtJDti/fLWRv8D99Wvak77I9UyxI
         pmn2p8a6HHC8S5J7UxktXliBPUi4SMfwuBxPb6BgcLaS4U1Tj0UzfcYQdWom7jq8TtuC
         +0lVLZD1DNccNGPWoDaJVrZyiWYlpMKSGVq0edTX8NCoju9WiCOyXKhg9shJdiXDKvGc
         EaVeaPBccag6RTt7hR0MrnK+Wbn/G0E1aU6eZNkraErr99IP7drq51UxPxkUmecACyel
         Nt0w==
X-Gm-Message-State: AOJu0YxISXli4xQOq0ERW3H0n9NpOxmwxMOVzumyhYBCFXOdA5ff8BdB
	zF/jeRbGr9AC+/hIyuCqi885VrupPsG3/sLhdt0Yev/Ncn7zLZNlBQTPF2dJ7xU5JOg6//xBRX0
	sNUwv0Edva5HYJtGpPrVu8Mbf8tn/rTs=
X-Gm-Gg: AfdE7ckcxnGdm7CN1sgyXU/j+OlIEtHM82RLDXUnGxij8UryCS9PfdBdROvqW+Y9gYX
	9ppyCRqOHLADZVhUSzKJgSBtQWohDu7O5ZhIu4WZjcPfJaLRq1DY85MvGSV3biEgLeonEzHVnOh
	0De6OThFkNPBdcC6VWGiMbugKcxCDKVwWRWieKqRpmbNaKqNpDkE6jrPfsMVsN+SrXpMjLIYSzA
	CLzhbuXnVo955tc+dxvCWo+8ae1jo4QSReWB7uV2Bi5VHUL7cvkYbnHKP29GfK33oG+gAWW0h0u
	sB8M3ycEb6M+yNDHfrz8MlzXwJfKdUDEIrme742wkBG3d/NSPJkfLuJNwNGnT7JM945/K6iuQkn
	dMCO8TyYlPeZ5lMdWlQ==
X-Received: by 2002:a05:6a00:3395:b0:84c:145e:16b9 with SMTP id
 d2e1a72fcca58-84c145e1962mr1192249b3a.18.1784208721955; Thu, 16 Jul 2026
 06:32:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784033357.git.roxy520tt@gmail.com> <6dab75f22855cb219e2e30a5497cab03b970ab91.1784033357.git.roxy520tt@gmail.com>
In-Reply-To: <6dab75f22855cb219e2e30a5497cab03b970ab91.1784033357.git.roxy520tt@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 16 Jul 2026 09:31:49 -0400
X-Gm-Features: AUfX_mwOBQMoPqGjbTFM1fZ1OwpwLVzxnWM0VPUPUABy_qo90EifY-WiIpJMFQw
Message-ID: <CADvbK_c7ZimrdY=yf+7jGzLTN6ZOT+-4_LzQxAg9-fEostzDtQ@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] sctp: close UDP tunnel sockets during netns teardown
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	marcelo.leitner@gmail.com, davem@davemloft.net, edumazet@google.com, 
	pabeni@redhat.com, horms@kernel.org, matttbe@kernel.org, yuantan098@gmail.com, 
	yifanwucs@gmail.com, tomapufckgml@gmail.com, bird@lzu.edu.cn, 
	tpluszz77@gmail.com, roxy520tt@gmail.com, sashiko-bot@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 14, 2026 at 9:51=E2=80=AFPM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Zhiling Zou <roxy520tt@gmail.com>
>
> proc_sctp_do_udp_port() starts per-net SCTP UDP tunneling sockets when
> net.sctp.udp_port is set, and stops/restarts them when the sysctl value
> changes. The netns exit path does not stop these sockets, so a namespace
> can be torn down while its SCTP UDP tunnel sockets are still installed.
>
> Close the UDP tunnel sockets from sctp_ctrlsock_exit() after unregisterin=
g
> the per-net sysctl table. This prevents new sysctl writes from racing in
> while the sockets are being released, and closes the sockets before the
> control socket is destroyed.
>
> Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/b9f1f02b0780ad6a719e2413f5f0bb8eb7=
702d94.1782585631.git.roxy520tt%40gmail.com
> Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> ---
> Changes in v3:
> - No code changes.
>
>  net/sctp/protocol.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index 49d9740b1e0f..27c26e12f95d 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1460,6 +1460,7 @@ static int __net_init sctp_ctrlsock_init(struct net=
 *net)
>  static void __net_exit sctp_ctrlsock_exit(struct net *net)
>  {
>         sctp_sysctl_net_unregister(net);
> +       sctp_udp_sock_stop(net);
>
>         /* Free the control endpoint.  */
>         inet_ctl_sock_destroy(net->sctp.ctl_sock);
> --
> 2.43.0
>
Acked-by: Xin Long <lucien.xin@gmail.com>
