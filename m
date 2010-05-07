From: "Weixing.Shi(Stone)" <Weixing.Shi@windriver.com>
Date: Fri, 07 May 2010 08:47:28 +0000
Subject: Re: [RFC PATCH v2] sctp: fix sctp to work with ipv6 source address
Message-Id: <4BE3D3A0.9090900@windriver.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------010609000205020405050108"
List-Id: <linux-sctp.vger.kernel.org>
References: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1273062644-11097-2-git-send-email-vladislav.yasevich@hp.com>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------010609000205020405050108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Vlad Yasevich wrote:
> From: Weixing Shi <Weixing.Shi@windriver.com>
>
> <vlad>
> Ok, updated to be a bit more correct.  Only leave the function early if the
> first lookup succeeds.
> </vlad>
>
> in the below test case, using the source address routing,
> sctp can not work.
> Node-A
> 1)ifconfig eth0 inet6 add 2001:1::1/64
> 2)ip -6 rule add from 2001:1::1 table 100 pref 100
> 3)ip -6 route add 2001:2::1 dev eth0 table 100
> 4)sctp_darn -H 2001:1::1 -P 250 -l &
> Node-B
> 1)ifconfig eth0 inet6 add 2001:2::1/64
> 2)ip -6 rule add from 2001:2::1 table 100 pref 100
> 3)ip -6 route add 2001:1::1 dev eth0 table 100
> 4)sctp_darn -H 2001:2::1 -P 250 -h 2001:1::1 -p 250 -s
>
> root cause:
> Node-A and Node-B use the source address routing, and
> at begining, source address will be NULL,sctp will
> search the  routing table by the destination address,
> because using the source address routing table, and
> the result dst_entry will be NULL.
>
> solution:
> walk through the bind address list to get the source
> address and then lookup the routing table again to get
> the correct dst_entry.
>
> Signed-off-by: Weixing Shi <Weixing.Shi@windriver.com>
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
> ---
>  net/sctp/ipv6.c |  113 ++++++++++++++++++++++++++++++++++---------------------
>  1 files changed, 70 insertions(+), 43 deletions(-)
>
> diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
> index 7326891..f75e2f8 100644
> --- a/net/sctp/ipv6.c
> +++ b/net/sctp/ipv6.c
> @@ -77,6 +77,10 @@
>  #include <net/sctp/sctp.h>
>  
>  #include <asm/uaccess.h>
> +static void sctp_v6_dst_saddr(union sctp_addr *addr, struct dst_entry *dst,
> +            __be16 port);
> +static int sctp_v6_cmp_addr(const union sctp_addr *addr1,
> +          const union sctp_addr *addr2);
>  
>  /* Event handler for inet6 address addition/deletion events.
>   * The sctp_local_addr_list needs to be protocted by a spin lock since
> @@ -242,8 +246,12 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>  					 union sctp_addr *daddr,
>  					 union sctp_addr *saddr)
>  {
> -	struct dst_entry *dst;
> +	struct dst_entry *dst = NULL;
>  	struct flowi fl;
> +	struct sctp_bind_addr *bp;
> +	struct sctp_sockaddr_entry *laddr;
> +	union sctp_addr dst_saddr;
> +	sctp_scope_t scope;
>  
>  	memset(&fl, 0, sizeof(fl));
>  	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
> @@ -259,16 +267,71 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
>  	}
>  
>  	dst = ip6_route_output(&init_net, NULL, &fl);
> +
> +	bp = &asoc->base.bind_addr;
> +	scope = sctp_scope(daddr);
> +
>   
if assoc = NULL, will cause kernel crash!
>  	if (!dst->error) {
> +		if (!asoc || saddr)
> +			goto out;
> +
> +		/* Walk through the bind address list and look for a bind
> +		 * address that matches the source address of the returned dst.
> +		 */
> +		sctp_v6_dst_saddr(&dst_saddr, dst, htons(bp->port));
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +			if (!laddr->valid || (laddr->state != SCTP_ADDR_SRC))
> +				continue;
> +
> +			/* Do not compare against v4 addrs */
> +			if ((laddr->a.sa.sa_family == AF_INET6) &&
> +			   (sctp_v6_cmp_addr(&dst_saddr, &laddr->a)))
>   
we do not concern use source address to find the dest address, so these 
lines can ignore!
> +				goto out_unlock;
> +		}
> +		rcu_read_unlock();
> +
> +		/* None of the bound addresses match the source address of the
> +		 * dst. So release it.
> +		 */
> +		dst_release(dst);
> +		dst = NULL;
> +	}
> +
> +	/* Walk through the bind address list and try to get a dst that
> +	 * matches a bind address as the source address.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> +		if (!laddr->valid || (laddr->state != SCTP_ADDR_SRC))
> +			continue;
> +
> +		if ((laddr->a.sa.sa_family == AF_INET6) &&
> +		    (scope <= sctp_scope(&laddr->a))) {
>   
here should be consider the most matched ipv6 address for the dest 
address, so it should be like :
+               list_for_each_entry_rcu(laddr, &bp->address_list, list) {
+                       if (!laddr->valid)
+                               continue;
+                       if ((laddr->state == SCTP_ADDR_SRC) &&
+                          (laddr->a.sa.sa_family == AF_INET6) &&
+                          (scope <= sctp_scope(&laddr->a))) {
+                               bmatchlen = 
sctp_v6_addr_match_len(daddr, &laddr->a);
+                               if (!baddr || (matchlen < bmatchlen)) {
+                               baddr = &laddr->a;
+                               matchlen = bmatchlen;
+                               }
+                       }

> +			ipv6_addr_copy(&fl.fl6_src, &laddr->a.v6.sin6_addr);
> +			dst = ip6_route_output(&init_net, NULL, &fl);
> +			if (dst->error) {
> +				dst_release(dst);
> +				dst = NULL;
> +			} else
> +				break;
> +		}
> +	}
> +
> +out_unlock:
> +	rcu_read_unlock();
> +
> +out:
> +	if (dst) {
>  		struct rt6_info *rt;
>  		rt = (struct rt6_info *)dst;
>  		SCTP_DEBUG_PRINTK("rt6_dst:%pI6 rt6_src:%pI6\n",
>  			&rt->rt6i_dst.addr, &rt->rt6i_src.addr);
>  		return dst;
> -	}
> -	SCTP_DEBUG_PRINTK("NO ROUTE\n");
> -	dst_release(dst);
> -	return NULL;
> +	} else 
> +		SCTP_DEBUG_PRINTK("NO ROUTE\n");
> +
> +	return dst;
>  }
>  
>  /* Returns the number of consecutive initial bits that match in the 2 ipv6
> @@ -289,13 +352,6 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
>  			      union sctp_addr *daddr,
>  			      union sctp_addr *saddr)
>  {
> -	struct sctp_bind_addr *bp;
> -	struct sctp_sockaddr_entry *laddr;
> -	sctp_scope_t scope;
> -	union sctp_addr *baddr = NULL;
> -	__u8 matchlen = 0;
> -	__u8 bmatchlen;
> -
>  	SCTP_DEBUG_PRINTK("%s: asoc:%p dst:%p daddr:%pI6 ",
>  			  __func__, asoc, dst, &daddr->v6.sin6_addr);
>  
> @@ -310,38 +366,9 @@ static void sctp_v6_get_saddr(struct sctp_sock *sk,
>  		return;
>  	}
>  
> -	scope = sctp_scope(daddr);
> -
> -	bp = &asoc->base.bind_addr;
> -
> -	/* Go through the bind address list and find the best source address
> -	 * that matches the scope of the destination address.
> -	 */
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(laddr, &bp->address_list, list) {
> -		if (!laddr->valid)
> -			continue;
> -		if ((laddr->state == SCTP_ADDR_SRC) &&
> -		    (laddr->a.sa.sa_family == AF_INET6) &&
> -		    (scope <= sctp_scope(&laddr->a))) {
> -			bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
> -			if (!baddr || (matchlen < bmatchlen)) {
> -				baddr = &laddr->a;
> -				matchlen = bmatchlen;
> -			}
> -		}
> -	}
> -
> -	if (baddr) {
> -		memcpy(saddr, baddr, sizeof(union sctp_addr));
> -		SCTP_DEBUG_PRINTK("saddr: %pI6\n", &saddr->v6.sin6_addr);
> -	} else {
> -		printk(KERN_ERR "%s: asoc:%p Could not find a valid source "
> -		       "address for the dest:%pI6\n",
> -		       __func__, asoc, &daddr->v6.sin6_addr);
> -	}
> +	if (dst)
> +		sctp_v6_dst_saddr(saddr, dst, htons(asoc->base.bind_addr.port));
>  
> -	rcu_read_unlock();
>  }
>  
>   

i open the sctp debug and and find that the using the source address to find the dst and dst source address does not have correct source address, it is always 0000:0000:0000:0000:0000:0000:0000:0000, i think this is maybe an ipv6 route bug, so if modify the code as yours, sctp can not work!

>  /* Make a copy of all potential local addresses. */
>   
based on the below consideration, i make a new patch for it! it can work 
in my environment!


-- 
Weixing.Shi(Stone)
BSP team
WIND RIVER | China Development Center
Tel: 86-10-8477-8502  |  Fax: 86-10-64790367
(M) : 86-13520312764


--------------010609000205020405050108
Content-Type: text/x-patch;
 name="0001-sctp-fix-sctp-to-work-with-ipv6-source-address-rout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-sctp-fix-sctp-to-work-with-ipv6-source-address-rout.pat";
 filename*1="ch"

From 300e10f7e4130829c49e5651b68bcf89f3b8b759 Mon Sep 17 00:00:00 2001
From: Weixing Shi <Weixing.Shi@windriver.com>
Date: Fri, 7 May 2010 16:32:30 +0800
Subject: [PATCH] sctp: fix sctp to work with ipv6 source address routing

in the below test case, using the source address routing,
sctp can not work.
Node-A
1)ifconfig eth0 inet6 add 2001:1::1/64
2)ip -6 rule add from 2001:1::1 table 100 pref 100
3)ip -6 route add 2001:2::1 dev eth0 table 100
4)sctp_darn -H 2001:1::1 -P 250 -l &
Node-B
1)ifconfig eth0 inet6 add 2001:2::1/64
2)ip -6 rule add from 2001:2::1 table 100 pref 100
3)ip -6 route add 2001:1::1 dev eth0 table 100
4)sctp_darn -H 2001:2::1 -P 250 -h 2001:1::1 -p 250 -s

root cause:
Node-A and Node-B use the source address routing, and
at begining, source address will be NULL,sctp will
search the  routing table by the destination address,
because using the source address routing table, and
the result dst_entry will be NULL.

solution:
walk through the bind address list to get the source
address and then lookup the routing table again to get
the correct dst_entry.

Signed-off-by: Weixing Shi <Weixing.Shi@windriver.com>
---
 net/sctp/ipv6.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 9fb5d37..03a2d8d 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -77,6 +77,8 @@
 #include <net/sctp/sctp.h>
 
 #include <asm/uaccess.h>
+static inline int sctp_v6_addr_match_len(union sctp_addr *s1,
+                                         union sctp_addr *s2);
 
 /* Event handler for inet6 address addition/deletion events.
  * The sctp_local_addr_list needs to be protocted by a spin lock since
@@ -242,8 +244,15 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
 					 union sctp_addr *daddr,
 					 union sctp_addr *saddr)
 {
-	struct dst_entry *dst;
+	struct dst_entry *dst = NULL;
 	struct flowi fl;
+	struct sctp_bind_addr *bp;
+	struct sctp_sockaddr_entry *laddr;
+	union sctp_addr dst_saddr;
+	union sctp_addr *baddr = NULL;
+	__u8 matchlen = 0;
+	__u8 bmatchlen;
+	sctp_scope_t scope;
 
 	memset(&fl, 0, sizeof(fl));
 	ipv6_addr_copy(&fl.fl6_dst, &daddr->v6.sin6_addr);
@@ -259,6 +268,39 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
 	}
 
 	dst = ip6_route_output(&init_net, NULL, &fl);
+	if (!asoc || saddr)
+		goto out;
+
+	if (dst->error) {
+		dst_release(dst);
+		dst = NULL;
+		bp = &asoc->base.bind_addr;
+		scope = sctp_scope(daddr);
+		/* Walk through the bind address list and try to get a dst that
+		 * matches a bind address as the source address.
+		*/
+		rcu_read_lock();
+		list_for_each_entry_rcu(laddr, &bp->address_list, list) {
+			if (!laddr->valid)
+				continue;
+			if ((laddr->state == SCTP_ADDR_SRC) &&
+			   (laddr->a.sa.sa_family == AF_INET6) &&
+			   (scope <= sctp_scope(&laddr->a))) {
+				bmatchlen = sctp_v6_addr_match_len(daddr, &laddr->a);
+				if (!baddr || (matchlen < bmatchlen)) {
+				baddr = &laddr->a;
+				matchlen = bmatchlen;
+				}
+			}
+		}
+		rcu_read_unlock();
+		if (baddr) {
+			ipv6_addr_copy(&fl.fl6_src, &baddr->v6.sin6_addr);
+			dst = ip6_route_output(&init_net, NULL, &fl);
+		}
+	}
+
+out:
 	if (!dst->error) {
 		struct rt6_info *rt;
 		rt = (struct rt6_info *)dst;
@@ -267,7 +309,8 @@ static struct dst_entry *sctp_v6_get_dst(struct sctp_association *asoc,
 		return dst;
 	}
 	SCTP_DEBUG_PRINTK("NO ROUTE\n");
-	dst_release(dst);
+	if (dst)
+		dst_release(dst);
 	return NULL;
 }
 
-- 
1.5.5.1


--------------010609000205020405050108--
