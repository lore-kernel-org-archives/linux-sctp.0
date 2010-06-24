From: Diego Elio =?UTF-8?Q?=E2=80=9CFlameeyes=E2=80=9D_?=
Date: Thu, 24 Jun 2010 13:44:41 +0000
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
Message-Id: <1277387081.13544.75.camel@yamato.local>
List-Id: <linux-sctp.vger.kernel.org>
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>
	 <4C235B75.2000807@hp.com> <1277385636.13544.67.camel@yamato.local>
	 <4C236063.9050302@hp.com>
In-Reply-To: <4C236063.9050302@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org

Il giorno gio, 24/06/2010 alle 09.40 -0400, Vlad Yasevich ha scritto:
> You don't call accept() on an SCTP SEQPACKET socket.  You can just
> read from it.

Okay I guess I'll send a patch to the man page to fix that then.

> This way, you'll ignore listening SOCK_STREAM sockets which will not
> have any
> data anyway, but you'll check out listening SOCK_SEQPACKET sockets
> that may have
> data waiting on them. 

Ah I think I see what you mean here: SIOCINQ would work for TCP-style
ESTABLISHED sockets _and_ SEQPACKET LISTENING sockets, right?

Will send the updated patch in a moment.

-- 
Diego Elio Pettenò — “Flameeyes”
http://blog.flameeyes.eu/

If you found a .asc file in this mail and know not what it is,
it's a GnuPG digital signature: http://www.gnupg.org/


