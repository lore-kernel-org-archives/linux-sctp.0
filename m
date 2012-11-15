From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 15 Nov 2012 13:13:02 +0000
Subject: Re: [PATCH] sctp: fix /proc/net/sctp/ memory leak
Message-Id: <1352985182.4497.26.camel@edumazet-glaptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <1352967802-2335-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1352967802-2335-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Sridhar Samudrala <sri@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, Dave Jones <davej@redhat.com>

On Thu, 2012-11-15 at 10:23 +0200, Tommi Rantala wrote:
> We are using single_open_net() and seq_open_net() in the opener
> functions, so avoid leaking memory by using single_release_net() and
> seq_release_net() as the struct file_operations release functions.
> 
> Discovered with Trinity (the syscall fuzzer).
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
>  net/sctp/proc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/proc.c b/net/sctp/proc.c
> index c3bea26..9966e7b 100644
> --- a/net/sctp/proc.c
> +++ b/net/sctp/proc.c
> @@ -102,7 +102,7 @@ static const struct file_operations sctp_snmp_seq_fops = {
>  	.open	 = sctp_snmp_seq_open,
>  	.read	 = seq_read,
>  	.llseek	 = seq_lseek,
> -	.release = single_release,
> +	.release = single_release_net,
>  };
>  

It seems you forgot to do do some work to pinpoint which commit added
this bug. Please add this in the changelog to ease maintainer and stable
teams work, and CC the author of said commit so that he has a chance to
Ack your patch.

Thanks !


