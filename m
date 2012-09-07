From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 07 Sep 2012 15:21:52 +0000
Subject: Re: [PATCH 1/2] dst: take into account policy update on check()
Message-Id: <1347031312.2484.794.camel@edumazet-glaptop>
List-Id: <linux-sctp.vger.kernel.org>
References: <5049FAE3.2050403@6wind.com>
	 <1347033467-3757-1-git-send-email-nicolas.dichtel@6wind.com>
	 <1347033467-3757-2-git-send-email-nicolas.dichtel@6wind.com>
	 <1347028510.2484.736.camel@edumazet-glaptop>  <504A08EA.3080506@6wind.com>
	 <1347030598.2484.777.camel@edumazet-glaptop>  <504A0F1F.5060504@6wind.com>
In-Reply-To: <504A0F1F.5060504@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: nicolas.dichtel@6wind.com
Cc: vyasevich@gmail.com, davem@davemloft.net, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On Fri, 2012-09-07 at 17:13 +0200, Nicolas Dichtel wrote:
> Le 07/09/2012 17:09, Eric Dumazet a écrit :
> > On Fri, 2012-09-07 at 16:47 +0200, Nicolas Dichtel wrote:
> >> Le 07/09/2012 16:35, Eric Dumazet a écrit :
> >>>
> >>> Hmm... cant we reuse rt_genid ?
> >>>
> >>> (When changing flow_cache_genid, change &net->ipv4.rt_genid)
> >>
> >> And so adding a new field in net->ipv6?
> >
> > or move net->ipv4.rt_genid to net->rt_genid
> >
> > Having separate field for IPv4/IPv6 is of little interest IMHO
> >
> Ok, I will wait feedback from other people and repost a patch after.

By the way, the get_random_bytes() calls in rt_cache_invalidate() and in
rt_genid_init() are no longer needed, since we dont use jhash anymore
(no more route cache)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index dc9549b..d6b2b1c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -448,26 +448,12 @@ static inline bool rt_is_expired(const struct rtable *rth)
 }
 
 /*
- * Perturbation of rt_genid by a small quantity [1..256]
- * Using 8 bits of shuffling ensure we can call rt_cache_invalidate()
- * many times (2^24) without giving recent rt_genid.
- * Jenkins hash is strong enough that litle changes of rt_genid are OK.
- */
-static void rt_cache_invalidate(struct net *net)
-{
-	unsigned char shuffle;
-
-	get_random_bytes(&shuffle, sizeof(shuffle));
-	atomic_add(shuffle + 1U, &net->ipv4.rt_genid);
-}
-
-/*
  * delay < 0  : invalidate cache (fast : entries will be deleted later)
  * delay >= 0 : invalidate & flush cache (can be long)
  */
 void rt_cache_flush(struct net *net, int delay)
 {
-	rt_cache_invalidate(net);
+	atomic_inc(&net->ipv4.rt_genid);
 }
 
 static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
@@ -2533,8 +2519,7 @@ static __net_initdata struct pernet_operations sysctl_route_ops = {
 
 static __net_init int rt_genid_init(struct net *net)
 {
-	get_random_bytes(&net->ipv4.rt_genid,
-			 sizeof(net->ipv4.rt_genid));
+	atomic_set(&net->ipv4.rt_genid, 0);
 	get_random_bytes(&net->ipv4.dev_addr_genid,
 			 sizeof(net->ipv4.dev_addr_genid));
 	return 0;


