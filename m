From: Qiujun Huang <hqjagain@gmail.com>
Date: Fri, 20 Mar 2020 23:53:29 +0000
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
Message-Id: <CAJRQjoc-U_K-2THbmBOj2TOWDTfP9yr5Vec-WjhTjS8sj19fHA@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200320110959.2114-1-hqjagain@gmail.com> <20200320185204.GB3828@localhost.localdomain>
In-Reply-To: <20200320185204.GB3828@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com, nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com

On Sat, Mar 21, 2020 at 2:52 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Mar 20, 2020 at 07:09:59PM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk:
> >
> > for the trouble SKB, it was in outq->transmitted queue
> >
> > sctp_outq_sack
> >       sctp_check_transmitted
> >               SKB was moved to outq->sack
>
> There is no outq->sack. You mean outq->sacked, I assume.
>
> >       then throw away the sack queue
>
> Where? How?
> If you mean:
>         /* Throw away stuff rotting on the sack queue.  */
>         list_for_each_safe(lchunk, temp, &q->sacked) {
>                 tchunk = list_entry(lchunk, struct sctp_chunk,
>                                     transmitted_list);
>                 tsn = ntohl(tchunk->subh.data_hdr->tsn);
>                 if (TSN_lte(tsn, ctsn)) {
>                         list_del_init(&tchunk->transmitted_list);
>                         if (asoc->peer.prsctp_capable &&
>                             SCTP_PR_PRIO_ENABLED(chunk->sinfo.sinfo_flags))
>                                 asoc->sent_cnt_removable--;
>                         sctp_chunk_free(tchunk);
>
> Then sctp_chunk_free is supposed to free the datamsg as well for
> chunks that were cumulative-sacked.
> For those not cumulative-sacked, sctp_for_each_tx_datachunk() will
> handle q->sacked queue as well:
>         list_for_each_entry(chunk, &q->sacked, transmitted_list)
>                 cb(chunk);
>
> So I don't see how skbs can be overlooked here.
>
> >               SKB was deleted from outq->sack
> > (but the datamsg held SKB at sctp_datamsg_to_asoc
>
> You mean sctp_datamsg_from_user ? If so, isn't it the other way
> around? sctp_datamsg_assign() will hold the datamsg, not the skb.
>
> > So, sctp_wfree was not called to destroy SKB)
> >
> > then migrate happened
> >
> >       sctp_for_each_tx_datachunk(
> >       sctp_clear_owner_w);
> >       sctp_assoc_migrate();
> >       sctp_for_each_tx_datachunk(
> >       sctp_set_owner_w);
> > SKB was not in the outq, and was not changed to newsk
>
> The real fix is to fix the migration to the new socket, though the
> situation on which it is happening is still not clear.
>
> The 2nd sendto() call on the reproducer is sending 212992 bytes on a
> single call. That's usually the whole sndbuf size, and will cause
> fragmentation to happen. That means the datamsg will contain several
> skbs. But still, the sacked chunks should be freed if needed while the
> remaining ones will be left on the queues that they are.

in sctp_sendmsg_to_asoc
datamsg holds his chunk result in that the sacked chunks can't be freed

list_for_each_entry(chunk, &datamsg->chunks, frag_list) {
sctp_chunk_hold(chunk);
sctp_set_owner_w(chunk);
chunk->transport = transport;
}

any ideas to handle it?

>
> Thanks,
> Marcelo
