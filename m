From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Mar 2020 00:14:16 +0000
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Message-Id: <20200326001416.GH3756@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200322090425.6253-1-hqjagain@gmail.com>
In-Reply-To: <20200322090425.6253-1-hqjagain@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiujun Huang <hqjagain@gmail.com>
Cc: davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anenbupt@gmail.com

On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> sctp_sock_migrate should iterate over the datamsgs to modify
> all trunks(skbs) to newsk. For this, out_msg_list is added to

s/trunks/chunks/

> sctp_outq to maintain datamsgs list.

It is an interesting approach. It speeds up the migration, yes, but it
will also use more memory per datamsg, for an operation that, when
performed, the socket is usually calm.

It's also another list to be handled, and I'm not seeing the patch
here move the datamsg itself now to the new outq. It would need
something along these lines:
sctp_sock_migrate()
{
...
        /* Move any messages in the old socket's receive queue that are for the
         * peeled off association to the new socket's receive queue.
         */
        sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
                event = sctp_skb2event(skb);
...
                /* Walk through the pd_lobby, looking for skbs that
                 * need moved to the new socket.
                 */
                sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
                        event = sctp_skb2event(skb);

That said, I don't think it's worth this new list.

  Marcelo
