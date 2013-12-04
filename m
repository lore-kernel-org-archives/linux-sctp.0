From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed, 04 Dec 2013 08:57:20 +0000
Subject: Re: [PATCH] sctp: disable max_burst when the max_burst is 0
Message-Id: <529EEE70.7090801@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <529C2E01.3090005@huawei.com> <20131202115640.GA10857@hmsreliant.think-freely.org> <DABC28BB-074A-42CE-ACEC-BE9893B4ED06@lurchi.franken.de> <529D7A82.3070207@huawei.com>
In-Reply-To: <529D7A82.3070207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wang Weidong <wangweidong1@huawei.com>
Cc: David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>, Michael Tuexen <Michael.Tuexen@lurchi.franken.de>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, dingtianhong@huawei.com

On 12/03/2013 07:30 AM, Wang Weidong wrote:
> As Michael pointed out that when max_burst is 0, it just disable
> max_burst. It declared in rfc6458#section-8.1.24. so add the check
> in sctp_transport_burst_limited, when it 0, just do nothing.
>
> Suggested-by: Vlad Yasevich <vyasevich@gmail.com>
> Suggested-by: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
> ---
>   net/sctp/transport.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/sctp/transport.c b/net/sctp/transport.c
> index e332efb..e580e34 100644
> --- a/net/sctp/transport.c
> +++ b/net/sctp/transport.c
> @@ -573,7 +573,8 @@ void sctp_transport_burst_limited(struct sctp_transport *t)
>   	u32 old_cwnd = t->cwnd;
>   	u32 max_burst_bytes;
>
> -	if (t->burst_limited)
> +	/* if the max_burst is 0, do notihing */
> +	if (t->burst_limited || !asoc->max_burst)
>   		return;

Minor nitpick ... you can remove the comment as it contains a typo and
basically says what the code is doing anyway, so you could instead make
the code a bit more clear for readers e.g. "asoc->max_burst = 0".

>   	max_burst_bytes = t->flight_size + (asoc->max_burst * asoc->pathmtu);
>
