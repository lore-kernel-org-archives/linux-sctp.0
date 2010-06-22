From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 22 Jun 2010 21:27:06 +0000
Subject: Re: [Lksctp-developers] multihoming with all interfaces changed between
Message-Id: <4C212AAA.2020807@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Honda-san

A few comments:

1) Can you please add -p to your 'diff' command or use git tools.  The current
patch has no function context so it's difficult to figure out what you are
modifying.

2) I don't think you need to create a CONFIG_ menu item for this since
it will be controlled by a sysctl as well as an API.  As such, the code can
start out disabled.

3) Also, please remove all of the dead or commented out code from this patch as
that makes reviewing that much harder.  The patch is already rather large.

4) Only endpoints bound to wildcard addresses are elligable autoasconf.  I
didn't see that accounted for in this patch (I may have missed it though..)

Now, to the code, as much as I can figure it out...

Michio Honda wrote:
> Sorry, let me resend the patch with in-line.  
> 
> Best regards,
> - Michio
> 
> On Apr 24, 2010, at 14:05 , Michio Honda wrote:
> 
>> Hi, 
>>
>>> First, this would depend on the AUTOASCONF functionality.  There were some folks
>>> that have to trying implementing it, but no formal submissions have been done.
>> If former patches are not going on, may I contribute my <2.6.34-rc5.patch>auto_asconf implementation?
>> I attach the patch for version 2.6.34-rc5.  
>>
> 
> Only in linux-2.6/include: asm-arm
> Only in linux-2.6/include: asm-mn10300
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/include/linux/sysctl.h linux-2.6/include/linux/sysctl.h
> --- linux-2.6.orig/include/linux/sysctl.h	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/include/linux/sysctl.h	2010-04-24 11:33:25.000000000 +0900
> @@ -767,6 +767,7 @@
>  	NET_SCTP_SNDBUF_POLICY		 = 15,
>  	NET_SCTP_SACK_TIMEOUT		 = 16,
>  	NET_SCTP_RCVBUF_POLICY		 = 17,
> +	NET_SCTP_AUTO_ASCONF_ENABLE	 = 18,
>  };
>  
>  /* /proc/sys/net/bridge */
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/include/net/sctp/sctp.h linux-2.6/include/net/sctp/sctp.h
> --- linux-2.6.orig/include/net/sctp/sctp.h	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/include/net/sctp/sctp.h	2010-04-21 11:09:15.000000000 +0900
> @@ -121,6 +121,10 @@
>  				     int flags);
>  extern struct sctp_pf *sctp_get_pf_specific(sa_family_t family);
>  extern int sctp_register_pf(struct sctp_pf *, sa_family_t);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +void sctp_addr_wq_mgmt(union sctp_addr *, int);
> +void sctp_path_check_and_react(struct sctp_association *, struct sockaddr *);
> +#endif
>  
>  /*
>   * sctp/socket.c
> @@ -134,6 +138,12 @@
>  void sctp_copy_sock(struct sock *newsk, struct sock *sk,
>  		    struct sctp_association *asoc);
>  extern struct percpu_counter sctp_sockets_allocated;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +int sctp_asconf_mgmt(struct sctp_endpoint *, struct sock *sk);
> +void sctp_add_addr_to_laddr(struct sockaddr *, struct sctp_association *);
> +void sctp_dbg_print_transmitted(struct sctp_association *);
> +void sctp_trans_immediate_retrans(struct sctp_transport *);
> +#endif
>  
>  /*
>   * sctp/primitive.c
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/include/net/sctp/sm.h linux-2.6/include/net/sctp/sm.h
> --- linux-2.6.orig/include/net/sctp/sm.h	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/include/net/sctp/sm.h	2010-04-21 11:09:15.000000000 +0900
> @@ -294,6 +294,10 @@
>  __u32 sctp_generate_tag(const struct sctp_endpoint *);
>  __u32 sctp_generate_tsn(const struct sctp_endpoint *);
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +void sctp_path_check_and_react(struct sctp_association *, struct sockaddr *);
> +#endif
> +
>  /* Extern declarations for major data structures.  */
>  extern sctp_timer_event_t *sctp_timer_events[SCTP_NUM_TIMEOUT_TYPES];
>  
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/include/net/sctp/structs.h linux-2.6/include/net/sctp/structs.h
> --- linux-2.6.orig/include/net/sctp/structs.h	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/include/net/sctp/structs.h	2010-04-24 11:33:54.000000000 +0900
> @@ -205,6 +205,12 @@
>  	 * It is a list of sctp_sockaddr_entry.
>  	 */
>  	struct list_head local_addr_list;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	int auto_asconf_enable;
> +	struct list_head addr_waitq;
> +	struct timer_list addr_wq_timer;
> +	spinlock_t addr_wq_lock;
> +#endif
>  
>  	/* Lock that protects the local_addr_list writers */
>  	spinlock_t addr_list_lock;
> @@ -265,6 +271,12 @@
>  #define sctp_port_alloc_lock		(sctp_globals.port_alloc_lock)
>  #define sctp_port_hashtable		(sctp_globals.port_hashtable)
>  #define sctp_local_addr_list		(sctp_globals.local_addr_list)
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +#define sctp_addr_waitq			(sctp_globals.addr_waitq)
> +#define sctp_addr_wq_timer		(sctp_globals.addr_wq_timer)
> +#define sctp_addr_wq_lock		(sctp_globals.addr_wq_lock)
> +#define sctp_auto_asconf_enable		(sctp_globals.auto_asconf_enable)
> +#endif
>  #define sctp_local_addr_lock		(sctp_globals.addr_list_lock)
>  #define sctp_scope_policy		(sctp_globals.ipv4_scope_policy)
>  #define sctp_addip_enable		(sctp_globals.addip_enable)
> @@ -800,6 +812,18 @@
>  	__u8 valid;
>  };
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +#define SCTP_NEWADDR	1
> +#define SCTP_DELADDR	2
> +#define SCTP_ADDRESS_TICK_DELAY	500
> +struct sctp_addr_wait {
> +	struct list_head list;
> +	struct rcu_head rcu;
> +	union sctp_addr a;
> +	int	cmd;
> +};
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +
>  typedef struct sctp_chunk *(sctp_packet_phandler_t)(struct sctp_association *);
>  
>  /* This structure holds lists of chunks as we are assembling for
> @@ -1897,6 +1921,14 @@
>  	 * after reaching 4294967295.
>  	 */
>  	__u32 addip_serial;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	/* list of valid address in association local */
> +	struct list_head asoc_laddr_list; 
> +	union sctp_addr *asconf_addr_del_pending;
> +	__u32 asconf_del_pending_cid;
> +	/* when this value is true, this asoc can choose outband src */
> +	int src_out_of_asoc_ok;
> +#endif

I've been trying to understand the need for these lists and it's escaping me.
Why do we need another list of source addresses in the association, when the
list in asoc->base.bind_addr is a difinitive list of addresses association is
bound to?

Just an address to that list that was provided by the your work queue and fire
off an asconf.  When an ACK arrives, the address state transitions as normal.

>  
>  	/* SCTP AUTH: list of the endpoint shared keys.  These
>  	 * keys are provided out of band by the user applicaton
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/kernel/sysctl_check.c linux-2.6/kernel/sysctl_check.c
> --- linux-2.6.orig/kernel/sysctl_check.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/kernel/sysctl_check.c	2010-04-21 18:40:22.000000000 +0900
> @@ -5,7 +5,6 @@
>  #include <linux/string.h>
>  #include <net/ip_vs.h>
>  
> -
>  static int sysctl_depth(struct ctl_table *table)
>  {
>  	struct ctl_table *tmp;
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/Kconfig linux-2.6/net/sctp/Kconfig
> --- linux-2.6.orig/net/sctp/Kconfig	2009-12-17 16:50:21.000000000 +0900
> +++ linux-2.6/net/sctp/Kconfig	2009-12-05 04:57:42.000000000 +0900
> @@ -56,6 +56,12 @@
>  
>  	  If unsure, say N
>  
> +config SCTP_AUTO_ASCONF
> +	bool "SCTP: Auto ASCONF"
> +	help
> +	  Automatically transmit ASCONF chunks on dynamic change of local 
> +	  addresses (only for boundall sockets)
> +
>  choice
>  	prompt "SCTP: Cookie HMAC Algorithm"
>  	default SCTP_HMAC_MD5
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/associola.c linux-2.6/net/sctp/associola.c
> --- linux-2.6.orig/net/sctp/associola.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/associola.c	2010-04-21 11:09:15.000000000 +0900
> @@ -281,6 +281,12 @@
>  	if (sctp_addip_noauth)
>  		asoc->peer.asconf_capable = 1;
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	asoc->asconf_addr_del_pending = NULL;
> +	asoc->asconf_del_pending_cid = 0;
> +	asoc->src_out_of_asoc_ok = 0;
> +	INIT_LIST_HEAD(&asoc->asoc_laddr_list);
> +#endif
>  	/* Create an input queue.  */
>  	sctp_inq_init(&asoc->base.inqueue);
>  	sctp_inq_set_th_handler(&asoc->base.inqueue, sctp_assoc_bh_rcv);
> @@ -447,6 +453,19 @@
>  	/* Free any cached ASCONF_ACK chunk. */
>  	sctp_assoc_free_asconf_acks(asoc);
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	/* Free pending address space being deleted */
> +	if (asoc->asconf_addr_del_pending != NULL) 
> +		kfree(asoc->asconf_addr_del_pending);
> +	if (!list_empty(&asoc->asoc_laddr_list)) {
> +		struct sctp_sockaddr_entry *laddr = NULL;
> +		list_for_each_entry(laddr, &asoc->asoc_laddr_list, list) {
> +			list_del(&laddr->list);
> +			kfree(laddr);
> +		}
> +	}
> +#endif
> +
>  	/* Free any cached ASCONF chunk. */
>  	if (asoc->addip_last_asconf)
>  		sctp_chunk_free(asoc->addip_last_asconf);
> @@ -545,6 +564,9 @@
>  {
>  	struct list_head	*pos;
>  	struct sctp_transport	*transport;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	struct sctp_chunk *chunk;
> +#endif
>  
>  	SCTP_DEBUG_PRINTK_IPADDR("sctp_assoc_rm_peer:association %p addr: ",
>  				 " port: %d\n",
> @@ -557,6 +579,16 @@
>  	 */
>  	if (asoc->peer.retran_path = peer)
>  		sctp_assoc_update_retran_path(asoc);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	/*
> +	list_for_each_entry(chunk, &peer->transmitted, transmitted_list) {
> +		if (chunk->transport = peer) {
> +			SCTP_DEBUG_PRINTK("assoc_rm_peer: this chunk's trans is this, reset it\n");
> +			chunk->transport = NULL;
> +		}
> +	}
> +	*/
> +#endif
>  
>  	/* Remove this peer from the list. */
>  	list_del(&peer->transports);
> @@ -621,7 +653,14 @@
>  			if (!mod_timer(&active->T3_rtx_timer,
>  					jiffies + active->rto))
>  				sctp_transport_hold(active);
> -	}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		active->flight_size += peer->flight_size;
> +		sctp_dbg_print_transmitted(asoc);
> +#endif
> +	}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +//	sctp_trans_immediate_retrans(asoc->peer.active_path);
> +#endif
>  

I don't think the above code is sctp_assoc_rm_peer is necessary.  The chunk
migration is currently taken care of.  If you wish to implement immediate
retransmit, that should be in a separate patch.

>  	asoc->peer.transport_count--;
>  
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/ipv6.c linux-2.6/net/sctp/ipv6.c
> --- linux-2.6.orig/net/sctp/ipv6.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/ipv6.c	2010-04-21 11:09:15.000000000 +0900
> @@ -96,6 +96,9 @@
>  	case NETDEV_UP:
>  		addr = kmalloc(sizeof(struct sctp_sockaddr_entry), GFP_ATOMIC);
>  		if (addr) {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			union sctp_addr *tmpaddr = NULL;
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  			addr->a.v6.sin6_family = AF_INET6;
>  			addr->a.v6.sin6_port = 0;
>  			ipv6_addr_copy(&addr->a.v6.sin6_addr, &ifa->addr);
> @@ -103,6 +106,10 @@
>  			addr->valid = 1;
>  			spin_lock_bh(&sctp_local_addr_lock);
>  			list_add_tail_rcu(&addr->list, &sctp_local_addr_list);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			tmpaddr = (union sctp_addr *)&addr->a;
> +			sctp_addr_wq_mgmt(&addr->a, SCTP_NEWADDR);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  			spin_unlock_bh(&sctp_local_addr_lock);
>  		}
>  		break;
> @@ -113,6 +120,11 @@
>  			if (addr->a.sa.sa_family = AF_INET6 &&
>  					ipv6_addr_equal(&addr->a.v6.sin6_addr,
>  						&ifa->addr)) {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +				union sctp_addr *tmpaddr;
> +				tmpaddr = (union sctp_addr *)&addr->a;
> +				sctp_addr_wq_mgmt(&addr->a, SCTP_DELADDR);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  				found = 1;
>  				addr->valid = 0;
>  				list_del_rcu(&addr->list);
> @@ -343,7 +355,30 @@
>  				matchlen = bmatchlen;
>  			}
>  		}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if ((laddr->state = SCTP_ADDR_NEW) && asoc->src_out_of_asoc_ok) {
> +			bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
> +			if (!baddr || (matchlen < bmatchlen)) {
> +				baddr = &laddr->a;
> +				matchlen = bmatchlen;
> +			}
> +		}
> +#endif
> +	}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	if (baddr = NULL) {
> +		/* We don't have a valid src addr in "endpoint-wide".  
> +		 * Looking up in assoc-locally valid address list.  
> +		 */
> +		list_for_each_entry(laddr, &asoc->asoc_laddr_list, list) {
> +			bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
> +			if (!baddr || (matchlen < bmatchlen)) {
> +				baddr = &laddr->a;
> +				matchlen = bmatchlen;
> +			}
> +		}
>  	}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  
>  	if (baddr) {
>  		memcpy(saddr, baddr, sizeof(union sctp_addr));
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/outqueue.c linux-2.6/net/sctp/outqueue.c
> --- linux-2.6.orig/net/sctp/outqueue.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/outqueue.c	2010-04-21 11:09:15.000000000 +0900
> @@ -344,6 +344,14 @@
>  			break;
>  		}
>  	} else {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		/* We add the ASCONF for the only one newly added address at 
> +		 * the front of the queue 
> +		 */
> +		if (q->asoc->src_out_of_asoc_ok && (chunk->chunk_hdr->type = SCTP_CID_ASCONF))
> +			list_add(&chunk->list, &q->control_chunk_list);
> +		else
> +#endif
>  		list_add_tail(&chunk->list, &q->control_chunk_list);
>  		SCTP_INC_STATS(SCTP_MIB_OUTCTRLCHUNKS);
>  	}
> @@ -848,6 +856,26 @@
>  		case SCTP_CID_SHUTDOWN:
>  		case SCTP_CID_ECN_ECNE:
>  		case SCTP_CID_ASCONF:
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			/* RFC 5061, 5.3
> +			 * F1) This means that until such time as the ASCONF 
> +			 * containing the add is acknowledged, the sender MUST 
> +			 * NOT use the new IP address as a source for ANY SCTP 
> +			 * packet except on carrying an ASCONF Chunk.
> +			 */
> +			if (asoc->src_out_of_asoc_ok) {
> +				SCTP_DEBUG_PRINTK("outq_flush: out_of_asoc_ok, transmit chunk type %d\n", chunk->chunk_hdr->type);
> +				packet = &transport->packet;
> +				sctp_packet_config(packet, vtag, 
> +						asoc->peer.ecn_capable);
> +				sctp_packet_append_chunk(packet, chunk);
> +				error = sctp_packet_transmit(packet);
> +				if (error < 0) {
> +					return error;
> +				}
> +				goto sctp_flush_out;
> +			}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  		case SCTP_CID_FWD_TSN:
>  			status = sctp_packet_transmit_chunk(packet, chunk,
>  							    one_packet);
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/protocol.c linux-2.6/net/sctp/protocol.c
> --- linux-2.6.orig/net/sctp/protocol.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/protocol.c	2010-04-22 18:06:47.000000000 +0900
> @@ -504,12 +504,25 @@
>  		sctp_v4_dst_saddr(&dst_saddr, dst, htons(bp->port));
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			if (!laddr->valid || ((laddr->state != SCTP_ADDR_SRC) && (asoc->src_out_of_asoc_ok = 0)))
> +#else
>  			if (!laddr->valid || (laddr->state != SCTP_ADDR_SRC))
> +#endif
>  				continue;
>  			if (sctp_v4_cmp_addr(&dst_saddr, &laddr->a))
>  				goto out_unlock;
>  		}
>  		rcu_read_unlock();
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		/* We don't have a valid src addr in "endpoint-wide".  
> +		 * Looking up in assoc-locally valid address list.  
> +		 */
> +		list_for_each_entry(laddr, &asoc->asoc_laddr_list, list) {
> +			if (sctp_v4_cmp_addr(&dst_saddr, &laddr->a))
> +				goto out_unlock;
> +		}
> +#endif
>  
>  		/* None of the bound addresses match the source address of the
>  		 * dst. So release it.
> @@ -628,6 +641,195 @@
>  	INET_ECN_xmit(sk);
>  }
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +void sctp_addr_wq_timeout_handler(unsigned long arg)
> +{
> +	struct sctp_addr_wait *addrw = NULL;
> +	union sctp_addr *addr = NULL;
> +	struct sctp_ep_common *epb = NULL;
> +	struct sctp_endpoint *ep = NULL;
> +	struct hlist_node *node = NULL;
> +	struct sctp_hashbucket *head = NULL;
> +	int cnt=0;
> +	int i; 
> +
> +	spin_lock_bh(&sctp_addr_wq_lock);
> +retry_wq:
> +	if (list_empty(&sctp_addr_waitq)) {
> +		SCTP_DEBUG_PRINTK("sctp_addrwq_timo_handler: nothing in addr waitq\n");
> +		spin_unlock_bh(&sctp_addr_wq_lock);
> +		return;
> +	}
> +	addrw = list_first_entry(&sctp_addr_waitq, struct sctp_addr_wait, list);
> +	if ((addrw->cmd != SCTP_NEWADDR) && (addrw->cmd != SCTP_DELADDR)) {
> +		SCTP_DEBUG_PRINTK("sctp_addrwq_timo_handler: Huh, cmd is neither NEWADDR nor DELADDR\n");
> +		list_del(&addrw->list);
> +		kfree(addrw);
> +		goto retry_wq;
> +	}
> +
> +	addr = &addrw->a;
> +	SCTP_DEBUG_PRINTK_IPADDR("sctp_addrwq_timo_handler: the first ent in wq %p is "," for cmd %d at entry %p\n", &sctp_addr_waitq, addr, addrw->cmd, addrw);
> +
> +	/* Now we send an ASCONF for each association */
> +	/* Note. we currently don't handle link local IPv6 addressees */
> +	if (addr->sa.sa_family = AF_INET6) {
> +		struct in6_addr *in6 = (struct in6_addr *)&addr->v6.sin6_addr;
> +
> +		if (ipv6_addr_type(&addr->v6.sin6_addr) & IPV6_ADDR_LINKLOCAL) {
> +			SCTP_DEBUG_PRINTK("sctp_timo_handler: link local, hence don't tell eps\n");
> +			list_del(&addrw->list);
> +			kfree(addrw);
> +			goto retry_wq;
> +		}
> +		if ((ipv6_chk_addr(&init_net, in6, NULL, 0) = 0) && (addrw->cmd = SCTP_NEWADDR)) {
> +			unsigned long timeo_val;
> +
> +			SCTP_DEBUG_PRINTK("sctp_timo_handler: this is on DAD, trying %d sec later\n", SCTP_ADDRESS_TICK_DELAY);
> +			timeo_val = jiffies;
> +			timeo_val += msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY);
> +			(void)mod_timer(&sctp_addr_wq_timer, timeo_val);
> +			spin_unlock_bh(&sctp_addr_wq_lock);
> +			return;
> +		}
> +	}
> +	for (i = 0; i < sctp_ep_hashsize; ++i) {
> +		head = &sctp_ep_hashtable[i];
> +		if (head = NULL) {
> +			SCTP_DEBUG_PRINTK("addrwq_timo_handler: no head in hash\n");
> +			continue;
> +		}
> +		write_lock(&head->lock);
> +		epb = NULL;
> +		sctp_for_each_hentry(epb, node, &head->chain) {
> +
> +			if (epb = NULL) {
> +				SCTP_DEBUG_PRINTK("addrwq_timo_handler: no epb\n");
> +				continue;
> +			}
> +			ep = sctp_ep(epb);
> +			SCTP_DEBUG_PRINTK("sctp_addrwq_timo_handler: walking eps, now ep:%p of head:%p \n", ep, head);
> +			if (sctp_asconf_mgmt(ep, epb->sk) < 0) {
> +				SCTP_DEBUG_PRINTK("sctp_addrwq_timo_handler: sctp_asconf_mgmt failed\n");
> +				continue;
> +			}
> +			++cnt;
> +		}
> +		write_unlock(&head->lock);

This can race with another bind()/bindx() call on the socket.  You don't have
sufficient protection.  The socket has to be locked and no user operations can
be allowed while an address is being added.

Additionally, the sctp_ep_hashtable only contains listening endpoints.  This
means that client sockets will not get this functionality.

One of the alternative solutions is to create an autoascof hash table, where
associations that can use autoasconf can live.  Any time there is an explicit
bindx() on one of these associations, that association is removed from this hash.

This gives you a unique list of associations that may perform autoasconf,
however you would still need to lock the socket that the association belongs to.
This is begging for an association level lock though, which we don't have.


> +	}
> +	if (addrw->cmd = SCTP_NEWADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_addrwq_timo_handler: ASCONFs (ADD) for wq ent: %p addr: "," is just set to %d eps\n", addrw, addr, cnt);
> +	} else if (addrw->cmd = SCTP_DELADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_addrwq_timo_handler: ASCONFs (DEL) for wq ent: %p addr: "," is just set to %d eps\n", addrw, addr, cnt);
> +	} 
> +
> +	list_del(&addrw->list);
> +	kfree(addrw);
> +
> +	if (list_empty(&sctp_addr_waitq)) {
> +		SCTP_DEBUG_PRINTK("sctp_addrwq_timo_handler: current entry is removed, no more entries\n");
> +		spin_unlock_bh(&sctp_addr_wq_lock);
> +		return;
> +	} else {
> +		goto retry_wq;
> +	}
> +	spin_unlock_bh(&sctp_addr_wq_lock);
> +}
> +
> +void sctp_addr_wq_mgmt(union sctp_addr *reqaddr, int cmd)
> +{
> +	struct sctp_addr_wait *addrw = NULL;
> +	struct sctp_addr_wait *addrw_new = NULL;
> +	unsigned long timeo_val;
> +	union sctp_addr *tmpaddr; // for debugging
> +
> +	/* first, we check if an opposite message already exist in the queue.  
> +	 * If we found such message, it is removed.  
> +	 * This operation is a bit stupid, but the DHCP client attaches the 
> +	 * new address after a couple of addition and deletion of that address
> +	 */
> +
> +	if (reqaddr = NULL) {
> +		SCTP_DEBUG_PRINTK("sctp_addr_wq_mgmt: no address message?\n");
> +		return;
> +	}
> +	/* for debugging */
> +	if (cmd = SCTP_NEWADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_addr_wq_mgmt: a new address is being added (%d) "," to waitq %p\n", cmd, reqaddr, &sctp_addr_waitq);
> +	} else if (cmd = SCTP_DELADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_addr_wq_mgmt: an existing address is being deleted %d "," from waitq %p\n", cmd, reqaddr, &sctp_addr_waitq);
> +	}
> +	
> +	spin_lock_bh(&sctp_addr_wq_lock);
> +	/* Offsets existing events in addr_wq */
> +	list_for_each_entry(addrw, &sctp_addr_waitq, list) {
> +		if (addrw->a.sa.sa_family != reqaddr->sa.sa_family) {
> +			continue;
> +		}
> +		if (reqaddr->sa.sa_family = AF_INET) {
> +			if (reqaddr->v4.sin_addr.s_addr = addrw->a.v4.sin_addr.s_addr) {
> +				if (cmd != addrw->cmd) {
> +					tmpaddr = &addrw->a;
> +					SCTP_DEBUG_PRINTK_IPADDR("sctp_addr_wq_mgmt offsets existing entry for %d "," in waitq %p\n", addrw->cmd, tmpaddr, &sctp_addr_waitq);
> +					list_del(&addrw->list);
> +					kfree(addrw);
> +					/* nothing to do anymore */
> +					spin_unlock_bh(&sctp_addr_wq_lock);
> +					return;
> +				}
> +			}
> +		}
> +		else if (reqaddr->sa.sa_family = AF_INET6) {
> +			if (memcmp(&reqaddr->v6.sin6_addr, &addrw->a.v6.sin6_addr, sizeof(struct in6_addr)) = 0) {
> +				if (cmd != addrw->cmd) {
> +					tmpaddr = &addrw->a;
> +					SCTP_DEBUG_PRINTK_IPADDR("sctp_addr_wq_mgmt: offsets existing entry for %d "," in waitq %p\n", addrw->cmd, tmpaddr, &sctp_addr_waitq);
> +					list_del(&addrw->list);
> +					kfree(addrw);
> +					spin_unlock_bh(&sctp_addr_wq_lock);
> +					return;
> +				}
> +			}
> +		}
> +	}
> +				
> +	/* OK, we have to add the new address to the wait queue */
> +	addrw_new = kmalloc(sizeof(struct sctp_addr_wait), GFP_ATOMIC);
> +	if (addrw_new = NULL) {
> +		SCTP_DEBUG_PRINTK("sctp_addr_weitq_mgmt no memory? return\n");
> +		spin_unlock_bh(&sctp_addr_wq_lock);
> +		return;
> +	}
> +	memset(addrw_new, 0, sizeof(struct sctp_addr_wait));
> +	if (reqaddr->sa.sa_family = AF_INET) {
> +		addrw_new->a.v4.sin_family = AF_INET;
> +		memcpy(&addrw_new->a.v4.sin_addr, &reqaddr->v4.sin_addr, sizeof(struct in_addr));
> +	} else if (reqaddr->sa.sa_family = AF_INET6) {
> +		addrw_new->a.v6.sin6_family = AF_INET6;
> +		memcpy(&addrw_new->a.v6.sin6_addr, &reqaddr->v6.sin6_addr, sizeof(struct in6_addr));
> +	} else {
> +		SCTP_DEBUG_PRINTK("sctp_addr_waitq_mgmt: Unknown family of request addr, return\n");
> +		kfree(addrw_new);
> +		spin_unlock_bh(&sctp_addr_wq_lock);
> +		return;
> +	}
> +	addrw_new->cmd = cmd;
> +	list_add_tail(&addrw_new->list, &sctp_addr_waitq);
> +	tmpaddr = &addrw_new->a;
> +	SCTP_DEBUG_PRINTK_IPADDR("sctp_addr_wq_mgmt add new entry for cmd:%d "," in waitq %p, start a timer\n", addrw_new->cmd, tmpaddr, &sctp_addr_waitq);
> +
> +	if (timer_pending(&sctp_addr_wq_timer)) {
> +		SCTP_DEBUG_PRINTK("sctp_addr_wq_mgmt: addr_wq timer is already running\n");
> +		spin_unlock_bh(&sctp_addr_wq_lock);
> +		return;
> +	}
> +	timeo_val = jiffies;
> +	timeo_val += msecs_to_jiffies(SCTP_ADDRESS_TICK_DELAY);
> +	(void)mod_timer(&sctp_addr_wq_timer, timeo_val);
> +	spin_unlock_bh(&sctp_addr_wq_lock);
> +}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +
>  /* Event handler for inet address addition/deletion events.
>   * The sctp_local_addr_list needs to be protocted by a spin lock since
>   * multiple notifiers (say IPv4 and IPv6) may be running at the same
> @@ -649,12 +851,19 @@
>  	case NETDEV_UP:
>  		addr = kmalloc(sizeof(struct sctp_sockaddr_entry), GFP_ATOMIC);
>  		if (addr) {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			union sctp_addr *tmpaddr;
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  			addr->a.v4.sin_family = AF_INET;
>  			addr->a.v4.sin_port = 0;
>  			addr->a.v4.sin_addr.s_addr = ifa->ifa_local;
>  			addr->valid = 1;
>  			spin_lock_bh(&sctp_local_addr_lock);
>  			list_add_tail_rcu(&addr->list, &sctp_local_addr_list);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			tmpaddr = (union sctp_addr *)&addr->a;
> +			sctp_addr_wq_mgmt(&addr->a, SCTP_NEWADDR);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  			spin_unlock_bh(&sctp_local_addr_lock);
>  		}
>  		break;
> @@ -665,6 +874,11 @@
>  			if (addr->a.sa.sa_family = AF_INET &&
>  					addr->a.v4.sin_addr.s_addr =
>  					ifa->ifa_local) {
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +				union sctp_addr *tmpaddr;
> +				tmpaddr = (union sctp_addr *)&addr->a;
> +				sctp_addr_wq_mgmt(&addr->a, SCTP_DELADDR);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  				found = 1;
>  				addr->valid = 0;
>  				list_del_rcu(&addr->list);
> @@ -1270,6 +1484,12 @@
>  
>  	/* Initialize the local address list. */
>  	INIT_LIST_HEAD(&sctp_local_addr_list);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	INIT_LIST_HEAD(&sctp_addr_waitq);
> +	spin_lock_init(&sctp_addr_wq_lock);
> +	sctp_addr_wq_timer.expires = 0;
> +	setup_timer(&sctp_addr_wq_timer, sctp_addr_wq_timeout_handler, (unsigned long)NULL); 
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  	spin_lock_init(&sctp_local_addr_lock);
>  	sctp_get_local_addr_list();
>  
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/sm_make_chunk.c linux-2.6/net/sctp/sm_make_chunk.c
> --- linux-2.6.orig/net/sctp/sm_make_chunk.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/sm_make_chunk.c	2010-04-24 11:35:34.000000000 +0900
> @@ -1370,6 +1370,27 @@
>  
>  	return target;
>  }
> +static void *sctp_dbg_addto_chunk(struct sctp_chunk *chunk, int len, const void *data)
> +{
> +	void *target;
> +	void *padding;
> +	int chunklen = ntohs(chunk->chunk_hdr->length);
> +	int padlen = WORD_ROUND(chunklen) - chunklen;
> +
> +	SCTP_DEBUG_PRINTK("dbg_addto_chk: chunklen: %d padlen: %d\n", chunklen, padlen);
> +	return NULL;
> +	padding = skb_put(chunk->skb, padlen);
> +	target = skb_put(chunk->skb, len);
> +
> +	memset(padding, 0, padlen);
> +	memcpy(target, data, len);
> +
> +	/* Adjust the chunk length field.  */
> +	chunk->chunk_hdr->length = htons(chunklen + padlen + len);
> +	chunk->chunk_end = skb_tail_pointer(chunk->skb);
> +
> +	return target;
> +}

Is this function still needed.  Looks like it does nothing...

>  
>  /* Append bytes from user space to the end of a chunk.  Will panic if
>   * chunk is not big enough.
> @@ -2600,6 +2621,86 @@
>  	return retval;
>  }
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +void
> +sctp_trans_immediate_retrans(struct sctp_transport *trans)
> +{
> +	struct sctp_association *asoc = trans->asoc;
> +
> +	/* Stop pending T3_rtx_timer on this transport */
> +	if (timer_pending(&trans->T3_rtx_timer)) {
> +		(void)del_timer(&trans->T3_rtx_timer);
> +		sctp_transport_put(trans);
> +		SCTP_DEBUG_PRINTK("trans_immediate_rtx: T3_rtx_timer on trans %p has been stopped\n", trans);
> +	} 
> +
> +	/* We consider the event as if the T3RTX timer expires */
> +	/*
> +	sctp_bh_unlock_sock(trans->asoc->base.sk);
> +	sctp_generate_t3_rtx_event((unsigned long)trans);
> +	sctp_bh_lock_sock(trans->asoc->base.sk);
> +	*/
> +	sctp_retransmit(&asoc->outqueue, trans, SCTP_RTXR_T3_RTX);
> +	if (!timer_pending(&trans->T3_rtx_timer)) {
> +		if (!mod_timer(&trans->T3_rtx_timer, jiffies + trans->rto)) 
> +			sctp_transport_hold(trans);
> +	}
> +
> +	return;
> +}
> +
> +void
> +sctp_path_check_and_react(struct sctp_association *asoc, struct sockaddr *sa)
> +{
> +	struct sctp_transport *trans;
> +	int addrnum, family;
> +	struct sctp_sockaddr_entry *saddr;
> +	struct sctp_bind_addr *bp;
> +	union sctp_addr *tmpaddr;
> +
> +	family = sa->sa_family;
> +	bp = &asoc->base.bind_addr;
> +	addrnum = 0;
> +	/* count up the number of local addresses in the same family */
> +	list_for_each_entry(saddr, &bp->address_list, list) {
> +		if (saddr->a.sa.sa_family = family) {
> +			tmpaddr = &saddr->a;
> +			if (family = AF_INET6 && 
> +			    ipv6_addr_type(&tmpaddr->v6.sin6_addr) & 
> +			    IPV6_ADDR_LINKLOCAL) {
> +				continue;
> +			}
> +			addrnum++;
> +		}
> +	}
> +	if (addrnum = 1) {
> +		union sctp_addr *tmpaddr;
> +		tmpaddr = (union sctp_addr *)sa;
> +		SCTP_DEBUG_PRINTK_IPADDR("pcheck_react: only 1 local addr in asoc %p "," family %d\n", asoc, tmpaddr, family);
> +		list_for_each_entry(trans, &asoc->peer.transport_addr_list, transports) {
> +			/* reset path information and release refcount to the 
> +			 * dst_entry  based on the src change */
> +			sctp_transport_hold(trans);
> +			trans->cwnd = min(4*asoc->pathmtu, max_t(__u32, 2*asoc->pathmtu, 4380));
> +			trans->ssthresh = asoc->peer.i.a_rwnd;
> +			trans->rtt = 0;
> +			trans->srtt = 0;
> +			trans->rttvar = 0;
> +			trans->rto = asoc->rto_initial;
> +			dst_release(trans->dst);
> +			trans->dst = NULL;
> +			memset(&trans->saddr, 0, sizeof(union sctp_addr));
> +			sctp_transport_route(trans, NULL, sctp_sk(asoc->base.sk));
> +			SCTP_DEBUG_PRINTK_IPADDR("we freed dst_entry (asoc: %p dst: "," trans: %p)\n", asoc, (&trans->ipaddr), trans);
> +			trans->rto_pending = 1;
> +			sctp_trans_immediate_retrans(trans);
> +			sctp_transport_put(trans);
> +		}
> +	}
> +	return;
> +}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +
>  /*
>   * ADDIP 3.1.1 Address Configuration Change Chunk (ASCONF)
>   *      0                   1                   2                   3
> @@ -2693,11 +2794,34 @@
>  	int			addr_param_len = 0;
>  	int 			totallen = 0;
>  	int 			i;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	sctp_addip_param_t del_param; // 8 Bytes (Type(0xC002), Len and CrrID)
> +	sctp_addip_param_t spr_param;
> +	struct sctp_af *del_af;
> +	struct sctp_af *spr_af;
> +	int del_addr_param_len = 0;
> +	int spr_addr_param_len = 0;
> +	int del_paramlen = sizeof(sctp_addip_param_t);
> +	int spr_paramlen = sizeof(sctp_addip_param_t);
> +	union sctp_addr_param del_addr_param; // (v4) 8 Bytes, (v6) 20 Bytes
> +	union sctp_addr_param spr_addr_param;
> +	int			v4 = 0;
> +	int			v6 = 0;
> +#endif
>  
>  	/* Get total length of all the address parameters. */
>  	addr_buf = addrs;
>  	for (i = 0; i < addrcnt; i++) {
>  		addr = (union sctp_addr *)addr_buf;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if (addr != NULL) {
> +			if (addr->sa.sa_family = AF_INET) {
> +				v4 = 1;
> +			} else if (addr->sa.sa_family = AF_INET6) {
> +				v6 = 1;
> +			}
> +		}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  		af = sctp_get_af_specific(addr->v4.sin_family);
>  		addr_param_len = af->to_addr_param(addr, &addr_param);
>  
> @@ -2706,11 +2830,53 @@
>  
>  		addr_buf += af->sockaddr_len;
>  	}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	if (asoc->asconf_addr_del_pending != NULL) {
> +		SCTP_DEBUG_PRINTK_IPADDR("mkasconf_update_ip: we have del_pending addr at %p "," on asoc %p\n", asoc->asconf_addr_del_pending, asoc->asconf_addr_del_pending, asoc);
> +	}
> +	/* Add the length of a pending address being deleted */
> +	if ((flags = SCTP_PARAM_ADD_IP) && 
> +	    (asoc->asconf_addr_del_pending != NULL)) {
> +		if (((asoc->asconf_addr_del_pending->sa.sa_family = AF_INET) 
> +		    && v4) || 
> +		    ((asoc->asconf_addr_del_pending->sa.sa_family = AF_INET6)
> +		    && v6)) {
> +			del_af = sctp_get_af_specific(asoc->asconf_addr_del_pending->sa.sa_family);
> +			del_addr_param_len = del_af->to_addr_param(asoc->asconf_addr_del_pending, &del_addr_param);
> +			totallen += del_paramlen;
> +			totallen += del_addr_param_len;
> +			SCTP_DEBUG_PRINTK("mkasconf_update_ip: now we picked del_pending addr, totallen for all addresses is %d\n", totallen);
> +			/* for Set Primary (equal size as del parameters */
> +			totallen += del_paramlen;
> +			totallen += del_addr_param_len;
> +		}
> +		if (v4) {
> +			if ((totallen != 32) && (totallen != 48)) {
> +				SCTP_DEBUG_PRINTK("mkasconf_update_ip: incorrect total length of ASCONF parameters, del + add MUST be 32 bytes, but %d bytes\n", totallen);
> +			return NULL;
> +			}
> +		} else if (v6) {
> +			if ((totallen != 56) && (totallen != 84)) {
> +				SCTP_DEBUG_PRINTK("mkasconf_update_ip: incorrect total length of ASCONF parameters, del + add MUST be 56 bytes, but %d bytes\n", totallen);
> +			return NULL;
> +			}
> +		}
> +	}
> +	SCTP_DEBUG_PRINTK("mkasconf_update_ip: call mkasconf() for %d bytes\n", totallen);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  
>  	/* Create an asconf chunk with the required length. */
>  	retval = sctp_make_asconf(asoc, laddr, totallen);
> +	/* micchie debug */
> +	if (retval = NULL) {
> +		SCTP_DEBUG_PRINTK("mkasconf_update_ip: mkasconf failed\n");
> +	} else {
> +		SCTP_DEBUG_PRINTK("mkasconf_update_ip: mkasconf successfully finished, chunk size is %u\n", retval->chunk_hdr->length);
> +	}
> +	/* end micchie */
>  	if (!retval)
>  		return NULL;
> +	// at least ok, micchie
>  
>  	/* Add the address parameters to the asconf chunk. */
>  	addr_buf = addrs;
> @@ -2727,6 +2893,32 @@
>  
>  		addr_buf += af->sockaddr_len;
>  	}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	SCTP_DEBUG_PRINTK("mkasconf_update_ip: call addto_chunk for del_pending addr\n");
> +	if ((flags = SCTP_PARAM_ADD_IP) && 
> +	    (asoc->asconf_addr_del_pending != NULL)) {
> +		addr = asoc->asconf_addr_del_pending;
> +		del_af = sctp_get_af_specific(addr->v4.sin_family);
> +		del_addr_param_len = del_af->to_addr_param(addr, &del_addr_param);
> +		del_param.param_hdr.type = SCTP_PARAM_DEL_IP;
> +		del_param.param_hdr.length = htons(del_paramlen + del_addr_param_len);
> +		del_param.crr_id = i;
> +		asoc->asconf_del_pending_cid = i;
> +
> +		sctp_addto_chunk(retval, del_paramlen, &del_param);
> +		sctp_addto_chunk(retval, del_addr_param_len, &del_addr_param);
> +		/* For SET_PRIMARY */
> +		addr_buf = addrs;
> +		addr = (union sctp_addr *)addr_buf;
> +		spr_af = sctp_get_af_specific(addr->v4.sin_family);
> +		spr_addr_param_len = spr_af->to_addr_param(addr, &spr_addr_param);
> +		spr_param.param_hdr.type = SCTP_PARAM_SET_PRIMARY;
> +		spr_param.param_hdr.length = htons(spr_paramlen + spr_addr_param_len);
> +		spr_param.crr_id = (i+1);
> +		sctp_addto_chunk(retval, spr_paramlen, &spr_param);
> +		sctp_addto_chunk(retval, spr_addr_param_len, &spr_addr_param);
> +	}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  	return retval;
>  }
>  
> @@ -2863,6 +3055,9 @@
>  	struct sctp_af *af;
>  	union sctp_addr	addr;
>  	union sctp_addr_param *addr_param;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	union sctp_addr *tmpaddrp = &asconf->source;
> +#endif
>  
>  	addr_param = (union sctp_addr_param *)
>  			((void *)asconf_param + sizeof(sctp_addip_param_t));
> @@ -2929,6 +3124,9 @@
>  		 * MUST send an Error Cause TLV with the error cause set to the
>  		 * new error code 'Request to Delete Last Remaining IP Address'.
>  		 */
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		SCTP_DEBUG_PRINTK_IPADDR("proc_asconf_param: DEL_IP (transport count %d srcaddr: "," chunk %p\n", asoc->peer.transport_count, tmpaddrp, asconf);
> +#endif
>  		if (asoc->peer.transport_count = 1)
>  			return SCTP_ERROR_DEL_LAST_IP;
>  
> @@ -2939,7 +3137,11 @@
>  		 * an Error Cause TLV set to the new error code 'Request to
>  		 * Delete Source IP Address'
>  		 */
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if (sctp_cmp_addr_exact(&asconf->source, &addr))
> +#else
>  		if (sctp_cmp_addr_exact(sctp_source(asconf), &addr))
> +#endif
>  			return SCTP_ERROR_DEL_SRC_IP;
>  
>  		/* Section 4.2.2
> @@ -2960,6 +3162,9 @@
>  		 * MAY mark the source address of the packet as its
>  		 * primary.
>  		 */
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		SCTP_DEBUG_PRINTK("proc_asconf_param: SET_PRIMARY\n");
> +#endif
>  		if (af->is_any(&addr))
>  			memcpy(&addr.v4, sctp_source(asconf), sizeof(addr));
>  
> @@ -3120,7 +3325,12 @@
>  	struct sctp_bind_addr *bp = &asoc->base.bind_addr;
>  	union sctp_addr_param *addr_param;
>  	struct sctp_transport *transport;
> +#ifndef CONFIG_SCTP_AUTO_ASCONF
>  	struct sctp_sockaddr_entry *saddr;
> +#endif
> +#ifdef CONFIG_SCTP_AUTO_ASCONF /* for debug only */
> +	union sctp_addr *addrp;
> +#endif
>  
>  	addr_param = (union sctp_addr_param *)
>  			((void *)asconf_param + sizeof(sctp_addip_param_t));
> @@ -3135,10 +3345,26 @@
>  		 * held, so the list can not change.
>  		 */
>  		local_bh_disable();
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		/* Until this ASCONF is acked on all associations, we cannot 
> +		 * consider this address as ADDR_SRC
> +		 */

Why?  Each association is separate, even though they may all belong to the same
endpoint, they can start using the new address once that ASCONF has been acked.



> +		addrp = &addr;
> +		SCTP_DEBUG_PRINTK_IPADDR("asconf_param_success: asoc %p adds "," (port: %d) to asoc_laddr_list\n", asoc, addrp, htons(bp->port));
> +		asoc->src_out_of_asoc_ok = 0;
> +		sctp_add_addr_to_laddr(&addr.sa, asoc);
> +		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
> +				transports) {
> +			dst_release(transport->dst);
> +			sctp_transport_route(transport, NULL,
> +					     sctp_sk(asoc->base.sk));
> +		}
> +#else
>  		list_for_each_entry(saddr, &bp->address_list, list) {
>  			if (sctp_cmp_addr_exact(&saddr->a, &addr))
>  				saddr->state = SCTP_ADDR_SRC;
>  		}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  		local_bh_enable();
>  		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
>  				transports) {
> @@ -3152,6 +3378,30 @@
>  	case SCTP_PARAM_DEL_IP:
>  		local_bh_disable();
>  		sctp_del_bind_addr(bp, &addr);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if (asoc->asconf_addr_del_pending != NULL) {
> +			if ((addr.sa.sa_family = AF_INET) && 
> +			    (asoc->asconf_addr_del_pending->sa.sa_family = 
> +			     AF_INET)) {
> +				if (asoc->asconf_addr_del_pending->v4.sin_addr.s_addr = addr.v4.sin_addr.s_addr) {
> +					kfree(asoc->asconf_addr_del_pending);
> +					asoc->asconf_del_pending_cid = 0;
> +					asoc->asconf_addr_del_pending = NULL;
> +					SCTP_DEBUG_PRINTK("proc_asconfack: now del_pending on asoc %p is freed\n", asoc);
> +				}
> +			} 
> +			else if ((addr.sa.sa_family = AF_INET6) && 
> +				(asoc->asconf_addr_del_pending->sa.sa_family = 
> +				 AF_INET6)) {
> +				if (memcmp(&asoc->asconf_addr_del_pending->v6.sin6_addr, &addr.v6.sin6_addr, sizeof(struct in6_addr)) = 0) {
> +					kfree(asoc->asconf_addr_del_pending);
> +					asoc->asconf_del_pending_cid = 0;
> +					asoc->asconf_addr_del_pending = NULL;
> +					SCTP_DEBUG_PRINTK("proc_asconfack: now del_pending on asoc %p is freed\n", asoc);
> +				}
> +			}
> +		}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  		local_bh_enable();
>  		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
>  				transports) {
> @@ -3242,6 +3492,10 @@
>  	int	no_err = 1;
>  	int	retval = 0;
>  	__be16	err_code = SCTP_ERROR_NO_ERROR;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	sctp_addip_param_t *first_asconf_param = NULL;
> +	int first_asconf_paramlen;
> +#endif
>  
>  	/* Skip the chunkhdr and addiphdr from the last asconf sent and store
>  	 * a pointer to address parameter.
> @@ -3256,6 +3510,10 @@
>  	length = ntohs(addr_param->v4.param_hdr.length);
>  	asconf_param = (sctp_addip_param_t *)((void *)addr_param + length);
>  	asconf_len -= length;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	first_asconf_param = asconf_param;
> +	first_asconf_paramlen = ntohs(first_asconf_param->param_hdr.length);
> +#endif
>  
>  	/* ADDIP 4.1
>  	 * A8) If there is no response(s) to specific TLV parameter(s), and no
> @@ -3310,6 +3568,37 @@
>  		asconf_len -= length;
>  	}
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	/* When the source address obviously changes to newly added one, we 
> +	   reset the cwnd to re-probe the path condition
> +	*/
> +	if (no_err && (first_asconf_param->param_hdr.type = SCTP_PARAM_ADD_IP)) {
> +		SCTP_DEBUG_PRINTK("proc_asconfack: no error and ADD parameter (len is %d) is processed, now we call pcheck_and_react\n", first_asconf_paramlen);
> +		if (first_asconf_paramlen = 16) {
> +			struct sockaddr_in sin;
> +
> +			memset(&sin, 0, sizeof(struct sockaddr_in));
> +			sin.sin_family = AF_INET;
> +			memcpy(&sin.sin_addr.s_addr, first_asconf_param + 1, 
> +					sizeof(struct in_addr));
> +			sctp_path_check_and_react(asoc, 
> +					(struct sockaddr *)&sin);
> +
> +		} else if (first_asconf_paramlen = 28) {
> +			struct sockaddr_in6 sin6;
> +
> +			memset(&sin6, 0, sizeof(struct sockaddr_in6));
> +			sin6.sin6_family = AF_INET6;
> +			memcpy(&sin6.sin6_addr, first_asconf_param + 1, 
> +					sizeof(struct in6_addr));
> +			sctp_path_check_and_react(asoc, 
> +					(struct sockaddr *)&sin6);
> +		} else {
> +			SCTP_DEBUG_PRINTK("funny asconf_paramlen? (%d)\n", first_asconf_paramlen);
> +		}
> +	}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +
>  	/* Free the cached last sent asconf chunk. */
>  	list_del_init(&asconf->transmitted_list);
>  	sctp_chunk_free(asconf);
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/socket.c linux-2.6/net/sctp/socket.c
> --- linux-2.6.orig/net/sctp/socket.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/socket.c	2010-04-22 18:06:56.000000000 +0900
> @@ -525,6 +525,9 @@
>  	struct list_head		*p;
>  	int 				i;
>  	int 				retval = 0;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	struct sctp_transport 		*trans = NULL;
> +#endif
>  
>  	if (!sctp_addip_enable)
>  		return retval;
> @@ -581,13 +584,16 @@
>  			goto out;
>  		}
>  
> +#ifndef CONFIG_SCTP_AUTO_ASCONF
>  		retval = sctp_send_asconf(asoc, chunk);
>  		if (retval)
>  			goto out;
> +#endif
>  
>  		/* Add the new addresses to the bind address list with
>  		 * use_as_src set to 0.
>  		 */
> +		SCTP_DEBUG_PRINTK("snd_asconf_addip: next, add_bind_addr with ADDR_NEW flag\n");
>  		addr_buf = addrs;
>  		for (i = 0; i < addrcnt; i++) {
>  			addr = (union sctp_addr *)addr_buf;
> @@ -597,6 +603,29 @@
>  						    SCTP_ADDR_NEW, GFP_ATOMIC);
>  			addr_buf += af->sockaddr_len;
>  		}
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		list_for_each_entry(trans, &asoc->peer.transport_addr_list, transports) {
> +			if (asoc->asconf_addr_del_pending != NULL) {
> +				/* This ADDIP ASCONF piggybacks DELIP for the 
> +				 * last address, so need to select src addr 
> +				 * from the out_of_asoc addrs 
> +				 */
> +				asoc->src_out_of_asoc_ok = 1;
> +			}
> +			/* Clear the source and route cache in the path */
> +			memset(&trans->saddr, 0, sizeof(union sctp_addr));
> +			dst_release(trans->dst);
> +//			sctp_transport_reset(trans);
> +			trans->cwnd = min(4*asoc->pathmtu, max_t(__u32, 2*asoc->pathmtu, 4380));
> +			trans->ssthresh = asoc->peer.i.a_rwnd;
> +			trans->rto = asoc->rto_initial;
> +			trans->rtt = 0;
> +			trans->srtt = 0;
> +			trans->rttvar = 0;
> +			sctp_transport_route(trans, NULL, sctp_sk(asoc->base.sk));
> +		}
> +		retval = sctp_send_asconf(asoc, chunk);
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
>  	}
>  
>  out:
> @@ -638,6 +667,7 @@
>  		 * bind address, there is nothing more to be removed (we need
>  		 * at least one address here).
>  		 */
> +		
>  		if (list_empty(&bp->address_list) ||
>  		    (sctp_list_single_entry(&bp->address_list))) {
>  			retval = -EBUSY;
> @@ -709,7 +739,11 @@
>  	struct sctp_sockaddr_entry *saddr;
>  	int 			i;
>  	int 			retval = 0;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	int			stored = 0;
>  
> +	chunk = NULL;
> +#endif
>  	if (!sctp_addip_enable)
>  		return retval;
>  
> @@ -760,8 +794,41 @@
>  		bp = &asoc->base.bind_addr;
>  		laddr = sctp_find_unmatch_addr(bp, (union sctp_addr *)addrs,
>  					       addrcnt, sp);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if ((laddr = NULL) && (addrcnt = 1)) {
> +			union sctp_addr *sa_addr = NULL;
> +
> +			if (asoc->asconf_addr_del_pending = NULL) {
> +				asoc->asconf_addr_del_pending = kmalloc(sizeof(union sctp_addr), GFP_ATOMIC);
> +				memset(asoc->asconf_addr_del_pending, 0, 
> +						sizeof(union sctp_addr));
> +				if (addrs->sa_family = AF_INET) {
> +					struct sockaddr_in *sin;
> +
> +					sin = (struct sockaddr_in *)addrs;
> +					asoc->asconf_addr_del_pending->v4.sin_family = AF_INET;
> +					memcpy(&asoc->asconf_addr_del_pending->v4.sin_addr, &sin->sin_addr, sizeof(struct in_addr));
> +				} else if (addrs->sa_family = AF_INET6) {
> +					struct sockaddr_in6 *sin6;
> +
> +					sin6 = (struct sockaddr_in6 *)addrs;
> +					asoc->asconf_addr_del_pending->v6.sin6_family = AF_INET6;
> +					memcpy(&asoc->asconf_addr_del_pending->v6.sin6_addr, &sin6->sin6_addr, sizeof(struct in6_addr));
> +				}
> +				sa_addr = (union sctp_addr *)addrs;
> +				SCTP_DEBUG_PRINTK_IPADDR("send_asconf_del_ip: keep the last address asoc: %p "," at %p\n", asoc, sa_addr, asoc->asconf_addr_del_pending);
> +				stored = 1;
> +				goto skip_mkasconf;
> +			} else {
> +				SCTP_DEBUG_PRINTK_IPADDR("send_asconf_del_ip: asoc %p, deleting last address "," is already stored at %p\n", asoc, asoc->asconf_addr_del_pending, asoc->asconf_addr_del_pending);
> +				continue;
> +			}
> +		}
> +#else
>  		if (!laddr)
>  			continue;
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +
>  
>  		/* We do not need RCU protection throughout this loop
>  		 * because this is done under a socket lock from the
> @@ -774,6 +841,9 @@
>  			goto out;
>  		}
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +skip_mkasconf:
> +#endif
>  		/* Reset use_as_src flag for the addresses in the bind address
>  		 * list that are to be deleted.
>  		 */
> @@ -795,16 +865,263 @@
>  		list_for_each_entry(transport, &asoc->peer.transport_addr_list,
>  					transports) {
>  			dst_release(transport->dst);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +			/* Clear source address cache */
> +			memset(&transport->saddr, 0, sizeof(union sctp_addr));
> +#endif
>  			sctp_transport_route(transport, NULL,
>  					     sctp_sk(asoc->base.sk));
>  		}
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +		if (stored) {
> +			/* We don't need to transmit ASCONF */
> +			continue;
> +		}
> +#endif
>  		retval = sctp_send_asconf(asoc, chunk);
>  	}
>  out:
>  	return retval;
>  }
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF 
> +
> +/* Add a new address to the list contains available addresses only in the 
> + * association.  If the new address is also available on the other associations 
> + * on the endpoint, it is marked as SCTP_ADDR_SRC in the bind address list on 
> + * the endpoint.  This situation is possible when an association receives an
> + * ASCONF-ACK
> + */
> +void
> +sctp_add_addr_to_laddr(struct sockaddr *sa, struct sctp_association *asoc)
> +{
> +	struct sctp_endpoint *ep = asoc->ep;
> +	struct sctp_association *tmp = NULL;
> +	struct sctp_bind_addr *bp;
> +	struct sctp_sockaddr_entry *addr;
> +	struct sockaddr_in *sin = NULL;
> +	struct sockaddr_in6 *sin6 = NULL;
> +	int local;
> +	int found;
> +
> +	union sctp_addr *tmpaddr = NULL;
> +	tmpaddr = (union sctp_addr *)sa;
> +	SCTP_DEBUG_PRINTK_IPADDR("add_addr_to_laddr: asoc: %p "," ep: %p", asoc, tmpaddr, ep);
> +	if (sa->sa_family = AF_INET) {
> +		sin = (struct sockaddr_in *)sa;
> +	} else if (sa->sa_family = AF_INET6) {
> +		sin6 = (struct sockaddr_in6 *)sa;
> +	}
> +
> +	/* Check if this address is locally available in the other asocs */
> +	local = 0;
> +	list_for_each_entry(tmp, &ep->asocs, asocs) {
> +		SCTP_DEBUG_PRINTK("add_addr_to_laddr: walking asocs in the ep %p, now asoc %p\n", ep, tmp);
> +		if (tmp = asoc) {
> +			continue;
> +		}
> +		found = 0;
> +		list_for_each_entry(addr, &tmp->asoc_laddr_list, list) {
> +			tmpaddr = &addr->a;
> +			if (sa->sa_family != addr->a.sa.sa_family) {
> +				continue;
> +			}
> +			if (sa->sa_family = AF_INET) {
> +				if (sin->sin_addr.s_addr = addr->a.v4.sin_addr.s_addr) {
> +					found = 1;
> +				}
> +			} else if (sa->sa_family = AF_INET6) {
> +				if (memcmp(&sin6->sin6_addr, &addr->a.v6.sin6_addr, sizeof(struct in6_addr)) = 0) {
> +					found = 1;
> +
> +				}
> +			}
> +		}
> +		if (!found) {
> +			SCTP_DEBUG_PRINTK("add_addr_to_laddr: not found in asoc %p\n", tmp);
> +			local = 1;
> +			break;
> +		}
> +	}
> +	addr = NULL;
> +
> +	if (local) {
> +		/* this address is not available in some of the other 
> +		 * associations.  So add as locally-available in this 
> +		 * asocciation 
> +		 */
> +		addr = kmalloc(sizeof(struct sctp_sockaddr_entry), GFP_ATOMIC);
> +		if  (addr = NULL) {
> +			SCTP_DEBUG_PRINTK("add_addr_to_laddr: failed to allocate memory for this address\n");
> +			return;
> +		}
> +		memset(addr, 0, sizeof(struct sctp_sockaddr_entry));
> +		if (sa->sa_family = AF_INET) {
> +			addr->a.sa.sa_family = AF_INET;
> +			addr->a.v4.sin_port = sin->sin_port;
> +			addr->a.v4.sin_addr.s_addr = sin->sin_addr.s_addr;
> +		} else if (sa->sa_family = AF_INET6) {
> +			addr->a.sa.sa_family = AF_INET6;
> +			addr->a.v6.sin6_port = sin6->sin6_port;
> +			memcpy(&addr->a.v6.sin6_addr, &sin6->sin6_addr, sizeof(struct in6_addr));
> +		}
> +		list_add_tail(&addr->list, &asoc->asoc_laddr_list);
> +		SCTP_DEBUG_PRINTK("add_addr_to_laddr: now we added this address to the local list on asoc %p\n", asoc);
> +	} else {
> +		/* this address is also available in all other asocs.  So set 
> +		 * it as ADDR_SRC in the bind-addr list in the endpoint, then 
> +		 * remove from the asoc_laddr_list on the associations.  
> +		 */
> +		SCTP_DEBUG_PRINTK("add_addr_to_laddr: this address is available in all other asocs\n");
> +		bp = &asoc->base.bind_addr;
> +
> +		/* change state of the new address in the bind list */
> +		list_for_each_entry(addr, &bp->address_list, list) {
> +			if (addr->state != SCTP_ADDR_NEW) {
> +				continue;
> +			}
> +			if (addr->a.sa.sa_family != sa->sa_family) {
> +				continue;
> +			}
> +			if (addr->a.sa.sa_family = AF_INET) {
> +				if (sin->sin_port != addr->a.v4.sin_port) {
> +					continue;
> +				}
> +				if (sin->sin_addr.s_addr != 
> +				    addr->a.v4.sin_addr.s_addr) {
> +					continue;
> +				}
> +			} else if (addr->a.sa.sa_family = AF_INET6) {
> +				if (sin6->sin6_port != addr->a.v6.sin6_port) {
> +					continue;
> +				}
> +				if (memcmp(&sin6->sin6_addr, 
> +				    &addr->a.v6.sin6_addr, 
> +				    sizeof(struct in6_addr)) != 0) {
> +					continue;
> +				}
> +			}
> +			SCTP_DEBUG_PRINTK("add_addr_to_laddr: found the entry for this address with ADDR_NEW flag, set to ADDR_SRC\n");
> +			addr->state = SCTP_ADDR_SRC;
> +		}
> +
> +		/* remove the entry of this address from the asoc-local list */
> +		list_for_each_entry(tmp, &ep->asocs, asocs) {
> +			if (tmp = asoc) {
> +				continue;
> +			}
> +			addr = NULL;
> +			list_for_each_entry(addr, &tmp->asoc_laddr_list, list) {
> +				if (sa->sa_family != addr->a.sa.sa_family) {
> +					continue;
> +				}
> +				if (sa->sa_family = AF_INET) {
> +					if (sin->sin_addr.s_addr != addr->a.v4.sin_addr.s_addr) {
> +						continue;
> +					}
> +				} else if (sa->sa_family = AF_INET6) {
> +					if (memcmp(&sin6->sin6_addr, &addr->a.v6.sin6_addr, sizeof(struct in6_addr)) != 0) {
> +						continue;
> +					}
> +				}
> +				break;
> +			}
> +			if (addr = NULL) {
> +				SCTP_DEBUG_PRINTK("add_addr_to_laddr: Huh, asoc %p doesn't have the entry for this address?\n", asoc);
> +				continue;
> +			}
> +			list_del(&addr->list);
> +			kfree(addr);
> +		}
> +	}
> +}
> +
> +/* set address events to associations in the given endpoint.  We assume the ep 
> + * is write-locked, and addr_wq is read-locked.  
> + */
> +int
> +sctp_asconf_mgmt(struct sctp_endpoint *ep, struct sock *sk)
> +{
> +	struct sctp_addr_wait *addrw = NULL;
> +	union sctp_addr *addr = NULL;
> +	int cmd;
> +	int error = 0;
> +
> +	if (!sctp_auto_asconf_enable) {
> +		return (-EINVAL);
> +	}
> +	if ((ep = NULL) || (sk = NULL)) {
> +		SCTP_DEBUG_PRINTK("sctp_asconf_mgmt: bad arg (ep %p sk %p)\n", ep, sk);
> +		return(-EINVAL);
> +	}
> +	if (list_empty(&sctp_addr_waitq)) {
> +		SCTP_DEBUG_PRINTK("asconf_mgmt: nothing in the wq\n");
> +		return(-EINVAL);
> +	}
> +	addrw = list_first_entry(&sctp_addr_waitq, struct sctp_addr_wait, list);
> +	if (addrw->cmd != SCTP_NEWADDR && addrw->cmd != SCTP_DELADDR) {
> +		SCTP_DEBUG_PRINTK("asconf_mgmt: invalid command in wq ent\n");
> +		return(-EINVAL);
> +	}
> +	addr = &addrw->a;
> +	cmd = addrw->cmd;
> +
> +	if (addr->sa.sa_family = AF_INET) {
> +		addr->v4.sin_port = htons(ep->base.bind_addr.port);
> +	} else if (addr->sa.sa_family = AF_INET6) {
> +		addr->v6.sin6_port = htons(ep->base.bind_addr.port);
> +	}
> +
> +	/* Debug */
> +	if (cmd = SCTP_NEWADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_asconf_mgmt: send an ASCONF to add a new addr at asocs of ep %p : "," (cmd: %d)\n", ep, addr, cmd);
> +	} else if (cmd = SCTP_DELADDR) {
> +		SCTP_DEBUG_PRINTK_IPADDR("sctp_asconf_mgmt: send an ASCONF to delete an existing addr at asocs of ep %p : "," (cmd: %d)\n", ep, addr, cmd);
> +	} 
> +
> +	if (cmd = SCTP_NEWADDR) {
> +		error = sctp_send_asconf_add_ip(sk, (struct sockaddr *)addr, 1);
> +		if (error) {
> +			SCTP_DEBUG_PRINTK("asconf_mgmt: send_asconf_add_ip returns %d\n", error);
> +			return(error);
> +		}
> +	} else if (cmd = SCTP_DELADDR) {
> +		error = sctp_send_asconf_del_ip(sk, (struct sockaddr *)addr, 1);
> +		if (error) {
> +			SCTP_DEBUG_PRINTK("asconf_mgmt: send_asconf_del_ip returns %d\n", error);
> +			return(error);
> +		}
> +	}
> +
> +	return(0);
> +}
> +
> +void
> +sctp_dbg_print_transmitted(struct sctp_association *asoc) 
> +{
> +	struct sctp_transport *trans = NULL;
> +	struct sctp_chunk *chk;
> +	struct list_head *sentqueue;
> +	uint32_t tsn;
> +	union sctp_addr *addr;
> +
> +
> +	if (!asoc) {
> +		return;
> +	}
> +	list_for_each_entry(trans, &asoc->peer.transport_addr_list, transports) {
> +		addr = &trans->ipaddr;
> +		sentqueue = &trans->transmitted;
> +		list_for_each_entry(chk, sentqueue, transmitted_list) {
> +			tsn = ntohl(chk->subh.data_hdr->tsn);
> +			SCTP_DEBUG_PRINTK_IPADDR("dbg_prt_transmitted: trans: %p "," cwnd: %u flight_size: %u tsn: %u gap_acked: %d\n", trans, addr, trans->cwnd, trans->flight_size, tsn, chk->tsn_gap_acked);
> +		}
> +	}
> +
> +}
> +#endif /* CONFIG_SCTP_AUTO_ASCONF */
> +

Is that really needed?

>  /* Helper for tunneling sctp_bindx() requests through sctp_setsockopt()
>   *
>   * API 8.1
> @@ -1135,6 +1452,9 @@
>  	if ((err = 0 || err = -EINPROGRESS) && assoc_id)
>  		*assoc_id = asoc->assoc_id;
>  
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	sctp_hash_endpoint(ep);
> +#endif

No, only listening endpoints are hashed.  Client endpoints have their
asociations hashed.  This would break things.


>  	/* Don't free association on exit. */
>  	asoc = NULL;
>  
> @@ -3548,6 +3868,10 @@
>  	struct sctp_association *asoc;
>  	long timeo;
>  	int error = 0;
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	struct sctp_sock *newsp = NULL;
> +	struct sctp_endpoint *newep = NULL;
> +#endif
>  
>  	sctp_lock_sock(sk);
>  
> @@ -3585,6 +3909,11 @@
>  	 * asoc to the newsk.
>  	 */
>  	sctp_sock_migrate(sk, newsk, asoc, SCTP_SOCKET_TCP);
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	newsp = sctp_sk(newsk);
> +	newep = newsp->ep;
> +	sctp_hash_endpoint(newep);
> +#endif
>  

Same here.


I'll be able to give a more detailed review once there is a little more context
in the patch (list which functions are modified) and all the
dead/debug/commented-out code is gone.

-vlad

>  out:
>  	sctp_release_sock(sk);
> diff -ru -x diff -ru -x '\.git' -x arch -x drivers -x fs -x asm -x Documentation linux-2.6.orig/net/sctp/sysctl.c linux-2.6/net/sctp/sysctl.c
> --- linux-2.6.orig/net/sctp/sysctl.c	2010-04-22 17:55:41.000000000 +0900
> +++ linux-2.6/net/sctp/sysctl.c	2010-04-24 11:36:05.000000000 +0900
> @@ -182,6 +182,15 @@
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +#ifdef CONFIG_SCTP_AUTO_ASCONF
> +	{
> +		.procname	= "auto_asconf_enable",
> +		.data		= &sctp_auto_asconf_enable,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},
> +#endif
>  	{
>  		.procname	= "prsctp_enable",
>  		.data		= &sctp_prsctp_enable,
> 
> 
> 
> 
> 
> 
> 
>> Best regards,
>> - Michio
>>
>> On Apr 20, 2010, at 23:07 , Vlad Yasevich wrote:
>>
>>>
>>> Johan Gall wrote:
>>>> Good morning,
>>>>
>>>> I am trying to find a workaround for the following problem :
>>>> BoxA with 2 interfaces i1 and i2
>>>> BoxB with 2 interfaces
>>>> BoxA spam messenges to BoxB
>>>> - Both BoxA interfaces change, i1(main) get down then i2 changes its
>>>> IP, between the 2 changes i2 was unusable
>>>> I am trying to use the ADDIP extension to ensure multihoming even
>>>> under this scenario.
>>>>
>>>> What I thought of is to send the following packet while using linux's
>>>> sysctl "net.sctp.addip_noauth_enable"
>>>> -START-OF-PACKET--
>>>> Common Header
>>>> ASCHUNK ADD new i2 ip (comes from an IP unknown from the association)
>>>> ASCHUNK REM old i2 ip(contains i1 address, now)
>>>> ASCHUNK CHANGE_PRIMARY to new i2 ip
>>>> -END-OF-PACKET-----
>>>>
>>>> According to what I understood from the RFC5061 (SCTP dynamic address
>>>> configuration), the ASCHUNKS should be associated to the old i2 ip
>>>> association. (1st chunk can't find assoc, try next in the packet,
>>>> found an assoc!)
>>>>
>>>> Thus, I have 2 questions.
>>>> How can I force the said packet configuration in user land (Linux 2.6.29)?
>>>> Would it even work?
>>> First, this would depend on the AUTOASCONF functionality.  There were some folks
>>> that have to trying implementing it, but no formal submissions have been done.
>>>
>>> This is not currently supported and to do it in the application is fairly hard
>>> since the app has no control over the timing or how the addresses are changed.
>>>
>>> Also, if the odl address is removed prior to the new one being added, it would
>>> cause issues as well.
>>>
>>>> (I don't know if it could help, but while I searched I found that
>>>> SCTP_EXPLICIT_EOR is not implemented yet)
>>> This has not relationship to address configuration.
>>>
>>>> Thanks a lot for having read this mail. Please excuse me if I have
>>>> missed obvious elements, I am just a student very new to SCTP (and
>>>> network programming in that matter).
>>>>
>>> No problems.
>>> -vlad
>>>> ------------------------------------------------------------------------------
>>>> Download Intel&#174; Parallel Studio Eval
>>>> Try the new software tools for yourself. Speed compiling, find bugs
>>>> proactively, and fine-tune applications for parallel performance.
>>>> See why Intel Parallel Studio got high marks during beta.
>>>> http://p.sf.net/sfu/intel-sw-dev
>>>> _______________________________________________
>>>> Lksctp-developers mailing list
>>>> Lksctp-developers@lists.sourceforge.net
>>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>>>>
>>> ------------------------------------------------------------------------------
>>> Download Intel&#174; Parallel Studio Eval
>>> Try the new software tools for yourself. Speed compiling, find bugs
>>> proactively, and fine-tune applications for parallel performance.
>>> See why Intel Parallel Studio got high marks during beta.
>>> http://p.sf.net/sfu/intel-sw-dev
>>> _______________________________________________
>>> Lksctp-developers mailing list
>>> Lksctp-developers@lists.sourceforge.net
>>> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
> 
