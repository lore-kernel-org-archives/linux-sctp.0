Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28231360EF3;
	Tue, 14 Jul 2026 01:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993256; cv=none; b=XvMBMrIxVqSx3NP7cSFex/luhSPB6G/7NFT4NAONu7BmqGXrS5FCI9ivpcZF5szAMLOTpeqAayFl04IKDYQJyEkXLC+Nidn8ITZ9hciHGejSO4IrVLAu9dsndIswxXk2UuTtwdyqrKCnamtLkRGNpB5ZYp1nKsE657VDiN7i2rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993256; c=relaxed/simple;
	bh=AJGlF/eqri/pikeFdgGpMF2j/rGkgHbnAe3aE0EyzOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fP/eO7Fhkv+2dZJQkBsNMiH0T+/YZJcpamZTV75ezuaeWRbb7lE61ZPMzCicSyBUAF9HhRGv8oG35xIKZgJKmboJVOyEvi4DGleUTg8oC7NWGD+RXdTgesRpSqccxwISNwhZwB+f+mx1Bhx9DXYRtOxnFiwvxY5OPtdT++6hugA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O+nvB3jc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O+nvB3jc"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E0BsX03973855;
	Tue, 14 Jul 2026 01:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=uLFrkn/oeABXxoDorUX47DrG0uBm/w0giU4zPAJDq
	+4=; b=O+nvB3jcsvIfRsS9TMRta8HT53cDt+ytt+8nMr1IilrVFdt7+qCHAV2uC
	6XBLI0ihMYKC5FfxXH8kXEo/QffkrMcMG1UQDzxyLpGuNB/WDvfpik2kNLoaduZ3
	E/wY/Y7K5zB0mhmXlX6JqRvVii4H9npJ86Qt8pLVsfFaOnbkejULnl1idhPL+l5M
	lVKR/qQx+xKxyWJREO3WQi4lZIjkDVfQujhEbfCZuYa7hdMf7UtJGse7oGfV4yZZ
	Ey0PCtKv0qWP73snko3zDofcqsdYYaFGpY1isEDH1OGyi2vrtrzYzFGn2IbkxrLJ
	3iFIZKF2DPOrlCXn3zKXvdWvt16Vg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegt3nyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 01:40:28 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66E1YdxS002926;
	Tue, 14 Jul 2026 01:40:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc05q0k7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 01:40:27 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66E1eNMS30802554
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jul 2026 01:40:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8DB220043;
	Tue, 14 Jul 2026 01:40:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7189520040;
	Tue, 14 Jul 2026 01:40:15 +0000 (GMT)
Received: from sapthagiri.in.ibm.com (unknown [9.39.30.210])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Jul 2026 01:40:15 +0000 (GMT)
From: Srikar Dronamraju <srikar@linux.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        David S Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        D Wythe <alibuda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>, Kuniyuki Iwashima <kuniyu@google.com>,
        linux-sctp@vger.kernel.org, Mahanta Jambigi <mjambigi@linux.ibm.com>,
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
        K Prateek Nayak <kprateek.nayak@amd.com>,
        Srikar Dronamraju <srikar@linux.ibm.com>
Subject: [PATCH 0/2] net: Use synchronous wakeups selectively
Date: Tue, 14 Jul 2026 07:09:41 +0530
Message-ID: <20260714013940.4068189-4-srikar@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: swnZ8k84VhCHp9l1OgXmsrnlbZJyqjdA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDAxMCBTYWx0ZWRfXwQeVNoERtGRG
 NDkywHfp3cFgJAW701EblrT5EmGFEkEWyIbb2XlNWpp6SDgsb8YNCi2ZbNVcyjGAy9QBrh9+9lB
 sx2kDnRcz99LD0Vozu4gLxzknEiVnbU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDAxMCBTYWx0ZWRfX0l+9M9RCV7/l
 SN13QSfmHhH5xXZllrrCXAbJEM7cXmUo4ShlwOhCVve+fG9nGsHeLGf8nYZeHfGiyEF9NkR0qWS
 19+VOzvPzk9lEpvzk+kAyFRPo0YPgZkoLSiRt0l7822dT5TXvfTa78PGPDBkyMe8+7JG5oQfdhl
 ym/PfAH8beOsLYCK9XujKgPcQFZ+o14D/CnHiZ/JbOuDYcwVOSTLcF5tkzcYTJ6BhfGXhxdOng3
 DURIIt0+r1Y7PJ9sRjkZXxN9961lPuM0m8nIc3/8zigFRPDuCLYb0vIUO3MciJeWKpOoZeSfhl3
 f8hcpgreHM2zJZI58IquDQINu+uuy4HQTDEfiFc1NPIdXuSekryi1Jtjgc39D4/28PXhNkzz30c
 DRKO5YidoYlGuNEcDEYiIVYV/8bbTHA4/b9LmDJieGjv7WMAjZy+d1Jn/dlCCg2nYH8bsnxl6PF
 7mzmostWJxz9tHolrmQ==
X-Authority-Analysis: v=2.4 cv=IqMutr/g c=1 sm=1 tr=0 ts=6a55938d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VuoEQsLsQp_es4t_5JUA:9
X-Proofpoint-GUID: ojGUtRFKMUJUAfLl9ciMPh-HwXf1RELn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 impostorscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140010

The scheduler assumes in several wakeup paths that a task using WF_SYNC
is likely to yield the CPU shortly. However several networking wakeup
paths unconditionally use synchronous wakeups even when the waking task
continues execution.

During wakeup, with WF_SYNC flag set, because of the assumption that
current thread is ready to give up, the wakee thread will be migrated
from any core within the chip to the current LLC. If these operations
are frequent, and wakers are actually not going away, then it will lead
to load imbalance and hurt performance. This is especially true in
architectures where LLCs are small and number of LLCs per chip are more.

Running vllm workload was run on Power10 system
                                  No patch      with patch %diff
Inference Time (sec)              17.84         16.35     -8.35%
llm query bandwidth (tokens/sec)  14.78         16.21     +9.68%

Lower inference time and higher tokens/sec is better.

Srikar Dronamraju (2):
  net/socket: Record preference for synchronous wakeups
  net/sock: Propagate WF_SYNC only when requested

 include/net/sock.h |  1 +
 net/core/sock.c    | 31 +++++++++++++++++++------
 net/sctp/socket.c  | 10 +++++++--
 net/smc/af_smc.c   |  4 ++--
 net/smc/smc_rx.c   | 10 +++++++--
 net/socket.c       | 56 +++++++++++++++++++++++++++++++++++++++-------
 net/tipc/socket.c  | 22 +++++++++++++-----
 net/unix/af_unix.c | 26 ++++++++++++++-------
 8 files changed, 126 insertions(+), 34 deletions(-)

-- 
2.51.0

