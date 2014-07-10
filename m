From: David Miller <davem@davemloft.net>
Date: Thu, 10 Jul 2014 23:14:27 +0000
Subject: Re: [PATCH v2 net-next 0/3] net: sctp: Add partial MSG_MORE support to SCTP
Message-Id: <20140710.161427.343089945230334314.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1726E6A3@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726E6A3@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com

From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 9 Jul 2014 08:29:11 +0000

> If an application has disabled Nagle then it is almost impossible
> to get more than one DATA chunk into an ethernet packet even if
> the application has more than one data chunk ready to transmit.
> 
> This could be fixed by adding an SCTP_CORK socket option - but
> using that requires a lot of system calls.
> An alternative is to honour MSG_MORE - using it to mean that
> another chunk will be sent soon.
> (There isn't much point using MSG_MORE to allow a chunk be extended,
> sendv() can be used for fragmented data.)
> 
> This is a partial implementation and takes a couple of shortcuts:
> 1) We only worry about whether MSG_MORE was set on the last send.
>    Data sent (by the application) with MSG_MORE unset will only be
>    unsent for flow control reasons.
>    So if the last send had MSG_MORE set, and an ack opens the window
>    then the unsent data won't be sent immediately.
> 
> 2) If the application doesn't do a send with MSG_MORE unset, then
>    buffered data shouldn't be buffered forever.
>    Rather than using a timer (as TCP does - which ought to be configurable
>    on a per-socket basis) we use the same rules as Nagle and ensure
>    that there is always some data outstanding.
>    This does mean that the first data chunk on an idle connection
>    is send in its own packet even if MSG_MORE is set.

I need some SCTP experts to review this series, thanks.
