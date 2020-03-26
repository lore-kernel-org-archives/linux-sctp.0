From: Qiujun Huang <hqjagain@gmail.com>
Date: Thu, 26 Mar 2020 01:30:08 +0000
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200322090425.6253-1-hqjagain@gmail.com> <20200326001416.GH3756@localhost.localdomain>
In-Reply-To: <20200326001416.GH3756@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Thu, Mar 26, 2020 at 8:14 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> > sctp_sock_migrate should iterate over the datamsgs to modify
> > all trunks(skbs) to newsk. For this, out_msg_list is added to
>
> s/trunks/chunks/

My :p.

>
> > sctp_outq to maintain datamsgs list.
>
> It is an interesting approach. It speeds up the migration, yes, but it
> will also use more memory per datamsg, for an operation that, when
> performed, the socket is usually calm.
>
> It's also another list to be handled, and I'm not seeing the patch
> here move the datamsg itself now to the new outq. It would need
> something along these lines:

Are all the rx chunks in the rx queues?

> sctp_sock_migrate()
> {
> ...
>         /* Move any messages in the old socket's receive queue that are for the
>          * peeled off association to the new socket's receive queue.
>          */
>         sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
>                 event = sctp_skb2event(skb);
> ...
>                 /* Walk through the pd_lobby, looking for skbs that
>                  * need moved to the new socket.
>                  */
>                 sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
>                         event = sctp_skb2event(skb);
>
> That said, I don't think it's worth this new list.

About this case:
datamsg
                   ->chunk0                       chunk1
       chunk2
 queue          ->transmitted                 ->retransmit
 ->not in any queue

Also need to maintain a datamsg list to record which datamsg is
processed avoiding repetitive
processing.
So, list it to outq. Maybe it will be used sometime.

>
>   Marcelo
