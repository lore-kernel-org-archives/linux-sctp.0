From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 24 Jun 2010 13:40:51 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
Message-Id: <4C236063.9050302@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>	 <4C235B75.2000807@hp.com> <1277385636.13544.67.camel@yamato.local>
In-Reply-To: <1277385636.13544.67.camel@yamato.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?RGllZ28gRWxpbyDigJxGbGFtZWV5ZXPigJ0gUGV0dGVuw7I=?= <flameeyes@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org



Diego Elio “Flameeyes” Pettenò wrote:
> Il giorno gio, 24/06/2010 alle 09.19 -0400, Vlad Yasevich ha scritto:
>> This should add a check for sctp_style(sk, TCP), since one can't read
>> from
>> a TCP style listening sockets, but can do so from UDP-style
>> (SOCK_SEQPACKET). 
> 
> I don't want to sound arrogant but... are you sure?

Yes, I am sure. :)

> 
> I ask because the simple testcase I wrote to make sure I didn't get it
> wrong opened the socket as SOCK_STREAM, and yet all of this worked fine
> (I'm attaching the source, for the sake of it)...
> 
> I sure hope you're mistaken here and it is _supposed_ to work here as
> well, as we cannot use SOCK_SEQPACKET in the software I'm writing this
> for (feng, from the lscube project) as accept() fails on SOCK_SEQPACKET
> (EOPNOTSUPP) -- which itslef is strange given that the man page for
> accept(2) reports it's supported on SOCK_STREAM and SOCK_SEQPACKET.
> 

You don't call accept() on an SCTP SEQPACKET socket.  You can just read from it.
SCTP uses SOCK_SEQPACKET to implement 1-to-many semantics, where you can have
multiple associations all serviced by the same socket.  In that case, the socket
is placed into the listening state and then the application may simply read
from it.

Thus your code that just returns the size of the first skb should take that into
consideration.

So the condition really is:
  if (sctp_style(sk, TCP) && sctp_state(sk, LISTENING))
	goto out;

This way, you'll ignore listening SOCK_STREAM sockets which will not have any
data anyway, but you'll check out listening SOCK_SEQPACKET sockets that may have
data waiting on them.

-vlad
