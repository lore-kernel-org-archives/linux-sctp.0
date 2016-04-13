From: Steven Ding <wjdingdev@gmail.com>
Date: Wed, 13 Apr 2016 02:39:20 +0000
Subject: uapi header mismatch with kernel ? //[PATCH] net: sctp: fix ABI through sctp_assoc_to_state helper
Message-Id: <CA+js23Fr8vHUZi4VnrR7OSAfOqtEK6832WsXCmVNy4W-w=kDxw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

Hi All,

This is Steven DING working with sooqing (sooqing@gmail.com).

He ever contacted in the year 2014 for the Linux kernel 3.x issue
where the SCTP states definition differ between kernel space and user
space. Daniel Borkmann confirmed the issue and provided a private fix
for it. He also planned to submit to the kernel later.

Now I'm using Debian kernel 3.2.0-4-amd64, and it seems the issue is still
there. I looked up the branches 3.14.x and I failed to find the fix.
So I'm not sure whether the fix has been in the Linux kernel, or which
load has the fix,
or probably I just missed it somewhere? Could anyone help me?

BTW, I applied Daniel's patch with 3.14.58 and it worked well.


> On 08/28/2014 08:33 AM, 苏庆 wrote:
> > Hi all,
> >
> > I found that In 3.x kernel, the sctp states are defined differently
> > between kernel and uapi header. This makes our application fails to
> > work.
> >
> > Is that a mismatch or am I missing something?
>
> You are correct, and that's not good ... can you try out the below
> kernel patch?
>
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
> @@ -320,6 +320,19 @@ static inline sctp_assoc_t sctp_assoc2id(const
> struct sctp_association *asoc)
>         return asoc ? asoc->assoc_id : 0;
>   }
>
> +static inline enum sctp_sstat_state
> +sctp_assoc_to_state(const struct sctp_association *asoc)
> +{
> +       /* SCTP's uapi always had SCTP_EMPTY(=0) as a dummy state, but we
> +        * got rid of it in kernel space. Therefore SCTP_CLOSED et al
> +        * start at =1 in user space, but actually as =0 in kernel space.
> +        * Now that we may not break user space and SCTP_EMPTY is exposed
> +        * there, hence we need to fix it up with an ugly offset to not
> +        * break applications.
> +        */
> +       return asoc->state + 1;
> +}
> +
>   /* Look up the association by its id.  */
>   struct sctp_association *sctp_id2assoc(struct sock *sk, sctp_assoc_t id);
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index eb71d49..634a2ab 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -4243,7 +4243,7 @@ static int sctp_getsockopt_sctp_status(struct
> sock *sk, int len,
>         transport = asoc->peer.primary_path;
>
>         status.sstat_assoc_id = sctp_assoc2id(asoc);
> -       status.sstat_state = asoc->state;
> +       status.sstat_state = sctp_assoc_to_state(asoc);
>         status.sstat_rwnd =  asoc->peer.rwnd;
>         status.sstat_unackdata = asoc->unack_data;
>
> --
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Steven
