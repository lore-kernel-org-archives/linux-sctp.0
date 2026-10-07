Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378D147D45B;
	Wed,  7 Oct 2026 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791366867; cv=none; b=Y8ZmQWcpEtuBd71w4CwVxGfcoz0wh8VSDfVFgo4AfKDzGp8EwrK/rFmQ1xFy5rOJDunErpT/5mJchpwOer6QadCSgpeyMrUwRIJPAVb2fMQusMFVxHyY9oCTqc4BPhTugZxo7x3IRgOpIPAFKZUd1I/lc1inffEBhEK2qXMeVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791366867; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ax7ydheT35UqwM0kNEUGwxJmlw8R2Ecwooqkh/Tleyg86zLFRWGLxDanh6HKli9KxdDG7OP1p3DNVFDABZ7z1+meiaA6FsIfefwHiJcPmjIEFYAyywispz2GRMB7jNi/ZbhILQqz99gwVW7QzmT716rYMUZ4ZDnbcfNGP96yuvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StYG7fGz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StYG7fGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D141F0089B;
	Wed,  7 Oct 2026 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791366856;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StYG7fGzl2oFdJzZbSyQfq3kGjCR3jtCS830YAn+PzsVoXK7CX1K+kMbvctL3xy2S
	 gypMaZrd8WvVLFC1PCS7zQxL4rju9oX40VLf55waft7OUQw/IGpkI8G4yFhIjDj2Pp
	 AKz0S5NQlKLm1H6aWrEX57l2xWDg8jhmXfeYxVX7wmv1oi1HXaVmfYKy7i2yiGBPVU
	 thCGnSa2yHoMnUy91ul8s7UYq8siAGkixKqZhlIcWsuSeajKwLa6+YGeapMf+yoIZO
	 XhHv2wpF754gV79saWcGjrSI41qD0UuGa0fbr6oQQ6noZbuesHUONjNHrd8MiD9/X3
	 Yi5rxlW2pf/Wg==
From: netdev-bot+sinfo@kernel.org
To: Hui Peng <benquike@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Xin Long <lucien.xin@gmail.com>,
 Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
 Simon Horman <horms@kernel.org>, linux-sctp@vger.kernel.org,
 netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
Date: Wed, 07 Oct 2026 09:54:15 +0000
Message-ID: <179136685553.2527009.11350015706759524936@kernel.org>
In-Reply-To: <20261007095128.1370109-1-benquike@gmail.com>
References: <20261007095128.1370109-1-benquike@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
