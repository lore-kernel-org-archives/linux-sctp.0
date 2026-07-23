Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED543FFFAD;
	Thu, 23 Jul 2026 08:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795554; cv=none; b=IfWaA160yS02Xugj0O0z2C4+Be+JUEikZsXeF8VFnZe3e+xdUclrFIdZsVNAwmU4bNfxz95l5kAh/DijO4puaZyM7DusEKXjl5BeehHMU23ecQSYbFeL/mgeq1Bg6ohiRdXAQ39G3gFOmzQYQAGmQgiqlBlE4dfuLu50EMFXpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795554; c=relaxed/simple;
	bh=lhBjB+2TsHb6+Ccx1Cni6AxQNJDYMCfAoVmnM/NpLh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CF07HYgMgi1pCV/lusJ1sO4MRqpVOy9Eq1EmQsEu0a44Eb6jFa3CMXKny1z+vSXGQaTDR2pIzCNNZ1WrIsKkO48aRXlUy/oFnQx4v9fpfe6YtVHZ7dKwlSCPzzCVCYJRWi8gLIgV8x3gHaG9kNB0iRYfUNaMhR7RiI8A9q3XJNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HQhyVga8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HQhyVga8"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N5Bjhf2077558;
	Thu, 23 Jul 2026 08:32:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:reply-to:subject:to; s=pp1; bh=c+FUZdiNT7tXfqPhAPbj+
	rtyAQgUJP12JalPT8RXPOc=; b=HQhyVga80SqKIvYOvAiVBknKWu7YL4MmIwHaf
	cBCc14aKCGd9OW5W2CFUSECmVmhkNPhcYpUav2RK+Ht+rtK2GGQf4Dp2ZNpsKFk/
	nN1rclv2F1RInu5+WahCd3wev7nMqRZE/1AjS664M/3BBWrlbgdpJriIKBokJyCy
	6QICJd4mtmQ8KAvay/Nz0hvRUjgF1AI/r3JxfoBJzmd9/cduZcfL7iyU9jDcDb2K
	CpDSSPTeNaXs3xHukGmWoXUt83wBfhne1uS2vJRLYXuikruU/7e3nLUJfC/AyOyI
	ONsYFWKNXoyqTQ5WK7uI2G6S0DiUqQsKvSu0TmiEkGyR+gYNg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahdyx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:32:04 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66N8JbaL008377;
	Thu, 23 Jul 2026 08:32:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyk11e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:32:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N8W05S16253434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 08:32:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 171692008D;
	Thu, 23 Jul 2026 08:32:00 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6EE02008F;
	Thu, 23 Jul 2026 08:31:51 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.126.150.29])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 23 Jul 2026 08:31:51 +0000 (GMT)
Date: Thu, 23 Jul 2026 14:01:50 +0530
From: Srikar Dronamraju <srikar@linux.ibm.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        David S Miller <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        D Wythe <alibuda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, linux-sctp@vger.kernel.org,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Simon Horman <horms@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
        Willem de Bruijn <willemb@google.com>, Xin Long <lucien.xin@gmail.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>
Subject: Re: [PATCH 0/2] net: Use synchronous wakeups selectively
Message-ID: <amHRdk5tkSr2Vzs6@linux.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260722100842.602fd5d2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20260722100842.602fd5d2@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: gBDUMOTqksB7WS-IKq230r8syThLwURb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA4MSBTYWx0ZWRfX20svQmYtpXr4
 QNkjDHwUlyhw91+5TultYn71vyTzoqkFLjUjJAJ56LqoEz6K3GQSq3M73KXoOhXlf/a48WkiSBf
 FqE5t5HWzdQTd+U3h4V+X6lT5zUpoEDPTP91hugnkLKACtnfJY5nDj4bmCQuc6rE6Bks1+0q2KS
 uRupy3SFPmKZIJMoQSWguX18KT7UNF2q0Ykp4AWt9s/5wSmibzRvsww+EkDT9A6sApwb5fVyIvn
 0w47lLZapEJHNnhcO1aiieE7GUflYt83mQX1mdP2I9QuiBH9mw0kZ7Zilzfu30iqmvwn1qyQ5rq
 n04TGWJmzgMB1vTsAS1WYwJzWRAOofHkC3WXkiTHLwfX1wHIMwtJudQ7ZzfcFh1oxWIKt4h/Y2F
 g3Mj9MZtQ1fWmq3dcxKkPEj5Zm+Ui2ZYahIbkXXpgyNwbBlXuFwHUog8BXp9pd3megZDEf+vu8m
 +Ho6TWmGk3P4aVvhMDw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA4MSBTYWx0ZWRfX/GSGBYxvgs3L
 Hr5KpBgC8qtlSxGH7x3BX8Ubbx55/I1gyhHTr2+AJB7H4VEhZB/sCMhOCDlZ8XrZ5qOZlQE5Thl
 trZUZd2iUKG6NhhG5L4kyCVRmI//P1I=
X-Proofpoint-GUID: -RfhO8uj95oMITfJOEkCx0vG8svLRrr1
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a61d185 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=8nJEP1OIZ-IA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=ozsKiyzDmcquE6yYZPIA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230081

* Jakub Kicinski <kuba@kernel.org> [2026-07-22 10:08:42]:

Hi Jakub, Thanks for taking a look.

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
> > architectures where LLCs are small and number of LLCs per chip are more.
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
> https://lore.kernel.org/all/20260708133815.3419465-1-usama.arif@linux.dev/
> 
> Maybe other maintainers will chime in, but I'm not convinced 
> by the heuristics you're adding. The behavior will be workload
> specific.

Currently scheduler provides 2 APIs because it supports 2 subtle behaviours.
1st API being wake_up_interruptible_poll and 2nd API being
wake_up_interruptible_sync_poll. The reason scheduler provides 2 APIs is
because the scheduler cant decide which behaviour the callee wants.

If the scheduler could have figured out which behaviour then there would
have been only 1 API. So the onus of using the right API is on the
callee.

Now the behaviour between the 2 APIs depends on fact that the callee is
going to give up the CPU now or if the callee will continue to run. If the
callee is going to continue to run, its better to use the more generic API
of the two which is wake_up_interruptible_poll. However if the callee is
giving up the CPU, its better to use wake_up_interruptible_sync_poll.

@peterz @ingom can you please confirm this behaviour is inline with
scheduler maintainers view.

Currently the networking code as I see is unconditionally (or blindly)
asking for sync behaviour i.e the socket API is saying the callees are going
to give up CPU soon. However the problem I am seeing is the callees are
actually not giving up CPU.

> The extent of networking involvement should be letting
> the scheduler know that we're waking from IO, not leaking scheduler
> heuristics into networking.

In this change, what we are depending on is file's flag that the socket
request is blocking or non-blocking. So why do we say we are leaking
scheduler hueristics? Would using an API or another API mean leaking
scheduler hueristics?  If we are blocking, this change will use
wake_up_interruptible_sync_poll and if non-blocking, it will use
wake_up_interruptible_poll.

-- 
Thanks and Regards
Srikar Dronamraju
