From: Vlad Yasevich <vyasevich@gmail.com>
Date: Thu, 07 Feb 2013 15:04:44 +0000
Subject: Re: [PATCH net 1/2] net: sctp: sctp_auth_make_key_vector: fix undefined ref-count behaviour
Message-Id: <5113C28C.2050607@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360231701.git.dborkman@redhat.com> <5eff11271160e84c7fc2d97b81161b1ae7be4a6e.1360231701.git.dborkman@redhat.com>
In-Reply-To: <5eff11271160e84c7fc2d97b81161b1ae7be4a6e.1360231701.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On 02/07/2013 05:55 AM, Daniel Borkmann wrote:
> In sctp_auth_make_key_vector(), a sctp_auth_bytes structure is being
> allocated, but without setting its object reference count, thus it's
> initialized with a random value from the memory, which can lead to
> i) premature free's of this object when being put (with possible
> subsequent kernel panics), or ii) memory leaks when refcount has a
> high value.
>
> Fix this by using the appropriate sctp_auth_create_key() allocator,
> which performs sanity checks, sets length and the refcount, as similar
> done in sctp_auth_asoc_set_secret() and others. This bug seems to be
> present since 2007 (1f485649f529: Implement SCTP-AUTH internals).

Not strictly a bug.  The vectors are temporary and directly freed by the 
caller.   They are only used by sctp_auth_asoc_create_secret() which 
builds the association secret key.  The vectors are destroyed at the end 
of that function using kfree() thus noone really cares about
the refcount on them and there are no leaks.

If you are going to convert to using sctp_auth_create_key() then you
need to convert the callers to user to use sctp_auth_key_put(). 
Otherwise you are leaking object counts.

-vlad

>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>   net/sctp/auth.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/net/sctp/auth.c b/net/sctp/auth.c
> index 159b9bc..55f1b06 100644
> --- a/net/sctp/auth.c
> +++ b/net/sctp/auth.c
> @@ -205,12 +205,10 @@ static struct sctp_auth_bytes *sctp_auth_make_key_vector(
>           if (chunks)
>   		len += ntohs(chunks->param_hdr.length);
>
> -	new = kmalloc(sizeof(struct sctp_auth_bytes) + len, gfp);
> +	new = sctp_auth_create_key(len, gfp);
>   	if (!new)
>   		return NULL;
>
> -	new->len = len;
> -
>   	memcpy(new->data, random, ntohs(random->param_hdr.length));
>   	offset += ntohs(random->param_hdr.length);
>
>

