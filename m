From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 28 May 2018 18:56:40 +0000
Subject: Re: [PATCH net] sctp: not allow to set rto_min with a value below 200 msecs
Message-Id: <20180528185640.GA3788@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <dc48b7c6a6dd1d8f19215cea6713d5723779d564.1527270062.git.lucien.xin@gmail.com>
 <20180525191319.GB392@hmswarspite.think-freely.org>
 <71FD541D-25FE-4100-980B-C3A0CEAF6CD4@lurchi.franken.de>
 <CACT4Y+YozRSfcoUoKHOWy5wujhVdks38vcfNGhwNj-REWcd-hw@mail.gmail.com>
 <D8455431-D0D7-4420-BEBF-E0B5BE5DBC97@lurchi.franken.de>
In-Reply-To: <D8455431-D0D7-4420-BEBF-E0B5BE5DBC97@lurchi.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Tuexen <michael.tuexen@lurchi.franken.de>
Cc: Dmitry Vyukov <dvyukov@google.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>, David Ahern <dsa@cumulusnetworks.com>, Eric Dumazet <edumazet@google.com>, syzkaller <syzkaller@googlegroups.com>

On Sun, May 27, 2018 at 10:58:35AM +0200, Michael Tuexen wrote:
...
> >>> Patch looks fine, you probably want to note this hard minimum in man(7) sctp as
> >>> well
> >>> 
> >> I'm aware of some signalling networks which use RTO.min of smaller values than 200ms.
> >> So could this be reduced?
> > 
> > Hi Michael,
> > 
> > What value do they use?
> I have seen values of
> RTO.Min     =  50ms
> RTO.Max     = 200ms
> RTO.Initial = 100ms

Those look doable to me.

Thanks,
Marcelo
