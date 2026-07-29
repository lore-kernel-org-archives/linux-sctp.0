Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2E45C709
	for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785341033; cv=pass; b=S5XxlqFMhYP3hBA5eJc2L4pK/qDajUqYxXBwF+g0A21KsQmfz7a9sw/gR4ueFr4RgFUGgNpuEQpbWyjc04A21kBaXjfi0q34Rg2VxKLibja9RT0Jysq3Ffmp/K+zqrCGW5ivYRmEZNCuMMPPiiJgCy9fMEXNeP5suP76SUeVTGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785341033; c=relaxed/simple;
	bh=9jvHZveWtXHHlQ1jzadPI9gN3vbZDtiixL2Ia/KB0jk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W0mwKyXX+F126obsz+rijrZkHskOY+8AhXvDWQLPKgeO3zLQRf22CSg56OFnnBrnBcddkGeAG2am/dRCWroSJnsu1dlskyOFfviwxDuGQ8t4H+aN/S7lMhlZ0nR352zf1m6AxIDY3Q9KdjVXtjSRETzezmxfNaBUhASwV9dpuFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bj51gJd8; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bj51gJd8"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-9667ea2fc22so257275241.2
        for <linux-sctp@vger.kernel.org>; Wed, 29 Jul 2026 09:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785341031; cv=none;
        d=google.com; s=arc-20260327;
        b=BEEEq2u40CaspU1XcThgVF80dOm6+s8KR/oGKLJ4fNrhcTDPXVCTmCaThwcL/nRBOy
         4PkyhsUIny0WnRAIh1KxwQxnqEyF0qDDAy2dV9qUYKUpTrlSenoJsPz53RXynh8NOgQD
         I4FLQR8UbzzUCnq32okxYFIgIGqIl530S+x93xUPlTTVn3VrKUTirUKDbXxgZkM+9Iim
         CIVT62atDNH53N4nj/NU0NEI5c1Rtrc5SIu/GIhlgQ3VcRb9nQ+IW8rv+MFBNHms/AhI
         JZzZ1eXtGgTnE4D4wuL/JhcPiiXw8qi3v1bR5UdRTCNEpIMFtRLLnzt5F3x5iwr2GYth
         mU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9jvHZveWtXHHlQ1jzadPI9gN3vbZDtiixL2Ia/KB0jk=;
        fh=DOXJ8jc/UUQzuTBRsMswLLJG2sN6EtV3JK1bYxRQXM0=;
        b=NHYVdFwxNyD+kLueUqgLkgcNmCGZ5Q4OIxKtijPrxMp+aE1hGl2b8Djbi/dOG6yXHO
         g7/tJtZ2pz1rs6fC/c5ZxG9Kxrl4nCypcu/CeFTXrS7MxtWMpH6RYiwOLToVwdTZ8unY
         4JOY4DyhqvTPZdbKtdH5AzwihI/GdtfR7e4NmlDdJmWgy4w8dw+/Ofb9vDexvioO9CA8
         eTSPbX6/oQGGKZqRBNHqF2+m/HaLlzbZMHwaEbg0rSsI/ZL/mz/7Ocn5ClPZeARoTLIS
         ga8c09RE+m763x/sWwyvwJzFfVXfIlfYgCnlo8WDP2JSQ4VJ8aXs5FfgB0cgGRpKWNCa
         PBZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785341031; x=1785945831; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9jvHZveWtXHHlQ1jzadPI9gN3vbZDtiixL2Ia/KB0jk=;
        b=Bj51gJd8vi7BcJhyOGo9ZkJ+4cFpMXL/QP4k3IsurPsJxTYUyT8mVgBc6oD0gqR0tF
         DK9++u83Cei1A1bY0AHwPE5UToH5WM+fvhp7I20+ySwsxeCLGfhsAgaHNX0zbEGRNsoJ
         3Gl3SWtB9d2iwcvulYCXASONla9KObfQMbSbQIRtbyn56mf2zxpCjuZRCojp0fEoE4ih
         0UrwVYfxB9KR0aHyEH1esET/ASNHWw7ECTT8E9Kn84BkyIt/KJrRqL/juSKk/yHAeoCd
         Cudb9ov5ofv4YNZTvkOdmK5eRnitIqGhOpNOPvr1tEMOq6Jkt5IvKO7X9Ktb7Ad5Adil
         P8Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785341031; x=1785945831;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9jvHZveWtXHHlQ1jzadPI9gN3vbZDtiixL2Ia/KB0jk=;
        b=XdtFA2LQE58kn2VKVENf5edymbt4TXQONV9XggxxocagKGjF56GeDzYM405pRsPUfj
         jr5mC+8D4epgvkBtVuHssQOQA0fviVct0DxwRbJiGEWCPXhMYuEEH+M7H5W+kDWR6HWK
         3U/srpopTUOLyHAr8mFSjpzCUI38HGZcrW3J19uilPY6LzyG0evfYeBDKdtC8pkZMf4i
         /NtveNrMzYIWSVCotmU0yt8kf1HxtI2iNIHMpw3M3O8dxp9ZNvaX30cDGW+zncoraLpp
         o2+zxojBy3JlamamTgkr2OLt3MNV0BLTfrVlgywnqYFH+zjEy7LTAXy/ugV8NBygDSfd
         I8zg==
X-Forwarded-Encrypted: i=1; AHgh+RqnSor23K2u39NNfnh/9tHEkP2bihzQLKobd0eW/Hm09wk/VpBI4gWgowSAEZkb0eiPEhKzMGa34OUR@vger.kernel.org
X-Gm-Message-State: AOJu0YxIxN4h2o8EzEhpDPOsTfS2IBovWlkgcKFaaOPZQfkaWAWJZFE1
	JqoS+CLTGqYalgw965KvMvgnsL6tUVEv051zvEWgGfGmX1ZdkVQioh6lccwCGt2yh+1wIImr2v0
	0d1RnruRVKHZ5m3ZYoDAON5LM0k+3qNY=
X-Gm-Gg: AR+sD11qwFYQ7g3tBWbp68CPAdPp5YqZAonx7qD/KlsvRfzItiM7jQyybcUhzz2poOh
	/mYz2wYqeK/PQhe/E+jm5gRM0d2abckipaShtDJIyKdWLBx1ejM9QCjvLfZLwzHNvgI72dQaH0P
	llZEwIVP02nYATUG9DXU6hirxhBwzwgi2lfKK1/NOK5DdKbIAh6NuT0FSwo3MOxFIofmnPmcnkk
	++wLmTPVSscyHVbpFF6n9pOsXIlPkV7rn0LF9mQ2NXakofTkT8KyjauPCoISOJkGJKYmvJxkKbn
	17q5tVPl40J0BirFiLDkkWyPNpwUZ/DsJx/fB9yBnoQbkzWmL1fBAh1OYd9kS+TFTIuQV2PK0la
	vA8N6TciBiYKNixaQl5CzbVvjRTm+qdl9X+yZ/eevtbI=
X-Received: by 2002:a05:6102:3e87:b0:738:ecd7:1984 with SMTP id
 ada2fe7eead31-7549f147633mr3169780137.3.1785341026373; Wed, 29 Jul 2026
 09:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723071818.459034-1-l1138897701@163.com> <20260728182431.3291b917@kernel.org>
In-Reply-To: <20260728182431.3291b917@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 29 Jul 2026 12:03:33 -0400
X-Gm-Features: AUfX_mxSOAibwdWHo3uMOeOrFHcxPhaZyGA2yz3_5W-NC3DfmXI2lIJDX9QqLXU
Message-ID: <CADvbK_dhcAwiaK6htMA3kkW797-qchajjFsJhFyi6KMEbkEm4g@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix addip_serial increment on ASCONF_ACK
 allocation failure
To: Jakub Kicinski <kuba@kernel.org>
Cc: luoqing <l1138897701@163.com>, marcelo.leitner@gmail.com, davem@davemloft.net, 
	edumazet@google.com, pabeni@redhat.com, horms@kernel.org, 
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 9:24=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Thu, 23 Jul 2026 15:18:18 +0800 luoqing wrote:
> > From: Qing Luo <luoqing@kylinos.cn>
> >
> > In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
> > the ASCONF_ACK chunk due to memory pressure, the code jumps to the
> > done label where asoc->peer.addip_serial is unconditionally incremented=
.
> >
> > This leaves the peer's ASCONF (serial N) unacknowledged while the local
> > endpoint now expects serial N+1. When the peer retransmits serial N, it
> > falls into the serial < addip_serial + 1 branch ,
> > which attempts to look up a cached ACK for serial N. No cached ACK
> > exists since the allocation failed, so the retransmission is silently
> > discarded. The peer eventually times out and ABORTs the association.
> >
> > Move the addip_serial increment inside the if (asconf_ack) block so tha=
t
> > the serial number is only advanced when the ASCONF_ACK is successfully
> > created and cached. This way, on allocation failure, the serial number
> > is unchanged and the peer's retransmitted ASCONF will be correctly
> > re-processed.
> >
> > Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)
>
> nit: missing quotation marks around the subject
> --
> pw-bot: cr

Somehow I missed this patch.

LGTM, except the nit Jakub pointed out.

Thanks.
