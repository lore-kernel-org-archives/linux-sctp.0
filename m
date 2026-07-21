Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F9735F609;
	Tue, 21 Jul 2026 05:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784610050; cv=none; b=uSo9zhF+A9UAGNdOPuUK33j8sIdiM4EUicjxNZ2Dlb4q366/G811T7K3ZInXOdAgkIect5SN4Lv23uKJS7ufUIJ8kgkmM/2Bg6qJNpNMlVRebQCa4uRhk7xKAeEwdnuJyxOkfWxWW+hCkwCn7iG8iVbeO7e0+xAnusrg45wtkb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784610050; c=relaxed/simple;
	bh=RtbhiD/mQUo50Z9FcwKcBFVpEfS7t1InoADrReoq9hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7NUBgF2DHQL9zDYY9zef8pC2xKbcqZczRi12tPoncf4YQz8KZYIWy1+FcP5gZo326hGJaHlxO9D90apGVL09vr2JxVNr3u1RsU6K/7XSWX+7nGCLYRHKXgIDsVqX3ZJzbR0MYM/KKme96AVHWXPpTI2i7mXmNbitY0bXHHwwMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NDQjG7Tz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NDQjG7Tz"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KNCqgv3553300;
	Tue, 21 Jul 2026 05:00:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HaFy4+
	MVMeagEonZ/LSo9gnyNCKUvlgCd9BIWgJ5JGw=; b=NDQjG7Tz71StW+NSsCGte/
	BjE6GHObFaO+GWKM+uIIwwUo96uLzB7RKkX0Wx4u/VwT00GgOG3jkxQgwK7hscOv
	QObPZfz55Uq4ZPBD+X9HUtcNxh0FM4uu38ZnZhagVflr0cCVn+bfWRasgAYFnpYI
	Rm7AUmJCOz+7FFGMsCDzA2Muv06oD4fH0XlDLqVS0aKEH0Frxch+cUTkY211D89p
	MwEY+KgZtT35iTL5gINhnmBDlQY8xOfUIIC9Y09MnYKS1z7i1KK23mUCi/qjLphi
	d22ndVCzCSlF7uJVCnmhskmlY2iK7McjSjiy0qJ3rgf/T0ZpBPY611Oo33+nidvw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abaww1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 05:00:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66L4obiq003139;
	Tue, 21 Jul 2026 05:00:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtjrsa9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 05:00:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66L50J7553608930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 05:00:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EC8220040;
	Tue, 21 Jul 2026 05:00:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 901B32004B;
	Tue, 21 Jul 2026 05:00:12 +0000 (GMT)
Received: from [9.39.17.99] (unknown [9.39.17.99])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jul 2026 05:00:12 +0000 (GMT)
Message-ID: <1dc7d5f2-0e72-4dff-867a-c44156ac3da6@linux.ibm.com>
Date: Tue, 21 Jul 2026 10:30:11 +0530
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] net/socket: Record preference for synchronous wakeups
To: Srikar Dronamraju <srikar@linux.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>
References: <20260714013940.4068189-4-srikar@linux.ibm.com>
 <20260714013940.4068189-5-srikar@linux.ibm.com>
Content-Language: en-US
From: Shrikanth Hegde <sshegde@linux.ibm.com>
In-Reply-To: <20260714013940.4068189-5-srikar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA0NSBTYWx0ZWRfX9y6TVZBkNdYf
 1vSY0d1NwBS/tIC6RmeW+LfBuik0x13Ddq8UgA+yVatgwa8iR7dflBgA55XaoOJtlALYkVjPwxk
 lGPPctIGBgNwQ/hnl5FZemWxlA1vcyFM2eYOqH5SNccX/tTubwdOzUtkFCZGAKzOMpvE//yLxPE
 6B1Z1dGOyFG5gbOnPy8KUCjOcvpS0ZlFZKEQrbSyhfXtK+4m4Ty42A5JrqmH7+nRsfQYvd+ATUF
 nP9qYT7lwVb8A/bsOogioHMv0TImJmttkzl/XbIaMNln5HMF+93DCxrCvu9U6gZkpgRIFSPDm8s
 N4JaDFvDqYi2WGdfrVipmNzUf83CY2zX8J+nGPPdVvCJ8loG2Gt+5J8cL8ce0KoV67+nRolkrfM
 53PnV93j2wX9L2vXWyZPyco4qecCAsol8E0PCgGKEqr6wZB+LkesOUBe4M071Gj/9aye1be/OoM
 Pb2aJMuAIL9MI9RkUpQ==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a5efce9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=kzuGRFPQ2Gws9SZ42BYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: I-tDB5z4DLULTLxLbb__zXO7lIFkrTi-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA0NSBTYWx0ZWRfX/iVf4bxlsPaW
 1UzFjEQ3ZsvgeImJQgtYdzZpWwag4MbnPhDDwY4zG0kTnznadt5Pj/yJz/7yZPySDgdjbfmgozM
 0HkdBA1MGd1WxRdXFQF8Xkcm+t0MHZU=
X-Proofpoint-GUID: lTrg1FdGAGIPkUAcjLqyLUNUU8GOooIl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210045

Hi Srikar.

On 7/14/26 7:09 AM, Srikar Dronamraju wrote:
> Scheduler differentiates between affine and non-affine wakeups by the
> way of sync flags. Scheduler prefers to pull the tasks towards the waker
> if the sync flag is set.
> 
> In some cases, socket APIs are blindly requesting sync wakeups. This may
> cause load-balance issues and non-optimal performance.
> 
> Record whether the most recent blocking socket operation could benefit
> from synchronous wakeups. Subsequent readiness notifications use this
> hint to determine whether WF_SYNC should be propagated.
> 

What you mean by recent? Was it info on past set of packets?
Could you please explain the flow a bit?

Shouldn't it be
- if this socket has been defined as nonblock it shouldn't use sync
   always?

> The flag is advisory and affects only wakeup placement decisions.
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.ibm.com>
> ---
>   include/net/sock.h |  1 +
>   net/socket.c       | 56 +++++++++++++++++++++++++++++++++++++++-------
>   2 files changed, 49 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 51185222aac2..acc6b1976dc4 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1022,6 +1022,7 @@ enum sock_flags {
>   	SOCK_RCVMARK, /* Receive SO_MARK  ancillary data with packet */
>   	SOCK_RCVPRIORITY, /* Receive SO_PRIORITY ancillary data with packet */
>   	SOCK_TIMESTAMPING_ANY, /* Copy of sk_tsflags & TSFLAGS_ANY */
> +	SOCK_SYNC_WAKEUP, /* Prefer synchronous socket wakeups */
>   };
>   
>   #define SK_FLAGS_TIMESTAMP ((1UL << SOCK_TIMESTAMP) | (1UL << SOCK_TIMESTAMPING_RX_SOFTWARE))
> diff --git a/net/socket.c b/net/socket.c
> index 63c69a0fa74e..0bcb57ae490e 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1198,15 +1198,27 @@ static void sock_splice_eof(struct file *file)
>   		ops->splice_eof(sock);
>   }
>   
> +static inline void sock_update_sync_wakeup(struct sock *sk, bool nonblock)
> +{
> +	if (unlikely(!sk))
> +		return;
> +
> +	if (nonblock) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP))
> +			sock_reset_flag(sk, SOCK_SYNC_WAKEUP);
> +	} else {
> +		if (!sock_flag(sk, SOCK_SYNC_WAKEUP))
> +			sock_set_flag(sk, SOCK_SYNC_WAKEUP);
> +	}
> +}

nit: You can combine two if statements. A bit easier to read.


static inline void sock_update_sync_wakeup(struct sock *sk, bool nonblock)
{
	if (unlikely(!sk))
		return;

	if (nonblock && sock_flag(sk, SOCK_SYNC_WAKEUP))
		sock_reset_flag(sk, SOCK_SYNC_WAKEUP);
	else if (!nonblock && !sock_flag(sk, SOCK_SYNC_WAKEUP))
		sock_set_flag(sk, SOCK_SYNC_WAKEUP);
}

> +
>   static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   {
>   	struct file *file = iocb->ki_filp;
>   	struct socket *sock = file->private_data;
>   	struct msghdr msg = {.msg_iter = *to};
>   	ssize_t res;
> -
> -	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
> -		msg.msg_flags = MSG_DONTWAIT;
> +	bool nonblock;
>   
>   	if (iocb->ki_pos != 0)
>   		return -ESPIPE;
> @@ -1214,6 +1226,11 @@ static ssize_t sock_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   	if (!iov_iter_count(to))	/* Match SYS5 behaviour */
>   		return 0;
>   
> +	nonblock = (file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT);
> +	if (nonblock)
> +		msg.msg_flags = MSG_DONTWAIT;
> +
> +	sock_update_sync_wakeup(sock->sk, nonblock);
>   	res = sock_recvmsg(sock, &msg, msg.msg_flags);
>   	*to = msg.msg_iter;
>   	return res;
> @@ -1225,13 +1242,17 @@ static ssize_t sock_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	struct socket *sock = file->private_data;
>   	struct msghdr msg = {.msg_iter = *from};
>   	ssize_t res;
> +	bool nonblock;
>   
>   	if (iocb->ki_pos != 0)
>   		return -ESPIPE;
>   
> -	if (file->f_flags & O_NONBLOCK || (iocb->ki_flags & IOCB_NOWAIT))
> +	nonblock = (file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT);
> +	if (nonblock)
>   		msg.msg_flags = MSG_DONTWAIT;
>   
> +	sock_update_sync_wakeup(sock->sk, nonblock);
> +
>   	if (sock->type == SOCK_SEQPACKET)
>   		msg.msg_flags |= MSG_EOR;
>   
> @@ -2221,6 +2242,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
>   	struct sockaddr_storage address;
>   	int err;
>   	struct msghdr msg;
> +	bool nonblock;
>   
>   	err = import_ubuf(ITER_SOURCE, buff, len, &msg.msg_iter);
>   	if (unlikely(err))
> @@ -2246,8 +2268,11 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
>   		msg.msg_namelen = addr_len;
>   	}
>   	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
> -	if (sock->file->f_flags & O_NONBLOCK)
> +	nonblock = (sock->file->f_flags & O_NONBLOCK);
> +	if (nonblock)
>   		flags |= MSG_DONTWAIT;
> +
> +	sock_update_sync_wakeup(sock->sk, nonblock);
>   	msg.msg_flags = flags;
>   	return __sock_sendmsg(sock, &msg);
>   }
> @@ -2284,6 +2309,7 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
>   	};
>   	struct socket *sock;
>   	int err, err2;
> +	bool nonblock;
>   
>   	err = import_ubuf(ITER_DEST, ubuf, size, &msg.msg_iter);
>   	if (unlikely(err))
> @@ -2297,8 +2323,11 @@ int __sys_recvfrom(int fd, void __user *ubuf, size_t size, unsigned int flags,
>   	if (unlikely(!sock))
>   		return -ENOTSOCK;
>   
> -	if (sock->file->f_flags & O_NONBLOCK)
> +	nonblock = (sock->file->f_flags & O_NONBLOCK);
> +	if (nonblock)
>   		flags |= MSG_DONTWAIT;
> +
> +	sock_update_sync_wakeup(sock->sk, nonblock);
>   	err = sock_recvmsg(sock, &msg, flags);
>   
>   	if (err >= 0 && addr != NULL) {
> @@ -2634,6 +2663,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
>   	unsigned char *ctl_buf = ctl;
>   	int ctl_len;
>   	ssize_t err;
> +	bool nonblock;
>   
>   	err = -ENOBUFS;
>   
> @@ -2666,8 +2696,12 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
>   	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
>   	msg_sys->msg_flags = flags;
>   
> -	if (sock->file->f_flags & O_NONBLOCK)
> +	nonblock = (sock->file->f_flags & O_NONBLOCK);
> +	if (nonblock)
>   		msg_sys->msg_flags |= MSG_DONTWAIT;
> +
> +	sock_update_sync_wakeup(sock->sk, nonblock);
> +
>   	/*
>   	 * If this is sendmmsg() and current destination address is same as
>   	 * previously succeeded address, omit asking LSM's decision.
> @@ -2887,6 +2921,7 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
>   	unsigned long cmsg_ptr;
>   	int len;
>   	ssize_t err;
> +	bool nonblock;
>   
>   	msg_sys->msg_name = &addr;
>   	cmsg_ptr = (unsigned long)msg_sys->msg_control;
> @@ -2895,9 +2930,12 @@ static int ____sys_recvmsg(struct socket *sock, struct msghdr *msg_sys,
>   	/* We assume all kernel code knows the size of sockaddr_storage */
>   	msg_sys->msg_namelen = 0;
>   
> -	if (sock->file->f_flags & O_NONBLOCK)
> +	nonblock = (sock->file->f_flags & O_NONBLOCK);
> +	if (nonblock)
>   		flags |= MSG_DONTWAIT;
>   
> +	sock_update_sync_wakeup(sock->sk, nonblock);
> +
>   	if (unlikely(nosec))
>   		err = sock_recvmsg_nosec(sock, msg_sys, flags);
>   	else
> @@ -3056,6 +3094,8 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
>   		if (flags & MSG_WAITFORONE)
>   			flags |= MSG_DONTWAIT;
>   
> +		sock_update_sync_wakeup(sock->sk, flags & MSG_WAITFORONE);
> +
>   		if (timeout) {
>   			ktime_get_ts64(&timeout64);
>   			*timeout = timespec64_sub(end_time, timeout64);

