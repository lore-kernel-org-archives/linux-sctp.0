From: David Miller <davem@davemloft.net>
Date: Mon, 21 Apr 2008 21:38:30 +0000
Subject: Re: [Lksctp-developers] Is this a possible race condition.
Message-Id: <20080421.143830.159427055.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <480CB247.1090902@hp.com>
In-Reply-To: <480CB247.1090902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Mon, 21 Apr 2008 11:27:03 -0400

> The only difference between the 2 is that second accounting done by
> sctp_packet_transmit().  It changes sk_wmem_alloc, but not assoc.sndbuf_used.
> Thus in one case, there is an extra change against the send buffer that
> causes us to exceed it temporarily and thus get scheduled out.  Since we
> never wake up, I am now starting to think that the wake-up code is
> called while the application is still running.  So the race is between
> a wake-up and a call to schedule_timeout.
>
> The reason this is not an issue for TCP is that TCP never drops the
> socket lock when going to sleep so the socket is still locked when
> the buffer cleanup happens.  That's not a case for SCTP.

You need to provide more precise context when making such broad
statements of fact about TCP :-)))

For example, if TCP hits it's send buffer limits when trying to send,
it will release the socket lock while sleeping (via
sk_stream_wait_memory() --> sk_wait_event()).  Otherwise ACKs would
not be processed because a locked socket forces all incoming packets
to get queued to the backlog, to be processed at the next
release_sock() call.

I imagine you're talking about the case where the memory allocation on
transmit itself sleeps.
