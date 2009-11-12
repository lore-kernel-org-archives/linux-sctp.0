From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Nov 2009 16:29:17 +0000
Subject: Re: [Lksctp-developers] [PATCH 2/3] sctp: fix integer overflow when
Message-Id: <4AFC37DD.8090605@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Andrei Pelinescu-Onciul wrote:
> When setting the autoclose timeout in jiffies there is a possible
> integer overflow if the value in seconds is very large
> (e.g. for 2^22 s with HZ24). The problem appears even on
> 64-bit due to the integer promotion rules. The fix is just a cast
>  to unsigned long.
> 
> Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
> ---
>  net/sctp/associola.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 525864b..7f69f4d 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -166,7 +166,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_HEARTBEAT] = 0;
>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_SACK] = asoc->sackdelay;
>  	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] > -		sp->autoclose * HZ;
> +		(unsigned long)sp->autoclose * HZ;
>  
>  	/* Initilizes the timers */
>  	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)

This becomes unnecessary with Patch 3.


-vlad
