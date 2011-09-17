From: Max Matveev <makc@redhat.com>
Date: Sat, 17 Sep 2011 04:38:27 +0000
Subject: Re: [PATCH] sctp: deal with multiple COOKIE_ECHO chunks
Message-Id: <20084.9283.714998.398630@regina.usersys.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20110830072010.94AE98132707@regina.usersys.redhat.com>
	<20110916.171747.406895441960738806.davem@davemloft.net>
In-Reply-To: <20110916.171747.406895441960738806.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vladislav.yasevich@hp.com

On Fri, 16 Sep 2011 17:17:47 -0400 (EDT), David Miller wrote:

 davem> From: Max Matveev <makc@redhat.com>
 davem> Date: Tue, 30 Aug 2011 17:02:24 +1000

 >> Attempt to reduce the number of IP packets emitted in response to single
 >> SCTP packet (2e3216cd) introduced a complication - if a packet contains
 >> two COOKIE_ECHO chunks and nothing else then SCTP state machine corks the
 >> socket while processing first COOKIE_ECHO and then loses the association
 >> and forgets to uncork the socket. To deal with the issue add new SCTP
 >> command which can be used to set association explictly. Use this new
 >> command when processing second COOKIE_ECHO chunk to restore the context
 >> for SCTP state machine.
 >> 
 >> Signed-off-by: Max Matveev <makc@redhat.com>

 davem> Applied, but there were a ton of whitespace errors that GIT complained
 davem> about and I had to fix up.

Sorry about it - I did check it with checkpatch.pl and it was happy:
must've been the mailer.

max
