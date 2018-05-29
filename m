From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 29 May 2018 18:02:57 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <20180529180257.GE3788@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <20180527010059.GA15798@neilslaptop.think-freely.org>
 <20180528194315.GB3788@localhost.localdomain>
 <20180529114111.GA24144@hmswarspite.think-freely.org>
 <559FFFDD-E508-4936-9544-CACE606AF40F@lurchi.franken.de>
 <20180529154514.GC3788@localhost.localdomain>
 <CADVnQymCNEtQFThsbQ0u7jirx24i45f5L7P-2dPf8omkshqwmg@mail.gmail.com>
 <20180529170604.GD3788@localhost.localdomain>
 <CADvbK_fbKbH2wm6Xurr+ELVag-LvyQdL+peJd=wp7OL7_zMZTQ@mail.gmail.com>
In-Reply-To: <CADvbK_fbKbH2wm6Xurr+ELVag-LvyQdL+peJd=wp7OL7_zMZTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xin Long <lucien.xin@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>, Michael Tuexen <michael.tuexen@lurchi.franken.de>, Neil Horman <nhorman@tuxdriver.com>, Dmitry Vyukov <dvyukov@google.com>, Netdev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, syzkaller <syzkaller@googlegroups.com>

On Wed, May 30, 2018 at 01:45:08AM +0800, Xin Long wrote:
> If we're counting on max_t to fix this CPU stuck. It should not that
> matter if min rto < the value causing that stuck.

Yes but putting a floor to rto_{min,max} now is to protect the rtx
timer now, not the heartbeat one.

> 
> >
> > Anyway, what about we add a floor to rto_max too, so that RTO can
> > actually grow into something bigger that don't hog the CPU? Like:
> > rto_min floor = 5ms
> > rto_max floor = 50ms
> >
> >   Marcelo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
