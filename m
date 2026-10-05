Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04FE49E5C9;
	Mon,  5 Oct 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791219998; cv=none; b=YGr/rWOazMVmWCsmbTn49V0gcmy+V4HsuKSsnoEtN+EdM5IMtf49xlARjrbdMAQDYWOB56qWtEDYhA7ub1LdIQNQZu6Y2wXBX+1veEoTv6cViPY+/hDGuuAeRHfS22DAI/suA7W0+Lczuj49RAuERzUJEpLqJ99Vnw4Oclu6bf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791219998; c=relaxed/simple;
	bh=8F8mSAW/k0eqIcHQ70tsevziv6GXTDd+oboqu2EBDCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SpJY2c8TMIKIWeQhmoxMi3+wqdSg/hEWR0CQXbiK9S4k5SivXtAkkJW6WPRb68EsjT8cunFQruvWAuv6SHQundv2GaxwjFGBgVC5FpNvmw1JVW3Yk2F7fWI8vDtkXIYofk8JjIkBWs3Boz2sOIwd7Fm0QQ/4zOyL8zPkqkYnkww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6xEddsM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6xEddsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5641F000FF;
	Mon,  5 Oct 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791219996;
	bh=v1Q6rTSslRIJu2shXHuYe/4dJXnmArSwjWE/5GtfHoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j6xEddsMVUnL2AuBgy26TFlP0pQuJmVipOXBVxzgB3k9ICirf6YzU1pOsvL2f/W6r
	 aXB6gtOP1hrzbbMMcSMnGsPe69Jva3Cm1qHL3Qzi6L3+Tc0mHPw9sEQ5QnQqna0pV9
	 rXVZ/Xev94L+m4mMp5YRNaJQL8b353/UsbPAumkeol098PIHDzOXUrpPWoAoiNNAHN
	 PJdE80mrd/Ot7H5QEhoDEKzuZLEOXcF17eAR/kjBeNpWifAXoBR1SYmDNIWwcR9qgb
	 hci7As2yVTkTES8m8lP931ZjQTPTCARvzSTzDjvCDlwLQDD3huCiECEoQfeY54YHY8
	 08lvDQiTJBa+g==
Date: Mon, 5 Oct 2026 18:06:32 +0100
From: Simon Horman <horms@kernel.org>
To: Hui Peng <benquike@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net-next v2] sctp: copy zeroed stats to user in
 sctp_getsockopt_pr_streamstatus() when !streamoute
Message-ID: <20261005170632.GB83879@horms.kernel.org>
References: <20260930044611.204739-1-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930044611.204739-1-benquike@gmail.com>

On Wed, Sep 30, 2026 at 04:46:11AM +0000, Hui Peng wrote:
> When an SCTP stream output extension structure (streamoute) has not yet
> been allocated, sctp_getsockopt_pr_streamstatus() sets the local stack
> variables params.sprstat_abandoned_unsent = 0 and
> params.sprstat_abandoned_sent = 0, but then immediately jumps to 'out:',
> bypassing copy_to_user(). As a result, when an uninitialized user buffer
> is passed to getsockopt(SCTP_PR_STREAM_STATUS), the kernel returns
> success (0) without copying the zeroed stats back to user space, leaving
> uninitialized data in the user buffer.
> 
> Refactor the !streamoute check into an if-else chain so that when
> streamoute is NULL, params is zeroed and falls through to copy_to_user(),
> copying the zeroed stats to user space and setting retval = 0 once before
> returning.
> 
> Tested in QEMU against Linux 7.3.0-rc3 using an uninitialized
> sctp_prstatus user struct passed to getsockopt(SCTP_PR_STREAM_STATUS) on a
> freshly created stream: on the unfixed kernel the user struct contains
> uninitialized stack garbage; whereas with this fix applied, getsockopt()
> copies zeroed stats into user space and returns 0.
> 
> Fixes: 28b7eab0f910 ("sctp: add SCTP_PR_STREAM_STATUS getsockopt")

The hash cited above does not seem to exist.
I suggest that the appropriate fixes tag is as you had for v1:

Fixes: 28b7eab0f910 ("sctp: add SCTP_PR_STREAM_STATUS getsockopt")

Also, the patch should probably be targeted at net, again as you had for v1.
I realised that Paolo suggested net-next, without a Fixes tag. But I
believe the premise of that suggestion was that he felt this was not a bug fix.
However, Xin responded stating he thought it was, and I expect that carries,
especially when combined with the updated patch description you have
supplied in v2.

Please treat the above as FYI at this point.
I do not expect a repost is required at this time.

> Cc: stable@vger.kernel.org
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> Changes in v2:
> - Re-target subject tag to [PATCH net-next v2].
> - Remove redundant retval = 0 assignment in !streamoute block and fall
>   through to copy_to_user() as suggested by Paolo Abeni and Xin Long.

...
