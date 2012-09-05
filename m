From: Matija Glavinic Pecotic <matija.glavinic-pecotic.ext@nsn.com>
Date: Wed, 05 Sep 2012 11:27:08 +0000
Subject: Re: [Lksctp-developers] route/dst_entry caching issue
Message-Id: <5047370C.8080604@nsn.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------060804000809090001000409"
List-Id: <linux-sctp.vger.kernel.org>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------060804000809090001000409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello lksctp developers,

a while back we noticed below described issue.

In order to quick-fix this, we implemented following workaround:

1) added interface to sctp for invalidating all dst entries on all 
associations (0002-sctp-export-dst-entries-invalidation-if.patch) - this 
is on top of below mentioned patch 
(0001-sctp-check-cached-dst-before-using-it.patch)

2) in a separate module route and ipsec events are monitored and upon 
addition and deletion of routes, along with xfrm events interface is 
called. This is done by netlink socket opened within the kernel. If 
interested, I can share that one as well.

Could you please give some comments on both workaround and mentioned issue?

Thanks and regards,

Matija

On 12.06.2012 19:10, ext Matija Glavinic Pecotic wrote:
> Hello,
>
> We're facing an issue regarding route change and startup of ipsec
> tunnel. Here is setup and test scenarios:
>
> 1) Setup
> Simple sctp client and server. Client is bound to the loopback address
> 10.0.0.1 and it is connected to the server via eth3 (192.168.2.1) which
> is in LAN with eth2 (192.168.2.2) and eth3 (192.168.2.3) on the server
> and server is bound to the 20.0.0.1 which is loopback.
>
> Client:
>
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>       inet 10.0.0.1/8 scope global lo
>       inet6 ::1/128 scope host
>          valid_lft forever preferred_lft forever
>
> 13: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>       link/ether 00:40:43:30:81:80 brd ff:ff:ff:ff:ff:ff
>       inet 192.168.2.1/24 brd 192.168.2.255 scope global eth3
>       inet6 fe80::240:43ff:fe30:8180/64 scope link
>          valid_lft forever preferred_lft forever
>
> 192.168.2.0/24 dev eth3  proto kernel  scope link  src 192.168.2.1
> 192.168.253.0/24 dev rio0  proto kernel  scope link  src 192.168.253.16
> 192.168.254.0/23 dev eth0  proto kernel  scope link  src 192.168.255.1
> 20.0.0.0/8 via 192.168.2.1 dev eth3  scope link
>
> Server:
>
> 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 16436 qdisc noqueue state UNKNOWN
>       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
>       inet 20.0.0.1/8 scope global lo
>       inet6 ::1/128 scope host
>          valid_lft forever preferred_lft forever
>
> 12: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>       link/ether 00:40:43:b1:f8:ae brd ff:ff:ff:ff:ff:ff
>       inet 192.168.2.2/24 brd 192.168.2.255 scope global eth2
>       inet6 fe80::240:43ff:feb1:f8ae/64 scope link
>          valid_lft forever preferred_lft forever
>
> 13: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP
>       link/ether 00:40:43:b1:f8:af brd ff:ff:ff:ff:ff:ff
>       inet 192.168.2.3/24 brd 192.168.2.255 scope global eth3
>       inet6 fe80::240:43ff:feb1:f8af/64 scope link
>          valid_lft forever preferred_lft forever
>
> 192.168.2.0/24 dev eth2  proto kernel  scope link  src 192.168.2.2
> 192.168.2.0/24 dev eth3  proto kernel  scope link  src 192.168.2.3
> 192.168.253.0/24 dev rio0  proto kernel  scope link  src 192.168.253.16
> 192.168.255.0/24 dev eth0  proto kernel  scope link  src 192.168.255.2
> 10.0.0.0/8 via 192.168.2.1 dev eth2
> 10.0.0.0/8 via 192.168.2.1 dev eth3  metric 10
>
> Server listens on 20.0.0.1 and when client is connected it sends message
> indefinitely
>
> Kernel is 2.6.32.58 and sctp is applied with patch from this thread:
> http://sourceforge.net/mailarchive/message.php?msg_id=25786006
> (0001-sctp-check-cached-dst-before-using-it.patch)
>
> 2) Test scenario 1
>
> Start sctp_server
> Start sctp_client -> clients receives messages from the server
> Observe traffic flow -> as expected it goes over eth2 on the server
> Delete route 10.0.0.0/8 via 192.168.2.1 dev eth2
> Traffic still goes over eth2, on server restart it goes over eth3
>
> For reference, I've run also TCP server/client which does the same
> thing, after deletion of mentioned route traffic continued over eth3.
> Other kinds of traffic are also rerouted on route deletion (icmp)
>
> 3) Test scenario 2
>
> Setup same as before, eth3 on server isn't used.
>
> Start sctp_server
> Start sctp_client -> traffic ok
> Start ipsec tunnel:
>       left=192.168.2.2
>       leftsubnet=20.0.0.0/24
>       right=192.168.2.1
>       rightsubnet=10.0.0.0/24
> After start of ipsec tunnel, traffic went over same dst unencrypted for
> a short period of time.
> For reference, again same scenario with TCP server/client -> traffic
> started to be encrypted immediately
>
> ------
>
> In my opinion there is problem with cached dst_entry. I've tried following:
>
> [sctp.h]
> /* The cookie is always 0 since this is how it's used in the
>    * pmtu code.
>    */
> static inline struct dst_entry *sctp_transport_dst_check(struct
> sctp_transport *t)
> {
> 	if (t->dst) {
> 		dst_release(t->dst);
> 		t->dst = NULL;
> 	}
>
> 	return t->dst;
> }
>
> With this I just wanted to force sctp to route every time it wants to
> send packet, and after this change above mentioned scenarios passed.
> Here is my short analysis, ignore it if I got something wrong: I see
> potential problem with SCTP's dst_entry: struct dst_entry *dst which is
> member of sctp_transport. For example, ipv4&6 implement operations on
> dst_entry (ipv4_dst_ops ) which are to be done when event occurs, such
> as unreachability, route deleteion, etc. SCTP doesn't, and it also
> doesn't use dst_entries from ipv*. In this way, only events which impact
> SCTPs dst_entries are default ones, NETDEV_DOWN and NETDEV_UNREGISTER
> and these are only which will be noted with dst_check().
>
> Could you comment please? I'll be glad to make tests/verifications or
> provide any sort of help on this.
>
> Thanks & regards,
>
> Matija
>
> ------------------------------------------------------------------------------
> Live Security Virtual Conference
> Exclusive live event will cover all the ways today's security and
> threat landscape has changed and how IT managers can respond. Discussions
> will include endpoint security, mobile security and the latest in malware
> threats. http://www.accelacomm.com/jaw/sfrnl04242012/114/50122263/
> _______________________________________________
> Lksctp-developers mailing list
> Lksctp-developers@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/lksctp-developers
>


--------------060804000809090001000409
Content-Type: text/x-patch;
 name="0002-sctp-export-dst-entries-invalidation-if.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-sctp-export-dst-entries-invalidation-if.patch"

diff -purN linux.unpatched/include/net/sctp/sctp.h linux/include/net/sctp/sctp.h
--- linux.unpatched/include/net/sctp/sctp.h	2012-08-03 17:29:28.000000000 +0200
+++ linux/include/net/sctp/sctp.h	2012-08-03 17:18:22.000000000 +0200
@@ -704,4 +704,10 @@ static inline struct dst_entry *sctp_tra
 	return t->dst;
 }
 
+/** 
+ * invalidate all dst_cache entries, goes through all associations and 
+ * invalidates associated dst_entries. 
+ */
+void __sctp_invalidate_all_assocs_dst(void);
+
 #endif /* __net_sctp_h__ */
diff -purN linux.unpatched/net/sctp/protocol.c linux/net/sctp/protocol.c
--- linux.unpatched/net/sctp/protocol.c	2012-08-03 17:29:28.000000000 +0200
+++ linux/net/sctp/protocol.c	2012-08-03 18:39:16.000000000 +0200
@@ -1058,6 +1058,42 @@ static void sctp_v4_del_protocol(void)
 	unregister_inetaddr_notifier(&sctp_inetaddr_notifier);
 }
 
+void __sctp_invalidate_all_assocs_dst(void)
+{
+	struct sctp_hashbucket *head;
+	struct sctp_ep_common *epb;
+	struct sctp_association *assoc;
+	struct hlist_node *node;
+	int    hash = 0;
+	struct sctp_transport *transport;
+	union sctp_addr *primary;
+	
+	printk(KERN_INFO "[%s:%d]: Invalidating all dst_entries\n", __FUNCTION__, __LINE__);
+
+	for(hash = 0; hash < sctp_assoc_hashsize; hash++)
+	{	
+		head = &sctp_assoc_hashtable[hash];
+		sctp_local_bh_disable();
+		write_lock(&head->lock);
+	
+		sctp_for_each_hentry(epb, node, &head->chain) {
+			assoc = sctp_assoc(epb);
+			
+			primary = &assoc->peer.primary_addr;
+	
+			list_for_each_entry(transport, &assoc->peer.transport_addr_list, transports) 
+			{
+				printk(KERN_INFO "[%s:%d]: Invalidating: transport@0x%p, dst@0x%p, dst->obsolete=%d\n", __FUNCTION__, __LINE__, transport, (*transport).dst, (*transport).dst->obsolete);
+				(*transport).dst->obsolete = 2;				
+			}
+			
+		}
+		write_unlock(&head->lock);
+		sctp_local_bh_enable();
+	}
+}
+EXPORT_SYMBOL(__sctp_invalidate_all_assocs_dst);
+
 /* Initialize the universe into something sensible.  */
 SCTP_STATIC __init int sctp_init(void)
 {
@@ -1069,6 +1105,8 @@ SCTP_STATIC __init int sctp_init(void)
 	int max_share;
 	int order;
 
+	printk(KERN_WARNING "[%s:%d]: Initializing SCTP stack patched for routes and ipsec operations\n", __FUNCTION__, __LINE__);
+	
 	/* SCTP_DEBUG sanity check. */
 	if (!sctp_sanity_check())
 		goto out;
@@ -1297,7 +1335,7 @@ SCTP_STATIC __init int sctp_init(void)
 	status = sctp_v6_add_protocol();
 	if (status)
 		goto err_v6_add_protocol;
-
+		
 	status = 0;
 out:
 	return status;

--------------060804000809090001000409--
