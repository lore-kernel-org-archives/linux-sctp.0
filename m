Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DFD34404A
	for <linux-sctp@vger.kernel.org>; Mon, 27 Jul 2026 01:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785117290; cv=pass; b=O7HyGAtFPhynDnU9I/QLpyJK2LyiIkk/eYcm/KKq2AFYO0DVz4UWDG5GIXoH1JiVQAc8UAGH+JAzWMW0hJpPNypakCi19OYCAtM4xOfPigNP2kr/3cCcAbcNQyJ1AC0yfO1uL18YQEQuo+qhgpBa9VmwfEHzyYcNYCpm+PtsuuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785117290; c=relaxed/simple;
	bh=rtmriYEiiXh9AiGf/ImslMhlbJqXEvvwuLm05PxWEhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eETzpT11fuE8Idn0RS/6Yl4gydNKViCPcFR1pbQAbemefNzGKs9hmbBvL72sqNkExR6XIi+coQHSHDtg07YGuqgI842fSw/xNHr4hvjaM149RR31mne3ThN4ZP4mHZ4IkF8gntJihmT7qTwbhSSaSOXyIMbnBsbx1sA/0rsG3qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qf/KhVGI; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qf/KhVGI"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84874b52eabso2936035b3a.0
        for <linux-sctp@vger.kernel.org>; Sun, 26 Jul 2026 18:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785117289; cv=none;
        d=google.com; s=arc-20260327;
        b=RBYfyitsz/ZHAllRHp90VGpm7kSVuMTJpU183EAK+dOyH1D/mZkwQSsg1EU54hn952
         zjZoEfYH0dCmxhQNT/a6fc/RzjqEioXpDuaJDK4ezQNFDIDBq0ZnrHf3brHLWkqAvAFd
         eC63oFTaNfkEm0zRlb5vChkYDiukPbtZmFXkyvUHc+LHixVm5JciQ6dZVr7+YaHYLRe0
         149+Cuj5rWOMF2opy6oWe9HSSro7CLLJQX7tGZsYuqZHvhtOJf2SM0UuPpX8sS3UKrCx
         DbWo8NEFkyoSdOFyKwLA1jMkVD57da//zw7O4SwzLDbIFG1wumSdLGeA53pmO9r2/kh6
         29vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ecSEh+Y8e2yI7Di008PFhEfYZS8V17bShnvXF3pJHY=;
        fh=6ul/xO1tToXCO7FsWPPBz3ncP9ff/c021OIUWIl0LgA=;
        b=TlI7kUHMuvM56HKPZJzk99N28NdJnKBZioaDOlloB5vBcMZCb2AAMyR9AEjpCSP1U6
         mRKVceDMP0gjwzmqEpUmujhQ11q+9BEMpb1e4SsKEMXK4DBi+AY1InWB5S9iBcR8+pBL
         B/T58J9+qe+8BaFhQyFuOxVJWM3QWsqLsLqvJ4DG3XswquAvJifpTxxfprWOoiqFGNII
         jP1YwABO+wmDc/ev1AvqEXxJJmHHCTGLxNTbUDjzFm+qRgHtRTXeVSyHQ6K1d2KUoHS7
         eVphEcOcxTmMtLwoEucBMmRe39KmxOtnzUZ225v9PKcJIxB3JEdHnhm69UynXqt17+iv
         q6Rg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785117289; x=1785722089; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7ecSEh+Y8e2yI7Di008PFhEfYZS8V17bShnvXF3pJHY=;
        b=Qf/KhVGItvadUqJWNk5XSKVNAtT2pGPcWJz6OTSgezZUOe2ymIdwFH0CCR0U8U9HRd
         f26iuBjOHvifrwWzonhQoOCPjhMFtUXULrxzoxgKupu7mWh6WDCa/0kbKuV7cc1XrbWa
         2I5N8zOBHgKcOJ/HixIitwBPfWDVkk5qugHBZyx+8gzn4vCZDfq+qdhezAa89vInG6EJ
         zF757IhshgukK1UGiOB73aQXyl/HxOASEcVlf4VA43OMrKKHxD9VfWeZ8fH3S//Ab2hK
         HITlYKo4R7alaEY9JtoE3jzfbEly++sFBbua+pdYMgczCtPo2jA4b0q2KsehFxzuzNza
         xgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785117289; x=1785722089;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ecSEh+Y8e2yI7Di008PFhEfYZS8V17bShnvXF3pJHY=;
        b=ibkIl4Ik/TDMkuPV9jEOKlDmyauAK+7V5z5m7vSHlwWCfONpYyTMoTc18QEMn6kEL2
         hx/SKEp1/Kl1QqE+V1BvLDbK+e0Smf7yI54ZkF+ed6Kyxr/2f8aqEgfguznm9Q3Em2X1
         JFdgWrCqc6v7qf3bq5BwD3QqMF0uSme3Qht8XnqlYqSrEA1XjUf6Ujj8GImSyZm3woyD
         3ympWrXCp7K2oHQLehuaxCrEfjaF97DOoripvUBmfU0EjH3MCX6cCTqwBb3XQtV1Tu0J
         +gd6xpxRbzSEpq/L32GyQT8PfZ6asjYfs23W/f74/jOA5MMSv35fn6Opv4jegxENFYsz
         F7WA==
X-Forwarded-Encrypted: i=1; AHgh+RqKGfDrlnnzRFhfNxFeFl8D38JBXnqI3qfXYx4iHbH1+Qh1yThDXw5WWK7vS7uTkg5oX+EBJOc9GrND@vger.kernel.org
X-Gm-Message-State: AOJu0YyQBs12l1+GXDRYYtmLGV96cKxxRmCczG0niyXM+KmpWK+6OBeb
	nEBEMcOah270qXq0lBCldlhcRVVEI8/pEGHu5xhYNVomtnjEIs2TKaFnxv9203GOv9aHp9THdcU
	XyuhDVsMUhSuq5U2P6aFkeoJ95hcXd9I=
X-Gm-Gg: AR+sD10gS+OV/fqP/8JtfkxdZCKhIPXiPQjOCG1IvgTccdUysBgGJf/7z1A+a52GQut
	/Z0olYwJa+FDdK8CT0Rnf5snMOO+LJtLNoZcSZ0TCmnhCfoCMcFbSsEaYQYfDx6aU/Kssd3QR+u
	7VL066vpgS4yY++CKnWGfR+/0d15oP04b4YEZguF3ESWU/mpQydMTYC2kFv3PZzAbWp9xqReS5e
	mqxVJWas56jjQj0nriRliePslx0y9tW2L21Epr5FFMPoYFB7dRlg10hBTPnQaHH8VldP6HPnWQm
	8otk+NepfcTWwmElxS+LmtfGNXZ7hC6Xj4OG1vppyntZ7vqOK4QszRZlxa4qGQ==
X-Received: by 2002:a05:6a00:1947:b0:848:6895:b754 with SMTP id
 d2e1a72fcca58-84e5946ff2amr5220235b3a.28.1785117288699; Sun, 26 Jul 2026
 18:54:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260725032053.521705-1-manizada@pm.me>
In-Reply-To: <20260725032053.521705-1-manizada@pm.me>
From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 26 Jul 2026 21:54:37 -0400
X-Gm-Features: AUfX_mwsbOAjAfHSNJPFMow5jaMI4QuDx4UrQ8_46JnLFLe9Upel7JdQzagr2CI
Message-ID: <CADvbK_dkGGDe=U5SP4nNGuFRgT4FLqbBsEggh2k7qtnhU1XfxQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: prevent peer transport count overflow
To: Asim Viladi Oglu Manizada <manizada@pm.me>
Cc: netdev@vger.kernel.org, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 11:21=E2=80=AFPM Asim Viladi Oglu Manizada
<manizada@pm.me> wrote:
>
> sctp_assoc_add_peer() increments the association's 16-bit transport_count
> for every new unique peer. Adding the 65,536th transport wraps the count =
to
> zero.
>
> SCTP sock_diag uses transport_count to reserve the INET_DIAG_PEERS payloa=
d,
> then copies one sockaddr_storage for every entry in transport_addr_list.
> After the wrap, a diagnostic dump reserves an empty payload and writes
> 8 MiB of peer addresses past the skb tail.
>
> Reject a new unique peer when transport_count has reached U16_MAX. Perfor=
m
> the check after the existing-peer lookup so a duplicate address continues
> to return its existing transport at the limit.
>
> Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
> Cc: stable@vger.kernel.org
> Assisted-by: avom-custom-harness:gpt-5.5-qwen3.6-mod-mix
> Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
> ---
>  net/sctp/associola.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 62d3cc155809..b6ac0966420a 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -614,6 +614,9 @@ struct sctp_transport *sctp_assoc_add_peer(struct sct=
p_association *asoc,
>                 return peer;
>         }
>
> +       if (asoc->peer.transport_count =3D=3D U16_MAX)
> +               return NULL;
> +
>         peer =3D sctp_transport_new(asoc->base.net, addr, gfp);
>         if (!peer)
>                 return NULL;
> --
> 2.53.0
>
Acked-by: Xin Long <lucien.xin@gmail.com>
