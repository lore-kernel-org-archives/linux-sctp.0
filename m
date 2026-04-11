Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9761B298991;
	Sat, 11 Apr 2026 20:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775938583; cv=none; b=OAovDspmui9wFiuLjJvHzoXrv66DHgLnpV8mWv7nuDx2knQcYQiq9UX4WNTQxnnAeYXW50fxigHJ0Ue1aZfDGq78xKpnaay90KHuZ8m3hsDbwYWf8RifHxLcIwYy4+tFxzIGVZhikP01rCtmEZclJLZ3EwgIMuJZA64sd+G71Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775938583; c=relaxed/simple;
	bh=1loORrVCyxX9Oj1P51ged/6OsjTSRcdRHzl7XE/ZV8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4WQdNhmuKlgyRB5MpLMfPbBYNObAk5Bem6qs1HkJZFYt9/Pcu0DG2XUFBtD8Svxkg3KMhrZfQ+MRqedVoxuNt2kSidYPNOOZSDkVSenw4nyBEXuhLCY3DH2TbAA8HjzlFc6LcXi1UUMWxBHt/0FjG4IsxVc5aEBT1PXm+lD0pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6156E60491; Sat, 11 Apr 2026 22:16:19 +0200 (CEST)
Date: Sat, 11 Apr 2026 22:16:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH net 1/2] netfilter: skip recording stale or retransmitted
 INIT
Message-ID: <adqsEmki7ppz9T1g@strlen.de>
References: <cover.1775847557.git.lucien.xin@gmail.com>
 <6e09f9a8d1f13f3ce691c696d3dd7b2a2e6c6184.1775847557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e09f9a8d1f13f3ce691c696d3dd7b2a2e6c6184.1775847557.git.lucien.xin@gmail.com>

Xin Long <lucien.xin@gmail.com> wrote:
 
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 645d2c43ebf7..7e10fa65cbdd 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -466,9 +466,13 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
>  			if (!ih)
>  				goto out_unlock;
>  
> -			if (ct->proto.sctp.init[dir] && ct->proto.sctp.init[!dir])
> -				ct->proto.sctp.init[!dir] = 0;
> -			ct->proto.sctp.init[dir] = 1;
> +			/* Do not record INIT matching peer vtag (stale or retransmitted INIT). */
> +			if (old_state == SCTP_CONNTRACK_NONE ||
> +			    ct->proto.sctp.vtag[!dir] != ih->init_tag) {

Should    ct->proto.sctp.vtag[!dir] == ih->init_tag case also
set ignore = true?
