From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Thu, 26 Apr 2018 22:28:14 +0000
Subject: Re: [PATCH net-next 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <20180426222814.GA10301@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <1524508866-317485-1-git-send-email-obabin@virtuozzo.com>
 <20180423213314.GG3711@localhost.localdomain>
 <27adcf09-830d-48cb-34ab-aaabffa2b202@virtuozzo.com>
In-Reply-To: <27adcf09-830d-48cb-34ab-aaabffa2b202@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Babin <obabin@virtuozzo.com>
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Fri, Apr 27, 2018 at 01:14:56AM +0300, Oleg Babin wrote:
> Hi Marcelo,
>
> On 04/24/2018 12:33 AM, Marcelo Ricardo Leitner wrote:
> > Hi,
> >
> > On Mon, Apr 23, 2018 at 09:41:04PM +0300, Oleg Babin wrote:
> >> Each SCTP association can have up to 65535 input and output streams.
> >> For each stream type an array of sctp_stream_in or sctp_stream_out
> >> structures is allocated using kmalloc_array() function. This function
> >> allocates physically contiguous memory regions, so this can lead
> >> to allocation of memory regions of very high order, i.e.:
> >>
> >>   sizeof(struct sctp_stream_out) = 24,
> >>   ((65535 * 24) / 4096) = 383 memory pages (4096 byte per page),
> >>   which means 9th memory order.
> >>
> >> This can lead to a memory allocation failures on the systems
> >> under a memory stress.
> >
> > Did you do performance tests while actually using these 65k streams
> > and with 256 (so it gets 2 pages)?
> >
> > This will introduce another deref on each access to an element, but
> > I'm not expecting any impact due to it.
> >
>
> No, I didn't do such tests. Could you please tell me what methodology
> do you usually use to measure performance properly?
>
> I'm trying to do measurements with iperf3 on unmodified kernel and get
> very strange results like this:
...

I've been trying to fight this fluctuation for some time now but
couldn't really fix it yet. One thing that usually helps (quite a lot)
is increasing the socket buffer sizes and/or using smaller messages,
so there is more cushion in the buffers.

What I have seen in my tests is that when it floats like this, is
because socket buffers floats between 0 and full and don't get into a
steady state. I believe this is because of socket buffer size is used
for limiting the amount of memory used by the socket, instead of being
the amount of payload that the buffer can hold. This causes some
discrepancy, especially because in SCTP we don't defrag the buffer (as
TCP does, it's the collapse operation), and the announced rwnd may
turn up being a lie in the end, which triggers rx drops, then tx cwnd
reduction, and so on. SCTP min_rto of 1s also doesn't help much on
this situation.

On netperf, you may use -S 200000,200000 -s 200000,200000. That should
help it.

Cheers,
Marcelo
