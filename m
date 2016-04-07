From: Jakub Sitnicki <jkbs@redhat.com>
Date: Thu, 07 Apr 2016 08:05:32 +0000
Subject: Re: [PATCH v2 2/2] sctp: delay calls to sk_data_ready() as much as possible
Message-Id: <87egah3ktv.fsf@beetle.home>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1459952558.git.marcelo.leitner@gmail.com> <703257ed516669b180fcce57e6745b1853da9a95.1459952558.git.marcelo.leitner@gmail.com>
In-Reply-To: <703257ed516669b180fcce57e6745b1853da9a95.1459952558.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org

On Wed, Apr 06, 2016 at 07:53 PM CEST, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> Currently, the processing of multiple chunks in a single SCTP packet
> leads to multiple calls to sk_data_ready, causing multiple wake up
> signals which are costly and doesn't make it wake up any faster.
>
> With this patch it will notice that the wake up is pending and will do it
> before leaving the state machine interpreter, latest place possible to
> do it realiably and cleanly.
>
> Note that sk_data_ready events are not dependent on asocs, unlike waking
> up writers.
>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---

[...]

> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 7fe56d0acabf66cfd8fe29dfdb45f7620b470ac7..e7042f9ce63b0cfca50cae252f51b60b68cb5731 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -1742,6 +1742,11 @@ out:
>  			error = sctp_outq_uncork(&asoc->outqueue, gfp);
>  	} else if (local_cork)
>  		error = sctp_outq_uncork(&asoc->outqueue, gfp);
> +
> +	if (sctp_sk(ep->base.sk)->pending_data_ready) {
> +		ep->base.sk->sk_data_ready(ep->base.sk);
> +		sctp_sk(ep->base.sk)->pending_data_ready = 0;
> +	}
>  	return error;
>  nomem:
>  	error = -ENOMEM;

Would it make sense to introduce a local variable for ep->base.sk (and
make this function 535+1 lines long ;-)

      struct sock *sk = ep->base.sk;

... like sctp_ulpq_tail_event() does?

Thanks,
Jakub
