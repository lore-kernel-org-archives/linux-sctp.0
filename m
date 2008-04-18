From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 18 Apr 2008 19:41:47 +0000
Subject: Re: [PATCH] SCTP: Fix DATA retransmit after fast retransmit
Message-Id: <4808F97B.1060401@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48085441.2030904@cn.fujitsu.com>
In-Reply-To: <48085441.2030904@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> If DATA chunk is resend by fast retransmit, and no SACK is received, 
> this DATA chunk can not be send again after T3 timeout.
> 
> This is because chunk->sent_at will be update after chunk is 
> transmitted, but after fast retransmit, T3 timer will not be reset, so 
> sctp_retransmit_mark() can not mark this chunk for retransmit, and will 
> never sent again because not T3 timer is running.
> 
> You can test this by following data transmit:
> 
> Endpoint A                    Endpoint B
> 
>              <--------------  DATA1
>              <--------------  DATA2
>              <--------------  DATA3
>              <--------------  DATA4
>              <--------------  DATA5
> SACK(1,2)    --------------->
> SACK(1,3)    --------------->
> SACK(1,3,4)  --------------->
> SACK(1,3,4,5)--------------->
>              <--------------  DATA2 (Fast retransmit)
> NO SACK is sent, DATA2 will never be send again.
> 
> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> 
> --- a/net/sctp/outqueue.c    2008-04-18 09:00:58.000000000 -0400
> +++ b/net/sctp/outqueue.c    2008-04-18 09:06:07.000000000 -0400
> @@ -425,7 +425,8 @@ void sctp_retransmit_mark(struct sctp_ou
>              * retransmitting due to T3 timeout.
>              */
>             if (reason = SCTP_RTXR_T3_RTX &&
> -                (jiffies - chunk->sent_at) < transport->last_rto)
> +                (jiffies - chunk->sent_at) < transport->last_rto &&
> +                !chunk->fast_retransmit)
>                 continue;
> 
>             /* RFC 2960 6.2.1 Processing a Received SACK
> 
> 

The problem with this patch is that a fast retransmitted chunk ends up being
retransmitted again too early.

There is text in 4960 that I am really trying to understand the intention of:

   4)  Restart the T3-rtx timer only if the last SACK acknowledged the
       lowest outstanding TSN number sent to that address, or the
       endpoint is retransmitting the first outstanding DATA chunk sent
       to that address.

In particular the send part of the above sentence.

Is the meaning that when fast retransmitting the earliest outstanding DATA,
we should restart T3-RTX?

If that's the case, then when we fast-rtx DATA2 above, we should restart
t3-rtx timer.

-vlad
