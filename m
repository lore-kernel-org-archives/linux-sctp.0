From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Nov 2009 16:24:45 +0000
Subject: Re: [Lksctp-developers] [PATCH 1/3] sctp: fix autoclose timer race
Message-Id: <4AFC36CD.2020806@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Andrei Pelinescu-Onciul wrote:
> For very small autoclose timeouts (e.g. 0 or close to 0 due to
> overflows) it's possible that the timer is executed immediately
> after is set, before there is a chance to increase the association
> reference counter. To avoid this race, always reference the
> association before calling mod_timer() and dereference it back if
> the timer was already active.
> 

Actually, I don't think this can happen.  At worst, you'd trigger
a soft lock-up, since the code modifying the timer is already holding
a socket lock.  But that would only happen if that code is pre-empted,
which would mean that a user version of the lock is held, then the
autoclose would get rescheduled anyway.

-vlad

> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
> ---
>  net/sctp/output.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index b94c211..8c39bd2 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -586,8 +586,9 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>  			timer = &asoc->timers[SCTP_EVENT_TIMEOUT_AUTOCLOSE];
>  			timeout = asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE];
>  
> -			if (!mod_timer(timer, jiffies + timeout))
> -				sctp_association_hold(asoc);
> +			sctp_association_hold(asoc);
> +			if (mod_timer(timer, jiffies + timeout))
> +				sctp_association_put(asoc); /* already active, deref */
>  		}
>  	}
>  
