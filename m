Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A82BE7DD;
	Tue, 21 Jul 2026 04:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784609437; cv=none; b=ZfygZ9QIppdTq+vSe2ePsN2sl+S7o0HzoamyW2sTcJH49aNBq2QnMEj9rp8+KWDEu8aW86O16kUYHIwON9myUPMCG79RaGYuZZ7B+WzZVdWRBhKcOSdHg0OmlOVOyWl8btRgAfJWMSg13Stag7CyVynsQbNiHpNTI+nHMceo3b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784609437; c=relaxed/simple;
	bh=f44eNukRggsUOpfrKivaXG/WM00O/Km2KdALa95b5q8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qllktUo9zvMd7m3VXyWh6KUZ6smT27rWmKi7rUMY67yKcF3ZjNvIYZmEPG8S1r9mROredefN5rcIWuQ+KELmxSEh9eo0yTCj0U0aThlV+thC5JFdP6gJ/wzH4KywoY2PFWbXQjDig1Fmz4QNvNyiy5Qt0QHq/cnpNuE/q2KxdOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Od0A7Geq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Od0A7Geq"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KNDtfu3562185;
	Tue, 21 Jul 2026 04:50:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AaAsoz
	OWwpCuYCq26EovY7890xu/04NvsGRJ8k2E82c=; b=Od0A7Geq5iOaz/P0XwGLmI
	4ht34cL07iSTvV4O6Ca57ocVytOsRBhWI6xrcl4Ytbag1uY/O4j9zo0qTs2Emhen
	MQuPmUoD7/pdJqbN1dww5LMcgbD7ImFTIT9aDX836qWi8K/HrBb+aFQKrvJSAU8T
	J8j1LepE4oczse/3Qjg6OQN3A6WyUR/CCJHD0VeqF2q2m/culjSAaWCi3DcLdy4Z
	DV75hqy/CQAaAEQtzh2B1qOghL7B51nBuJyK9JefQt4Ht0ha+MLIwD0G3HoHFTrh
	nfeEPc2SRnqlUslUWXmIT/Gjknyby9q25lW2NoHwq9lCGTZ2UEmusaVWjuaXbxmA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ah2h31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 04:50:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66L4YsEd029523;
	Tue, 21 Jul 2026 04:50:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktq0xgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 04:50:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66L4oC7029688144
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jul 2026 04:50:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1C192004E;
	Tue, 21 Jul 2026 04:50:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88D7620043;
	Tue, 21 Jul 2026 04:50:04 +0000 (GMT)
Received: from [9.39.17.99] (unknown [9.39.17.99])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Jul 2026 04:50:04 +0000 (GMT)
Message-ID: <5bf27f85-6d07-4f40-8604-8b9ac9777db9@linux.ibm.com>
Date: Tue, 21 Jul 2026 10:20:03 +0530
Precedence: bulk
X-Mailing-List: linux-sctp@vger.kernel.org
List-Id: <linux-sctp.vger.kernel.org>
List-Subscribe: <mailto:linux-sctp+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sctp+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] net/sock: Propagate WF_SYNC only when requested
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
 <20260714013940.4068189-6-srikar@linux.ibm.com>
From: Shrikanth Hegde <sshegde@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20260714013940.4068189-6-srikar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: _cuN3Wvogp_F8jne52Pgw_JkWJVrJa_v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDA0NSBTYWx0ZWRfX4xYt7JMvz5z1
 Bf5LIlFQspUoxRlJ6HekthQZD+gNgr316yeik9ap1kFfY434MojTPU0nQKaGFFJ1Sq2DwVCNmen
 3erGPyMgPulX+Yy6a5Rnr34SGFS9Gs6CBFfLQLwVmWWLOKJ9tYOrFuhrvfICVvDIVoCglJj70ef
 gqEVbWeUalngklFihbsUvBWKjHpNmDlkRG43tpGX7i5VJNWri3pdn3gu/wZghPrCiAuW49zr9GB
 LkSDAi3sEU2qzFTj14VEyWmqma8na1Zw1XOZrCFJLZmr0jYQntBA4S/XbYykat6GKse8UBYoWLP
 4m/JYwxVaDJ++nXmMk+JyAqhp74jhnXD9OkJ68ol5cKQiCo2Bcd3LNCEOBw7JrPGWVt42jJj4+o
 CeYLUCo8xI28xyWOGXiU96eTzO3weQVITvfbYKJfEZ3MaWRG3BTobTkRYsRu/ASCJve5Y334zhw
 BR4+zvd2S2+o+HPXVxg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDA0NSBTYWx0ZWRfX/dX4ql4EQfVx
 fmlnV1Ps2rTdKDfvNJbXVRRFpCfqVLB0tyJzFofI4POJoS3npS57+D+AhtNwIMEA6JDxsURIjcS
 i3aXZICDROMkvRinC4yEItKFH1StpD4=
X-Proofpoint-GUID: 4AsqktYc_fNMp6ryw98x1VyCDdoLAjun
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a5efa8a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=D7B-jMnUd-_QZL7UbJsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_06,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210045

Hi Srikar,

On 7/14/26 7:09 AM, Srikar Dronamraju wrote:
> Use SOCK_SYNC_WAKEUP to select between synchronous and asynchronous wakeup
> wakeup APIs. This avoids propagating WF_SYNC when no blocking waiter is
> expected. All wakeup locations in networking code that currently issue
> synchronous poll-style wakeups unconditionally are updated.
> 

You can also add the performance data in the cover-letter to this patch.

> Signed-off-by: Srikar Dronamraju <srikar@linux.ibm.com>
> ---
>   net/core/sock.c    | 31 ++++++++++++++++++++++++-------
>   net/sctp/socket.c  | 10 ++++++++--
>   net/smc/af_smc.c   |  4 ++--
>   net/smc/smc_rx.c   | 10 ++++++++--
>   net/tipc/socket.c  | 22 +++++++++++++++++-----
>   net/unix/af_unix.c | 26 ++++++++++++++++++--------
>   6 files changed, 77 insertions(+), 26 deletions(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 8a59bfaa8096..a214e883b14b 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3652,9 +3652,15 @@ void sock_def_readable(struct sock *sk)
>   
>   	rcu_read_lock();
>   	wq = rcu_dereference(sk->sk_wq);
> -	if (skwq_has_sleeper(wq))
> -		wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN | EPOLLPRI |
> +	if (skwq_has_sleeper(wq)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN | EPOLLPRI |
> +						EPOLLRDNORM | EPOLLRDBAND);
> +		} else {
> +			wake_up_interruptible_poll(&wq->wait, EPOLLIN | EPOLLPRI |
>   						EPOLLRDNORM | EPOLLRDBAND);
> +		}
> +	}
>   	sk_wake_async_rcu(sk, SOCK_WAKE_WAITD, POLL_IN);
>   	rcu_read_unlock();
>   }
> @@ -3670,9 +3676,15 @@ static void sock_def_write_space(struct sock *sk)
>   	 */
>   	if (sock_writeable(sk)) {
>   		wq = rcu_dereference(sk->sk_wq);
> -		if (skwq_has_sleeper(wq))
> -			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
> +		if (skwq_has_sleeper(wq)) {
> +			if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +				wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
> +						EPOLLWRNORM | EPOLLWRBAND);
> +			} else {
> +				wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
>   						EPOLLWRNORM | EPOLLWRBAND);
> +			}
> +		}
>   
>   		/* Should agree with poll, otherwise some programs break */
>   		sk_wake_async_rcu(sk, SOCK_WAKE_SPACE, POLL_OUT);
> @@ -3695,10 +3707,15 @@ static void sock_def_write_space_wfree(struct sock *sk, int wmem_alloc)
>   
>   		/* rely on refcount_sub from sock_wfree() */
>   		smp_mb__after_atomic();
> -		if (wq && waitqueue_active(&wq->wait))
> -			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
> +		if (wq && waitqueue_active(&wq->wait)) {
> +			if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +				wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
>   						EPOLLWRNORM | EPOLLWRBAND);
> -
> +			} else {
> +				wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
> +						EPOLLWRNORM | EPOLLWRBAND);
> +			}
> +		}
>   		/* Should agree with poll, otherwise some programs break */
>   		sk_wake_async_rcu(sk, SOCK_WAKE_SPACE, POLL_OUT);
>   	}
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index c7b9e325ec1c..9cb3432f065a 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -9348,9 +9348,15 @@ void sctp_data_ready(struct sock *sk)
>   
>   	rcu_read_lock();
>   	wq = rcu_dereference(sk->sk_wq);
> -	if (skwq_has_sleeper(wq))
> -		wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN |
> +	if (skwq_has_sleeper(wq)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN |
> +					EPOLLRDNORM | EPOLLRDBAND);
> +		} else {
> +			wake_up_interruptible_poll(&wq->wait, EPOLLIN |
>   						EPOLLRDNORM | EPOLLRDBAND);
> +		}
> +	}
>   	sk_wake_async_rcu(sk, SOCK_WAKE_WAITD, POLL_IN);
>   	rcu_read_unlock();
>   }
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index b5db69073e20..1a6ea2e30769 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -819,10 +819,10 @@ static void smc_fback_wakeup_waitqueue(struct smc_sock *smc, void *key)
>   		wake_up_interruptible_all(&wq->wait);
>   	} else {
>   		flags = key_to_poll(key);
> -		if (flags & (EPOLLIN | EPOLLOUT))
> +		if (flags & (EPOLLIN | EPOLLOUT) && sock_flag(&smc->sk, SOCK_SYNC_WAKEUP))
>   			/* sk_data_ready or sk_write_space */
>   			wake_up_interruptible_sync_poll(&wq->wait, flags);
> -		else if (flags & EPOLLERR)
> +		else
>   			/* sk_error_report */
>   			wake_up_interruptible_poll(&wq->wait, flags);
>   	}
> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index c1d9b923938d..4e288a2364d2 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -39,9 +39,15 @@ static void smc_rx_wake_up(struct sock *sk)
>   	/* called already in smc_listen_work() */
>   	rcu_read_lock();
>   	wq = rcu_dereference(sk->sk_wq);
> -	if (skwq_has_sleeper(wq))
> -		wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN | EPOLLPRI |
> +	if (skwq_has_sleeper(wq)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN | EPOLLPRI |
>   						EPOLLRDNORM | EPOLLRDBAND);
> +		} else {
> +			wake_up_interruptible_poll(&wq->wait, EPOLLIN | EPOLLPRI |
> +						EPOLLRDNORM | EPOLLRDBAND);
> +		}
> +	}
>   	sk_wake_async_rcu(sk, SOCK_WAKE_WAITD, POLL_IN);
>   	if ((sk->sk_shutdown == SHUTDOWN_MASK) ||
>   	    (sk->sk_state == SMC_CLOSED))
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index e564341e0216..9fa83a89882c 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -2116,9 +2116,15 @@ static void tipc_write_space(struct sock *sk)
>   
>   	rcu_read_lock();
>   	wq = rcu_dereference(sk->sk_wq);
> -	if (skwq_has_sleeper(wq))
> -		wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
> +	if (skwq_has_sleeper(wq)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
>   						EPOLLWRNORM | EPOLLWRBAND);
> +		} else {
> +			wake_up_interruptible_poll(&wq->wait, EPOLLOUT |
> +						EPOLLWRNORM | EPOLLWRBAND);
> +		}
> +	}
>   	rcu_read_unlock();
>   }
>   
> @@ -2134,9 +2140,15 @@ static void tipc_data_ready(struct sock *sk)
>   
>   	rcu_read_lock();
>   	wq = rcu_dereference(sk->sk_wq);
> -	if (skwq_has_sleeper(wq))
> -		wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN |
> -						EPOLLRDNORM | EPOLLRDBAND);
> +	if (skwq_has_sleeper(wq)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&wq->wait, EPOLLIN |
> +							EPOLLRDNORM | EPOLLRDBAND);
> +		} else {
> +			wake_up_interruptible_poll(&wq->wait, EPOLLIN |
> +							EPOLLRDNORM | EPOLLRDBAND);
> +		}
> +	}
>   	rcu_read_unlock();
>   }
>   
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index f7a9d55eee8a..15ebcc2d9d58 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -601,9 +601,15 @@ static void unix_write_space(struct sock *sk)
>   	rcu_read_lock();
>   	if (unix_writable(sk, READ_ONCE(sk->sk_state))) {
>   		wq = rcu_dereference(sk->sk_wq);
> -		if (skwq_has_sleeper(wq))
> -			wake_up_interruptible_sync_poll(&wq->wait,
> -				EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
> +		if (skwq_has_sleeper(wq)) {
> +			if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +				wake_up_interruptible_sync_poll(&wq->wait,
> +					EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
> +			} else {
> +				wake_up_interruptible_poll(&wq->wait,
> +					EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
> +			}
> +		}
>   		sk_wake_async_rcu(sk, SOCK_WAKE_SPACE, POLL_OUT);
>   	}
>   	rcu_read_unlock();
> @@ -2603,11 +2609,15 @@ int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
>   		goto out;
>   	}
>   
> -	if (wq_has_sleeper(&u->peer_wait))
> -		wake_up_interruptible_sync_poll(&u->peer_wait,
> -						EPOLLOUT | EPOLLWRNORM |
> -						EPOLLWRBAND);
> -
> +	if (wq_has_sleeper(&u->peer_wait)) {
> +		if (sock_flag(sk, SOCK_SYNC_WAKEUP)) {
> +			wake_up_interruptible_sync_poll(&u->peer_wait,
> +						EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
> +		} else {
> +			wake_up_interruptible_poll(&u->peer_wait,
> +						EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND);
> +		}
> +	}
>   	if (msg->msg_name) {
>   		unix_copy_addr(msg, skb->sk);
>   


Would it make sense to write a macro or a wrapper function do the
same instead of sprinkling the same at all the places?

similar comment for patch 1.

IMHO, it would make it easier to read.

