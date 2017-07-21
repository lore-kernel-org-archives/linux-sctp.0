From: fblistes@free.fr
Date: Fri, 21 Jul 2017 14:39:09 +0000
Subject: Re: help about a lockup in sctp module
Message-Id: <b37fec97cf5a1ba906948392cbae36ae@free.fr>
List-Id: <linux-sctp.vger.kernel.org>
References: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
In-Reply-To: <AM4PR0202MB28024E8574F1D64AA9B8F0F4B2A00@AM4PR0202MB2802.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-sctp@vger.kernel.org

     Hello,

We have gone forward analyzing a crash dump we have (but haven't yet be 
able to reproduce the problem on a test platform).

This problem occurs on a global network failure, whereas the local 
system has [at least] one active association :
it has only one local IP address, but the peer has 2 IP addresses 
(published through SCTP association), one selected as primary, is 
unreachable from our server, the other one is reachable (unless the 
network failure occurs).

The Linux kernel is running infinite loop in 
sctp_assoc_update_retran_path() function, called from a rto timeout.

The assocation is in SCTP_STATE_SHUTDOWN_SENT state, and we can see its 
2 peers :
   - the reachable peer is in state=1 (SCTP_PF)
   - the primary (and unreachable) peer is in state=3 SCTP_UNCONFIRMED

We can observe in the sctp_association structure than :
- the active_path is pointing to reachable peer
- the retran_path is pointing to unreachable peer.

 From these data, the main loop in sctp_assoc_update_retran_path() can't
actually finish, because the 2 possibles exits are :
- one peer is in SCTP_ACTIVE state (nope here)
- the current checked peer is the retran_path : can't be true, as the 
retran_path is in SCTP_UNCONFIRMED, so the loop has been 'continued' 
before coming to this second test !

We suppose that the problem could come from 
sctp_select_active_and_retran_path() function, where in 3.16 Debian 's 
kernel version (3.16.39-1+deb8u2), the retran_path could be set to 
primary peer even if it's in SCTP_UNCONFIRMED state :

static void sctp_select_active_and_retran_path(struct sctp_association 
*asoc)
{
	struct sctp_transport *trans, *trans_pri = NULL, *trans_sec = NULL;
	struct sctp_transport *trans_pf = NULL;

         ...


	/* If we failed to find a usable transport, just camp on the
	 * primary or retran, even if they are inactive, if possible
	 * pick a PF iff it's the better choice.
	 */
	if (trans_pri = NULL) {
		trans_pri = sctp_trans_elect_best(asoc->peer.primary_path,
						  asoc->peer.retran_path);
		trans_pri = sctp_trans_elect_best(trans_pri, trans_pf);
		trans_sec = asoc->peer.primary_path;
	}

	/* Set the active and retran transports. */
	asoc->peer.active_path = trans_pri;
	asoc->peer.retran_path = trans_sec;       <-   retran_path gets the 
Primary path
}

We saw that in Linux git's commit 
aa4a83ee8bbc08342c4acfd59ef234cac51a1eef, this algorithm was changed, 
not selecting PRIMARY path anymore :
could this patch fix our problem ?

     with regards,
         Fred Boiteux.

