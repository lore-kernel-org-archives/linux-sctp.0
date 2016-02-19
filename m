From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 19 Feb 2016 10:28:50 +0000
Subject: Re: [PATCHv2] sctp: Fix port hash table size computation
Message-Id: <1455877730.648.21.camel@edumazet-ThinkPad-T530>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160218.153921.2010668846576353053.davem@davemloft.net>
	 <1455829857-15797-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1455829857-15797-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Vladislav Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>

On jeu., 2016-02-18 at 16:10 -0500, Neil Horman wrote:
> Dmitry Vyukov noted recently that the sctp_port_hashtable had an error in
> its size computation, observing that the current method never guaranteed
> that the hashsize (measured in number of entries) would be a power of two,
> which the input hash function for that table requires.  The root cause of
> the problem is that two values need to be computed (one, the allocation
> order of the storage requries, as passed to __get_free_pages, and two the
> number of entries for the hash table).  Both need to be ^2, but for
> different reasons, and the existing code is simply computing one order
> value, and using it as the basis for both, which is wrong (i.e. it assumes
> that ((1<<order)*PAGE_SIZE)/sizeof(bucket) is still ^2 when its not).

Looks complicated for a stable submission.

What about reusing existing trick instead ?


diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ab0d538..3e4e11b 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1434,6 +1434,10 @@ static __init int sctp_init(void)
 	do {
 		sctp_port_hashsize = (1UL << order) * PAGE_SIZE /
 					sizeof(struct sctp_bind_hashbucket);
+
+		while (sctp_port_hashsize & (sctp_port_hashsize - 1))
+			sctp_port_hashsize--;
+
 	if ((sctp_port_hashsize > (64 * 1024)) && order > 0)
 		continue;
 	sctp_port_hashtable = (struct sctp_bind_hashbucket *)


