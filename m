From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu, 28 Aug 2014 07:47:18 +0000
Subject: Re: uapi header mismatch with kernel ?
Message-Id: <53FEDE86.2090705@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <CA+sbV4gaHaEskjKiAZOGUXAr5zjbCF7F70KC01y9xgOb8KcPng@mail.gmail.com>
In-Reply-To: <CA+sbV4gaHaEskjKiAZOGUXAr5zjbCF7F70KC01y9xgOb8KcPng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

On 08/28/2014 09:34 AM, Daniel Borkmann wrote:
> On 08/28/2014 08:33 AM, 苏庆 wrote:
>> Hi all,
>>
>> I found that In 3.x kernel, the sctp states are defined differently
>> between kernel and uapi header. This makes our application fails to
>> work.
>>
>> Is that a mismatch or am I missing something?
>
> You are correct, and that's not good ... can you try out the below
> kernel patch?

Note, the problem is that we cannot just redefine the sctp_state_t
enum back to as it was as it's accessing a function pointer lookup
table, so I think it's better to just add this offset for user space
now. It's read-only anyway.

>  From 90653829a4d406898f6906849f3eca481ec01894 Mon Sep 17 00:00:00 2001
> From: Daniel Borkmann <dborkman@redhat.com>
> Date: Thu, 28 Aug 2014 09:26:36 +0200
> Subject: [PATCH] net: sctp: fix ABI through sctp_assoc_to_state helper
>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> ---
>   include/net/sctp/sctp.h | 13 +++++++++++++
>   net/sctp/socket.c       |  2 +-
>   2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
> index f6e7397..f50dccf 100644
> --- a/include/net/sctp/sctp.h
> +++ b/include/net/sctp/sctp.h
> @@ -320,6 +320,19 @@ static inline sctp_assoc_t sctp_assoc2id(const struct sctp_association *asoc)
>       return asoc ? asoc->assoc_id : 0;
>   }
>
> +static inline enum sctp_sstat_state
> +sctp_assoc_to_state(const struct sctp_association *asoc)
> +{
> +    /* SCTP's uapi always had SCTP_EMPTY(=0) as a dummy state, but we
> +     * got rid of it in kernel space. Therefore SCTP_CLOSED et al
> +     * start at =1 in user space, but actually as =0 in kernel space.
> +     * Now that we may not break user space and SCTP_EMPTY is exposed
> +     * there, hence we need to fix it up with an ugly offset to not
> +     * break applications. :(
> +     */
> +    return asoc->state + 1;
> +}
> +
>   /* Look up the association by its id.  */
>   struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id);
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index eb71d49..634a2ab 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4243,7 +4243,7 @@ static int sctp_getsockopt_sctp_status(struct sock *sk, int len,
>       transport = asoc->peer.primary_path;
>
>       status.sstat_assoc_id = sctp_assoc2id(asoc);
> -    status.sstat_state = asoc->state;
> +    status.sstat_state = sctp_assoc_to_state(asoc);
>       status.sstat_rwnd =  asoc->peer.rwnd;
>       status.sstat_unackdata = asoc->unack_data;
>
