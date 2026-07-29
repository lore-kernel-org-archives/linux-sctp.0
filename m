Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED63BF66D;
	Wed, 29 Jul 2026 23:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785368144; cv=none; b=kMyXIbI9opOMxuY/hMCcad8zgp3CqsbbYsZeWKAYIPnP/gqldJzia0Y/XjGtYR9nF0bDz+feYlXYsgjbPUGsP8QZwfKIEnbbB3fWW76iyGrshRRr5GzQj8gmGA/+qJfOi5/cMFQeY5EAgBQkt4mQxmvdoNxwBxOqWngBQhqDVng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785368144; c=relaxed/simple;
	bh=OQL+RV+7+blO9OD08I9jhwt2nD6njKN9vLdf/ZnKu0s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WoOwMELa3sK4hQ6DBP1aKn+vRCIy0ox4e7PeIe4dtT6nzS5AqEYU5W5R4g6U8eJqquQB360BJbXuGRy8GDtO1HTFB4tIPzVZSS4bSsqK85lZ+4PE4EsTtP7mFmBaBSdF0YKtrDDTPhsBPZaoNTDqhmds9JyLwwectpkeh8KfDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ba7JFQy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ba7JFQy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B751F000E9;
	Wed, 29 Jul 2026 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785368143;
	bh=Q95yK0W0Thk50dNQH31d+Tad4W9E02Is5xPeOPQLRNo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ba7JFQy5EOSU+JbPmZ9pyFmKYcpX6pEJcKHs9lkqWFZMVy63nY+acT3Q3GV3l3taW
	 P4Td37+5ez3a/YRhCNqxP3n5kvWvLbCo0t6mCB7guYwf68U9eO4isTtntcV3Edr1ud
	 V8jfskXWkFi6bJwoIuFkcBdCRoQuSy7rDLhyeuN0IRiE86Y8qhBhjP9xnWqcafytWy
	 eW16HMCthNcSELlPDLTgZ2LrymbmkCfNding2Rt4S27nofbohwJDV/gFRmsPscyj3v
	 XlEJlYApreP65wZFw7sfBUo8hgfSlkZuIoDvWMuW5SQoFWN9w+popZgPlvJPL4iaT2
	 RQdbw0+SuRbQA==
Date: Wed, 29 Jul 2026 16:35:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: luoqing <l1138897701@163.com>, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 marcelo.leitner@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v5] sctp: auth: discard auth_chunk when
 skb_clone fails
Message-ID: <20260729163542.4d3bea9a@kernel.org>
In-Reply-To: <CADvbK_cAR8qZwA1pAN1Kov+v-Whg_P19VK-Fzpztxc5fiwA+Pg@mail.gmail.com>
References: <CADvbK_cb8Q=9nv5Z5eR3cf=NLb=5=wSg_HKHrtCtPU_bAN=qvg@mail.gmail.com>
	<20260723061107.384106-1-l1138897701@163.com>
	<20260728182359.3cd3acf6@kernel.org>
	<CADvbK_cAR8qZwA1pAN1Kov+v-Whg_P19VK-Fzpztxc5fiwA+Pg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2026 10:43:26 -0400 Xin Long wrote:
> > > When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
> > > due to memory pressure, chunk->auth_chunk is NULL. The original
> > > code still sets chunk->auth = 1 and continues, leaving the
> > > COOKIE-ECHO to be processed without a valid auth_chunk for
> > > deferred verification.
> > >
> > > Discard the AUTH chunk early via pdiscard when skb_clone() fails,
> > > so that the receive loop can continue processing remaining chunks
> > > in the inqueue instead of stalling the entire packet.  
> >
> > Hi Xin Long, should we apply this or it's no longer worth it after
> > 8e04823c120b ?
> >  
> Apply it to net-next.git.
> 
> Acked-by: Xin Long <lucien.xin@gmail.com>

Thanks!

> So sending patches with wrong in-reply-to doesn't require repost?

If patchwork ingests the series correctly (which is usually does 
for single patch postings) there's no need to resend. It's mostly 
a convenience thing for maintainers since we try to process patches
from oldest and the threading makes the sort harder.
