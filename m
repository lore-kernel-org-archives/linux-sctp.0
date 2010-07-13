From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 13 Jul 2010 15:05:41 +0000
Subject: Re: about the sctpCurrEstab MIB item
Message-Id: <4C3C80C5.6060809@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4C3C1539.5030302@cn.fujitsu.com>
In-Reply-To: <4C3C1539.5030302@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On 07/13/2010 03:26 AM, Shan Wei wrote:
> The sctpCurrEstab MIB item is defined in RFC3873 as 
> the number of associations for which the current state is
> either ESTABLISHED, SHUTDOWN-RECEIVED or SHUTDOWN-PENDING.
> 
> So, an association for which the current state is SHUTDOWN-SENT
> or SHUTDOWN-ACK-SENT should not counted in SctpCurrEstab. Right?
> 
> But, actually, the implementation of Linux is not consistent with the spec.
> An association is thought as "established" with the current state of
> ESTABLISHED, SHUTDOWN-RECEIVED, SHUTDOWN-PENDING. SHUTDOWN-SENT
> or SHUTDOWN-ACK-SENT.
> 
> Has any reasons for this implementation?
> If not, I think we should fix it.
> 

I don't know of any reason other then it makes a whole lot more sense then
what's stated in the RFC.

Why would SHUTDOWN_SENT be treated any different then SHUTDOWN_RECEIVED?

Think of this situation.  You have a server streaming data to the client.
The client crashes for some reason, and that triggers a SHUTDOWN to be sent.
The server still has a bunch of data buffered as it's trying to write stuff
the wire.  In this case, our association count would be inconsistent if we
followed the spec.  On the client we would not count an association that's
still alive and consuming resources, while on the server side we would.

I really think that this is an oversight of the MIB spec and in my personal
opinion it is not worth fixing.

I am, however, open to counter-arguments.

-vlad
