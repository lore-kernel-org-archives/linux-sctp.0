Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD5E3655C5;
	Thu, 25 Jun 2026 02:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782352876; cv=none; b=rRRvdJL3ZoIm3b5avsBTnMgq1sctXoooAe/Nhk1XrytZ3or3Q64+7a9mVjVRgLYxjU+XqpG/3ydwikvxc/JKv7RGUwlQSLQWn4gbV8Swi4voDVvaX/85Ak652zLHoiWgCjsBATEuLP42GjdJR8TPfntMbxSN+EoyfXR8CbF8nx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782352876; c=relaxed/simple;
	bh=5fwKkWOdRgv8AYwCq9cF27hJ4iVT/vs3FPoo28SGqgw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qezOgj0tR8+/p6Tvv/7BiqnfNixZEgUeSG9T9dqyXUI7b3FIotUk0WbBtmMGh+BWDl/3iHMS+A1ls0Z18gNYcG7++d/4MnrM/c+li6pjVBIiIHGwBu6zlKo98e7yl8A+U7b46hKv0pWGEqupztnu1Sgh1aEnFNu36Nj6K3yL4MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iv0Q0Rbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iv0Q0Rbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2CD1F000E9;
	Thu, 25 Jun 2026 02:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782352875;
	bh=wW6nsLdslasre0ulUwLa728OsKwT54yRmRh1tbw2mPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iv0Q0Rbxg0ZUTDyBLmZyb2PLawiGmkmfRHQGjdUC1w1KVDEkucG4QBVntAYVzdd4X
	 NLDN6Mh7ZV00EodOw++UgD9YwZ/l5q+8RAXTcQA0KYDu9EVTrd5FSytQSvQds90nxy
	 W3ynJQao1WBvw2hOAJ2RZFH0xuMbSXMhob+Y1qTdqQw6ish+FodqnmrSdaC0mRSsbW
	 yB/un86FvEP0aszINcvOYtAFqjl5u1Aa1dfafVmFv5Ggv7V3mLFMKLLIQFTsv2efSu
	 NawbZsg0jyZ0NbZOQU9BtEq38CwLJjM2LfYs482BTJPhJliqqirK6XzmaFMEKBeSwI
	 jb9kP+QrtkOIQ==
Date: Wed, 24 Jun 2026 19:01:14 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] sctp: use sctp_auth_shkey_release() in
 error path for consistency
Message-ID: <20260624190114.10060932@kernel.org>
In-Reply-To: <20260622100235.34263-1-vulab@iscas.ac.cn>
References: <20260622100235.34263-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jun 2026 18:02:35 +0800 Wentao Liang wrote:
> Use the proper refcount-aware helper sctp_auth_shkey_release() instead
> of kfree() when freeing cur_key in the error path of sctp_auth_set_key().
> While both are equivalent in the current code, using the helper maintains
> abstraction consistency and prevents potential issues if the code is
> reordered in the future.

## Form letter - net-next-closed

We have already submitted our pull request with net-next material for v7.2,
and therefore net-next is closed for new drivers, features, code refactoring
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after June 29th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer
pv-bot: closed
