From: David Miller <davem@davemloft.net>
Date: Fri, 09 Aug 2013 20:37:20 +0000
Subject: Re: [PATCH net-next] net: sctp: sctp_set_owner_w: fix panic during skb orphaning
Message-Id: <20130809.133720.232424253997869104.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1375872121-12429-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1375872121-12429-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Wed,  7 Aug 2013 12:42:01 +0200

> This patch fixes the following triggered bug ...
 ...
> ... that is triggered after commit 376c7311b ("net: add a temporary sanity
> check in skb_orphan()"). What is happening is that we call sctp_set_owner_w()
> for chunks in the SCTP output path from sctp_sendmsg(). Such chunks eventually
> origin from constructors like sctp_make_chunk() where skb->sk = sk is being
> set for socket accounting. Doing a git grep -n "skb->sk" net/sctp/ shows that
> also in other places the socket pointer is being set, before issuing a
> SCTP_CMD_SEND_PKT command and the like. Since SCTP is doing it's own memory
> accounting anyway and has its own skb destructor functions, we should
> customize sctp_set_owner_w() and call skb_orphan() if we set a different
> owner of the skb than the current one in order to properly call their
> destructor function, but not run into a panic due to our non-exisiting one as
> we set sctp_wfree() destructor right after that. Otherwise, we can just skip
> orphaning and reassignment to the very same socket and only set the destructor
> handler.

This debugging check is exactly trying to catch what SCTP is doing,
setting skb->sk without also setting the destructor.

I would much rather see you reorganize and fix SCTP to behave properly
rather than coding up a check which is essentially "if skb_orphan() bug
won't trigger, call it"  That defeats the whole purpose of the check.

Thanks.
