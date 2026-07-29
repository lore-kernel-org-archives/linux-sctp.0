Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630171EE7C6;
	Wed, 29 Jul 2026 01:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785288242; cv=none; b=BeKIPCeVPJ3IfXSKTFZt9h3ucDlse5ZsWep0/QUksQ5RzNU4sIOy4/eOjmUNUAtBORdL7jtxydi4P/WEko1APRZgTv+k6jKhnSNLKR/Urp+Lza6GEiiYV4dpaKTnILiPVUIAvhQ9CO4mt17XchhndkuEE9YOwJzCa5x5gDkKjZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785288242; c=relaxed/simple;
	bh=6f7p6/jY3yN0gGSeknZN1vw+ZWMp/qTNTAHb1x57DGA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsSnL2eI8SjQP8PsjjeMLI0FkuN/ft2/syo+sHykrxZ69bCy/ys7HZwXdlcNlJxakwzOsPdw0R0hWWrtAa1iZNzChFwBCpfvfN40ngQs0GgGTC9DsLmFVRUXBlms9T/Ewhs/vlhyUP+jp8wyWvzlrROrsZTJCSuzTqVZAdsiQjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awXdPJht; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awXdPJht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7251F000E9;
	Wed, 29 Jul 2026 01:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785288241;
	bh=pLel7Ia7aDtF8GaCLYBSwOj3dVvXVsZElHDqS/cW/fY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=awXdPJhtSCVu+6r+tD4L5oVxTxxVxE2VHURe9ZqR03lbyrFi0nKobCjkeqW9of2I5
	 2T7y7pOAmPuGPytAB6XgOS7SWf8pMy8RdqO7akcMvJ0WLrsVViEcCLTBDnbaCKCw25
	 pkEiaYiGp34kDfjgm4PVN3IWeBL5hWPqoEheOuSzfbJjrL3wh2u+u+g3vG+4lPnBbg
	 eH7nPPMenOFqN4QWMxMwgwp/chCeecNvczswVgPI2/aHsXjHP/XSdDmLNz0VsyfS8y
	 uo2xKeq2mQ/RyRaVZibIlOgmv+xQH1gooHYgUl9pc8TrZX1Kn6BtUA4fq231aG30ai
	 CTm/lbUSkfW5Q==
Date: Tue, 28 Jul 2026 18:23:59 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: luoqing <l1138897701@163.com>
Cc: lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5] sctp: auth: discard auth_chunk when
 skb_clone fails
Message-ID: <20260728182359.3cd3acf6@kernel.org>
In-Reply-To: <20260723061107.384106-1-l1138897701@163.com>
References: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
	<20260723061107.384106-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 14:11:07 +0800 luoqing wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> due to memory pressure, chunk->auth_chunk is NULL. The original
> code still sets chunk->auth = 1 and continues, leaving the
> COOKIE-ECHO to be processed without a valid auth_chunk for
> deferred verification.
> 
> Discard the AUTH chunk early via pdiscard when skb_clone() fails,
> so that the receive loop can continue processing remaining chunks
> in the inqueue instead of stalling the entire packet.

Hi Xin Long, should we apply this or it's no longer worth it after
8e04823c120b ?

> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 62d3cc155809..a5f2835dbe0f 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -999,6 +999,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
>  			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
>  				chunk->auth_chunk = skb_clone(chunk->skb,
>  							      GFP_ATOMIC);
> +				if (!chunk->auth_chunk) {
> +					chunk->pdiscard = 1;
> +					continue;
> +				}
>  				chunk->auth = 1;
>  				continue;
>  			}
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index dfb1719275db..a15b599b20b7 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -368,6 +368,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
>  			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
>  				chunk->auth_chunk = skb_clone(chunk->skb,
>  								GFP_ATOMIC);
> +				if (!chunk->auth_chunk) {
> +					chunk->pdiscard = 1;
> +					continue;
> +				}
>  				chunk->auth = 1;
>  				continue;
>  			}

