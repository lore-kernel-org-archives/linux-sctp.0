From: David Miller <davem@davemloft.net>
Date: Sat, 17 Dec 2016 16:25:12 +0000
Subject: Re: [PATCH net] sctp: sctp_epaddr_lookup_transport should be protected by rcu_read_lock
Message-Id: <20161217.112512.1659218665787719927.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <eb70a1f54c102c728a5572f1aa2842940fc3f5a5.1481814055.git.lucien.xin@gmail.com>
In-Reply-To: <eb70a1f54c102c728a5572f1aa2842940fc3f5a5.1481814055.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, dvyukov@google.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 15 Dec 2016 23:00:55 +0800

> Since commit 7fda702f9315 ("sctp: use new rhlist interface on sctp transport
> rhashtable"), sctp has changed to use rhlist_lookup to look up transport, but
> rhlist_lookup doesn't call rcu_read_lock inside, unlike rhashtable_lookup_fast.
> 
> It is called in sctp_epaddr_lookup_transport and sctp_addrs_lookup_transport.
> sctp_addrs_lookup_transport is always in the protection of rcu_read_lock(),
> as __sctp_lookup_association is called in rx path or sctp_lookup_association
> which are in the protection of rcu_read_lock() already.
> 
> But sctp_epaddr_lookup_transport is called by sctp_endpoint_lookup_assoc, it
> doesn't call rcu_read_lock, which may cause "suspicious rcu_dereference_check
> usage' in __rhashtable_lookup.
> 
> This patch is to fix it by adding rcu_read_lock in sctp_endpoint_lookup_assoc
> before calling sctp_epaddr_lookup_transport.
> 
> Fixes: 7fda702f9315 ("sctp: use new rhlist interface on sctp transport rhashtable")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
