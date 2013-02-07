From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Feb 2013 15:05:46 +0000
Subject: Re: [PATCH net 2/2] net: sctp: sctp_auth_key_put: use kzfree instead of kfree
Message-Id: <5113C2CA.6080102@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360231701.git.dborkman@redhat.com> <8c764d916f21d56402a5b9a915ea31d927898da0.1360231701.git.dborkman@redhat.com>
In-Reply-To: <8c764d916f21d56402a5b9a915ea31d927898da0.1360231701.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 02/07/2013 05:55 AM, Daniel Borkmann wrote:
> For sensitive data like keying material, it is common practice to zero
> out keys before returning the memory back to the allocator. Thus, use
> kzfree instead of kfree.
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>   net/sctp/auth.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 55f1b06..69fcd6d 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -71,7 +71,7 @@ void sctp_auth_key_put(struct sctp_auth_bytes *key)
>   		return;
>
>   	if (atomic_dec_and_test(&key->refcnt)) {
> -		kfree(key);
> +		kzfree(key);
>   		SCTP_DBG_OBJCNT_DEC(keys);
>   	}
>   }
>

