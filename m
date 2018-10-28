From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 28 Oct 2018 04:17:56 +0000
Subject: Re: [PATCH v2] sctp: socket.c validate sprstat_policy
Message-Id: <CADvbK_dHDq69jtLHh4p9xeonhcLAjSytTZMZ0vN3QzcukP2ajg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20181027205320.14975-1-tomasbortoli@gmail.com>
In-Reply-To: <20181027205320.14975-1-tomasbortoli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tomasbortoli@gmail.com
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, davem <davem@davemloft.net>, linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sun, Oct 28, 2018 at 5:54 AM Tomas Bortoli <tomasbortoli@gmail.com> wrote:
>
> It is possible to perform out-of-bound reads on
> sctp_getsockopt_pr_streamstatus() and on
> sctp_getsockopt_pr_assocstatus() by passing from userspace a
> sprstat_policy that overflows the abandoned_sent/abandoned_unsent
> fixed length arrays. The over-read data are directly copied/leaked
> to userspace.
>
> Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
> Reported-by: syzbot+5da0d0a72a9e7d791748@syzkaller.appspotmail.com
> ---
>  net/sctp/socket.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index fc0386e8ff23..14dce5d95817 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -7083,7 +7083,9 @@ static int sctp_getsockopt_pr_assocstatus(struct sock *sk, int len,
>         }
>
>         policy = params.sprstat_policy;
> -       if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
> +       if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
> +           __SCTP_PR_INDEX(policy) > SCTP_PR_INDEX(MAX) ||
> +           __SCTP_PR_INDEX(policy) < 0)
>                 goto out;
>
>         asoc = sctp_id2assoc(sk, params.sprstat_assoc_id);
> @@ -7142,7 +7144,9 @@ static int sctp_getsockopt_pr_streamstatus(struct sock *sk, int len,
>         }
>
>         policy = params.sprstat_policy;
> -       if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)))
> +       if (!policy || (policy & ~(SCTP_PR_SCTP_MASK | SCTP_PR_SCTP_ALL)) ||
> +           __SCTP_PR_INDEX(policy) > SCTP_PR_INDEX(MAX) ||
> +           __SCTP_PR_INDEX(policy) < 0)
>                 goto out;
This is not the correct fix.
See https://lkml.org/lkml/2018/10/27/136
