Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195203;
	b=RsYwoXZSW8bdxv/RJNWzBnME1hvyG025HzFGMJo3+7ubyRY5Li+9cVoMN2LjJeCwaM/w
	 S9AOJ6Lnd7s2fz0vA3rONaCIpZ/Pw4MsAw+wAULE1cQt+fs0dQd53Z8jw5OjNzZvxu03j
	 TD7lVUhFBaAp/PDLujRjj3xgP/HNI0TiUETBAqMvwlsLFg3noy3a8cWv5o3M4JrFmXTDj
	 EmhoswTUjGLNjJfMRwWsByz25rMV2Izkv3P74Vcfr9f84ggumlCLRUv/N32YXx7PN4blV
	 oDUYxRPJTJJlXjoFCUTYPXCFNkJhLcs9U4fO9rD7ypTfh79aWA7el9VXYHNnCTA4sMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195203;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=fSXkQFvYokTP7/zdJJbPcVi6eQ2VnCwRvk+/9wXmlm4=;
	b=Yz9CiQYer5QvgbQ5ivwjxxlAb9X4BEdH1IWDOSnoHzc7l9XBf8xNf/M0X5TJpG2jRYqg
	 /IGyEQdJf8vMK6126pO34TzbhVtn+LKnfUVG1g4NyzbfWyC9UEmU9GNgFWxBU1gj1R8q+
	 vgnblCK/uika/mR4uElCs7sPrTb972QAG6XsBz7ESkFy47l0Grk0D29edb4xbz/d48jq/
	 G503WYD0/d1/obL+2Mlz70ihQpxrf+7BeVQ01ulXPB4d4JZuz5yMy6CAEfJ/nP4Jsc+DW
	 27eXK4Tb/qiSY17306gmuVN2pklbtdYGWt0gVbCRZoJAJ2jTL51PV84VrqgbJfNEOcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n2Ut93IM;
	arc=none smtp.remote-ip=91.218.175.41
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47B1606A336
	for <linux-sctp@vger.kernel.org>; Mon,  9 Nov 2026 03:33:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E47B1606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=n2Ut93IM
X-Envelope-To: linux-sctp@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fSXkQFvYokTP7/zdJJbPcVi6eQ2VnCwRvk+/9wXmlm4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794195201; v=1; x=1794800001;
 b=n2Ut93IMk5wbYHQpCRpxNmGWhRns/ZPjp9DMBNrDWYFmhQP74+eMYgCdXzahxev+pTxZnazP
 xnQhboH/v4FuZZ8QVZCP0Z094K/Chq9zfsEgguqN+oS44UU12wB7FjiBxK6GQNAj0vk9FEdsAEB
 BoNJz6MIpRHleeX8plCJBxCU=
X-Envelope-To: linux-sctp@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1b12e287425c2338;
	Mon, 09 Nov 2026 03:33:19 +0000
X-Mizu-Trace-ID: 1b12e287425c2338
X-Migadu-Flow: FLOW_OUT
Message-ID: <dbdb9385-89cd-4e4f-bfb8-b72510e8801b@linux.dev>
Date: Mon, 9 Nov 2026 11:33:09 +0800
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Post: <mailto:linux-sctp@vger.kernel.org>
List-Help: <mailto:linux-sctp+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sctp+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/14] net: annotate data-races around sysctl
 knobs
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
 Paul Moore <paul@paul-moore.com>, Matthieu Baerts <matttbe@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Julian Anastasov <ja@ssi.bg>, Allison Henderson <achender@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond
 <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-security-module@vger.kernel.org, mptcp@lists.linux.dev,
 lvs-devel@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-sctp@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAL+tcoDvFNAZubOjw9+Z1eyaVeiBzt_Xg3KMNucY879bg-ZLow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/9/26 11:11 AM, Jason Xing wrote:
> On Mon, Nov 9, 2026 at 10:55 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>> While testing the recent sysctl range fixes I noticed that a lot of our
>> sysctl knobs are read with plain loads while the handlers update them
>> with WRITE_ONCE() and no lock, so KCSAN reports them as data races. I
>> then used an LLM to go through every ctl_table under net/ and list the
>> readers that were left behind. This series annotates them with
>> READ_ONCE(), and adds WRITE_ONCE() to a few custom handlers and netlink
>> paths that store to the same fields with plain writes. Most of it is a
>> plain READ_ONCE() at each read; where a function reads the same knob
>> twice to make one decision, it now reads it once into a local, so the
>> comparison and the value it acts on cannot come from two different
>> writes.
>>
>> There are no Fixes tags. Done one knob per patch this would be well over
>> a hundred commits, so I grouped them by subsystem and feature instead to
>> keep the review manageable. If maintainers prefer, I can split it up
>> further with a Fixes tag on each one, as several smaller series.
> Over the last year, I've been thinking about the annotation stuff
> especially around sysctls, which, I suppose, shouldn't actually affect
> the real workload but does affect the outcome of the syzbot.
>
> Out of sheer curiosity, my question would be what is the point of
> trying to change all of them? Or what kind of benefits can we get from
> the big series?


Three things:

1. A plain load may be emitted twice by the compiler. ip_error() compares
peer->rate_tokens against ip_rt_error_cost and then subtracts it again;
if the sysctl changes in between, the u32 wraps. A few readers have that
shape and now read the knob once into a local.

2. Tearing is not involved here, all the fields are at most word sized.

3. The rest is the memory model: a lockless read of a field written with
WRITE_ONCE() is a data race unless it is marked
(tools/memory-model/Documentation/access-marking.txt). That is what KCSAN
reports, and why most of the series is plain READ_ONCE().


I think the benefit is doing it in one pass.


