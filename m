From: David Miller <davem@davemloft.net>
Date: Thu, 18 Oct 2018 05:12:12 +0000
Subject: Re: [PATCH net] sctp: fix race on sctp_id2asoc
Message-Id: <20181017.221212.2290996875910546663.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <081e1546a92f5bde8bdef0366561ff0b8ddd9eb2.1539707812.git.mleitner@redhat.com>
In-Reply-To: <081e1546a92f5bde8bdef0366561ff0b8ddd9eb2.1539707812.git.mleitner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, dvyukov@google.com

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 16 Oct 2018 15:18:17 -0300

> syzbot reported an use-after-free involving sctp_id2asoc.  Dmitry Vyukov
> helped to root cause it and it is because of reading the asoc after it
> was freed:
> 
>         CPU 1                       CPU 2
> (working on socket 1)            (working on socket 2)
> 	                         sctp_association_destroy
> sctp_id2asoc
>    spin lock
>      grab the asoc from idr
>    spin unlock
>                                    spin lock
> 				     remove asoc from idr
> 				   spin unlock
> 				   free(asoc)
>    if asoc->base.sk != sk ... [*]
> 
> This can only be hit if trying to fetch asocs from different sockets. As
> we have a single IDR for all asocs, in all SCTP sockets, their id is
> unique on the system. An application can try to send stuff on an id
> that matches on another socket, and the if in [*] will protect from such
> usage. But it didn't consider that as that asoc may belong to another
> socket, it may be freed in parallel (read: under another socket lock).
> 
> We fix it by moving the checks in [*] into the protected region. This
> fixes it because the asoc cannot be freed while the lock is held.
> 
> Reported-by: syzbot+c7dd55d7aec49d48e49a@syzkaller.appspotmail.com
> Acked-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Applied and queued up for -stable.
