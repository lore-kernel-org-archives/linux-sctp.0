From: Vladislav Yasevich <vyasevich@gmail.com>
Date: Mon, 25 Jan 2016 03:24:10 +0000
Subject: Re: [PATCH net] sctp: allow setting SCTP_SACK_IMMEDIATELY by the application
Message-Id: <CAGCdqXE1VvyuoyhgJnRtksoRBPHwD0jSbvUHAo3pSErWuGGhBQ@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <e066aaa1725a6cafb73ad270376ed2ebc953917a.1453494301.git.marcelo.leitner@gmail.com>
In-Reply-To: <e066aaa1725a6cafb73ad270376ed2ebc953917a.1453494301.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Jan 22, 2016 at 3:29 PM, Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
> This patch extends commit b93d6471748d ("sctp: implement the sender side
> for SACK-IMMEDIATELY extension") as it didn't white list
> SCTP_SACK_IMMEDIATELY on sctp_msghdr_parse(), causing it to be
> understood as an invalid flag and returning -EINVAL to the application.
>
> Note that the actual handling of the flag is already there in
> sctp_datamsg_from_user().
>
> https://tools.ietf.org/html/rfc7053#section-7
>
> Fixes: b93d6471748d ("sctp: implement the sender side for SACK-IMMEDIATELY extension")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> ---
>  net/sctp/socket.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 2657b51f627625a4d674041da1f6dd913932b1d7..594ba9db9c2660b6b0803a2a3955ea7e8b3a7a44 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -6638,6 +6638,7 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
>
>                         if (cmsgs->srinfo->sinfo_flags &
>                             ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> +                             SCTP_SACK_IMMEDIATELY |
>                               SCTP_ABORT | SCTP_EOF))
>                                 return -EINVAL;
>                         break;
> @@ -6661,6 +6662,7 @@ static int sctp_msghdr_parse(const struct msghdr *msg, sctp_cmsgs_t *cmsgs)
>
>                         if (cmsgs->sinfo->snd_flags &
>                             ~(SCTP_UNORDERED | SCTP_ADDR_OVER |
> +                             SCTP_SACK_IMMEDIATELY |
>                               SCTP_ABORT | SCTP_EOF))
>                                 return -EINVAL;
>                         break;
> --
> 2.5.0
>
