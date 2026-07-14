Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF481360EE8;
	Tue, 14 Jul 2026 01:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783993255; cv=none; b=IPq6RfdVyo9MiEkoYAyhaeh7hcOqMUm56nFXomNOUF2QoF0UE5x/fayzZytow9ArxKPUoziow0OdTqpvcg4Ngs4DKHXHe1ARYFW74M8ASz/IiU3LMYuu0JapcRfAAtwcdhwIE41FNDXSYmvYbVZDq5pUWftMpQ85uQ8IkfLg1Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783993255; c=relaxed/simple;
	bh=l6bvERbMlY3ENpErQmgpGYUwGdpBsN5ID1iHYaT/gpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iicaqRCM7u0u7ITSDFrVF2230bENyk1Q53EYdh5ufX0ScQRnKsWOuhSCpOSbeRshtVu4yLeDMx3wGqr/d5S6Y2SxyclzGmK9/M9Z048bEOIGQRpJLj9K4m8nPJjJvkXkueQRsBTseJlPzq/BAi008jsyPTmOpLfnpHO4MucXDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hZjMGnvN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hZjMGnvN"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E0CKbx3892631;
	Tue, 14 Jul 2026 01:40:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2HwqGz5K8dsONnjlX
	fGFSI1z6mJQtd/EhSeHyWKpGbg=; b=hZjMGnvNlhRRVOjZYbVHIfw8VWiFJO6k2
	zjeYNlex1j7AsEbiR6CkwvgKPg3D+kDIgnC75SnYrbjYn9GE9xqpTa8uEWyZRe4a
	6+DYTzx5BJI/Lbr2A48CRQ5ncX+bPF2zGrwXNvFXMBhNTVtmj/eWgt+g1Rn8Jp5m
	zk4UVdBuAPjK1y5JXFLtfBxRmyA/gTBNTngXy4lkXAa8DqBxF1cabqUlnPCrO1UU
	WbFu1XE8+akF4RlJrrpFiSjJDAmPKla4dhyV6xyX4pY3KEAsMHdJqT0bskFnbvR+
	C3w1xgH0azKk4+zs5xFb5MohjeTF+51shusaeeUVg663WMNywOMQg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbf2a36wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 01:40:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66E1YcKv027329;
	Tue, 14 Jul 2026 01:40:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc15jrcre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 01:40:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66E1eWte61538642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jul 2026 01:40:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DC3020043;
	Tue, 14 Jul 2026 01:40:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30D4320040;
	Tue, 14 Jul 2026 01:40:24 +0000 (GMT)
Received: from sapthagiri.in.ibm.com (unknown [9.39.30.210])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Jul 2026 01:40:23 +0000 (GMT)
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
Subject: [PATCH 1/2] net/socket: Record preference for synchronous wakeups
Date: Tue, 14 Jul 2026 07:09:42 +0530
Message-ID: <20260714013940.4068189-5-srikar@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714013940.4068189-4-srikar@linux.ibm.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDAxMCBTYWx0ZWRfX2xwLfpTsRk+w
 8PBt1xpxiqGMTctHmElcH0ZMNSA0pMejN4wW1T1ucyycEwZ3KtW7fOfG6RZH5MY02JPA8MddiVB
 XY4WPP+/NTNA1Vu/iJsPUwrnwZun6KM=
X-Proofpoint-GUID: 3CG71h_FKbaXbMLI9sZJP_JA8nadajtz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDAxMCBTYWx0ZWRfX8E84TxvaQGmo
 tiJfHEPLFKzfYSo/qjGM/8mRkginXbsyHTIZg/RMJq7ZTCkDWPWhmtaOh/Fu3/sPWAQ6ZDXmSwM
 +A2VYtZx0KOe9lMdPQLEUx0lGz5x2p/ALPClVIXjfnWUS01X6tuLE9DPCXVdihtl/naLtAq7WjU
 z4VRFqMB9vPBMwBYjySp5MMfyUIyIanNqh50T6uihAWUkeqBzrcKzIcJsB8IDXbm13qbj54D8Xn
 2BEhGjYWE7W0ChP/sBAUeT+h05EiTXS01RSArXycUysWxDMpZso1CDurE+f1qBAJ4FUOYfPJPbU
 ej3oAx6LpTZpNDY90zdtFGh1VwYyWQf6NNI7KLjktII4BLFXGP/V6sCcOMmAbKMdLwWAjnHtlGS
 LDm2QQ4MfLVNFWS+eMc0t3cRhaVtWzq8oQhD0tFoV0Gf+wFSQUlV9hPHEy+j2kNPJyx1ql+GlQx
 SVUPwAHGoDqgeT1Po7Q==
X-Proofpoint-ORIG-GUID: 5lJU2OG1f1bKDrsZmJWFzqgjNi1Gtcai
X-Authority-Analysis: v=2.4 cv=PvajqQM3 c=1 sm=1 tr=0 ts=6a559395 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=rxtpb416KjLQLQcnxosA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1011 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140010

Scheduler differentiates between affine and non-affine wakeups by the
way of sync flags. Scheduler prefers to pull the tasks towards the waker
if the sync flag is set.

In some cases, socket APIs are blindly requesting sync wakeups. This may
cause load-balance issues and non-optimal performance.

Record whether the most recent blocking socket operation could benefit
from synchronous wakeups. Subsequent readiness notifications use this
hint to determine whether WF_SYNC should be propagated.

The flag is advisory and affects only wakeup placement decisions.

Signed-off-by: Srikar Dronamraju <srikar@linux.ibm.com>
---
 include/net/sock.h |  1 +
 net/socket.c       | 56 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 51185222aac2..acc6b1976dc4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1022,6 +1022,7 @@ enum sock_flags {
 	SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
 	SOCK_RCVPRIORITY, /* Receive SO_PRIORITY ancillary data with packet */
 	SOCK_TIMESTAMPING_ANY, /* Copy of sk_tsflags & TSFLAGS_ANY */
+	SOCK_SYNC_WAKEUP, /* Prefer synchronous socket wakeups */
 };
 
 #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
diff --git a/net/socket.c b/net/socket.c
index 63c69a0fa74e..0bcb57ae490e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1198,15 +1198,27 @@ static void sock_splice_eof(struct file *file)
 		ops->splice_eof(sock);
 }
 
+static inline void sock_update_sync_wakeup(struct sock *sk, bool nonblock)
+{
+	if (unlikely(!sk))
+		return;
+
+	if (nonblock) {
+		if (sock_flag(sk, SOCK_SYNC_WAKEUP))
+			sock_reset_flag(sk, SOCK_SYNC_WAKEUP);
+	} else {
+		if (!sock_flag(sk, SOCK_SYNC_WAKEUP))
+			sock_set_flag(sk, SOCK_SYNC_WAKEUP);
+	}
+}
+
 static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	struct socket *sock = file->private_data;
 	struct msghdr msg = {.msg_iter = *to};
 	ssize_t res;
-
-	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
-		msg.msg_flags = MSG_DONTWAIT;
+	bool nonblock;
 
 	if (iocb->ki_pos != 0)
 		return -ESPIPE;
@@ -1214,6 +1226,11 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!iov_iter_count(to))	/* Match SYS5 behaviour */
 		return 0;
 
+	nonblock = (file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT);
+	if (nonblock)
+		msg.msg_flags = MSG_DONTWAIT;
+
+	sock_update_sync_wakeup(sock->sk, nonblock);
 	res = sock_recvmsg(sock, &msg, msg.msg_flags);
 	*to = msg.msg_iter;
 	return res;
@@ -1225,13 +1242,17 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct socket *sock = file->private_data;
 	struct msghdr msg = {.msg_iter = *from};
 	ssize_t res;
+	bool nonblock;
 
 	if (iocb->ki_pos != 0)
 		return -ESPIPE;
 
-	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
+	nonblock = (file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT);
+	if (nonblock)
 		msg.msg_flags = MSG_DONTWAIT;
 
+	sock_update_sync_wakeup(sock->sk, nonblock);
+
 	if (sock->type == SOCK_SEQPACKET)
 		msg.msg_flags |= MSG_EOR;
 
@@ -2221,6 +2242,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 	struct sockaddr_storage address;
 	int err;
 	struct msghdr msg;
+	bool nonblock;
 
 	err = import_ubuf(ITER_SOURCE, buff, len, &msg.msg_iter);
 	if (unlikely(err))
@@ -2246,8 +2268,11 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 		msg.msg_namelen = addr_len;
 	}
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
-	if (sock->file->f_flags & O_NONBLOCK)
+	nonblock = (sock->file->f_flags & O_NONBLOCK);
+	if (nonblock)
 		flags |= MSG_DONTWAIT;
+
+	sock_update_sync_wakeup(sock->sk, nonblock);
 	msg.msg_flags = flags;
 	return __sock_sendmsg(sock, &msg);
 }
@@ -2284,6 +2309,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	};
 	struct socket *sock;
 	int err, err2;
+	bool nonblock;
 
 	err = import_ubuf(ITER_DEST, ubuf, size, &msg.msg_iter);
 	if (unlikely(err))
@@ -2297,8 +2323,11 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (sock->file->f_flags & O_NONBLOCK)
+	nonblock = (sock->file->f_flags & O_NONBLOCK);
+	if (nonblock)
 		flags |= MSG_DONTWAIT;
+
+	sock_update_sync_wakeup(sock->sk, nonblock);
 	err = sock_recvmsg(sock, &msg, flags);
 
 	if (err >= 0 && addr != NULL) {
@@ -2634,6 +2663,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	unsigned char *ctl_buf = ctl;
 	int ctl_len;
 	ssize_t err;
+	bool nonblock;
 
 	err = -ENOBUFS;
 
@@ -2666,8 +2696,12 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
+	nonblock = (sock->file->f_flags & O_NONBLOCK);
+	if (nonblock)
 		msg_sys->msg_flags |= MSG_DONTWAIT;
+
+	sock_update_sync_wakeup(sock->sk, nonblock);
+
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2887,6 +2921,7 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
 	unsigned long cmsg_ptr;
 	int len;
 	ssize_t err;
+	bool nonblock;
 
 	msg_sys->msg_name = &addr;
 	cmsg_ptr = (unsigned long)msg_sys->msg_control;
@@ -2895,9 +2930,12 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
+	nonblock = (sock->file->f_flags & O_NONBLOCK);
+	if (nonblock)
 		flags |= MSG_DONTWAIT;
 
+	sock_update_sync_wakeup(sock->sk, nonblock);
+
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -3056,6 +3094,8 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 		if (flags & MSG_WAITFORONE)
 			flags |= MSG_DONTWAIT;
 
+		sock_update_sync_wakeup(sock->sk, flags & MSG_WAITFORONE);
+
 		if (timeout) {
 			ktime_get_ts64(&timeout64);
 			*timeout = timespec64_sub(end_time, timeout64);
-- 
2.52.0

