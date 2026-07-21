Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1148442107;
	Tue, 21 Jul 2026 21:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668021; cv=none; b=FwMc/dAGPAqouA7OXmcCHGR4jVX+YNYS870zpTYSGVegQhirUcy4AcNajqyKdhcB7EPux4dByR/zB4O2mzPpuh6qTWpgl9PcA2NOQDMatIjWgwbC2Vx2iuIpb0vw+sep6lvs9LHWiRfOXlgw882Y6ZegFKMyl4sxaXls21emUWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668021; c=relaxed/simple;
	bh=JltIqwd2g4PZsbTsOlBMggkBKsK6QXyPs+p0vF/bQuE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ss08EtBOLq1LElXKOFnBer9G9G6ypAGRQEfhGUNrxRwuc4NG9oRVIIwnavAunKyyrEFzbPw2twET1gitocV7MGeVQbQ9BZIdBSWfR7DQRSmXp2JOTfoxEprPuDGpLmQwB6pkWheOrVDZVxzRlhGnbWlusoV9De74gnj0O3LaOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ln2ByyT6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ln2ByyT6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F601F00A3A;
	Tue, 21 Jul 2026 21:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784668019;
	bh=7abXyW5cA3rz+bga/ufpLUDWGqJKwYg+XMhDXnLdN1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ln2ByyT65k9ls7JpzavSEX+UODFqy0DYM9oXz+jXMpNyCIPwTzsIKxgUfG+sS74Dm
	 +tXns42gZ/hCoNw4l2LlCJS6nJCWXbjffYNAvFy1/xwL9wIJ4AdGWcIChwSzrZWLRl
	 vSuh0BpWfWuBcNfc9H3c92rRXRfakXZqc3xJgdRGwAjS1Am6KUpB7NFQObuR203HsJ
	 Yi/E53Z0d/G1/8ZuBeR4SCdndhoHlo/X9kWizNOkXAjQtXw0HEEos2ejPjkuvofDhg
	 HpRZJlNXQch1NefUsxOUHy7qnGOQ+Xviw9Q4UhXcdAU16OwCuNxPVOlpO7H1KWLiLV
	 eOGmtC3KrtS8Q==
Date: Tue, 21 Jul 2026 14:06:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: MingXuan <omeux327@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] sctp: diag: fix uninitialized stack leak via
 INET_DIAG_LOCALS/PEERS
Message-ID: <20260721140658.21d898ef@kernel.org>
In-Reply-To: <20260715033536.64963-1-omeux327@gmail.com>
References: <20260715033536.64963-1-omeux327@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Jul 2026 11:35:36 +0800 MingXuan wrote:
> Fixes: 8f840e47f190cbe61a96945c13e9551048d42cef ("sctp: add the sctp_diag.c file")

Please trim the commit hash per recommended format of the Fixes tag

> Cc: stable@vger.kernel.org
> Signed-off-by: MingXuan <omeux327@gmail.com>
> ---
>  net/sctp/diag.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/net/sctp/diag.c b/net/sctp/diag.c
> index d758f5c3e06e..12557e924cc2 100644
> --- a/net/sctp/diag.c
> +++ b/net/sctp/diag.c
> @@ -85,8 +85,12 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
>  	info = nla_data(attr);
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(laddr, address_list, list) {
> -		memcpy(info, &laddr->a, sizeof(laddr->a));
> -		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
> +		size_t addr_len = laddr->a.sa.sa_family == AF_INET ?
> +				  sizeof(struct sockaddr_in) :
> +				  sizeof(struct sockaddr_in6);
> +
> +		memset(info, 0, addrlen);
> +		memcpy(info, &laddr->a, addr_len);

Having a variables called addrlen and addr_len in the same context
is quite confusing. Can you come up with a better name?
-- 
pw-bot: cr
