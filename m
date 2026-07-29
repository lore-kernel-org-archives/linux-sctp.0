Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEC53064B5
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785345430; cv=pass; b=IKBAVA1smGoJ/uiPNZc4njASsWvIjgSy8gj7wt4tlzIZ99/63+TEjRUGoc2+9t14N/X8kcXZaLMjtoHMR83J+eqXlmngeLE7tdCcl1z9mcmCliEU1U/qQTtkOwJLhtKhgvoELJBoMlXhWipQ6oa0isSxKcc2OQFWBP8dJZdQ8NI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785345430; c=relaxed/simple;
	bh=OhmbSmdM0u9DdOQrpt0cd9CMwSU+7fo2RA//JQhrP5I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GCl0XgytkufaoC4nChUVTrd+0j7t8+HLI1IkW0eRzqe2YzVJbZVH0q74eShpsfx/u8TCygK5k0i/u2pFtvt26PKBuVJF/EFk1geDbr9JGdZ9ekt01c6zNPDz5UiRCVHNWGIqdZb63a9I6+61rgKIwiEIhgmXB1p4pafR8FgfcYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BIchv2Af; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIchv2Af"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8486ac3f347so83497b3a.1
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 10:17:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785345428; cv=none;
        d=google.com; s=arc-20260327;
        b=Jp2dTaeHFkKJKsy/a6+7gEPWfnUMt1MZGc4r63LwHR2ov+ejJsIgc9aKadCQ6NJ4uk
         htOuPO9AtgwLvkf3PWvMETDE4VM397N8dXOS4maHdRXnXCrx4UlSk6ifd7zGpknNm+r/
         rMzTC10EcuojI+0f9yv4z1HZU4R5lmbxXvpcQXgyPM4RaOdVUjlaX4JfGRM1YdRYDtk8
         E8ZLahA4PWgSfdKzN0w+kXuIKIoSxRQvou6+PljpTVNDnUxx9I0xt5bripNGAa7HOdRW
         R5zL9WlvJyDUKBar/EypUu0ZEINEHn4jgdY1AkFrEj2qf8VkSYLLDz0ph+ztVl7NaX4/
         GGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=THkS45SRNxVl9I20kniMraMAUjrTFAmlyl7h5NEZIog=;
        fh=xuMiNuJ/0CNFnelqWn5+koKJ7kUvck6aVXsyi3te9rI=;
        b=YiRk/bD1Cv9jjXugh7OH1xjpOmN69Zl31+8B4S5LmmaQtbxFwZvD0oHYIL8mK9aQWJ
         lP2cJ/3QgAqLMb4smyMHdjbmPV1fblJrWnZFmLoWAoENd3cBU65gFgo9iW6RXSitsHKB
         blapYvARXQYfME6aK9urbcbGLVeHzQhgkUWnixNh2o3gV3Dz2DtK2LJjD2fl0SjxPlYw
         HOlrmPjUlSyErWNdR1LNf0NQSegTEAt+GmsSyurOimY+zA4gnZmiPAX94apLdpHufdNg
         HLcHW+n4baqvQ2A6fphwG9qXvU7xcBO9tNvE1mkW+xVpucsrI7ztqmBqZ1hwz5nO0noR
         +lAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785345428; x=1785950228; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=THkS45SRNxVl9I20kniMraMAUjrTFAmlyl7h5NEZIog=;
        b=BIchv2Afs+jkdWlV1UgVEkPeSgbhL3Rd8Eqs/fi4kBZkelKQ04NMg2NWABZ4Hiyl3N
         xadmvaqq9KL03mCuEwyMJoYht37zLohmLPqawc294OLsqy2TCNuLjUGogYLfh96faua3
         lfh8ISf24SdGJ+3mSbzV8qwv/1k9V7DE6rMKaJVs7KJwAl/zMfoANLou5btDQTIgvytr
         RbNYltwmjSmGN8G/kS/LHAV28MR4Tz6cJ9qc9QidZ1RRDTAQdQkJ1Jl3o6qMZiHUiluN
         VbN9dIs+3CkZtQhNsJcwjoqNZ08U0QDDaD6evwrAPYnxSqxu4ZPiA0WMdp4555z2O07O
         uqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785345428; x=1785950228;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=THkS45SRNxVl9I20kniMraMAUjrTFAmlyl7h5NEZIog=;
        b=HMBT/+v6G3qZRuVOH8zyDRMTJadKqer21xDFgB0O3d+tbigg/PCfKzwh74qU9yDP3O
         PQcrHfJsD64LTChsOCSmvGNQs4Qj5Qxdr7ahzcHstJOyJ1f0RGGQ0ZtM5rwCYfBwKL3Z
         5+KKdaBQz5BLXHsrkqOX8bAsGZKeJVS9bQml00HSh/yAyHhA3PfnRNwJkSDDzcLVM1xb
         qLl4+npSX2jdNoR2uSbbDeY7c2gt+biU18kN9h1h4MfnrTXYsHx4UmefBWiNJGNAzNy7
         A0Jovp8Oz646FondDjQ1HsJRR+5Tq8GgGYt0Ftz+I7+aFPg+Mq8JyLFXTiTd8eHCHjZJ
         2wNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOYNowdJwkbhuTWlxMEcS6UB1YDeld+puW6FUjNN/0FAt69F2bFbmJ+eEmzpn2C7517amlR5Tb5Gg4@vger.kernel.org
X-Gm-Message-State: AOJu0YxMTb/CQJHeXlACNTI4whxl/Lp41zt1du6Y4fMHn8kKxKxzpKhn
	2pGz/skmTvm6eLd+q6hQu3aIXoahSuRb/opoEFsRuFAu9WBX+CegI9Apm4WUn1VOFkLcib8AK5P
	WuVuHYYuFhvw2humDwN7QG2CkqS+AlXA=
X-Gm-Gg: AR+sD103VUb0keTNh0BLGPj0ncNxoXSawDMofXf2IGYsWq4z/OTg0lxu+u6s8GeNRE9
	+wtBjm95T4Af4QMWzf7HCQgK07sAN1jH0KtmfhbrNZmnJ3vTKvnipQw2CHeb7JX3nZ/iLevpg9e
	9JfFnj7D+FviXn8/CLraoJpDhSVbRPpg01MUU6545z56PPR4oliYQBHVs+sM4H/76bn4ALebHJM
	FvRao4UDHYStq5L8y8aV9xP6K1ivOpsFJ+kQAhTUgxjy5VsUO0ra8v0p3bP3FrX1Yd2rDdVW02Y
	+kBIz+AEqRW+QVqwFKxgds0CGyF/RvQERNuZDmlhBEo+bctz3SAaMCbDSbY/Q/6OuoFIJfXjozb
	pWa+PNGnX8eC6KvFIUlJkWnkILVDSUKNl+J1mX4BKl8rc
X-Received: by 2002:a05:6a00:240a:b0:836:6f2e:bb6d with SMTP id
 d2e1a72fcca58-84ea7980b0bmr3344957b3a.14.1785345427563; Wed, 29 Jul 2026
 10:17:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729160028.54546-1-baul.lee@xbow.com>
In-Reply-To: <20260729160028.54546-1-baul.lee@xbow.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 29 Jul 2026 13:16:54 -0400
X-Gm-Features: AUfX_mycAA4GRHZLpXxPNLNWzWds11yaKRsmLmnwj2-pURl4kFY9e09gLFpPNa0
Message-ID: <CADvbK_cCCaE3BiGb9cUE1SM8BwJ-vJn+ezRiO1h538OeHyPutA@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: keep chunk->transport in step with the list
 it is queued on
To: Baul Lee <baul.lee@xbow.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 12:00=E2=80=AFPM Baul Lee <baul.lee@xbow.com> wrote=
:
>
> __sctp_outq_flush_rtx() moves a gap-acked chunk onto another transport's
> transmitted list without updating chunk->transport:
>
>         if (chunk->tsn_gap_acked) {
>                 list_move_tail(&chunk->transmitted_list,
>                                &transport->transmitted);
>                 continue;
>         }
>
> The chunk then sits on a live transport's list while chunk->transport sti=
ll
> names a different one.  If that transport is removed - sctp_assoc_rm_peer=
()
> from an ASCONF Delete-IP - sctp_transport_free() RCU-frees it and the chu=
nk
> is left with a dangling pointer.  sctp_assoc_rm_peer() scrubs
> peer->transmitted and asoc->outqueue.out_chunk_list, but the chunk is on
> neither.
>
> The pointer is not followed while tsn_gap_acked is set.  A SACK that
> reneges on the TSN clears the flag, and the next SACK reaches
>
>         tchunk->transport->flight_size -=3D sctp_data_size(tchunk);
>
> inside the freed transport.  KASAN reports a slab-use-after-free read in
> sctp_check_transmitted(), freed from sctp_assoc_rm_peer().  Both the
> removal and the SACKs come from the association peer.
>
> Set chunk->transport at the move.  The ordinary resend path needs nothing=
:
> it reaches its list_move_tail() only after sctp_packet_append_chunk()
> returned SCTP_XMIT_OK, and __sctp_packet_append_chunk() has rebound the
> chunk by then.
>
> Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baul Lee <baul.lee@xbow.com>
> ---
> v3:
>  - drop the redundant assignment on the ordinary resend path (Xin Long)
>  - trim the commit message
>
> v2:
>  - fix the root cause in __sctp_outq_flush_rtx() rather than scrubbing th=
e
>    retransmit queue in sctp_assoc_rm_peer(), which cannot see chunks alre=
ady
>    migrated onto another transport's list
>  - correct the Fixes tag
>
> Link to v1: https://lore.kernel.org/netdev/20260726060453.42730-1-baul.le=
e@xbow.com/
> Link to v2: https://lore.kernel.org/netdev/20260729124929.5885-1-baul.lee=
@xbow.com/
>
>  net/sctp/outqueue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index f6b8c13dafa4..e92fb9da4647 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -650,6 +650,7 @@ static int __sctp_outq_flush_rtx(struct sctp_outq *q,=
 struct sctp_packet *pkt,
>                 if (chunk->tsn_gap_acked) {
>                         list_move_tail(&chunk->transmitted_list,
>                                        &transport->transmitted);
> +                       chunk->transport =3D transport;
>                         continue;
>                 }
>
> --
> 2.53.0
>
Acked-by: Xin Long <lucien.xin@gmail.com>
