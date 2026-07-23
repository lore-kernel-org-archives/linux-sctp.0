Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CE440B38A;
	Thu, 23 Jul 2026 08:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796650; cv=none; b=Cu5RXX7xDbgVT2Vjc33HCK7xexkgSQjeq3KKlSnTvgfcLB7GNPW1yeUewEfX7zn6vk826O4HPFmyY6U4oKp5hhrV4lmObU2uDCkbE3hyBHSTvSN3tD0fcF6Chx3P2S4NFAnYHI6HKVzTMi/sEI9qiNRbHBsvXYzdQ9zB3zDOK44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796650; c=relaxed/simple;
	bh=pIoJJ+SvhA2scIPPdaE5gO9ZSsxtn74V5LEKtd+uCaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWduA74cnsYN1McEHGtf0FT4qMW1SZI5vtZkDkyTPrBvqvATep+1yUVOM5MV+mXw/QtGj86dWZ+VYUhly5Or3tlCXKmnncdPJNvLXfzMZcEp8QpDGWZ2JsvTGl1TEbOayL7uwVSm0jW+gWoUoZUgaACQ8vlGXNPc2/MruJHD7FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PO7qWhec; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PO7qWhec"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N5CEEd2083549;
	Thu, 23 Jul 2026 08:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=aG61y+rsu387gJEseZ9ne6+r183i+18z1QBwWqmKFR4=; b=PO7qWhecorUI
	s6Gbmmn3ppa6g9hvgHQnb93ieXavc2vvj8b55PdSVwAvoEnUNoWjHwU0N5BAFOM4
	Dw/jc5TO3QiIUthYDoEK3VxCrUoh3dKADMHaEx5OHniVr/rIv4XbewVJ+6YcJfHk
	bq6kDHesmMDjN+a2h9tgcLWmYF7mlVWr7TE9lK0rhS3OZkkMZEE+aysQw8rhJbDT
	fY5+vW2zuU9OF2lMpp+sZ7N745jxFZy9kRD5HV7xADNGwA7OxAJzFT8C3PiCp12a
	ZBxxBM06z50qEUu+1bRr+iIljyUNs4F0cThxckqc/OuRGbhWsh+kk/1RbiIV6Uqj
	bGbBCr+IXQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7916nbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:50:21 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66N8nos7022595;
	Thu, 23 Jul 2026 08:50:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1gk5f5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 08:50:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N8oGuY16908722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 08:50:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15C7320098;
	Thu, 23 Jul 2026 08:50:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E413E2009E;
	Thu, 23 Jul 2026 08:50:07 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.126.150.29])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 08:50:07 +0000 (GMT)
Date: Thu, 23 Jul 2026 14:19:56 +0530
From: Srikar Dronamraju <srikar@linux.ibm.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, David S Miller <davem@davemloft.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        D Wythe <alibuda@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>,
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
Message-ID: <amHVtLnO7R2snG4L@linux.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260722100842.602fd5d2@kernel.org>
 <CANn89i+o3rT6Jnx_6SK2vdmeuHVkZwTJXD++Kua9ZCJb-wVFHg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+o3rT6Jnx_6SK2vdmeuHVkZwTJXD++Kua9ZCJb-wVFHg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: BDBsCyZq3H0b3cjmSqe402FANmvFSrr-
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a61d5cd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=MzLsWxuSgiCLPq6Zp1UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA4NiBTYWx0ZWRfX8bmdL9T5rglM
 afa4O3H1pSJfQYvDGVhYQKt56tyemfuy63ar65DM9hzaDktMFWQeuLDPBUhwNvLN2zGmgpgClmI
 NgRWNA3yCT81dUS6T4ngZeR6l8X8hBg=
X-Proofpoint-GUID: N9IEK1XpunVUWSBMyGEX440vpQlrKU-_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA4NiBTYWx0ZWRfX3EBHpXRd66XD
 4bXWGFkCSZqBkMFRMgFiw1dl51nFRr6SY9bqXT3Tp0zlI7Eb4640s5Wffy042foWoQPCpjFEWgZ
 XXm9NxWFgUQZO7o9hKc5kZDnW4q0oljpVrF5Bolg/WC0aa9CTisDMvrONlmyJZUOxiA0QSfMY4e
 G9fGgwKbzr7HwzA2FCW1UmeT5TLsSDjs1q7+sjxrNr3HivfhJEHOgYRVAv8AQLpjZXYCXoP/98h
 CNGRSUu6JDxNu8QFBhhnrq83dU0WkrbbKlIE8N+/j+BsOXrL8RwYyolO+wWs8wFp1J3Z+lc5lju
 WEHPlOA+ORuP5K8vVQJuPlQ+c7HWcijyT340tEeqb2w74RPEZhytN6yqSPmmdJr/mCJsB+nRCy9
 9WJ0cayk8xNH7mt2xtE41ATh74HTmsRFU8uY2XV5b27EaGpdw+SOYi84NZVysZcYKNXHhuAIxwH
 gYT24WToU/Pu2tJf3gA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230086

* Eric Dumazet <edumazet@google.com> [2026-07-23 05:17:08]:

> On Wed, Jul 22, 2026 at 7:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 14 Jul 2026 07:09:41 +0530 Srikar Dronamraju wrote:
> > > The scheduler assumes in several wakeup paths that a task using WF_SYNC
> > > is likely to yield the CPU shortly. However several networking wakeup
> > > paths unconditionally use synchronous wakeups even when the waking task
> > > continues execution.
> >
> > Somewhat related recent patch:
> >
> > https://lore.kernel.org/all/20260708133815.3419465-1-usama.arif@linux.dev/
> >
> > Maybe other maintainers will chime in, but I'm not convinced
> > by the heuristics you're adding. The behavior will be workload
> > specific. The extent of networking involvement should be letting
> > the scheduler know that we're waking from IO, not leaking scheduler
> > heuristics into networking.
> > --
> > pw-bot: cr
> 
> In any case, adding code to the fast path in every network system call
> is undesirable.

Yes, I understand adding code in fast path is undesirable. However as
mentioned previous reply, we need to differentiate between blocking and
non-blocking API. Doing unconditional nonblocking, is probably even worse.

-- 
Thanks and Regards
Srikar Dronamraju
