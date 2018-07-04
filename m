From: David Miller <davem@davemloft.net>
Date: Wed, 04 Jul 2018 12:38:42 +0000
Subject: Re: [PATCHv2 net] sctp: fix the issue that pathmtu may be set lower than MINSEGMENT
Message-Id: <20180704.213842.1687330861488453118.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <0ebc621b57952699c67c558dde3ce61b784e3f74.1530606647.git.lucien.xin@gmail.com>
In-Reply-To: <0ebc621b57952699c67c558dde3ce61b784e3f74.1530606647.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  3 Jul 2018 16:30:47 +0800

> After commit b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed
> for too small MTUs"), sctp_transport_update_pmtu would refetch pathmtu
> from the dst and set it to transport's pathmtu without any check.
> 
> The new pathmtu may be lower than MINSEGMENT if the dst is obsolete and
> updated by .get_dst() in sctp_transport_update_pmtu. In this case, it
> could have a smaller MTU as well, and thus we should validate it
> against MINSEGMENT instead.
> 
> Syzbot reported a warning in sctp_mtu_payload caused by this.
> 
> This patch refetches the pathmtu by calling sctp_dst_mtu where it does
> the check against MINSEGMENT.
> 
> v1->v2:
>   - refetch the pathmtu by calling sctp_dst_mtu instead as Marcelo's
>     suggestion.
> 
> Fixes: b6c5734db070 ("sctp: fix the handling of ICMP Frag Needed for too small MTUs")
> Reported-by: syzbot+f0d9d7cba052f9344b03@syzkaller.appspotmail.com
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
