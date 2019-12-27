From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 27 Dec 2019 10:47:35 +0000
Subject: Re: [PATCHv2 net-next] sctp: move trace_sctp_probe_path into sctp_outq_sack
Message-Id: <20191227104735.GO4444@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20191227080034.1323-1-qdkevin.kou@gmail.com>
In-Reply-To: <20191227080034.1323-1-qdkevin.kou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kevin Kou <qdkevin.kou@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, davem@davemloft.net

On Fri, Dec 27, 2019 at 08:00:34AM +0000, Kevin Kou wrote:
> The original patch bringed in the "SCTP ACK tracking trace event"
> feature was committed at Dec.20, 2017, it replaced jprobe usage
> with trace events, and bringed in two trace events, one is
> TRACE_EVENT(sctp_probe), another one is TRACE_EVENT(sctp_probe_path).
> The original patch intended to trigger the trace_sctp_probe_path in
> TRACE_EVENT(sctp_probe) as below code,
> 
> +TRACE_EVENT(sctp_probe,
> +
> +       TP_PROTO(const struct sctp_endpoint *ep,
> +                const struct sctp_association *asoc,
> +                struct sctp_chunk *chunk),
> +
> +       TP_ARGS(ep, asoc, chunk),
> +
> +       TP_STRUCT__entry(
> +               __field(__u64, asoc)
> +               __field(__u32, mark)
> +               __field(__u16, bind_port)
> +               __field(__u16, peer_port)
> +               __field(__u32, pathmtu)
> +               __field(__u32, rwnd)
> +               __field(__u16, unack_data)
> +       ),
> +
> +       TP_fast_assign(
> +               struct sk_buff *skb = chunk->skb;
> +
> +               __entry->asoc = (unsigned long)asoc;
> +               __entry->mark = skb->mark;
> +               __entry->bind_port = ep->base.bind_addr.port;
> +               __entry->peer_port = asoc->peer.port;
> +               __entry->pathmtu = asoc->pathmtu;
> +               __entry->rwnd = asoc->peer.rwnd;
> +               __entry->unack_data = asoc->unack_data;
> +
> +               if (trace_sctp_probe_path_enabled()) {
> +                       struct sctp_transport *sp;
> +
> +                       list_for_each_entry(sp, &asoc->peer.transport_addr_list,
> +                                           transports) {
> +                               trace_sctp_probe_path(sp, asoc);
> +                       }
> +               }
> +       ),
> 
> But I found it did not work when I did testing, and trace_sctp_probe_path
> had no output, I finally found that there is trace buffer lock
> operation(trace_event_buffer_reserve) in include/trace/trace_events.h:
> 
> static notrace void                                                     \
> trace_event_raw_event_##call(void *__data, proto)                       \
> {                                                                       \
>         struct trace_event_file *trace_file = __data;                   \
>         struct trace_event_data_offsets_##call __maybe_unused __data_offsets;\
>         struct trace_event_buffer fbuffer;                              \
>         struct trace_event_raw_##call *entry;                           \
>         int __data_size;                                                \
>                                                                         \
>         if (trace_trigger_soft_disabled(trace_file))                    \
>                 return;                                                 \
>                                                                         \
>         __data_size = trace_event_get_offsets_##call(&__data_offsets, args); \
>                                                                         \
>         entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>                                  sizeof(*entry) + __data_size);         \
>                                                                         \
>         if (!entry)                                                     \
>                 return;                                                 \
>                                                                         \
>         tstruct                                                         \
>                                                                         \
>         { assign; }                                                     \
>                                                                         \
>         trace_event_buffer_commit(&fbuffer);                            \
> }
> 
> The reason caused no output of trace_sctp_probe_path is that
> trace_sctp_probe_path written in TP_fast_assign part of
> TRACE_EVENT(sctp_probe), and it will be placed( { assign; } ) after the
> trace_event_buffer_reserve() when compiler expands Macro,
> 
>         entry = trace_event_buffer_reserve(&fbuffer, trace_file,        \
>                                  sizeof(*entry) + __data_size);         \
>                                                                         \
>         if (!entry)                                                     \
>                 return;                                                 \
>                                                                         \
>         tstruct                                                         \
>                                                                         \
>         { assign; }                                                     \
> 
> so trace_sctp_probe_path finally can not acquire trace_event_buffer
> and return no output, that is to say the nest of tracepoint entry function
> is not allowed. The function call flow is:
> 
> trace_sctp_probe()
> -> trace_event_raw_event_sctp_probe()
>  -> lock buffer
>  -> trace_sctp_probe_path()
>    -> trace_event_raw_event_sctp_probe_path()  --nested
>    -> buffer has been locked and return no output.
> 
> This patch is to remove trace_sctp_probe_path from the TP_fast_assign
> part of TRACE_EVENT(sctp_probe) to avoid the nest of entry function,
> and trigger sctp_probe_path_trace in sctp_outq_sack.
> 
> After this patch, you can enable both events individually,
>   # cd /sys/kernel/debug/tracing
>   # echo 1 > events/sctp/sctp_probe/enable
>   # echo 1 > events/sctp/sctp_probe_path/enable
> 
> Or, you can enable all the events under sctp.
> 
>   # echo 1 > events/sctp/enable
> 
> v1->v2:
>  -add trace_sctp_probe_path_enabled check to avoid traversing the
>   transport list when the tracepoint is disabled as Marcelo's suggestion.

Oh, nice, thanks for taking the time to add it back.

Dave already applied your v1, so you actually need an incremental
patch now :-)

> 
> Signed-off-by: Kevin Kou <qdkevin.kou@gmail.com>
> ---
>  include/trace/events/sctp.h | 9 ---------
>  net/sctp/outqueue.c         | 7 +++++++
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/events/sctp.h b/include/trace/events/sctp.h
> index 7475c7b..d4aac34 100644
> --- a/include/trace/events/sctp.h
> +++ b/include/trace/events/sctp.h
> @@ -75,15 +75,6 @@
>  		__entry->pathmtu = asoc->pathmtu;
>  		__entry->rwnd = asoc->peer.rwnd;
>  		__entry->unack_data = asoc->unack_data;
> -
> -		if (trace_sctp_probe_path_enabled()) {
> -			struct sctp_transport *sp;
> -
> -			list_for_each_entry(sp, &asoc->peer.transport_addr_list,
> -					    transports) {
> -				trace_sctp_probe_path(sp, asoc);
> -			}
> -		}
>  	),
>  
>  	TP_printk("asoc=%#llx mark=%#x bind_port=%d peer_port=%d pathmtu=%d "
> diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> index 0dab62b..83ddcfe 100644
> --- a/net/sctp/outqueue.c
> +++ b/net/sctp/outqueue.c
> @@ -36,6 +36,7 @@
>  #include <net/sctp/sctp.h>
>  #include <net/sctp/sm.h>
>  #include <net/sctp/stream_sched.h>
> +#include <trace/events/sctp.h>
>  
>  /* Declare internal functions here.  */
>  static int sctp_acked(struct sctp_sackhdr *sack, __u32 tsn);
> @@ -1238,6 +1239,12 @@ int sctp_outq_sack(struct sctp_outq *q, struct sctp_chunk *chunk)
>  	/* Grab the association's destination address list. */
>  	transport_list = &asoc->peer.transport_addr_list;
>  
> +	/* SCTP path tracepoint for congestion control debugging. */
> +	if (trace_sctp_probe_path_enabled()) {
> +		list_for_each_entry(transport, transport_list, transports)
> +			trace_sctp_probe_path(transport, asoc);
> +	}
> +
>  	sack_ctsn = ntohl(sack->cum_tsn_ack);
>  	gap_ack_blocks = ntohs(sack->num_gap_ack_blocks);
>  	asoc->stats.gapcnt += gap_ack_blocks;
> -- 
> 1.8.3.1
> 
