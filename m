From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 02 Oct 2019 01:03:56 +0000
Subject: Re: [PATCH net] sctp: set newsk sk_socket before processing listening sk backlog
Message-Id: <20191002010356.GG3499@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
In-Reply-To: <acd60f4797143dc6e9817b3dce38e1408caf65e5.1569849018.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>

On Mon, Sep 30, 2019 at 09:10:18PM +0800, Xin Long wrote:
> This patch is to fix a NULL-ptr deref crash in selinux_sctp_bind_connect:
> 
>   [...] kasan: GPF could be caused by NULL-ptr deref or user memory access
>   [...] RIP: 0010:selinux_sctp_bind_connect+0x16a/0x230
>   [...] Call Trace:
>   [...]  security_sctp_bind_connect+0x58/0x90
>   [...]  sctp_process_asconf+0xa52/0xfd0 [sctp]
>   [...]  sctp_sf_do_asconf+0x782/0x980 [sctp]
>   [...]  sctp_do_sm+0x139/0x520 [sctp]
>   [...]  sctp_assoc_bh_rcv+0x284/0x5c0 [sctp]
>   [...]  sctp_backlog_rcv+0x45f/0x880 [sctp]
>   [...]  __release_sock+0x120/0x370
>   [...]  release_sock+0x4f/0x180
>   [...]  sctp_accept+0x3f9/0x5a0 [sctp]
>   [...]  inet_accept+0xe7/0x6f0
> 
> It was caused by that the 'newsk' sk_socket was not set before going to
> security sctp hook when doing accept() on a tcp-type socket:
> 
>   inet_accept()->
>     sctp_accept():
>       lock_sock():
>           lock listening 'sk'
>                                           do_softirq():
>                                             sctp_rcv():  <-- [1]
>                                                 asconf chunk arrived and
>                                                 enqueued in 'sk' backlog
>       sctp_sock_migrate():
>           set asoc's sk to 'newsk'
>       release_sock():
>           sctp_backlog_rcv():
>             lock 'newsk'
>             sctp_process_asconf()  <-- [2]
>             unlock 'newsk'
>     sock_graft():
>         set sk_socket  <-- [3]
> 
> As it shows, at [1] the asconf chunk would be put into the listening 'sk'
> backlog, as accept() was holding its sock lock. Then at [2] asconf would
> get processed with 'newsk' as asoc's sk had been set to 'newsk'. However,
> 'newsk' sk_socket is not set until [3], while selinux_sctp_bind_connect()
> would deref it, then kernel crashed.

Note that sctp will migrate such incoming chunks from sk to newsk in
sctp_rcv() if they arrived after the mass-migration performed at
sctp_sock_migrate().

That said, did you explore changing inet_accept() so that
sk1->sk_prot->accept() would return sk2 still/already locked?
That would be enough to block [2] from happening as then it would be
queued on newsk backlog this time and avoid nearly duplicating
inet_accept(). (too bad for this chunk, hit 2 backlogs..)

AFAICT TCP code would be fine with such change. Didn't check other
protocols.
