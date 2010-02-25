From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 25 Feb 2010 01:19:02 +0000
Subject: Re: [PATCH] sctp: send SHUTDOWN-ACK chunk back to where the SHUTDOWN
Message-Id: <4B85D006.7060103@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4B4C307C.5070901@cn.fujitsu.com>
In-Reply-To: <4B4C307C.5070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Vlad Yasevich wrote:
> I was just doing review of the patches again and testing them out.
>
> I think the following is a more elegant solution.
>
> diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> index 4e4ca65..bbd238d 100644
> --- a/net/sctp/sm_sideeffect.c
> +++ b/net/sctp/sm_sideeffect.c
> @@ -696,11 +696,15 @@ static void sctp_cmd_setup_t2(sctp_cmd_seq_t *cmds,
>  {
>         struct sctp_transport *t;
>
> -       t = sctp_assoc_choose_alter_transport(asoc,
> +       if (chunk->transport)
> +               t = chunk->transport;
> +       else {
> +               t = sctp_assoc_choose_alter_transport(asoc,
>                                               asoc->shutdown_last_sent_to);
> +               chunk->transport = t;
> +       }
>         asoc->shutdown_last_sent_to = t;
>         asoc->timeouts[SCTP_EVENT_TIMEOUT_T2_SHUTDOWN] = t->rto;
> -       chunk->transport = t;
>  }
>
>  /* Helper function to change the state of an association. */
>   

It is OK to me, thanks.


