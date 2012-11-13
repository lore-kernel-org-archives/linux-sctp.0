From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 13 Nov 2012 15:01:11 +0000
Subject: Re: [PATCH] sctp: fix /proc/net/sctp/ memory leak
Message-Id: <20121113150111.GB27416@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1352815276-24628-1-git-send-email-tt.rantala@gmail.com>
In-Reply-To: <1352815276-24628-1-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue, Nov 13, 2012 at 04:01:16PM +0200, Tommi Rantala wrote:
> We are using single_open_net() and seq_open_net() in the opener
> functions, so avoid leaking memory by using single_release_net() and
> seq_release_net() as the struct file_operations release functions.
> 
> Discovered with Trinity (the syscall fuzzer).
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
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
>  /* Set up the proc fs entry for 'snmp' object. */
> @@ -251,7 +251,7 @@ static const struct file_operations sctp_eps_seq_fops = {
>  	.open	 = sctp_eps_seq_open,
>  	.read	 = seq_read,
>  	.llseek	 = seq_lseek,
> -	.release = seq_release,
> +	.release = seq_release_net,
>  };
>  
>  /* Set up the proc fs entry for 'eps' object. */
> @@ -372,7 +372,7 @@ static const struct file_operations sctp_assocs_seq_fops = {
>  	.open	 = sctp_assocs_seq_open,
>  	.read	 = seq_read,
>  	.llseek	 = seq_lseek,
> -	.release = seq_release,
> +	.release = seq_release_net,
>  };
>  
>  /* Set up the proc fs entry for 'assocs' object. */
> @@ -517,7 +517,7 @@ static const struct file_operations sctp_remaddr_seq_fops = {
>  	.open = sctp_remaddr_seq_open,
>  	.read = seq_read,
>  	.llseek = seq_lseek,
> -	.release = seq_release,
> +	.release = seq_release_net,
>  };
>  
>  int __net_init sctp_remaddr_proc_init(struct net *net)
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

