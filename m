Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBEF4369A;
	Wed, 30 Sep 2026 00:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790726817; cv=none; b=ixxO7/D4+o//sTcEi1ENF8V0lNEe5mLiOkA0prAyDVd88Z8D9Df/viKSXP7tiRXZFdcYW+wQ6kmlYRx+firGEAHwEkQahNZ5QNO4bIlyQY5RdruJZgzcpdo6DsLLHb+MDb3OoyqR1xwBmMoI7QOfavdLaM+4jddG7DkqYQfY3TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790726817; c=relaxed/simple;
	bh=63Jp0evF0M4ucdUFVuaFEUDi0mSJvzbzlt2go9iL0zc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tp0qQvnf+M9bZvPVphTbgTSwZxBw5OyuiOPuilARnBMreRSY4AROQhCRQMk+VzjZV9sjeDBCR8DVVoHPVwX/hhRL7DNNZtURiQANIestcGQ5K2DSD6WimDjnFVUUu1YOTENdetEjNd0DjT4Z7G/scnQOKYM9VdvoCC9Jqt+kG4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k0QSIk8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k0QSIk8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AF81F000FF;
	Wed, 30 Sep 2026 00:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790726815;
	bh=KZNeWJWiaTQnToZiLYCTXPvWZ09fX11/qRuUSoJnFe0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=k0QSIk8zFvICPq4Lhs4ZhWxKc4LG1+9ZFP5cxlqIdr8JqLEKhJZ0soo4vAbPqdxUP
	 U6H2ixmk667Zs6VWCq5y64vUYvXeaGgkwpEMHUPv8g6KsFhFbdObRSzxT8FENgT9Si
	 E95fufYrCCcjKHMnqCp6tyVm5RJQB/ddA3bHVN5SEIB31YUas4vhvs0tD889g5Qy5e
	 CqqsZ9AXjVywpb4zCJGnFhAYX1clxMpAn0P/ZjE29yzKoCmzVOO8mbhG51baWdbAIv
	 jEnvFNF1CIXPHWGisxbkaVpdFFV4Gu3EQpBl5fANt161l76oIbMlZYpq7ORVU/Q4Ea
	 uCuOvGacNxpxw==
Subject: Re: [PATCH net v3 1/2] sctp: hold shkey across socket migration
From: netdev-bot+sashiko@kernel.org
To: juny24602@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 linux-sctp@vger.kernel.org, netdev@vger.kernel.org, david.lee@trailofbits.com,
 kylebot@openai.com, junvyyang@tencent.com, stable@kernel.org,
 corvus@tencent.com
Date: Wed, 30 Sep 2026 00:06:53 +0000
Message-ID: <179072681379.434549.16278864761662817865@kernel.org>
In-Reply-To: <20260926100359.78731-2-juny24602@gmail.com>
References: <20260926100359.78731-2-juny24602@gmail.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit author, David Lee <david.lee@trailofbits.com>, has no
  Signed-off-by line.

--

sctp: hold shkey across socket migration

sctp_sock_migrate() orphans queued tx chunks before moving the association
to the new socket. skb_orphan() calls sctp_wfree(), which can drop the last
reference on chunk->shkey before sctp_set_owner_w() uses it again. This
patch takes a temporary shkey reference in sctp_clear_owner_w() and drops
it in a new sctp_set_owner_w_migrate() helper, after the new owner has
taken its own reference.

> Fixes: 1b1e0bc99474 ("sctp: add refcnt support for sh_key")
> Assisted-by: Codex:gpt-5.6-sol gpt-5.5-cyber
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> Acked-by: Xin Long <lucien.xin@gmail.com>

[Severity: Low]
This isn't a bug, but is there a Signed-off-by missing for the patch
author?

The Author: line is David Lee <david.lee@trailofbits.com>. The only
Signed-off-by is from Kyle Zeng <kylebot@openai.com>, and there is no
Co-developed-by tag.

The original submission for this patch seems to have come from
david.lee@trailofbits.com. That means the submitter has not signed off
either.

Documentation/process/submitting-patches.rst requires a DCO sign-off
from the author. checkpatch.pl reports this case as "Missing
Signed-off-by: line by nominal patch author".

Which of these is the intended attribution?

  - Kyle Zeng is the author. The patch would then need a From: Kyle Zeng
    line and a sign-off from the submitter.

  - David Lee is the author. He would then need to add his own
    Signed-off-by, plus a Co-developed-by for Kyle Zeng if he co-wrote
    the patch.

The next patch in the series, "sctp: re-point retained control chunks
on association migration", has the same trailers.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260926100359.78731-1-juny24602%40gmail.com
