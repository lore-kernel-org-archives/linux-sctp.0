From: David Miller <davem@davemloft.net>
Date: Thu, 15 Jun 2017 18:41:04 +0000
Subject: Re: [PATCH net] sctp: return next obj by passing pos + 1 into sctp_transport_get_idx
Message-Id: <20170615.144104.2153172737322445562.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <a129be6693b882bac11ace44d659ceb1c1cc4f79.1497520148.git.lucien.xin@gmail.com>
In-Reply-To: <a129be6693b882bac11ace44d659ceb1c1cc4f79.1497520148.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 15 Jun 2017 17:49:08 +0800

> In sctp_for_each_transport, pos is used to save how many objs it has
> dumped. Now it gets the last obj by sctp_transport_get_idx, then gets
> the next obj by sctp_transport_get_next.
> 
> The issue is that in the meanwhile if some objs in transport hashtable
> are removed and the objs nums are less than pos, sctp_transport_get_idx
> would return NULL and hti.walker.tbl is NULL as well. At this moment
> it should stop hti, instead of continue getting the next obj. Or it
> would cause a NULL pointer dereference in sctp_transport_get_next.
> 
> This patch is to pass pos + 1 into sctp_transport_get_idx to get the
> next obj directly, even if pos > objs nums, it would return NULL and
> stop hti.
> 
> Fixes: 626d16f50f39 ("sctp: export some apis or variables for sctp_diag and reuse some for proc")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
