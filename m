From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Tue, 27 Aug 2013 14:23:30 +0000
Subject: Re: [PATCH net-next v2] net: sctp: sctp_verify_init: clean up mandatory checks and add comment
Message-Id: <521CB662.3050903@cogentembedded.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377612363-10779-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377612363-10779-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

Hello.

On 27-08-2013 18:06, Daniel Borkmann wrote:

> Add a comment related to RFC4960 explaning why we do not check for initial
> TSN, and while at it, remove yoda notation checks and clean up code from
> checks of mandatory conditions. That's probably just really minor, but makes
> reviewing easier.

> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>   v1->v2: update comment as Neil suggested

>   net/sctp/sm_make_chunk.c | 26 ++++++++++++--------------
>   1 file changed, 12 insertions(+), 14 deletions(-)

> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index 01e9783..e1c1531 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2240,25 +2240,23 @@ int sctp_verify_init(struct net *net, const struct sctp_association *asoc,
>   		     struct sctp_chunk **errp)
>   {
>   	union sctp_params param;
> -	int has_cookie = 0;
> +	bool has_cookie = false;
>   	int result;
>
> -	/* Verify stream values are non-zero. */
> -	if ((0 = peer_init->init_hdr.num_outbound_streams) ||
> -	    (0 = peer_init->init_hdr.num_inbound_streams) ||
> -	    (0 = peer_init->init_hdr.init_tag) ||
> -	    (SCTP_DEFAULT_MINWINDOW > ntohl(peer_init->init_hdr.a_rwnd))) {
> -
> +	/* Check for missing mandatory parameters. Note: Initial TSN is
> +	 * also mandatory, but is not checked here since the valid range
> +	 * is 0..2**(32-1). RFC4960, section 3.3.3.

    I don't think you really meant 2**(32-1) = 2**31. Previously you wrote 
2**32-1.

WBR, Sergei

