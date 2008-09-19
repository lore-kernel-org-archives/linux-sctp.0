From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Fri, 19 Sep 2008 20:14:20 +0000
Subject: Re: [PATCH] sctp: Fix kernel panic while process protocol violation
Message-Id: <48D4081C.5000608@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <48C47CBC.3000405@cn.fujitsu.com>
In-Reply-To: <48C47CBC.3000405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Wei Yongjun wrote:
> Vlad Yasevich wrote:
>> Wei Yongjun wrote:
>>  
>>> Since call to function sctp_sf_abort_violation() need paramter 'arg'
>>> with
>>> 'struct sctp_chunk' type, it will read the chunk type and chunk
>>> length from
>>> the chunk_hdr member of chunk. But call to sctp_sf_violation_paramlen()
>>> always with 'struct sctp_paramhdr' type's parameter, it will be
>>> passed to
>>> sctp_sf_abort_violation(). This may cause kernel panic.
>>>
>>>    sctp_sf_violation_paramlen()
>>>      |-- sctp_sf_abort_violation()
>>>         |-- sctp_make_abort_violation()
>>>
>>> This patch fixed this problem by add a new paramter 'struct
>>> sctp_paramhdr'
>>> to sctp_make_abort_violation(), if param is not NULL, encode phdr with
>>> param,
>>> if param is NULL, encode phdr with chunk.
>>>
>>> This patch also fix two place which called sctp_sf_violation_paramlen()
>>> with
>>> wrong paramter type.
>>>     
>>
>> GAK!!!  Thanks for finding this.
>>
>> I am not sure I am very happy this approach though...
>>
>> sctp_sf_violation_paramlen() is only used in processing of
>> ascof/asconf_ack,
>> so changing generic ABORT generation to track another argument is not the
>> cleanest solution...
>>
>> In addition, we also have sctp_process_inv_paramlength() which is almost
>> the same thing as sctp_sf_violation_paramlen().  So, I think it would
>> be a good idea to have this code cleaned up and merged into a single
>> function that can be called from both palaces.
>>
>> Part of the problem is that INIT processing expects an error chunk
>> instead
>> of the abort.  However, it's being rather dense in that regard and should
>> be taught how to handle both.
>>   
> 
> Here error chunk is not need, because this is a fatal error and will
> send ABORT which only use
> the payload of this chunk. So, used abort has the same effect.
>> Once that happens, sctp_process_inv_paramlength() can start returning
>> an ABORT chunk back just like sctp_sf_violation_paramlen().  An once
>> that happens, we can call this one function from everywhere.
>>   
> [PATCHv2] sctp: Fix kernel panic while process protocol violation parameter
> 
> Since call to function sctp_sf_abort_violation() need paramter 'arg' with
> 'struct sctp_chunk' type, it will read the chunk type and chunk length from
> the chunk_hdr member of chunk. But call to sctp_sf_violation_paramlen()
> always with 'struct sctp_paramhdr' type's parameter, it will be passed to
> sctp_sf_abort_violation(). This may cause kernel panic.
> 
>   sctp_sf_violation_paramlen()
>     |-- sctp_sf_abort_violation()
>        |-- sctp_make_abort_violation()
> 
> This patch fixed this problem. This patch also fix two place which called
> sctp_sf_violation_paramlen() with wrong paramter type.
> 

Ok.  I like this much better.  For the bug fix, this is good enough, but
as a next step, we consolidate this a little bit more.

Just one question.

> Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
> ---
> include/net/sctp/sm.h    |    3 ++
> net/sctp/sm_make_chunk.c |   37 +++++++++++++++++++++++------------
> net/sctp/sm_statefuns.c  |   48
> +++++++++++++++++++++++++++++++++++----------
> 3 files changed, 64 insertions(+), 24 deletions(-)
> 
> diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
> index 2481173..029a54a 100644
> --- a/include/net/sctp/sm.h
> +++ b/include/net/sctp/sm.h
> @@ -227,6 +227,9 @@ struct sctp_chunk *sctp_make_abort_violation(const
> struct sctp_association *,
>                    const struct sctp_chunk *,
>                    const __u8 *,
>                    const size_t );
> +struct sctp_chunk *sctp_make_violation_paramlen(const struct
> sctp_association *,
> +                   const struct sctp_chunk *,
> +                   struct sctp_paramhdr *);
> struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *,
>                   const struct sctp_transport *,
>                   const void *payload,
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index e8ca4e5..dbc4394 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -1012,6 +1012,29 @@ end:
>     return retval;
> }
> 
> +struct sctp_chunk *sctp_make_violation_paramlen(
> +    const struct sctp_association *asoc,
> +    const struct sctp_chunk *chunk,
> +    struct sctp_paramhdr *param)
> +{
> +    struct sctp_chunk *retval;
> +    static const char error[] = "The following parameter had invalid
> length:";
> +    size_t payload_len = WORD_ROUND(sizeof(error)) +
> sizeof(sctp_errhdr_t) +
> +                        sizeof(sctp_paramhdr_t);

Do we really need the WORD_ROUND above.  Before we were doing error
chunks that could have contained more then one parameter.  But in this
case, we are only going to have this single parameter and the
chunk allocation routing will WORD_ROUND the entire length properly.

-vlad

> +
> +    retval = sctp_make_abort(asoc, chunk, payload_len);
> +    if (!retval)
> +        goto nodata;
> +
> +    sctp_init_cause(retval, SCTP_ERROR_PROTO_VIOLATION,
> +            sizeof(error) + sizeof(sctp_paramhdr_t));
> +    sctp_addto_chunk(retval, sizeof(error), error);
> +    sctp_addto_param(retval, sizeof(sctp_paramhdr_t), param);
> +
> +nodata:
> +    return retval;
> +}
> +
> /* Make a HEARTBEAT chunk.  */
> struct sctp_chunk *sctp_make_heartbeat(const struct sctp_association *asoc,
>                   const struct sctp_transport *transport,
> @@ -1782,11 +1805,6 @@ static int sctp_process_inv_paramlength(const
> struct sctp_association *asoc,
>                     const struct sctp_chunk *chunk,
>                     struct sctp_chunk **errp)
> {
> -    static const char error[] = "The following parameter had invalid
> length:";
> -    size_t        payload_len = WORD_ROUND(sizeof(error)) +
> -                        sizeof(sctp_paramhdr_t);
> -
> -
>     /* This is a fatal error.  Any accumulated non-fatal errors are
>      * not reported.
>      */
> @@ -1794,14 +1812,7 @@ static int sctp_process_inv_paramlength(const
> struct sctp_association *asoc,
>         sctp_chunk_free(*errp);
> 
>     /* Create an error chunk and fill it in with our payload. */
> -    *errp = sctp_make_op_error_space(asoc, chunk, payload_len);
> -
> -    if (*errp) {
> -        sctp_init_cause(*errp, SCTP_ERROR_PROTO_VIOLATION,
> -                sizeof(error) + sizeof(sctp_paramhdr_t));
> -        sctp_addto_chunk(*errp, sizeof(error), error);
> -        sctp_addto_param(*errp, sizeof(sctp_paramhdr_t), param);
> -    }
> +    *errp = sctp_make_violation_paramlen(asoc, chunk, param);
> 
>     return 0;
> }
> diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> index 8848d32..7c622af 100644
> --- a/net/sctp/sm_statefuns.c
> +++ b/net/sctp/sm_statefuns.c
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
> @@ -4240,12 +4240,38 @@ static sctp_disposition_t
> sctp_sf_violation_paramlen(
>                      const struct sctp_endpoint *ep,
>                      const struct sctp_association *asoc,
>                      const sctp_subtype_t type,
> -                     void *arg,
> -                     sctp_cmd_seq_t *commands) {
> -    static const char err_str[] = "The following parameter had invalid
> length:";
> +                     void *arg, void *ext,
> +                     sctp_cmd_seq_t *commands)
> +{
> +    struct sctp_chunk *chunk =  arg;
> +    struct sctp_paramhdr *param = ext;
> +    struct sctp_chunk *abort = NULL;
> 
> -    return sctp_sf_abort_violation(ep, asoc, arg, commands, err_str,
> -                    sizeof(err_str));
> +    if (sctp_auth_recv_cid(SCTP_CID_ABORT, asoc))
> +        goto discard;
> +
> +    /* Make the abort chunk. */
> +    abort = sctp_make_violation_paramlen(asoc, chunk, param);
> +    if (!abort)
> +        goto nomem;
> +
> +    sctp_add_cmd_sf(commands, SCTP_CMD_REPLY, SCTP_CHUNK(abort));
> +    SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
> +
> +    sctp_add_cmd_sf(commands, SCTP_CMD_SET_SK_ERR,
> +            SCTP_ERROR(ECONNABORTED));
> +    sctp_add_cmd_sf(commands, SCTP_CMD_ASSOC_FAILED,
> +            SCTP_PERR(SCTP_ERROR_PROTO_VIOLATION));
> +    SCTP_DEC_STATS(SCTP_MIB_CURRESTAB);
> +
> +discard:
> +    sctp_sf_pdiscard(ep, asoc, SCTP_ST_CHUNK(0), arg, commands);
> +
> +    SCTP_INC_STATS(SCTP_MIB_ABORTEDS);
> +
> +    return SCTP_DISPOSITION_ABORT;
> +nomem:
> +    return SCTP_DISPOSITION_NOMEM;
> }
> 
> /* Handle a protocol violation when the peer trying to advance the

