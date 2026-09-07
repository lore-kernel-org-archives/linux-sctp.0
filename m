Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC673F1063;
	Mon,  7 Sep 2026 04:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753900; cv=none; b=RZnRM7TLfRKeRPkxrmvhyI7uqizDOvbfVBIW3ppUsDsaWvbDDzph0qJbny2XWAo9y8HIj0jvcRPmhUFInVL9ZDr43puBz59PUTBvMuN06yPJNBVabbqkRuSYWkVaHu6AUKJVCe49NDnM8C813EP2eLNZOKQiogd3VS6y4Ld1G+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753900; c=relaxed/simple;
	bh=geld1fy2QvBe9SZCEgi4WsuP/nt+AIAaxuC/yyGQYrA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NUKTAjSC02MlAamqgXKAF7kVoYb6cG8L2xd8fSl4PkuVZNQejdPy1lrRbrLlcotluG1FH3adx8uDLUxNrPRqEQQDAq/faouJ5rc9QKggQYKKJZUHKoA/NnqMPf/lRzRR6CHOGZ4quDCQ9yQGRqkx6SBu5xLignMbBzUBcZ0cSP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVPWgk+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVPWgk+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331DA1F00A3A;
	Mon,  7 Sep 2026 04:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788753898;
	bh=ypnefb5cBXr2rc2Y24PDf8nI76hplEhA0TW2ZY8sVCU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=fVPWgk+OW+iZka7GSqIwIg6nzU/rDOMmeuJFTL50cttcUbN3m/b8xIKvd49YFYS93
	 BT2w61axkJGI2FwviGdkFTQa4xfkHYOgO54zzSQFfkSasTCgdXo/ML18uwm2meR8k/
	 IykoGRYxn7wrrTW72J4V5yqWpOzJyHSnkUB3yf+384++xkIsq2qdna0OaswIXXndTk
	 8UtvePtsjLXwQUu3HLndOeGqlRlj/CXuF6S9DjksupxgEe9aoMC7s3i+WtIlBLR5t3
	 7ZWJcdSny9SCxUsoJweoT+WQHLjtw/6mwwUoqmB3uUdshR6mjeMU5IZSI4lmyuYT0U
	 3FfLiSI8GrVqg==
Subject:
 Re: [PATCH v2 net] sctp: avoid livelock while updating retransmit path
From: netdev-bot+sashiko@kernel.org
To: sunyiqixm@gmail.com
Cc: lucien.xin@gmail.com, davem@davemloft.net, edumazet@google.com,
 horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
 linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, netdev@vger.kernel.org,
 pabeni@redhat.com, stable@vger.kernel.org
Date: Mon, 07 Sep 2026 04:04:57 +0000
Message-ID: <178875389773.219967.10749525397271653040@kernel.org>
In-Reply-To: <20260902025206.phbpyxmpf4zrtdpx@sunyiqi-llm-kernel>
References: <20260902025206.phbpyxmpf4zrtdpx@sunyiqi-llm-kernel>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] The permanent part of the commit message (everything above the
  `---` line) is not a changelog.

--

sctp: avoid livelock while updating retransmit path

sctp_assoc_update_retran_path() could loop forever when every remaining
transport, including the current retran_path, was in SCTP_UNCONFIRMED
state, because the state check ran before the wraparound test.  The patch
moves the candidate selection under a state test so the wraparound
comparison is always reached, and restores the NULL guard before assigning
asoc->peer.retran_path.

Link: https://lore.kernel.org/r/20260827075006.3979566-1-sunyiqixm@gmail.com/

The code change itself looks fine to me; my only comments are about the
commit message.

> sctp: avoid livelock while updating retransmit path
>
> --jv3lfyjkrnvkybth
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
>
> On Thu, Aug 27, 2026 at 3:50 AM, Xin Long wrote:
> > After removing the continue, I think you can keep using
> > if (trans == asoc->peer.retran_path) here without 'last' needed.
>
> Yes. The v1 'last' variable was redundant once the SCTP_UNCONFIRMED
> path no longer uses continue. Drop it in this revision and retain the
> original wraparound comparison after the candidate-selection block.
>
> The reproducer is attached.

[Severity: Medium]
Was this text meant to end up above the --- separator?  Everything above
--- is what git am records permanently, so the MIME boundary and headers:

    --jv3lfyjkrnvkybth
    Content-Type: text/plain; charset=us-ascii
    Content-Disposition: inline

get committed verbatim into the changelog.

The reply to the reviewer and the v1/v2 discussion ("The v1 'last'
variable was redundant once the SCTP_UNCONFIRMED path no longer uses
continue. Drop it in this revision") also read as thread material rather
than changelog material, and the same information is already recorded in
the "Changes in v2" block below the --- marker.

Can the statement "The reproducer is attached." be dropped or replaced?
Nothing is attached to the patch, and there is no selftest or
Reported-by/Closes tag pointing at one, so a reader of
git log net/sctp/associola.c has no way to reach the described ASCONF
wildcard DEL-IP scenario.

Would you mind respinning with only the last three paragraphs (the
livelock description, the fix description, and the NULL guard note) plus
the Fixes and Signed-off-by tags above the --- line?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260902025206.phbpyxmpf4zrtdpx%40sunyiqi-llm-kernel
