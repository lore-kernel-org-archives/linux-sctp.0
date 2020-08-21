From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 21 Aug 2020 06:57:25 +0000
Subject: Re: [PATCH net] sctp: not disable bh in the whole sctp_get_port_local()
Message-Id: <CADvbK_eej9URRLMrN=nLTAdcmaHJAmT+69-Ghk7i8JLcSmzENg@mail.gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <b3da88b999373d2518ac52a9e1d0fcb935109ea8.1597906119.git.lucien.xin@gmail.com>
 <661ff148-627d-3b1f-f450-015dafefd137@gmail.com>
In-Reply-To: <661ff148-627d-3b1f-f450-015dafefd137@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Neil Horman <nhorman@tuxdriver.com>

On Thu, Aug 20, 2020 at 9:13 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 8/19/20 11:48 PM, Xin Long wrote:
> > With disabling bh in the whole sctp_get_port_local(), when
> > snum = 0 and too many ports have been used, the do-while
> > loop will take the cpu for a long time and cause cpu stuck:
> >
> >   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
> >   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
> >   [ ] Call Trace:
> >   [ ]  _raw_spin_lock+0xc1/0xd0
> >   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
> >   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
> >   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
> >   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
> >   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> >
> > There's no need to disable bh in the whole function of
> > sctp_get_port_local. So fix this cpu stuck by removing
> > local_bh_disable() called at the beginning, and using
> > spin_lock_bh() instead.
> >
> > The same thing was actually done for inet_csk_get_port() in
> > Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> > ports in bind()").
> >
> > Thanks to Marcelo for pointing the buggy code out.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
>
>
> Any reason you chose to not use a cond_resched() then ?
>
> Clearly this function needs to yield, not only BH, but to other threads.
>
Right, it explains why the cpu stuck is gone, but sctp_get_port_local()
still use the cpu quite a lot:


Thanks, will post v2.
