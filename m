From: Joe Perches <joe@perches.com>
Date: Fri, 01 Mar 2019 22:22:30 +0000
Subject: Re: [PATCH] sctp: chunk.c: correct format string for size_t in printk
Message-Id: <9bcd6a2389a8ffce41768ddc8b224daedacf76b7.camel@perches.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190228113652.55552-1-maennich@google.com>
In-Reply-To: <20190228113652.55552-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthias Maennich <maennich@google.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2019-02-28 at 11:36 +0000, Matthias Maennich wrote:
> According to Documentation/core-api/printk-formats.rst, size_t should be
> printed with %zu, rather than %Zu.
> 
> In addition, using %Zu triggers a warning on clang (-Wformat-extra-args):
[]
> diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
[]
> @@ -192,7 +192,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
>  	if (unlikely(!max_data)) {
>  		max_data = sctp_min_frag_point(sctp_sk(asoc->base.sk),
>  					       sctp_datachk_len(&asoc->stream));
> -		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%Zu)",
> +		pr_warn_ratelimited("%s: asoc:%p frag_point is zero, forcing max_data to default minimum (%zu)",
>  				    __func__, asoc, max_data);

trivia: the format is also missing a terminating '\n'
