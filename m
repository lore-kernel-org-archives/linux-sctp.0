From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 18 Nov 2008 14:10:02 +0000
Subject: Re: BUG in sctp crashes the system
Message-Id: <20081118141002.GC5336@dhcp35.suse.cz>
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
> >>> we are experiencing BUG and hang conditions with simple echo client-server 
> >>> SCTP application.  It looks like a race condition which is rather hard to 
> >>> trigger. 
> >>>
> >>> BUG traces come usually with sctp code in the code paths (see traces attached) 
> >>> but sometimes the machine simply hangs without any traces at all. It 
> >>> obviously depends on the kernel configuration and HW (different machines 
> >>> comes with different traces).
> >>>
> >>> Initial report of this issue was against SLES10SP2 (2.6.16.60) kernel but we 
> >>> were able to reproduce with upstream Linus tree as well (2.6.
> >>> {25,26,27,75fa67706cce5272bcfc51ed646f2da21f3bdb6e}).
> >>> We were able to reproduce _only_ with 2 _directly_ connected machines with 
> >>> 1GiB wired ethernet connection. (no BUG condition occurred on the single HW 
> >>> nor with connection through at least one switch or 100MB). Original report 
> >>> states that it takes from minutes to hours to trigger this issue but it takes 
> >>> hours in my testing environment.
> >>>
> >>> At first we thought that this can be caused by SO_REUSEADDR used by server 
> >>> application, but I was able to reproduce also without it.
> >>> We are also not 100% sure that the sctp is culprit here, but almost all traces 
> >>> contain some sctp paths so it smells suspicious.
> >>>
> >>> This may have security implications so I am not attaching the crash 
> >>> application directly into this email (please write me and I will send it 
> >>> directly or let me know if it is safe to publish it publicly in the mailing 
> >>> list).
> >>>
> >>> Thanks for any help/hints and let me know if you need some more information or 
> >>> test some patches.
> >>>
> >>> Best regards
> >>>
> >> In the earlier kernels there were a few bugs in the accept code paths that
> >> had to do with locking the newly created socket correctly as well as locking
> >> the port hash table during the migration of the ports.  Both of those
> >> contributed to crashes at odd points in time and sometimes even to stack and
> >> memory corruptions.
> >>
> >> I'll take a look at what's causing skb overflow in 2.6.28.
> > 
> > Is there any update (patch to test). This is starting to be critical
> > from our POV. 
> > Do you have any ETA?
> > Is there some way how to help here?
> > 
> 
> which version in particular is most critical?
> 
> Just remember then 2.6.16 is very old and there have been a lot of fixes that
> address critical issues.

I think that we can focus on current upstream Linus tree, because those
older version contain many backported sctp fixes.

> 
> For 2.6.28, can you apply the attached patch and post dmesg output.  Also, if
> it's possible to capture a kdump, that would make things much easier.

Will try. 

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
