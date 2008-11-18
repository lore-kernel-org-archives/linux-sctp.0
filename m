From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 18 Nov 2008 14:22:23 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081118142222.GD5336@dhcp35.suse.cz>
List-Id: <linux-sctp.vger.kernel.org>
References: <200811061205.57403.mhocko@suse.cz>
In-Reply-To: <200811061205.57403.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Tue 18-11-08 09:04:58, Vlad Yasevich wrote:
> Michal Hocko wrote:
> > On Thu 06-11-08 08:48:45, Vlad Yasevich wrote:
> >> Michal Hocko wrote:
> >>> Hi,
[...]
> > Do you have any ETA?
> > Is there some way how to help here?
> > 
> 
> which version in particular is most critical?
> 
> Just remember then 2.6.16 is very old and there have been a lot of fixes that
> address critical issues.
> 
> For 2.6.28, can you apply the attached patch and post dmesg output.  Also, if
> it's possible to capture a kdump, that would make things much easier.

Does it make sense to enable CONFIG_SCTP_DBG_MSG and CONFIG_SCTP_DBG_OBJCNT?
We don't set them in our enterprise kernels and I as this seems to be
race condition I would like to prevent some timing issues. But if it is
worth trying I can try to turn them on.

> 
> Thanks
> 
> -vlad

> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> index 9661d7b..e240044 100644
> --- a/include/net/sctp/structs.h
> +++ b/include/net/sctp/structs.h
> @@ -791,6 +791,7 @@ struct sctp_packet {
>  
>  	/* This contains the payload chunks.  */
>  	struct list_head chunk_list;
> +	__u32 num_chunks;
>  
>  	/* This is the overhead of the sctp and ip headers. */
>  	size_t overhead;
> diff --git a/net/sctp/output.c b/net/sctp/output.c
> index c3f417f..7b9a550 100644
> --- a/net/sctp/output.c
> +++ b/net/sctp/output.c
> @@ -114,6 +114,7 @@ struct sctp_packet *sctp_packet_init(struct sctp_packet *packet,
>  	packet->source_port = sport;
>  	packet->destination_port = dport;
>  	INIT_LIST_HEAD(&packet->chunk_list);
> +	packet->num_chunks = 0;
>  	if (asoc) {
>  		struct sctp_sock *sp = sctp_sk(asoc->base.sk);
>  		overhead = sp->pf->af->net_header_len;
> @@ -349,6 +350,7 @@ append:
>  
>  	/* It is OK to send this chunk.  */
>  	list_add_tail(&chunk->list, &packet->chunk_list);
> +	packet->num_chunks += 1;
>  	packet->size += chunk_len;
>  	chunk->transport = packet->transport;
>  finish:
> @@ -485,6 +487,12 @@ int sctp_packet_transmit(struct sctp_packet *packet)
>  		if (chunk = packet->auth)
>  			auth = skb_tail_pointer(nskb);
>  
> +		/* DEBUG: Check to see if this chunk will overflow the
> +		 * skb.  Output needed info
> +		 */
> +		if ((nskb->tail + chunk->skb->len) > nskb->end) {
> +			printk(KERN_ERR "Possible SKB overflow: packet size = %u, packet overhead = %u, packet chunks = %u, mtu = %u\n", packet->size, packet->overhead, packet->num_chunks, asoc?asoc->pathmtu:tp->pathmtu);
> +		}
>  		cksum_buf_len += chunk->skb->len;
>  		memcpy(skb_put(nskb, chunk->skb->len),
>  			       chunk->skb->data, chunk->skb->len);


-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
