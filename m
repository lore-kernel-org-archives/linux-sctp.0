Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D9B25B092;
	Fri,  2 Oct 2026 00:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790901494; cv=none; b=nyJOzyudMp5+1hzzTL5yiNiT9QpMx3xBXUvwxbGTAo9ipdMug915u6+/ovceNEE6eNUCaxwX1o1ywdaKAgWUJoR/Eb453+L2FKBcqTH+OwwamFkmMK0RzkA5f4yAMMSFiLiX4WSPHFxbH4k8mYtUSVk5EwBx1wmyWPSbWVaysxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790901494; c=relaxed/simple;
	bh=QO+xcArTR3a26WqHth8KpxoC/JMLl4gB0KDGVJNxQYM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WEZ4A5B/07ktsb5WQvGPJEgPxFLLVU0psfSunYvpqCJlT2QuXPj+BKvwzocwqx8clHvDPtPTe6svImtp/gCY3+X8EcqyICZmnmq5mgalRSUaLXYSbgiBxJCFOMkG+xkRcKg/KRg879vAZrnJ98VNFklK1Ve01D9gEhKfv5LyrEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fZxidBBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZxidBBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1D31F00893;
	Fri,  2 Oct 2026 00:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790901492;
	bh=9G9Gp22sD6F2MLnPvbvkpT0KyPSGOudpskd/aZZNlrw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fZxidBBIc/z1wKHwgZeDlw2oTEcVrCxEDfCADVsjv2cWSBf2d3s8yg9vJYc4yu0zJ
	 oFnrkjh+Fm7xXUv6CYWJtHK9UbOUJ83bJGJVQQCMRkMnAQZOy1f2wFzKLyO5/iQb7P
	 eI08fWvYE5j07cAQ4LiKJJeVIAwSnr7G++2HfK4pZTMiQzryudyLqdx0QujBKJ2w1Z
	 vGcLcZCt05Py1cDWSRXuu+3PAWjV/i04qJ+puhr6h7LbK6Wb4+doIAiAp/HOsQ4R7U
	 MsnPzHquoHeIZnFXTHimk0iRIl8NZMKIqZ65oxkCiwEC5XN3ZgnVVuxQ1g21BBUGNV
	 H+Q1FinrTMWgw==
Date: Thu, 1 Oct 2026 17:38:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Seung Min Shin <guncraft2000@naver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: hold transport reference across connect wait
Message-ID: <20261001173811.17b0b861@kernel.org>
In-Reply-To: <20260928152132.3705137-1-guncraft2000@naver.com>
References: <20260928152132.3705137-1-guncraft2000@naver.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Sep 2026 15:21:32 +0000 Seung Min Shin wrote:
> Subject: [PATCH] sctp: hold transport reference across connect wait

this needs a respin, it conflicted with commit 4f1da630d13de
-- 
pw-bot: cr
