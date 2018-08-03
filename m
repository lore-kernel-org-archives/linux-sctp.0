From: Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
Date: Fri, 03 Aug 2018 20:56:56 +0000
Subject: Re: [PATCH v2 0/2] net/sctp: Avoid allocating high order memory with kmalloc()
Message-Id: <2D7531CF-9E0A-4B33-83E5-724B7C88F363@lurchi.franken.de>
List-Id: <linux-sctp.vger.kernel.org>
References: <20180724173647.GA8881@localhost.localdomain>
 <20180803162102.19540-1-khorenko@virtuozzo.com>
 <cd32848f0018432fad7246620d32c4e5@AcuMS.aculab.com>
 <20180803203009.GG5482@localhost.localdomain>
In-Reply-To: <20180803203009.GG5482@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: David Laight <David.Laight@aculab.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, "oleg.babin@gmail.com" <oleg.babin@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>



> On 3. Aug 2018, at 22:30, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> 
> On Fri, Aug 03, 2018 at 04:43:28PM +0000, David Laight wrote:
>> From: Konstantin Khorenko
>>> Sent: 03 August 2018 17:21
>>> 
>>> Each SCTP association can have up to 65535 input and output streams.
>>> For each stream type an array of sctp_stream_in or sctp_stream_out
>>> structures is allocated using kmalloc_array() function. This function
>>> allocates physically contiguous memory regions, so this can lead
>>> to allocation of memory regions of very high order, i.e.:
>> ...
>> 
>> Given how useless SCTP streams are, does anything actually use
>> more than about 4?
> 
> Maybe Michael can help us with that. I'm also curious now.
In the context of SIGTRAN I have seen 17 streams...

In the context of WebRTC I have seen more streams. In general,
the streams concept seems to be useful. QUIC has lots of streams.

So I'm wondering why they are considered useless.
David, can you elaborate on this?

Best regards
Michael
> 
>  Marcelo

