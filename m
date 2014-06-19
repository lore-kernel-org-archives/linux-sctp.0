From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 19 Jun 2014 13:28:16 +0000
Subject: Re: [PATCH net] net: sctp: check proc_dointvec result in proc_sctp_do_auth
Message-Id: <53A2E570.7000404@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1403127991-18114-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1403127991-18114-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 06/18/2014 05:46 PM, Daniel Borkmann wrote:
> When writing to the sysctl field net.sctp.auth_enable, it can well
> be that the user buffer we handed over to proc_dointvec() via
> proc_sctp_do_auth() handler contains something other than integers.
> 
> In that case, we would set an uninitialized 4-byte value from the
> stack to net->sctp.auth_enable that can be leaked back when reading
> the sysctl variable, and it can unintentionally turn auth_enable
> on/off based on the stack content since auth_enable is interpreted
> as a boolean.
> 
> Fix it up by making sure proc_dointvec() returned sucessfully.
> 
> Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
> Reported-by: Florian Westphal <fwestpha@redhat.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>  net/sctp/sysctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index dcb1959..8a5b5c2 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -444,8 +444,7 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
>  		tbl.data = &net->sctp.auth_enable;
>  
>  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> -
> -	if (write) {
> +	if (write && ret = 0) {
>  		struct sock *sk = net->sctp.ctl_sock;
>  
>  		net->sctp.auth_enable = new_value;
> 

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad
