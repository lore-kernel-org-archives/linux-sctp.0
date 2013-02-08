From: Vlad Yasevich <vyasevich@gmail.com>
Date: Fri, 08 Feb 2013 15:01:48 +0000
Subject: Re: [PATCH net-next] net: sctp: sctp_auth_make_key_vector: use sctp_auth_create_key
Message-Id: <5115135C.6050601@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360314390.git.dborkman@redhat.com> <783e1129996c3f09c7da121f5dd91c8ac7ba5baa.1360314390.git.dborkman@redhat.com>
In-Reply-To: <783e1129996c3f09c7da121f5dd91c8ac7ba5baa.1360314390.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 02/08/2013 04:22 AM, Daniel Borkmann wrote:
> In sctp_auth_make_key_vector, we allocate a temporary sctp_auth_bytes
> structure with kmalloc instead of the sctp_auth_create_key allocator.
> Change this to sctp_auth_create_key as it is the case everywhere else,
> so that we also can properly free it via sctp_auth_key_put. This makes
> it easier for future code changes in the structure and allocator itself,
> since a single API is consistently used for this purpose. Also, by
> using sctp_auth_create_key we're doing sanity checks over the arguments.
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/auth.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 94a12de..5ec7509 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -209,12 +209,10 @@ static struct sctp_auth_bytes *sctp_auth_make_key_vector(
>
>   	len = random_len + hmacs_len + chunks_len;
>
> -	new = kmalloc(sizeof(struct sctp_auth_bytes) + len, gfp);
> +	new = sctp_auth_create_key(len, gfp);
>   	if (!new)
>   		return NULL;
>
> -	new->len = len;
> -
>   	memcpy(new->data, random, random_len);
>   	offset += random_len;
>
> @@ -353,8 +351,8 @@ static struct sctp_auth_bytes *sctp_auth_asoc_create_secret(
>   	secret = sctp_auth_asoc_set_secret(ep_key, first_vector, last_vector,
>   					    gfp);
>   out:
> -	kfree(local_key_vector);
> -	kfree(peer_key_vector);
> +	sctp_auth_key_put(local_key_vector);
> +	sctp_auth_key_put(peer_key_vector);
>
>   	return secret;
>   }
>

