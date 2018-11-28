From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 28 Nov 2018 12:21:38 +0000
Subject: Re: [PATCHv2 net] sctp: update frag_point when stream_interleave is set
Message-Id: <20181128122138.GA32491@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <507afa887be8d5be9cc3030f6f21bc40719615e2.1543317110.git.lucien.xin@gmail.com>
In-Reply-To: <507afa887be8d5be9cc3030f6f21bc40719615e2.1543317110.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Jakub Audykowicz <jakub.audykowicz@gmail.com>

On Tue, Nov 27, 2018 at 07:11:50PM +0800, Xin Long wrote:
> sctp_assoc_update_frag_point() should be called whenever asoc->pathmtu
> changes, but we missed one place in sctp_association_init(). It would
> cause frag_point is zero when sending data.
> 
> As says in Jakub's reproducer, if sp->pathmtu is set by socketopt, the
> new asoc->pathmtu inherits it in sctp_association_init(). Later when
> transports are added and their pmtu >= asoc->pathmtu, it will never
> call sctp_assoc_update_frag_point() to set frag_point.
> 
> This patch is to fix it by updating frag_point after asoc->pathmtu is
> set as sp->pathmtu in sctp_association_init(). Note that it moved them
> after sctp_stream_init(), as stream->si needs to be set first.
> 
> Frag_point's calculation is also related with datachunk's type, so it
> needs to update frag_point when stream->si may be changed in
> sctp_process_init().
> 
> v1->v2:
>   - call sctp_assoc_update_frag_point() separately in sctp_process_init
>     and sctp_association_init, per Marcelo's suggestion.
> 
> Fixes: 2f5e3c9df693 ("sctp: introduce sctp_assoc_update_frag_point")
> Reported-by: Jakub Audykowicz <jakub.audykowicz@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/associola.c     | 7 ++++---
>  net/sctp/sm_make_chunk.c | 3 +++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 6a28b96..dd77ec3 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -118,9 +118,6 @@ static struct sctp_association *sctp_association_init(
>  	asoc->flowlabel = sp->flowlabel;
>  	asoc->dscp = sp->dscp;
>  
> -	/* Initialize default path MTU. */
> -	asoc->pathmtu = sp->pathmtu;
> -
>  	/* Set association default SACK delay */
>  	asoc->sackdelay = msecs_to_jiffies(sp->sackdelay);
>  	asoc->sackfreq = sp->sackfreq;
> @@ -252,6 +249,10 @@ static struct sctp_association *sctp_association_init(
>  			     0, gfp))
>  		goto fail_init;
>  
> +	/* Initialize default path MTU. */
> +	asoc->pathmtu = sp->pathmtu;
> +	sctp_assoc_update_frag_point(asoc);
> +
>  	/* Assume that peer would support both address types unless we are
>  	 * told otherwise.
>  	 */
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 4a4fd19..f4ac6c5 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2462,6 +2462,9 @@ int sctp_process_init(struct sctp_association *asoc, struct sctp_chunk *chunk,
>  			     asoc->c.sinit_max_instreams, gfp))
>  		goto clean_up;
>  
> +	/* Update frag_point when stream_interleave may get changed. */
> +	sctp_assoc_update_frag_point(asoc);
> +
>  	if (!asoc->temp && sctp_assoc_set_id(asoc, gfp))
>  		goto clean_up;
>  
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
