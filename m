From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 24 Jun 2010 13:58:30 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
Message-Id: <4C236486.5070708@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>	 <4C235B75.2000807@hp.com> <1277385636.13544.67.camel@yamato.local>	 <4C236063.9050302@hp.com> <1277387081.13544.75.camel@yamato.local>
In-Reply-To: <1277387081.13544.75.camel@yamato.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?RGllZ28gRWxpbyDigJxGbGFtZWV5ZXPigJ0gUGV0dGVuw7I=?= <flameeyes@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org



Diego Elio “Flameeyes” Pettenò wrote:
> Il giorno gio, 24/06/2010 alle 09.40 -0400, Vlad Yasevich ha scritto:
>> You don't call accept() on an SCTP SEQPACKET socket.  You can just
>> read from it.
> 
> Okay I guess I'll send a patch to the man page to fix that then.

I don't think the man page needs an update.  This is just an SCTP-ism.
There are other protocols using SOCK_SEQPACKET that implement and support
accept() call.

The SCTP api spec decided that it wouldn't support accept() and we have to
follow it.


> 
>> This way, you'll ignore listening SOCK_STREAM sockets which will not
>> have any
>> data anyway, but you'll check out listening SOCK_SEQPACKET sockets
>> that may have
>> data waiting on them. 
> 
> Ah I think I see what you mean here: SIOCINQ would work for TCP-style
> ESTABLISHED sockets _and_ SEQPACKET LISTENING sockets, right?

Right.

-vlad

> 
> Will send the updated patch in a moment.
> 
