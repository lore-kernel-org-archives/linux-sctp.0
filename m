Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9C438009
	for <linux-sctp@vger.kernel.org>; Tue, 21 Jul 2026 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784620862; cv=none; b=MP9/cd2KIHw6sVM2nPKfamkrPKDHCCfMYMMZL9aixLaOd9pLyWVIxUWqaveXW5hDy6BtSB2J0mi/m1gqLB2GTHboLekzskLFJiLtEtQ8ao63EjqjHRVq85K+7NxlRt+ve2iC/Y7GfRqBb+9iNG4evx3Ey9d5tQoleVC0mFxKGjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784620862; c=relaxed/simple;
	bh=yq5AesY3WbJ8Pgvq1fyy9I1ZZo28UY1oxpCoLb0euC4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=QBM1Wg5MkdjNch/jUhX9Oj9Y/gPVKUskBO9oru+Pt7ddZFtxA5Fzrzf9/0Co3Slxf40do7wAOO6X3fNA7N+nDobkgSyRAjl/pM1P/Cc733s9mjf/CEPAPVofYVYN9nHHaW2K5tWL3rTq3a6GnVQGMNTVLGOMWlGXKYw6uJ/OEkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtvOfEnB; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtvOfEnB"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81e9f7491ffso135406097b3.0
        for <linux-sctp@vger.kernel.org>; Tue, 21 Jul 2026 01:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784620860; x=1785225660; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e3R4qRYczJBnpWuDaBta6gvyeC66Rhl7Tf5bIRt5HKg=;
        b=QtvOfEnBVOjkTO7b9XsQMEvAd3ccoBj4nXQv6eaZL+4+9TVD/Rn1+M1IilNj0F6jl/
         DP4i9+dPzOtT7Zuc9TYRXK1dhKNEfABQitB0C+7R7PMl8f096c+Z60jwWhk5gldoUpdQ
         53JsL/3oZHyZ6vrvvXaDQnAKdtY+SRy0VFjlv2uswy91ubXPY9D+3R7FLoxbjGCJyEJa
         SumwAUS1VljWQxDg/3hmP8QJ/nNGSBGR7nRVloC2ZS18d58YIWCDU2PmclgSDxooOgiE
         IRQKHgOf8pIZ07SV1GwNmouhIXu2PBPfVXMIQABJIjLGhg/4L7n0DfJHGTgAy4/akhPb
         1HxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784620860; x=1785225660;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e3R4qRYczJBnpWuDaBta6gvyeC66Rhl7Tf5bIRt5HKg=;
        b=mF5T47y2mPqYVSpa/abnl2kh1akbJ59x7l+CLp2Y8TmIHvgvQonZRhvbq8zT8Awxja
         qPPcIM9fSsIVekYVk39CScQB69JwAG86E+rGlMnrLH55br4aY7DK2Q5tjT+O4iLXghQv
         4K+TB/WduLVRlNQN4apIrB9gka0CGwddC9q27diUHYj2eAmz3M76B9BgFevyE9rgMsJ0
         hH2xjRiyIkIb3wuxyXWskbOOraROD4mE/08jbetCjv6Ptz4n46uPionH2kYT48rRti+K
         33FHrIqhigzypodvZLTfsiJAFciP/d51JXBZN/DSogkpYU1IgDlS/GwGauqYOarpOvwk
         7nlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr+p0LbBV+Xh3Ag007etNlSCOFwe7CqHKfJYPNKzlqPBRhxfH1wVBcQe36Brb8oVVw3DzrALbQqHIgb@vger.kernel.org
X-Gm-Message-State: AOJu0YwrxHw2O4iPkOze9Fzi+09wybiEZdzTKuBlmxZZ9VjniwSlapXu
	iBgIFVuVAZw4IVUfoxh376tzA5SsMqle2dCWZfaPfE/wMF2uu+GjBfuLa9DcmRC3
X-Gm-Gg: AR+sD117OfMTqce7QzmGywCsxExyB5UksR5iiHI9vB3gY9agZjEl1uBgmxq51p85t9a
	7wrckFUu/fMihZBBP60PBe6tLXBsRQdmIuZGbzfClfB0m9GT0jpt1FI4zeAg6CZbbodRWcouhPK
	4NPJumCjKzDH07aRuUWUMa4wwrUDkj+YdIb6gGcAnS3+Iw6/XehECtVLb5eeuHRWJFJz/1A3dox
	xBmfwmkCFfHlR0QQvSwCrcmUUWhV71DsEqOf0Bi9DVaV2ysnIOHB5XnyA68C8Szf4uAbKd3HuJ7
	wa68g4bUQzIIxCvAHXhpidZ8NAiw5IY1jzWvxr+3CQrjd+Zg+FDskk6dvihcu+J/sauVftHA6yW
	w8nuzk8akfy0EhKCn+pSmxkUmfuMh0ipSfOhuHKT5qRJb53qtIrkDBVh/NW1gzRXX2HoHfH5V5c
	+f+iOVqn9PfFVLeXpHGAFERl19Dt7uFd9LE+V6kTbwTNit/YzS1MZh1GpEk7DiFEaseg==
X-Received: by 2002:a05:690c:3504:b0:80a:9ff6:c01 with SMTP id 00721157ae682-81ef285019fmr59688947b3.53.1784620860213;
        Tue, 21 Jul 2026 01:01:00 -0700 (PDT)
Received: from gmail.com (172.235.85.34.bc.googleusercontent.com. [34.85.235.172])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81ef4034901sm59680597b3.12.2026.07.21.01.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 01:00:59 -0700 (PDT)
Date: Tue, 21 Jul 2026 04:00:59 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Srikar Dronamraju <srikar@linux.ibm.com>, 
 LKML <linux-kernel@vger.kernel.org>, 
 netdev@vger.kernel.org, 
 David S Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Dust Li <dust.li@linux.alibaba.com>, 
 D Wythe <alibuda@linux.alibaba.com>, 
 Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Jon Maloy <jmaloy@redhat.com>, 
 Kuniyuki Iwashima <kuniyu@google.com>, 
 linux-sctp@vger.kernel.org, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, 
 Simon Horman <horms@kernel.org>, 
 Tony Lu <tonylu@linux.alibaba.com>, 
 Wen Gu <guwen@linux.alibaba.com>, 
 Wenjia Zhang <wenjia@linux.ibm.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Xin Long <lucien.xin@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, 
 Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Srikar Dronamraju <srikar@linux.ibm.com>
Message-ID: <willemdebruijn.kernel.53771955fa7f@gmail.com>
In-Reply-To: <20260714013940.4068189-5-srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260714013940.4068189-5-srikar@linux.ibm.com>
Subject: Re: [PATCH 1/2] net/socket: Record preference for synchronous wakeups
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

Srikar Dronamraju wrote:
> Scheduler differentiates between affine and non-affine wakeups by the
> way of sync flags. Scheduler prefers to pull the tasks towards the waker
> if the sync flag is set.
> 
> In some cases, socket APIs are blindly requesting sync wakeups. This may
> cause load-balance issues and non-optimal performance.
> 
> Record whether the most recent blocking socket operation could benefit

What is the heuristic that determines this?

If respinning, please state that explicitly in the commit message.


> from synchronous wakeups. Subsequent readiness notifications use this
> hint to determine whether WF_SYNC should be propagated.
> 
> The flag is advisory and affects only wakeup placement decisions.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.ibm.com>
