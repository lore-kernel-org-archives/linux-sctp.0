From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 08 Feb 2013 15:50:02 +0000
Subject: Re: [PATCH net 2/2] net: sctp: sctp_endpoint_free: zero out secret key data
Message-Id: <51151EAA.2090302@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360327229.git.dborkman@redhat.com> <cf390ae999888aafe57914bcd87e5207be154557.1360327229.git.dborkman@redhat.com>
In-Reply-To: <cf390ae999888aafe57914bcd87e5207be154557.1360327229.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 02/08/2013 08:04 AM, Daniel Borkmann wrote:
> On sctp_endpoint_destroy, previously used sensitive keying material
> should be zeroed out before the memory is returned, as we already do
> with e.g. auth keys when released.
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

I'll ack this, but the whole multiple cookie keys code is completely 
unused and has been all this time.  Noone uses anything other then the 
secret_key[0] since there is no changeover support anywhere.  It might 
be nice to clean that up too.

Acked-by: Vlad Yasevich <vyasevic@redhat.com>

-vlad

> ---
>   net/sctp/endpointola.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
> index 17a001b..1a9c5fb 100644
> --- a/net/sctp/endpointola.c
> +++ b/net/sctp/endpointola.c
> @@ -249,6 +249,8 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
>   /* Final destructor for endpoint.  */
>   static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
>   {
> +	int i;
> +
>   	SCTP_ASSERT(ep->base.dead, "Endpoint is not dead", return);
>
>   	/* Free up the HMAC transform. */
> @@ -271,6 +273,9 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
>   	sctp_inq_free(&ep->base.inqueue);
>   	sctp_bind_addr_free(&ep->base.bind_addr);
>
> +	for (i = 0; i < SCTP_HOW_MANY_SECRETS; ++i)
> +		memset(&ep->secret_key[i], 0, SCTP_SECRET_SIZE);
> +
>   	/* Remove and free the port */
>   	if (sctp_sk(ep->base.sk)->bind_hash)
>   		sctp_put_port(ep->base.sk);
>


c
If
