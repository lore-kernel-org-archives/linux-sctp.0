From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 25 Feb 2013 07:40:20 +0000
Subject: re: sctp: Add ASCONF operation on the single-homed host
Message-Id: <20130225074018.GA31806@longonot.mountain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110608065302.GF3846@shale.localdomain>
In-Reply-To: <20110608065302.GF3846@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

[ This warning is old but I haven't sent it before.  I guess back
  in the day we didn't do cross function analysis. ]

Hello Michio Honda,

This is a semi-automatic email about new static checker warnings.

The patch 8a07eb0a50ae: "sctp: Add ASCONF operation on the 
single-homed host" from Apr 26, 2011, leads to the following Smatch 
complaint:

net/sctp/socket.c:827 sctp_send_asconf_del_ip()
	 error: we previously assumed 'laddr' could be null (see line 791)

net/sctp/socket.c
   790						       addrcnt, sp);
   791			if ((laddr = NULL) && (addrcnt = 1)) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If laddr is NULL and addrcnt is 2 then it will lead to a NULL
dereference.

   792				if (asoc->asconf_addr_del_pending)
   793					continue;
   794				asoc->asconf_addr_del_pending    795				    kzalloc(sizeof(union sctp_addr), GFP_ATOMIC);
   796				if (asoc->asconf_addr_del_pending = NULL) {
   797					retval = -ENOMEM;
   798					goto out;
   799				}
   800				asoc->asconf_addr_del_pending->sa.sa_family    801					    addrs->sa_family;
   802				asoc->asconf_addr_del_pending->v4.sin_port    803					    htons(bp->port);
   804				if (addrs->sa_family = AF_INET) {
   805					struct sockaddr_in *sin;
   806	
   807					sin = (struct sockaddr_in *)addrs;
   808					asoc->asconf_addr_del_pending->v4.sin_addr.s_addr = sin->sin_addr.s_addr;
   809				} else if (addrs->sa_family = AF_INET6) {
   810					struct sockaddr_in6 *sin6;
   811	
   812					sin6 = (struct sockaddr_in6 *)addrs;
   813					asoc->asconf_addr_del_pending->v6.sin6_addr = sin6->sin6_addr;
   814				}
   815				SCTP_DEBUG_PRINTK_IPADDR("send_asconf_del_ip: keep the last address asoc: %p ",
   816				    " at %p\n", asoc, asoc->asconf_addr_del_pending,
   817				    asoc->asconf_addr_del_pending);
   818				asoc->src_out_of_asoc_ok = 1;
   819				stored = 1;
   820				goto skip_mkasconf;
   821			}
   822	
   823			/* We do not need RCU protection throughout this loop
   824			 * because this is done under a socket lock from the
   825			 * setsockopt call.
   826			 */
   827			chunk = sctp_make_asconf_update_ip(asoc, laddr, addrs, addrcnt,
                                                                 ^^^^^
Null dereference here.

   828							   SCTP_PARAM_DEL_IP);
   829			if (!chunk) {

regards,
dan carpenter
