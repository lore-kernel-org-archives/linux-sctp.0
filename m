From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 08 Sep 2008 15:03:28 +0000
Subject: Re: [PATCH] sctp: Fix kernel panic while process protocol violation
Message-Id: <48C53EC0.7090901@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48C47CBC.3000405@cn.fujitsu.com>
In-Reply-To: <48C47CBC.3000405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Since call to function sctp_sf_abort_violation() need paramter 'arg' with
> 'struct sctp_chunk' type, it will read the chunk type and chunk length from
> the chunk_hdr member of chunk. But call to sctp_sf_violation_paramlen()
> always with 'struct sctp_paramhdr' type's parameter, it will be passed to
> sctp_sf_abort_violation(). This may cause kernel panic.
> 
>    sctp_sf_violation_paramlen()
>      |-- sctp_sf_abort_violation()
>         |-- sctp_make_abort_violation()
> 
> This patch fixed this problem by add a new paramter 'struct sctp_paramhdr'
> to sctp_make_abort_violation(), if param is not NULL, encode phdr with
> param,
> if param is NULL, encode phdr with chunk.
> 
> This patch also fix two place which called sctp_sf_violation_paramlen()
> with
> wrong paramter type.

GAK!!!  Thanks for finding this.

I am not sure I am very happy this approach though...

sctp_sf_violation_paramlen() is only used in processing of ascof/asconf_ack,
so changing generic ABORT generation to track another argument is not the
cleanest solution...

In addition, we also have sctp_process_inv_paramlength() which is almost
the same thing as sctp_sf_violation_paramlen().  So, I think it would
be a good idea to have this code cleaned up and merged into a single
function that can be called from both palaces.

Part of the problem is that INIT processing expects an error chunk instead
of the abort.  However, it's being rather dense in that regard and should
be taught how to handle both.

Once that happens, sctp_process_inv_paramlength() can start returning
an ABORT chunk back just like sctp_sf_violation_paramlen().  An once
that happens, we can call this one function from everywhere.

-vlad


> 
> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
> include/net/sctp/sm.h    |    1 +
> net/sctp/sm_make_chunk.c |   11 +++++++++--
> net/sctp/sm_statefuns.c  |   29 +++++++++++++++--------------
> 3 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 2481173..c080f19 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -225,6 +225,7 @@ struct sctp_chunk *sctp_make_abort_user(const struct
> sctp_association *,
>                     const struct msghdr *, size_t msg_len);
> struct sctp_chunk *sctp_make_abort_violation(const struct
> sctp_association *,
>                    const struct sctp_chunk *,
> +                   const struct sctp_paramhdr *,
>                    const __u8 *,
>                    const size_t );
> struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *,
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index e8ca4e5..6702901 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -989,6 +989,7 @@ static void *sctp_addto_param(struct sctp_chunk
> *chunk, int len,
> struct sctp_chunk *sctp_make_abort_violation(
>     const struct sctp_association *asoc,
>     const struct sctp_chunk *chunk,
> +    const struct sctp_paramhdr *param,
>     const __u8   *payload,
>     const size_t paylen)
> {
> @@ -1003,8 +1004,14 @@ struct sctp_chunk *sctp_make_abort_violation(
>     sctp_init_cause(retval, SCTP_ERROR_PROTO_VIOLATION, paylen
>                     + sizeof(sctp_paramhdr_t));
> 
> -    phdr.type = htons(chunk->chunk_hdr->type);
> -    phdr.length = chunk->chunk_hdr->length;
> +    if (param != NULL) {
> +        phdr.type = param->type;
> +        phdr.length = param->length;
> +    } else {
> +        phdr.type = htons(chunk->chunk_hdr->type);
> +        phdr.length = chunk->chunk_hdr->length;   
> +    }
> +
>     sctp_addto_chunk(retval, paylen, payload);
>     sctp_addto_param(retval, sizeof(sctp_paramhdr_t), &phdr);
> 
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 8848d32..2b13729 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
> @@ -103,7 +103,7 @@ static sctp_disposition_t
> sctp_stop_t1_and_abort(sctp_cmd_seq_t *commands,
> static sctp_disposition_t sctp_sf_abort_violation(
>                      const struct sctp_endpoint *ep,
>                      const struct sctp_association *asoc,
> -                     void *arg,
> +                     void *arg, void *ext,
>                      sctp_cmd_seq_t *commands,
>                      const __u8 *payload,
>                      const size_t paylen);
> @@ -119,7 +119,7 @@ static sctp_disposition_t sctp_sf_violation_paramlen(
>                      const struct sctp_endpoint *ep,
>                      const struct sctp_association *asoc,
>                      const sctp_subtype_t type,
> -                     void *arg,
> +                     void *arg, void *ext,
>                      sctp_cmd_seq_t *commands);
> 
> static sctp_disposition_t sctp_sf_violation_ctsn(
> @@ -3425,7 +3425,7 @@ sctp_disposition_t sctp_sf_do_asconf(const struct
> sctp_endpoint *ep,
>     addr_param = (union sctp_addr_param *)hdr->params;
>     length = ntohs(addr_param->p.length);
>     if (length < sizeof(sctp_paramhdr_t))
> -        return sctp_sf_violation_paramlen(ep, asoc, type,
> +        return sctp_sf_violation_paramlen(ep, asoc, type, arg,
>                (void *)addr_param, commands);
> 
>     /* Verify the ASCONF chunk before processing it. */
> @@ -3433,8 +3433,8 @@ sctp_disposition_t sctp_sf_do_asconf(const struct
> sctp_endpoint *ep,
>                 (sctp_paramhdr_t *)((void *)addr_param + length),
>                 (void *)chunk->chunk_end,
>                 &err_param))
> -        return sctp_sf_violation_paramlen(ep, asoc, type,
> -                          (void *)&err_param, commands);
> +        return sctp_sf_violation_paramlen(ep, asoc, type, arg,
> +                          (void *)err_param, commands);
> 
>     /* ADDIP 5.2 E1) Compare the value of the serial number to the value
>      * the endpoint stored in a new association variable
> @@ -3542,8 +3542,8 @@ sctp_disposition_t sctp_sf_do_asconf_ack(const
> struct sctp_endpoint *ep,
>         (sctp_paramhdr_t *)addip_hdr->params,
>         (void *)asconf_ack->chunk_end,
>         &err_param))
> -        return sctp_sf_violation_paramlen(ep, asoc, type,
> -               (void *)&err_param, commands);
> +        return sctp_sf_violation_paramlen(ep, asoc, type, arg,
> +               (void *)err_param, commands);
> 
>     if (last_asconf) {
>         addip_hdr = (sctp_addiphdr_t *)last_asconf->subh.addip_hdr;
> @@ -4103,13 +4103,14 @@ sctp_disposition_t sctp_sf_violation(const
> struct sctp_endpoint *ep,
> static sctp_disposition_t sctp_sf_abort_violation(
>                      const struct sctp_endpoint *ep,
>                      const struct sctp_association *asoc,
> -                     void *arg,
> +                     void *arg, void *ext,
>                      sctp_cmd_seq_t *commands,
>                      const __u8 *payload,
>                      const size_t paylen)
> {
>     struct sctp_packet *packet = NULL;
>     struct sctp_chunk *chunk =  arg;
> +    struct sctp_paramhdr *param = ext;
>     struct sctp_chunk *abort = NULL;
> 
>     /* SCTP-AUTH, Section 6.3:
> @@ -4127,7 +4128,7 @@ static sctp_disposition_t sctp_sf_abort_violation(
>         goto discard;
> 
>     /* Make the abort chunk. */
> -    abort = sctp_make_abort_violation(asoc, chunk, payload, paylen);
> +    abort = sctp_make_abort_violation(asoc, chunk, param, payload,
> paylen);
>     if (!abort)
>         goto nomem;
> 
> @@ -4227,7 +4228,7 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
> {
>     static const char err_str[]="The following chunk had invalid length:";
> 
> -    return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> +    return sctp_sf_abort_violation(ep, asoc, arg, NULL, commands, err_str,
>                     sizeof(err_str));
> }
> 
> @@ -4240,11 +4241,11 @@ static sctp_disposition_t
> sctp_sf_violation_paramlen(
>                      const struct sctp_endpoint *ep,
>                      const struct sctp_association *asoc,
>                      const sctp_subtype_t type,
> -                     void *arg,
> +                     void *arg, void *ext,
>                      sctp_cmd_seq_t *commands) {
>     static const char err_str[] = "The following parameter had invalid
> length:";
> 
> -    return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> +    return sctp_sf_abort_violation(ep, asoc, arg, ext, commands, err_str,
>                     sizeof(err_str));
> }
> 
> @@ -4263,7 +4264,7 @@ static sctp_disposition_t sctp_sf_violation_ctsn(
> {
>     static const char err_str[]="The cumulative tsn ack beyond the max
> tsn currently sent:";
> 
> -    return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> +    return sctp_sf_abort_violation(ep, asoc, arg, NULL, commands, err_str,
>                     sizeof(err_str));
> }
> 
> @@ -4285,7 +4286,7 @@ static sctp_disposition_t sctp_sf_violation_chunk(
>     if (!asoc)
>         return sctp_sf_violation(ep, asoc, type, arg, commands);
> 
> -    return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> +    return sctp_sf_abort_violation(ep, asoc, arg, NULL, commands, err_str,
>                     sizeof(err_str));
> }
> /***************************************************************************
> 

