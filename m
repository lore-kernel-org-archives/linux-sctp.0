Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DDA43CE40;
	Wed, 22 Jul 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740125; cv=none; b=usd15Y2PyqkZwdQyru3Rz2k8hBZRyrbgwdczDwq30hHMXB1jHElrwO+rJsokvk1et2IgYooMdGLmsWkQEd42odfB93GNW+sGB7H40P81coDcG7vNoLz4058S77YNTugmjRfwN7RyhfP6Hy4MPbTEgu8m9Oudx8tnKgSf00wrCK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740125; c=relaxed/simple;
	bh=68ukbvbjFlDS/553huav/930plS/q2o/5U9lI2XyouE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5JqPOvwbfjeSYXqUbgaIdL6LxdItoQ2yMVoTJWxk5sJUiB1AF/583+VpO2FCed5lb11MyOsCj+1RbpsGhAgixm/TwuYbT2S3qa2A8T0rG9r15OOPtGU95EcX8Pl3CKfoUDe+SGEfeIB5oUVy0mBs07sITmoYlPNU3ImJbu0mGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J54G4Kve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J54G4Kve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978C81F000E9;
	Wed, 22 Jul 2026 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784740124;
	bh=CcpgTqz4oSwMtZriogIaHP0XtQXhQt1wXGdQRPgtt84=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=J54G4KveKJlg/9nm4Q7BPWv4G9Q+5qwARXdHuftgngZauhWCB2GywsHpE8ickiAsA
	 f0IO+nn0Q0m6sg/fithGFWAU5njbriTUpxix/WJdEji02jNbyZTdEVa8una1Y99YuD
	 yrqWDEuH04gatxyrYlUf+6yTzIZ635NNEjwCpNr9CJmijDqeKiRh3JCFIWtVtRezn6
	 9pLetVgxpg5Rn7Zf34Ch92Gn7LaOZr5+1UIZHCFPOwN1Qwksc+kv/w/7yiXZXDI4sh
	 7L2NgBboUNn5qTHHnJZ1EENqNWTlipwITVY+qS2E+LdqEebrvOHGZ15S/QVLwtlRcy
	 8x0ExmSO7uzqg==
Date: Wed, 22 Jul 2026 10:08:42 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Srikar Dronamraju <srikar@linux.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, David S
 Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Dust Li <dust.li@linux.alibaba.com>, D Wythe
 <alibuda@linux.alibaba.com>, Eric Dumazet <edumazet@google.com>, Jon Maloy
 <jmaloy@redhat.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 linux-sctp@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Simon Horman
 <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Wen Gu
 <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Willem de
 Bruijn <willemb@google.com>, Xin Long <lucien.xin@gmail.com>, Shrikanth
 Hegde <sshegde@linux.ibm.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>
Subject: Re: [PATCH 0/2] net: Use synchronous wakeups selectively
Message-ID: <20260722100842.602fd5d2@kernel.org>
In-Reply-To: <20260714013940.4068189-4-srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Jul 2026 07:09:41 +0530 Srikar Dronamraju wrote:
> The scheduler assumes in several wakeup paths that a task using WF_SYNC
> is likely to yield the CPU shortly. However several networking wakeup
> paths unconditionally use synchronous wakeups even when the waking task
> continues execution.
> 
> During wakeup, with WF_SYNC flag set, because of the assumption that
> current thread is ready to give up, the wakee thread will be migrated
> from any core within the chip to the current LLC. If these operations
> are frequent, and wakers are actually not going away, then it will lead
> to load imbalance and hurt performance. This is especially true in
> architectures where LLCs are small and number of LLCs per chip are more.
> 
> Running vllm workload was run on Power10 system
>                                   No patch      with patch %diff
> Inference Time (sec)              17.84         16.35     -8.35%
> llm query bandwidth (tokens/sec)  14.78         16.21     +9.68%
> 
> Lower inference time and higher tokens/sec is better.

Somewhat related recent patch:

https://lore.kernel.org/all/20260708133815.3419465-1-usama.arif@linux.dev/

Maybe other maintainers will chime in, but I'm not convinced 
by the heuristics you're adding. The behavior will be workload
specific. The extent of networking involvement should be letting
the scheduler know that we're waking from IO, not leaking scheduler
heuristics into networking.
-- 
pw-bot: cr
