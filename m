From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 21 Aug 2020 20:07:04 +0000
Subject: Re: [PATCHv2 net] sctp: not disable bh in the whole sctp_get_port_local()
Message-Id: <20200821200704.GM3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
In-Reply-To: <08a14c2f087153c18c67965cc37ed2ac22da18ed.1597993178.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Neil Horman <nhorman@tuxdriver.com>

On Fri, Aug 21, 2020 at 02:59:38PM +0800, Xin Long wrote:
> With disabling bh in the whole sctp_get_port_local(), when
> snum = 0 and too many ports have been used, the do-while
> loop will take the cpu for a long time and cause cpu stuck:
> 
>   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
>   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
>   [ ] Call Trace:
>   [ ]  _raw_spin_lock+0xc1/0xd0
>   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
>   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
>   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
>   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
>   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> 
> There's no need to disable bh in the whole function of
> sctp_get_port_local. So fix this cpu stuck by removing
> local_bh_disable() called at the beginning, and using
> spin_lock_bh() instead.
> 
> The same thing was actually done for inet_csk_get_port() in
> Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> ports in bind()").
> 
> Thanks to Marcelo for pointing the buggy code out.
> 
> v1->v2:
>   - use cond_resched() to yield cpu to other tasks if needed,
>     as Eric noticed.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
