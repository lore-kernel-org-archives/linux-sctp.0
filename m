From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 20 Dec 2013 12:23:10 +0000
Subject: Re: undetected closed apps
Message-Id: <52B436AE.2000804@mojatatu.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <52AC7375.6010505@mojatatu.com>
In-Reply-To: <52AC7375.6010505@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 12/19/13 12:24, Vlad Yasevich wrote:
> On 12/19/2013 09:26 AM, Jamal Hadi Salim wrote:

>
> So, on this line socket state (SST) is 7 which is SCTP_SS_CLOSED.  This
> means that you performed a close() call.  The association state (ST) is
> 4 which is SHUTDOWN_PENDING.  This means that when you tried to close
> the socket, the association thought that there was some pending data.
>
> I seem to remember you and I discussing this situation before, but I
> can't find that thread.
>
> I'll take another look at how PR interacts with queue state to see if
> we can detect the proper empty state to send a SHUTDOWN.
>
> However, what the above tells me is that you don't actually set
> SO_LINGER on this socket.  If you did, instead of attempting SHUTDOWN,
> we would have sent an abort.  That might be a good workaround until
> we solve this "queue empty" problem.
>

I will give this a try when i get to the office. I am certain we linger
on the server. On client side, at one point we turned off heartbeats on
the client side and that typically goes with linger on. I will double
check.

cheers,
jamal

