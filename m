Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694A74CCDD3;
	Wed,  9 Sep 2026 18:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788979476; cv=none; b=MHLOAlO0XXtOD+N012dfW+1jXL3JfDDbwWIYnXdeaWsyxBVpEV/yIZN41bRWzTL2jcrskKUGHv9/OeS/EIkimHN4eBW37XdfbaCA+hBHWvjLPFRu5/u6vJIRWJks4q7hx76UCBV/MV7b1THHcR5LvQp7fvPqxHM2j5Wd+nqQbrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788979476; c=relaxed/simple;
	bh=92b6mDx38SkBTW1CKSdc5o804/KJIqG18Ln+BEcIg9k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZa6/eNwbOk3vPbpDkHiH/8TgO54rFWMh7UOuqVGb+TFjP5W5meKvASksSNBSK/hUPez/IILwIRvHDbubtgeorsbXf4k3CNh2pmQyokNPnHyDQxHMoxmiZ0bMcRMzBlfzYIknUGlwvwEFuU0SwitNvGvXJY7LACewnzkIoNZCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H7xXdBkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H7xXdBkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A641F000FF;
	Wed,  9 Sep 2026 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788979473;
	bh=NtMFWIVxrUnMYU9UF/S0v3PDBWWUWifcOu5n/Tvo3S8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=H7xXdBkxijvzx+OrAW5wpALgDFERZAbhBmI2YFa9+SXh583XR0cw53if5BWIKVDQA
	 RGOEds0DPgL94DLbSHPpnRK56G4i4YikBOWoHRK8qZuH4kF0K+EX4MrZ/DXsAmwRP1
	 63TfcxvxctxaTC/+CZ8oztfP5gKGkq5AXBTQ0rl6ssmg3f5TLTtI0hpsQa8j9qLgbG
	 TqSExXxhxWBlhCNnN9GNSFpwlFya/l8G0d9lH4JKjphhiRq+bfx5H2mhdUfErdZcJN
	 2vSoGj3XEkn/yVHSu03HZ7FZPoHUXTPC7qm5oN/G63VaeIGtpJSYV63fXjOTVBOdYc
	 b8PGTWjopSI2Q==
Date: Wed, 9 Sep 2026 11:44:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jun Yang <littleddfu@gmail.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Jun Yang
 <junvyyang@tencent.com>, stable@vger.kernel.org, TencentOS Corvus AI
 <corvus@tencent.com>
Subject: Re: [PATCH net] sctp: check asoc->base.dead before the RCV_SHUTDOWN
 break in sctp_wait_for_connect()
Message-ID: <20260909114432.0f4f2a4d@kernel.org>
In-Reply-To: <20260909024626.3494588-1-junvyyang@tencent.com>
References: <20260909024626.3494588-1-junvyyang@tencent.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Sep 2026 10:46:23 +0800 Jun Yang wrote:
> Subject: [PATCH net] sctp: check asoc->base.dead before the RCV_SHUTDOWN break in sctp_wait_for_connect()

This reportedly breaks sctp-related selftests in tree.
Please try to run those before you repost.
