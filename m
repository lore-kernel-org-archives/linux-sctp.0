Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C65E34EEF7
	for <linux-sctp@vger.kernel.org>; Thu, 23 Jul 2026 03:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776642; cv=pass; b=c89Jl/kHz3kRAP21Ui1pswmCItScZyNhiBhvDunTFWVdIZmg1DEd4tggPlMRvsgPN9Qg/PYBjZmiK5QXrpXbr1VpVH0/eQxoRjYMC3W3w/kFUDc4SCpIBhu+CS+a9v1h4VMbm2tlXS+5lYJWaEdP5/lf2ea+P2xYEqohoSVoTAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776642; c=relaxed/simple;
	bh=/19X+XTfIBIuI9fO1VZJyXOTsfu9qbVPKVTHHFi6RYs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NzGmg5HfgKx9znwd/fiWYM80AH3NsN/kVn1H6fT1NnMI8MkRyZ3foQLpipxfw6w/rr4h9eEsw3epUEh9XHl46hcbYP6j3kdZv0SnGmdCo6n3vYymFhxBbT9SSaoUmBH6H111V5Adq8Ct2sKHha9DFw3UWFdVIjZXStWnflAGjEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tynLym2r; arc=pass smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tynLym2r"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92edb12cdf2so10523085a.3
        for <linux-sctp@vger.kernel.org>; Wed, 22 Jul 2026 20:17:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784776640; cv=none;
        d=google.com; s=arc-20260327;
        b=sOf0Dww5C8dfEosa7WRbTRTVJHF0yb1PaRsqpnniBi24VoMd9sIbFnGVx4XnK0e6B/
         Up0RhOaXOOTrR0DZiv8bMczMIfxKfV0AIcC9JgDcBnxqokahqKv16WyY0F4XjrAr7d1A
         m6y2/3Lbz4U1en+MaOSDmkdXsPo0wr4cGu2VHB2yBGh1UfIh8TvnrKaaVtaSoSu4fXSP
         5ch854EptLw/7IqJlXyZ0tSsq9pBV3/SBUvodZUFY1PiwCQeUNhfsbE2sKU0bWAnWoQH
         jUvqrjjxBPDQVgAPcBY7rD6AnrU4QZaNkqi0S6t9fHW5b1Ex/bJJXtQznkKe/y6yX9W/
         E4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lX/zr1mEWyW9mjUIKmJHBct3N8j18Lej+ugTKOX1vbw=;
        fh=GLHuHpDl0LmWth5veYM0MnH55VKOXD9buECFEm1ln0k=;
        b=NVIZBEjPqRQm6xMEbCXj255QeIwNdHEkSr9nlIMZ0spNMpeyfAhXGZkp8almWAAd3v
         XfOeqvtKZupzuUEwfMgklwtTYfkerPX6lilnajAFW+tKZGc7SIhU/RxLSX1r3YOioqM6
         gEDO4VOCUBt78K5JNfgIybggwdS6vrS3L1iC081oR2HzRJawi6bVTWj/C+nRi5FTAFVP
         uIbIsGdeYMcb8wSTewAdxHib5FoUBKBhgIA1JEZDiUlSTLLn6U/Hu9xbxTIJlRvMdFfj
         2awVNzmHcOXr24oARIvqwGQGwQAkosy23A6vmfgI9pF5Tk4VW0CTZToRE8kyUQ6vLwmQ
         +xlQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784776640; x=1785381440; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lX/zr1mEWyW9mjUIKmJHBct3N8j18Lej+ugTKOX1vbw=;
        b=tynLym2rXllbv4sr6y9eWYtwW1m9/fi+fja+83UuQ+DjVDq9ulHX7Sy1I617dZYBbX
         rcdDT5qWfkycs+3pjO4hJrFRl8WkCyC9V0VhQfmiPtTqi+S9owRO3w5aHhm7v6N4BQW/
         sNZBckt9zdn68zvVglnuaheTn+oFOuXBuvIaco6CnPDR4YwdQFFwiCU5FXBSibtDD1L6
         T9mLWro+ex5Fz20AUxrGGORWPpMpGfjDbYKni9T7fFGxqlm0IHnn2wLdBtT/mZar7hZO
         0+Louh3yWffe15EECH0shU505jcHtdaW7yZMYkcdLLUqqUPetnsncxp4803YxLnkmJli
         4XTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784776640; x=1785381440;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lX/zr1mEWyW9mjUIKmJHBct3N8j18Lej+ugTKOX1vbw=;
        b=S4Zb8ScAdWaew3DPfytiqBDNgHk4s5xPXCMTzIIbrtT7DA/gIA87kdUKd/cGoiO58Z
         78QA3SEZEZLmZ1LpU2JMt2ltoffs3a6Wr2PbJvTNDbBOdDIzoj46BRBOsYrRA+uYwcy5
         g1INz7WTYbvIVLVMOjd1p/nlNTyOWq7mAOOYHoMMtd2G68xerQur4dGMl7H+3f/19rpR
         cysC6Cv1s+sH/GSIGgwLlJ7wMXClTmydxPVqXADqeu/U7us0ZR/LXo1nQIeg6jlvx8ZG
         v0isUO0IqAw7a2FWzbI0R4SxkJm2DmDEQ4/DzgEftMCGE87e32mzMpJ69R5m1qxVWeD6
         NDLg==
X-Forwarded-Encrypted: i=1; AHgh+RquwPMWJyTtE0TLhbBmM9puacTYKYI5Jcv445OqU+XIvZy/QVlT7qAt9s2yerUk+ttoXhH97Rylx8uJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwqKE4PbgfLKbzNJkVyIHb1cmTclNYMnQXqOVOhU/0fTX6WxH8k
	/E4CaBSQyxHm7zpABoW5Bwr0sgyKm28D9zsIq91vOuI6Y97mFPYYfn6a3YW4teDxuQInJ1HGo9P
	deX7ihSaNTj/PGhTewiK3ImLRjqLzf8M1H6zL9+hy
X-Gm-Gg: AR+sD11Se+UUidssspN7LFQzeg7Pp+6eQ7mpzS9w1kdhTl91vSzgHZ/Xbq6AFEf0gne
	LKPUG7lVSShcBw4zXg2tOgkppzqAR/dKwrLZCaeT/WvMVU4XEWf0570joadDgKSll13za6Z364V
	K1oN2Wo5f/D7yohIh1yjri07wg7zUbIBkFTzbalHPlsLArDvlqghGcbfD2L+kYw3lMa1+dhlx/h
	HTH2KYKFkUfN/k3ZXqu1eyGHyWITYLTTO/1TJ1fm3/sIf+iSqA9yixMExg4bQykFrApJ22DTpmB
	RFT+yZFxlxn+7RJpfVYGawEUaaJfasB0l1QExKEB0zXQcnXDVfl/OOvFCUmTUQ3MI1hZQPY=
X-Received: by 2002:a05:620a:6310:10b0:92e:6338:cedb with SMTP id
 af79cd13be357-93103728115mr110555685a.73.1784776639229; Wed, 22 Jul 2026
 20:17:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714013940.4068189-4-srikar@linux.ibm.com> <20260722100842.602fd5d2@kernel.org>
In-Reply-To: <20260722100842.602fd5d2@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 23 Jul 2026 05:17:08 +0200
X-Gm-Features: AUfX_mzXeD6cj2fqrkt8d5aPZRvpbpGrPEZnPgET9lecz9ToCyfFIPgNk-oFujE
Message-ID: <CANn89i+o3rT6Jnx_6SK2vdmeuHVkZwTJXD++Kua9ZCJb-wVFHg@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: Use synchronous wakeups selectively
To: Jakub Kicinski <kuba@kernel.org>
Cc: Srikar Dronamraju <srikar@linux.ibm.com>, LKML <linux-kernel@vger.kernel.org>, 
	netdev@vger.kernel.org, David S Miller <davem@davemloft.net>, 
	Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Dust Li <dust.li@linux.alibaba.com>, 
	D Wythe <alibuda@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-sctp@vger.kernel.org, 
	Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sidraya Jayagond <sidraya@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	Wenjia Zhang <wenjia@linux.ibm.com>, Willem de Bruijn <willemb@google.com>, 
	Xin Long <lucien.xin@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 7:08=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 14 Jul 2026 07:09:41 +0530 Srikar Dronamraju wrote:
> > The scheduler assumes in several wakeup paths that a task using WF_SYNC
> > is likely to yield the CPU shortly. However several networking wakeup
> > paths unconditionally use synchronous wakeups even when the waking task
> > continues execution.
> >
> > During wakeup, with WF_SYNC flag set, because of the assumption that
> > current thread is ready to give up, the wakee thread will be migrated
> > from any core within the chip to the current LLC. If these operations
> > are frequent, and wakers are actually not going away, then it will lead
> > to load imbalance and hurt performance. This is especially true in
> > architectures where LLCs are small and number of LLCs per chip are more=
.
> >
> > Running vllm workload was run on Power10 system
> >                                   No patch      with patch %diff
> > Inference Time (sec)              17.84         16.35     -8.35%
> > llm query bandwidth (tokens/sec)  14.78         16.21     +9.68%
> >
> > Lower inference time and higher tokens/sec is better.
>
> Somewhat related recent patch:
>
> https://lore.kernel.org/all/20260708133815.3419465-1-usama.arif@linux.dev=
/
>
> Maybe other maintainers will chime in, but I'm not convinced
> by the heuristics you're adding. The behavior will be workload
> specific. The extent of networking involvement should be letting
> the scheduler know that we're waking from IO, not leaking scheduler
> heuristics into networking.
> --
> pw-bot: cr

In any case, adding code to the fast path in every network system call
is undesirable.
