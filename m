From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 05 Jan 2009 23:05:21 +0000
Subject: Re: BUG in sctp crashes sles10sp2 kernel
Message-Id: <49629231.4030200@hp.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------050903040807060309060507"
List-Id: <linux-sctp.vger.kernel.org>
References: <20081211145209.GB5236@dhcp35.suse.cz>
In-Reply-To: <20081211145209.GB5236@dhcp35.suse.cz>
To: linux-sctp@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903040807060309060507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Karsten, Michal

I think I found this cursed race.

The problem is that nothing is guarding the asoc->base.sk reference.  This
reference changes during the accept()/peeloff() code paths and the only
guard around it is the socket lock.  But that lock is not taken when
the reference is used for reading as it is done in sctp_rcv().

So, when we do sctp_bh_lock_sock(sk) in sctp_rcv(), we may be using
a stale cached copy of the sk which might have changed during sctp_accept().

What this allows us to do is to have a user sending a packet on a socket
at the same time we may be processing and incoming packet on the same socket.
We just end up taking different locks which totally hoses us.

-vlad



--------------050903040807060309060507
Content-Type: text/x-diff;
 name="race_test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="race_test.patch"

diff --git a/net/sctp/input.c b/net/sctp/input.c
index bf612d9..2e4a864 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -249,6 +249,19 @@ int sctp_rcv(struct sk_buff *skb)
 	 */
 	sctp_bh_lock_sock(sk);
 
+	if (sk != rcvr->sk) {
+		/* Our cached sk is different from the rcvr->sk.  This is
+		 * because migrate()/accept() may have moved the association
+		 * to a new socket and released all the sockets.  So now we
+		 * are holding a lock on the old socket while the user may
+		 * be doing something with the new socket.  Switch our veiw
+		 * of the current sk.
+		 */
+		sctp_bh_unlock_sock(sk);
+		sk = rcvr->sk;
+		sctp_bh_lock_sock(sk);
+	}
+
 	if (sock_owned_by_user(sk)) {
 		SCTP_INC_STATS_BH(SCTP_MIB_IN_PKT_BACKLOG);
 		sctp_add_backlog(sk, skb);

--------------050903040807060309060507--
