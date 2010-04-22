From: Wei Yongjun <yjwei@cn.fujitsu.com>
Date: Thu, 22 Apr 2010 01:36:50 +0000
Subject: Re: [PATCH 2.6.27.28]: fix kernel dead if sending SET_PRIMARY ASCONF
Message-Id: <4BCFA832.8050301@cn.fujitsu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <g2vfe1c05ca1004210349wec6d5452u77fcc226a80f1d08@mail.gmail.com>
In-Reply-To: <g2vfe1c05ca1004210349wec6d5452u77fcc226a80f1d08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org


> The linux kernel will die if an application send SET_PRIMARY ASCONF
> immediately after ADDIP ASCONF.
> The reason is that SCTP finishes processing ASCONF_ACK, it sends the next
> pending ASCONF. Therefore the state machine function sctp_do_sm() run
> recursively. The commands for ASCONF are executed before the commands
> for ASCONF_ACK.
> The command sequences are running in reversed order. Therefore, the T4
> timer for the new ASCONF starts before the old T4 timer stops. However,
> SCTP uses only one timer for all ASCONF chunks.
>
> This fixes the problem if deleting the statements for sending the next
> ASCONF during processing ASCONF_ACK, and instead, use a new command
> "SCTP_CMD_SEND_NEXT_ASCONF" for sending the next ASCONF chunk in the
> sideeffect function of ASCONF_ACK.
>
> Kernel version: 2.6.27.28
>
> diff -uprN a/include/net/sctp/command.h b/include/net/sctp/command.h
> --- a/include/net/sctp/command.h    2010-04-20 17:24:18.000000000 +0100
> +++ b/include/net/sctp/command.h    2010-04-21 09:55:37.000000000 +0100
> @@ -105,6 +105,7 @@ typedef enum {
>      SCTP_CMD_ASSOC_SHKEY,    /* generate the association shared keys */
>      SCTP_CMD_T1_RETRAN,     /* Mark for retransmission after T1 timeout  */
>      SCTP_CMD_UPDATE_INITTAG, /* Update peer inittag */
> +    SCTP_CMD_SEND_NEXT_ASCONF, /* Send the next ASCONF after
> processing ASCONF_ACK */
>      SCTP_CMD_LAST
>  } sctp_verb_t;
>
> diff -uprN a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> --- a/net/sctp/sm_make_chunk.c    2010-04-20 17:15:01.000000000 +0100
> +++ b/net/sctp/sm_make_chunk.c    2010-04-21 09:39:17.000000000 +0100
> @@ -3290,21 +3290,6 @@ int sctp_process_asconf_ack(struct sctp_
>      sctp_chunk_free(asconf);
>      asoc->addip_last_asconf = NULL;
>
> -    /* Send the next asconf chunk from the addip chunk queue. */
> -    if (!list_empty(&asoc->addip_chunk_list)) {
> -        struct list_head *entry = asoc->addip_chunk_list.next;
> -        asconf = list_entry(entry, struct sctp_chunk, list);
> -
> -        list_del_init(entry);
> -
> -        /* Hold the chunk until an ASCONF_ACK is received. */
> -        sctp_chunk_hold(asconf);
> -        if (sctp_primitive_ASCONF(asoc, asconf))
> -            sctp_chunk_free(asconf);
> -        else
> -            asoc->addip_last_asconf = asconf;
> -    }
> -
>      return retval;
>  }
>
> diff -uprN a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
> --- a/net/sctp/sm_sideeffect.c    2010-04-20 17:15:01.000000000 +0100
> +++ b/net/sctp/sm_sideeffect.c    2010-04-21 09:33:43.000000000 +0100
> @@ -1082,6 +1082,25 @@ static int sctp_cmd_interpreter(sctp_eve
>       */
>      while (NULL != (cmd = sctp_next_cmd(commands))) {
>          switch (cmd->verb) {
> +
> +        case SCTP_CMD_SEND_NEXT_ASCONF:
> +            asoc = cmd->obj.ptr;
> +            /* Send the next asconf chunk from the addip chunk queue. */
> +            if (!list_empty(&asoc->addip_chunk_list)) {
> +                struct list_head *entry = asoc->addip_chunk_list.next;
> +                struct sctp_chunk *asconf = list_entry(entry, struct
> sctp_chunk, list);
> +
> +                list_del_init(entry);
> +
> +                /* Hold the chunk until an ASCONF_ACK is received. */
> +                sctp_chunk_hold(asconf);
> +                if (sctp_primitive_ASCONF(asoc, asconf))
> +                    sctp_chunk_free(asconf);
> +                else
> +                    asoc->addip_last_asconf = asconf;
> +            }
> +            break;
> +
>   

It is better to make a function like sctp_do_send_next_asconf() to
do this, and just call it in here.

>          case SCTP_CMD_NOP:
>              /* Do nothing. */
>              break;
> diff -uprN a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> --- a/net/sctp/sm_statefuns.c    2010-04-20 17:15:01.000000000 +0100
> +++ b/net/sctp/sm_statefuns.c    2010-04-21 09:54:15.000000000 +0100
> @@ -3585,6 +3585,9 @@ sctp_disposition_t sctp_sf_do_asconf_ack
>      if ((rcvd_serial = sent_serial) && asoc->addip_last_asconf) {
>          sctp_add_cmd_sf(commands, SCTP_CMD_TIMER_STOP,
>                  SCTP_TO(SCTP_EVENT_TIMEOUT_T4_RTO));
> +
> +        sctp_add_cmd_sf(commands, SCTP_CMD_SEND_NEXT_ASCONF,
> +            SCTP_ASOC(asoc));
>
>   

This should only be done when sctp_process_asconf_ack() return zero.
If sctp_process_asconf_ack() return zero, the ASOC will be abort
>          if (!sctp_process_asconf_ack((struct sctp_association *)asoc,
>                           asconf_ack))
>
>
>
> Signed-off-by: Yuansong Qiao <ysqiao@research.ait.ie>
>                         Shuaijun Zhang <szhang@research.ait.ie>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
