Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828D946DFE8
	for <linux-sctp@vger.kernel.org>; Tue, 28 Jul 2026 14:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785250507; cv=pass; b=aKpi2o00sZ6lrSdltTUk1vss6opORCKUE51IEEOhd/ltxitxHPkuQwmUqVkGuSgOQneYPDJcYuzwIfy8QIDRURJUdvsk6ishyZ5Hk0qpDEb9IqaET23tAKTHExmiINnI49wlyoSp11zHOnn9ab452f1oC2Gv4woRAk0eUoHCFr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785250507; c=relaxed/simple;
	bh=p4ZS2QnTFpdtxEy/xf7l2zuepNnHiLZl9CMn7GOvXPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a92cqy7421Wjo/JWUCOu5Vk5He78okabOAJBrhZ8wICnwmbSSDgVlGm1zZvdQBaRe9QbazZZbv7GhNiWHSW6SKnXG/+yCwq36+dDRivmYIJc6xyUQMQkdqUJIPCqoxhjW4cYj/YBVXZMHOxL8D9rfBQ+bSpJgfDQChwAGlg3I+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TSRnyLjZ; arc=pass smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TSRnyLjZ"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84a2c90e383so882292b3a.0
        for <linux-sctp@vger.kernel.org>; Tue, 28 Jul 2026 07:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785250505; cv=none;
        d=google.com; s=arc-20260327;
        b=WMoK52n/dJRcq6GM0s5x0/2h5LRjjuoljPO6b4qZzwT0IQFrpfFzMWa9XbOCACnKoF
         RcdmQxbU9AMWx79IFnv74IKDHxVoFQ7iKmYWfCFUIlm2/3gkMWpGbehForI4oUQIgE/G
         0eP6jjEpbkS3V6cKOUFPeXGhD2MFeHu/bYFOeGz71rcg3eaed/fVubavmLGCq7lKQ/ux
         I79sruXUosgyJMKVOYXd79H784n+B92wqXYcDUdBIYtywRlyLwGOlwAfA8UKiZ4jQBnM
         YB5vefS3xz+Q/87D8FJin2BbnOkUqBo9nTB7Q18Oo5HaWeNT2fEZ7xM1Fx5b0pCed2JW
         csYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wnZiRzYZKi9FGvHEmv0/yAIIifQ5Iqwvf7aqNKU+WYI=;
        fh=3rvDYXNb/r65jN5ZlUVVNZgls6nW8RMP05hwkuELuDU=;
        b=YUfgK+rHJ/ngdXUTHWzrR+2W/ddIg77V+7p1TGmqLPBZaUiIskD/vs3/nCc55aRx/M
         IhNTJobmUE6y60SRv0vnis6cCV+l1mfiClY82jFv7zIPUw5huO1mv/UmsQ66TuZ7sYXJ
         uZGXmIZn4xHmuh2BqhlaNnFIOwhCMEeCNFY7b5rM4RJcPUPNX1NTJTnUxxUlRSDaovwo
         KnyAw4S1ZaCHxq0QKAzlYtQrFz4RGVsuGjG+og6CWOyMXL10os9v+zvyi97AxINjlFXh
         dQ8dwstZCt/JGBfgqer3nk5talz2w63UPTGXTyJw8KBzvJ7cncFntj06AevU2faaqc55
         H2EA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785250505; x=1785855305; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wnZiRzYZKi9FGvHEmv0/yAIIifQ5Iqwvf7aqNKU+WYI=;
        b=TSRnyLjZ+xYBoBMy+KO6VVj7+iu27i3jsCc2jsDijMSzbv4440IgWHIYQj1rpFkSMP
         pNXxYrUsg8n+6eKjg72pqcJcLs6NMyebu9PlaRH8VOw4h5E/DhehUFrkYwscysSwwOeV
         l+JsjoTjGc0oLHsiExjKxqi5vCwKhFwb8zDh+y/r5Uy0wuFdHUBvGdRROeFXqCuLixP6
         Xt9JjRsnq4gkIddnSD/GI/CVcdul0LsAXcgl+WNic4hMME5nIdxS41rpdk/N9tyH5J04
         kzn1E4IIqrxQO5WYKpRSMmcUKcyzY9qudDAS+rm4LerICHNxjSCB35FtF4Hm1di2Usft
         uXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785250505; x=1785855305;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wnZiRzYZKi9FGvHEmv0/yAIIifQ5Iqwvf7aqNKU+WYI=;
        b=VOwKH9pgg73L5A7EKdfVjY4sLdo7Xh5Mdhtrmsda0/mRgGx8dBvfurJMCiVFJS48G6
         /E1AdDRNdORMTxyZAbj6nF5YmXSpd1M3Nc7q02rAhwisjv4GLlUJ8ZxvKQMe17xt19xM
         gVs9b0sd2CAlVnDJJa5R5NnyHe0wQSY7IssDxlWdkNE0i4nSjTbqgkNdvXuWZgZnhQX+
         kXk1XTgrLPn00D1TrJOrRzIM6GbcBzF+xz1rcxpHUrNsOqgW3f9twtN+QdeG1SXpQ+8n
         vIKk3+wIjwQ8FrE4UlV+hS+9k0MssjdEWvFG+MOfS87kgeRrsOxDpXDGqzeSHlrcX8LP
         EFJw==
X-Forwarded-Encrypted: i=1; AHgh+RqElswGDMk28KH+pETOfLaMW1EHCufQ3tqmq9gfegI8+uWaxmtbsPCm3+ZlXvX/5yKHlBgtk76RyVQk@vger.kernel.org
X-Gm-Message-State: AOJu0YytGJc+W1suhekA+9frkejIgkoXBePufnsx5WKZHAaZpeLEsIpQ
	JQxKblsKvg7FL7B2WrSJrxqyZHTu3P6v/TTea/ByNMf+RwoqSxN7gLKhLBooBDCnu1x02bxAUGq
	wZxu6XEwPduVdCE/G7PonaXOpMD0+jng=
X-Gm-Gg: AR+sD11dNKtI68A/OFADVIV6YsT8JpPS3lr+spQ/uH8ccAl80Ekcper24BCN91jtmwL
	/UJf4fM/oGAte19VpdjmOBdOYj+AvcIggiv0HcruW5MSwqpn7TZEe6MwDjZpeU57Fr5LG/Hl+jD
	OI8/cgq9EPxCTkMpGrBIl0mviCBpmOIhOblG4kuEyMiGrqUxde0w6ZJYCx43aX78KadtqUzkoFW
	g/xs4YuK20qwtntizNpv4cmRpcW+LOCbfPGJQcVNs0BXKkFDb5LFKC/XuMi73Bwhg2Mo5qWMPL4
	QmokSSzFJMRFUHXiaMp4jW50vfX5ZX47vudnsdhHonJf2RA/c6uqaLJAPcF8jEF30D43wKj3Me3
	NPb/UZMgfIm/AdIiVHg==
X-Received: by 2002:a05:6a00:27a5:b0:848:2f58:e1e9 with SMTP id
 d2e1a72fcca58-84e9329c546mr2926596b3a.36.1785250504812; Tue, 28 Jul 2026
 07:55:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com>
In-Reply-To: <20260727-sctp-adaptation-length-v1-1-0ab58b2810a5@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 28 Jul 2026 10:54:51 -0400
X-Gm-Features: AUfX_mw0BwbrM7UVJQNAz32ePThYFDRt2stVo7wKa45Plugisja7X07u24HlGCs
Message-ID: <CADvbK_esmVbc9hf5ihxkXOGrh=b7=wN2dVKzbnbp2KNH6CGC0w@mail.gmail.com>
Subject: Re: [PATCH net] sctp: validate Adaptation Indication parameter length
To: trilobyte777@gmail.com
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 7:18=E2=80=AFPM Charles Vosburgh via B4 Relay
<devnull+trilobyte777.gmail.com@kernel.org> wrote:
>
> From: Charles Vosburgh <trilobyte777@gmail.com>
>
> The Adaptation Layer Indication parameter contains a fixed 32-bit
> Adaptation Code Point after its parameter header. However,
> sctp_verify_param() accepts a header-only parameter because the generic
> parameter walker only requires the header to be present.
>
> sctp_process_param() then reads adaptation_ind beyond the declared
> parameter. When the malformed parameter is last in an INIT, the read
> starts at the receive skb tail, and the value is copied into the state
> cookie returned in the INIT ACK. This may disclose four receive-buffer
> tail bytes.
>
> Require the declared parameter length to match the fixed structure size
> and abort the association through the existing invalid parameter length
> path otherwise.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Charles Vosburgh <trilobyte777@gmail.com>
> ---
> Runtime-tested against net.git base 53658c6f3682.
>
> The patch passes checkpatch, builds net/sctp/sm_make_chunk.o, completes
> a full x86-64 bzImage build, and rejects the malformed header-only
> Adaptation Indication while preserving the baseline and valid
> eight-byte controls.
> ---
>  net/sctp/sm_make_chunk.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index c02809264075..1f7a097802b4 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2168,7 +2168,13 @@ static enum sctp_ierror sctp_verify_param(struct n=
et *net,
>         case SCTP_PARAM_HEARTBEAT_INFO:
>         case SCTP_PARAM_UNRECOGNIZED_PARAMETERS:
>         case SCTP_PARAM_ECN_CAPABLE:
> +               break;
>         case SCTP_PARAM_ADAPTATION_LAYER_IND:
> +               if (ntohs(param.p->length) !=3D sizeof(*param.aind)) {
> +                       sctp_process_inv_paramlength(asoc, param.p,
> +                                                    chunk, err_chunk);
> +                       retval =3D SCTP_IERROR_ABORT;
> +               }
>                 break;
>
>         case SCTP_PARAM_SUPPORTED_EXT:
>
> ---
> base-commit: 53658c6f3682967a5e76ed4bc7462c4bdcddaec3
> change-id: 20260727-sctp-adaptation-length-aa16536552d0
>
> Best regards,
> --
> Charles Vosburgh <trilobyte777@gmail.com>
>
>

Acked-by: Xin Long <lucien.xin@gmail.com>

Note: case SCTP_PARAM_COOKIE_PRESERVATIVE may have the same problem,
it will be nice if you can confirm it and fix it in another patch.

Thanks.
