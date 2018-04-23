From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 23 Apr 2018 21:33:31 +0000
Subject: Re: [PATCH net-next 1/2] net/sctp: Make wrappers for accessing in/out streams
Message-Id: <20180423213331.GH3711@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
 <1524508866-317485-2-git-send-email-obabin@virtuozzo.com>
In-Reply-To: <1524508866-317485-2-git-send-email-obabin@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Babin <obabin@virtuozzo.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Mon, Apr 23, 2018 at 09:41:05PM +0300, Oleg Babin wrote:
> This patch introduces wrappers for accessing in/out streams indirectly.
> This will enable to replace physically contiguous memory arrays
> of streams with flexible arrays (or maybe any other appropriate
> mechanism) which do memory allocation on a per-page basis.
>
> Signed-off-by: Oleg Babin <obabin@virtuozzo.com>
> ---
>  include/net/sctp/structs.h   |  30 +++++++-----
>  net/sctp/chunk.c             |   6 ++-
>  net/sctp/outqueue.c          |  11 +++--
>  net/sctp/socket.c            |   4 +-
>  net/sctp/stream.c            | 107 +++++++++++++++++++++++++------------------
>  net/sctp/stream_interleave.c |   2 +-
>  net/sctp/stream_sched.c      |  13 +++---
>  net/sctp/stream_sched_prio.c |  22 ++++-----
>  net/sctp/stream_sched_rr.c   |   8 ++--
>  9 files changed, 116 insertions(+), 87 deletions(-)
>
> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index a0ec462..578bb40 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -394,37 +394,37 @@ int sctp_stream_init(struct sctp_stream *stream, __u16 outcnt, __u16 incnt,
>
>  /* What is the current SSN number for this stream? */
>  #define sctp_ssn_peek(stream, type, sid) \
> -	((stream)->type[sid].ssn)
> +	(sctp_stream_##type##_ptr((stream), (sid))->ssn)
>
>  /* Return the next SSN number for this stream.	*/
>  #define sctp_ssn_next(stream, type, sid) \
> -	((stream)->type[sid].ssn++)
> +	(sctp_stream_##type##_ptr((stream), (sid))->ssn++)
>
>  /* Skip over this ssn and all below. */
>  #define sctp_ssn_skip(stream, type, sid, ssn) \
> -	((stream)->type[sid].ssn = ssn + 1)
> +	(sctp_stream_##type##_ptr((stream), (sid))->ssn = ssn + 1)
>
>  /* What is the current MID number for this stream? */
>  #define sctp_mid_peek(stream, type, sid) \
> -	((stream)->type[sid].mid)
> +	(sctp_stream_##type##_ptr((stream), (sid))->mid)
>
>  /* Return the next MID number for this stream.  */
>  #define sctp_mid_next(stream, type, sid) \
> -	((stream)->type[sid].mid++)
> +	(sctp_stream_##type##_ptr((stream), (sid))->mid++)
>
>  /* Skip over this mid and all below. */
>  #define sctp_mid_skip(stream, type, sid, mid) \
> -	((stream)->type[sid].mid = mid + 1)
> +	(sctp_stream_##type##_ptr((stream), (sid))->mid = mid + 1)
>
> -#define sctp_stream_in(asoc, sid) (&(asoc)->stream.in[sid])
> +#define sctp_stream_in(asoc, sid) sctp_stream_in_ptr(&(asoc)->stream, (sid))

This will get confusing:
- sctp_stream_in(asoc, sid)
- sctp_stream_in_ptr(stream, sid)

Considering all usages of sctp_stream_in(), seems you can just update
them to do the ->stream deref and keep only the later implementation.
Which then don't need the _ptr suffix.

  Marcelo
