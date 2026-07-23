Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7859A4570DA;
	Thu, 23 Jul 2026 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784821504; cv=none; b=rGNH0Q1wTU1GN0A/3PtKx4XzbfmYatcJXqsBTr1l74mkdEsm5VfBgWMQvmtiCONbSz7b/iML4Fix8K5SAg6Q7nmmeNy3gjIoppdMPoUuU87oHoIoTB5HKorcift0CPqqFVReHK5JwrA9jQbppRgeWw2JlTTkk3xRgNN1wPm1lkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784821504; c=relaxed/simple;
	bh=HsUVZHvZsu9/2cIqpL/HjWxfJ+3E+95haIzAVoRFlDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KyHuHMr6k2Q9vwFpKBXKVuAi/2iZoSb2B3wKGz/8TEOY0Xz6/pnOWbyDOi7/6RIELeKyhZQycE5vQVYREz0nY9SRDTSuSVs5Ke/qtMNOfa/gkhqjYIgDbrwuCAbpsvHS0q/g41HxXRuFv0p8zTByuoRSs0KPrEXqh48dWHo8vQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DOjgZKDq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DOjgZKDq"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66NDBuBB3106596;
	Thu, 23 Jul 2026 15:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=HYfDk8wZM2YqyeXF4/Le2jy1dA5YHRel0it5QD++K2A=; b=DOjgZKDqAJNp
	emgv+F3wCdep5i7hZfAm9DZWN3RwIA1msJ00qayBzQfguBBNW9Kh+fODmU8tszaw
	bS0ixmDeY3NpM87RRZ/TYovf8vGMzv0ffoDtJWuek4w3IR8CJ8i79BQwE2/bRiRW
	ltMCh2gWvZcx/Kep/t+tcYk5ipI4DSZYpAxRhDSuClfcZ/QpHe6V0n0YKizbe6xZ
	DTvZHG2XU/VHngBkPHrUIFEP304EjkAd1j55YkXqvnHKTbmZn/qHSExoiL0Vd7xu
	d1F0Z4ZCctURKm8CJ6qOw9iUr6+rtVa/vF4iSjGvq5jorvYRR6BNKn5LnytyA9nk
	XLh2eQCwMg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7918cbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 15:44:41 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66NFYeaL010559;
	Thu, 23 Jul 2026 15:44:40 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktqd1tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 15:44:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66NFia6V40567258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 15:44:36 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 406FC200FA;
	Thu, 23 Jul 2026 15:44:36 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E459A200FF;
	Thu, 23 Jul 2026 15:44:27 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.126.150.29])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 15:44:27 +0000 (GMT)
Date: Thu, 23 Jul 2026 21:14:26 +0530
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
Message-ID: <amI22o9MwDoGcBMl@linux.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260722100842.602fd5d2@kernel.org>
 <CANn89i+o3rT6Jnx_6SK2vdmeuHVkZwTJXD++Kua9ZCJb-wVFHg@mail.gmail.com>
 <amHVtLnO7R2snG4L@linux.ibm.com>
 <CANn89iLBzPOL=9oRAn-+RJncL+0By80gfvVqVe9RAwY2XJh3yA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLBzPOL=9oRAn-+RJncL+0By80gfvVqVe9RAwY2XJh3yA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 93Q7hm0gya6LbGgY6fJ3bDBVw8IP9FNV
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a6236e9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=1XWaLZrsAAAA:8
 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=YaNCMFN4SD4EEkJ8tWQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfX67sYXTybTsNz
 wsrSVe3dPGZ7t/jiITDQAloNx5mKhUx385XqxQQmajdHkUGO6eEZwerPv4YSIlmizAOONk60g7C
 U0FMR9Rn8HZXN8Up7JWfxvTQR48+P7k=
X-Proofpoint-GUID: nR3j5hTeQAwo_PSVpR_lE6gZQsHUaQxy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDE1NSBTYWx0ZWRfXzcDrtKZhUFAO
 KZqpHPYJa6fYVWqqnGKVAtdlBRPs6kREYVZtQkaKqN5dJkJq4fnUdQWUGk0i6pL9GL2W34sys55
 /zQS0chii0RPMl1/UYDxPMGHbGGaVkML7n95mj12vfdAsTMJzgTJ1svnzX4y43YItqgLuTgDddM
 DFRBex5f5iW0zN2BjWuruu8wM4Iy7z33RAAeEIAW+wg41OTska9uu3gIMP9GDcQWtI3NoaAGvNA
 HQ4hCTLQxQLARCq+HCfJ1DUcpXy9E81H3Fw+W2WrXimhx8mGKz0XetNqFoU9d9G6Zc7iwMy7Ckd
 5ZX1PNq6dAVskAj80dfeU1xuDCb4xyonjvd2YZDjyYOBpxXF0UOf3xaWrSksmqF3zHwwC83gJzL
 SCiODya6OUfF/BWbK/g0qIPuSQ4Mqv34I6zpTmrquIMoyNydDZhrAJ3XyYM4s8ve//wTBOWllYF
 /LVvPVDyZucorOvQWAQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_04,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230155

* Eric Dumazet <edumazet@google.com> [2026-07-23 10:57:24]:

> On Thu, Jul 23, 2026 at 10:50 AM Srikar Dronamraju <srikar@linux.ibm.com> wrote:
> >
> > * Eric Dumazet <edumazet@google.com> [2026-07-23 05:17:08]:
> >
> > > On Wed, Jul 22, 2026 at 7:08 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Tue, 14 Jul 2026 07:09:41 +0530 Srikar Dronamraju wrote:
> > > > > The scheduler assumes in several wakeup paths that a task using WF_SYNC
> > > > > is likely to yield the CPU shortly. However several networking wakeup
> > > > > paths unconditionally use synchronous wakeups even when the waking task
> > > > > continues execution.
> > >
> > > In any case, adding code to the fast path in every network system call
> > > is undesirable.
> >
> > Yes, I understand adding code in fast path is undesirable. However as
> > mentioned previous reply, we need to differentiate between blocking and
> > non-blocking API. Doing unconditional nonblocking, is probably even worse.
> 
> I suggested that applications choose what they prefer for each socket,
> once and for all.
> (This can also be a cgroup/BPF setting)
> 
> Flipping a socket bit at each recvmsg()/sendmsg() is a bad idea, you
> might break old application expectations.

Set once per socket is fine. However at the time of wake, we still have to
check the socket option right? I hope that overhead is fine.

Also do you have any precedent for once per socket option that I could look
at?

Thanks for your inputs.

-- 
Thanks and Regards
Srikar Dronamraju
