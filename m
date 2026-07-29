Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE48B2D97BB;
	Wed, 29 Jul 2026 01:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785288273; cv=none; b=tgk6O9toP0DjPz5EihrqtepgkIlx4cJbZWTAI3sivy2kLTFJAJcWU9L95u/e2UURuOd8sk49taUxBteAbeZSgtsjJFAKvQPOARBZoObtI2YXHBlhjLIljqzmR1pIEbMjohHUlbEVu+EnAP7AHLMmv/Vp4nVzd5AhY9GrSYmXx60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785288273; c=relaxed/simple;
	bh=0K7v+SNJIde2rWpQJx+biIFzcgjAmzOsq3IB+E4oT1U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTH3WqtKaSD17B7hH1/5HkOd996+P8fjerBPX7U6Ia4SAXHbOa6BIPWD8wFMzmIveyaatw7yQhcd5CpDfKbftuQFv3XF5HG7jbmRd45d5tKrVKgIECO0R+HunWuaaP/vJRVPShXC/t9fhuZ2xycP2X/Bsa4mZOS7YIBl6mqVmlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8YIZxfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8YIZxfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2198F1F00A3A;
	Wed, 29 Jul 2026 01:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785288272;
	bh=1eCwE+8DaunIjwYH+E8QqyYowTTJ9nKKsaiJjEMSfGU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i8YIZxfYvHLx8m/m2zA8EyFtXPCgG61w+IJhb3FBaivBQdnEJgdQkXNceZQonzbRI
	 pidgXBRhbLgDrW0wNJbYHNnNkhGkCHvJgh31DzcsenddaI9sfiEPjh+sngossW0kBj
	 Zv0C8dXIq/LzukqvqejJbjZipXyOOwWuVYqOzlqIRdLUKkCsVZrXxXQYYX5YyVO//L
	 jVNglaLHSTiy+naG7LOVFoqyXTJsO+/WSu2o9/XFL5p90xCq0TOsJ2h51GYNQCuQOu
	 xaTOu6dPq83NgAgSQndYnGIwJBnzbrCLesEfPv67fAlrtEJbANIMoPCq5pH5bt5I0t
	 1StM6w5LOcSJQ==
Date: Tue, 28 Jul 2026 18:24:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: luoqing <l1138897701@163.com>
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] sctp: fix addip_serial increment on ASCONF_ACK
 allocation failure
Message-ID: <20260728182431.3291b917@kernel.org>
In-Reply-To: <20260723071818.459034-1-l1138897701@163.com>
References: <20260723071818.459034-1-l1138897701@163.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Jul 2026 15:18:18 +0800 luoqing wrote:
> From: Qing Luo <luoqing@kylinos.cn>
> 
> In sctp_process_asconf(), when sctp_make_asconf_ack() fails to allocate
> the ASCONF_ACK chunk due to memory pressure, the code jumps to the
> done label where asoc->peer.addip_serial is unconditionally incremented.
> 
> This leaves the peer's ASCONF (serial N) unacknowledged while the local
> endpoint now expects serial N+1. When the peer retransmits serial N, it
> falls into the serial < addip_serial + 1 branch ,
> which attempts to look up a cached ACK for serial N. No cached ACK
> exists since the allocation failed, so the retransmission is silently
> discarded. The peer eventually times out and ABORTs the association.
> 
> Move the addip_serial increment inside the if (asconf_ack) block so that
> the serial number is only advanced when the ASCONF_ACK is successfully
> created and cached. This way, on allocation failure, the serial number
> is unchanged and the peer's retransmitted ASCONF will be correctly
> re-processed.
> 
> Fixes: 1da177e4c3f4 (Linux-2.6.12-rc2)

nit: missing quotation marks around the subject
-- 
pw-bot: cr
