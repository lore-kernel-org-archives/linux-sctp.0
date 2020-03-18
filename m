From: Qiujun Huang <hqjagain@gmail.com>
Date: Wed, 18 Mar 2020 02:45:51 +0000
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
In-Reply-To: <20200317173039.GA3828@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Wed, Mar 18, 2020 at 1:30 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Hi,
>
> On Tue, Mar 17, 2020 at 11:55:36PM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk:
> >
> > migrate routing        sctp_check_transmitted routing
> > ------------                    ---------------
>                                  sctp_close();
>                                    lock_sock(sk2);
>                                  sctp_primitive_ABORT();
>                                  sctp_do_sm();
>                                  sctp_cmd_interpreter();
>                                  sctp_cmd_process_sack();
>                                  sctp_outq_sack();
>                                  sctp_check_transmitted();
>
>   lock_sock(sk1);
>   sctp_getsockopt_peeloff();
>   sctp_do_peeloff();
>   sctp_sock_migrate();
> > lock_sock_nested(sk2);
> >                                mv the transmitted skb to
> >                                the it's local tlist
>
>
> How can sctp_do_sm() be called in the 2nd column so that it bypasses
> the locks in the left column, allowing this mv to happen?
>
> >
> > sctp_for_each_tx_datachunk(
> > sctp_clear_owner_w);
> > sctp_assoc_migrate();
> > sctp_for_each_tx_datachunk(
> > sctp_set_owner_w);
> >
> >                                put the skb back to the
> >                                assoc lists
> > ----------------------------------------------------
> >
> > The skbs which held bysctp_check_transmitted were not changed
> > to newsk. They were not dealt with by sctp_for_each_tx_datachunk
> > (sctp_clear_owner_w/sctp_set_owner_w).
>
> It would make sense but I'm missing one step earlier, I'm not seeing
> how the move to local list is allowed/possible in there. It really
> shouldn't be possible.

I totally agree that.
My mistake. So I added some log in my test showing the case:
The backtrace:
sctp_close
sctp_primitive_ABORT
sctp_do_sm
sctp_association_free
__sctp_outq_teardown
     /* Throw away unacknowledged chunks. */
    list_for_each_entry(transport, &q->asoc->peer.transport_addr_list,
    transports) {
    printk("[%d]deal with transmitted %#llx from transport %#llx  %s,
%d\n", raw_smp_processor_id(),
   &transport->transmitted, transport, __func__, __LINE__);
   while ((lchunk = sctp_list_dequeue(&transport->transmitted)) != NULL) {

The trouble skb is from another peer sk in the same asoc, but
accounted to the base.sk.
