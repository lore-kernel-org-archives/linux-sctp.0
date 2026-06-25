Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479133E833B;
	Thu, 25 Jun 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782400758; cv=none; b=CrQ4ZP/9fmcN5bVAq+LyGouG5LsnVn2U3MPK927NqkAQwQuwdv2dlRsSl7UoTYE/rRcvytRbm/jE39YP/FbQEMYnQ+OASeaek/eUNUac8x1Ir7z4W3MO/wj8Ye37i+aKrs+I9ivLX72r95alXVQjLngRHQu+fwjuIF6UWxy+wIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782400758; c=relaxed/simple;
	bh=Odath91MlpqQ/3qQChDCDqq8dVzrLYccrdUW0VNOaz8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t2z2CajJ+3OayEsjSAeTun9ImoOrUJJEUe8DrLi85g8lGaLH6LtcvXFX+nEuVrZDho2Ndigef3FRDi+Yhh8ufmrY+yHvj6uCa29u1vVly6QRFsH3dFeASoHYK+PfkGgVhaQVqdQXbnI9S2ygLwtkxB54jEQGikiwAop9oK0Qh5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLVuMNlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLVuMNlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C3F1F000E9;
	Thu, 25 Jun 2026 15:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782400757;
	bh=Odath91MlpqQ/3qQChDCDqq8dVzrLYccrdUW0VNOaz8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LLVuMNlrHeAjkZgtNByRv3n0b6TXqMFjZPg/CyEYStf350c39UMN1LnLZK7NOyC8h
	 LG66ugrqxna4iV03De/mW9P6E3R3jaDKVpOanOLLJz98kaQThby4CWE+/sGvnmOyeP
	 /V9gJIok6XwMSxOto2i9lKNi2ongcO7ar6ccYiDjOHnKPK7IpARqXOsOoUbwSliM3z
	 xdQ7vKz1XTIX7h+nNmhBQe7WWU8N8U0Ki9vM4svG2WDqzqfpSxli/50/ePetRzsYmf
	 zO2hl+Pw1YMtEMUrMTBOMO4Vlwd5S2OHNn/cFCo96BrCBg5nn5IIBsqQF7+DApPUm8
	 He2T9EfkCwTmQ==
Date: Thu, 25 Jun 2026 08:19:16 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] sctp: fix SCTP_RESET_STREAMS stream list length
 limit
Message-ID: <20260625081916.77a017f3@kernel.org>
In-Reply-To: <20260625142354.2600-1-alhouseenyousef@gmail.com>
References: <20260625142354.2600-1-alhouseenyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jun 2026 16:23:54 +0200 Yousef Alhouseen wrote:
> Changes in v2:
> - Add Fixes and Acked-by tags from Xin Long.
> - v1: https://lore.kernel.org/r/20260624122213.4052-1-alhouseenyousef@gmail.com

You don't have to repost patches for networking just to add tags :/
