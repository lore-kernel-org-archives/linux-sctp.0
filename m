From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 15 Sep 2008 15:40:41 +0000
Subject: Re: [PATCH] sctp: Fix to start T5-shutdown-guard timer while enter
Message-Id: <48CE81F9.9060407@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48C0837E.3060304@cn.fujitsu.com>
In-Reply-To: <48C0837E.3060304@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> RFC 4960: Section 9.2
> The sender of the SHUTDOWN MAY also start an overall guard timer
> 'T5-shutdown-guard' to bound the overall time for the shutdown
> sequence.  At the expiration of this timer, the sender SHOULD abort
> the association by sending an ABORT chunk.  If the 'T5-shutdown-
> guard' timer is used, it SHOULD be set to the recommended value of 5
> times 'RTO.Max'.
> 
> The timer 'T5-shutdown-guard' is used to counter the overall time
> for shutdown sequence, and it's start by the sender of the SHUTDOWN.
> So timer 'T5-shutdown-guard' should be start when we send the first
> SHUTDOWN chunk and enter the SHUTDOWN-SENT state, not start when we
> receipt of the SHUTDOWN primitive and enter SHUTDOWN-PENDING state.
> 
> If 'T5-shutdown-guard' timer is start at SHUTDOWN-PENDING state, the
> association may be ABORT while data is still transmitting.

Hi Wei

You missed the autoclose case which would have been very easy to test
had you run the regressions test from the lksctp-tools package.

In the future please run those tests and feel free to add tests there
to enhance our test matrix.

I'll fix it up this time.  Thanks
-vlad

> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
> net/sctp/sm_statefuns.c  |   14 +++++++-------
> net/sctp/sm_statetable.c |    2 +-
> 2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 8848d32..c4eea16 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -4517,13 +4517,6 @@ sctp_disposition_t sctp_sf_do_9_2_prm_shutdown(
>     sctp_add_cmd_sf(commands, SCTP_CMD_NEW_STATE,
>             SCTP_STATE(SCTP_STATE_SHUTDOWN_PENDING));
> 
> -    /* sctpimpguide-05 Section 2.12.2
> -     * The sender of the SHUTDOWN MAY also start an overall guard timer
> -     * 'T5-shutdown-guard' to bound the overall time for shutdown
> sequence.
> -     */
> -    sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
> -            SCTP_TO(SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD));
> -
>     disposition = SCTP_DISPOSITION_CONSUME;
>     if (sctp_outq_is_empty(&asoc->outqueue)) {
>         disposition = sctp_sf_do_9_2_start_shutdown(ep, asoc, type,
> @@ -4968,6 +4961,13 @@ sctp_disposition_t sctp_sf_do_9_2_start_shutdown(
>     sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
>             SCTP_TO(SCTP_EVENT_TIMEOUT_T2_SHUTDOWN));
> 
> +    /* RFC 4960 Section 9.2
> +     * The sender of the SHUTDOWN MAY also start an overall guard timer
> +     * 'T5-shutdown-guard' to bound the overall time for shutdown
> sequence.
> +     */
> +    sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_START,
> +            SCTP_TO(SCTP_EVENT_TIMEOUT_T5_SHUTDOWN_GUARD));
> +
>     if (asoc->autoclose)
>         sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
>                 SCTP_TO(SCTP_EVENT_TIMEOUT_AUTOCLOSE));
> diff --git a/net/sctp/sm_statetable.c b/net/sctp/sm_statetable.c
> index d991237..dd4ddc4 100644
> --- a/net/sctp/sm_statetable.c
> +++ b/net/sctp/sm_statetable.c
> @@ -897,7 +897,7 @@ static const sctp_sm_table_entry_t
> other_event_table[SCTP_NUM_OTHER_TYPES][SCTP_
>     /* SCTP_STATE_ESTABLISHED */ \
>     TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
>     /* SCTP_STATE_SHUTDOWN_PENDING */ \
> -    TYPE_SCTP_FUNC(sctp_sf_t5_timer_expire), \
> +    TYPE_SCTP_FUNC(sctp_sf_timer_ignore), \
>     /* SCTP_STATE_SHUTDOWN_SENT */ \
>     TYPE_SCTP_FUNC(sctp_sf_t5_timer_expire), \
>     /* SCTP_STATE_SHUTDOWN_RECEIVED */ \

