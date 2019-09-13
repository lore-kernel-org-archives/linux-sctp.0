From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 13 Sep 2019 13:31:22 +0000
Subject: RE: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <be14cc8353f6403c82ad81e3e741d8f0@AcuMS.aculab.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
 <9fc7ca1598e641cda3914840a4416aab@AcuMS.aculab.com>
 <CADvbK_d_Emw0K2Uq4P9OanRBr52tNjMsAOiJNi0TGsuWt6+81A@mail.gmail.com>
 <1e5c3163e6c649b09137eeb62d193d87@AcuMS.aculab.com>
 <CADvbK_dcGXPmO+wwwCvcsoGYPv+sdpw2b0cGuen-QPuxNcEcpQ@mail.gmail.com>
 <CADvbK_dqNas+vwP2t3LqWyabNnzRDO=PZPe4p+zE-vQJTnfKpA@mail.gmail.com>
 <20190911125609.GC3499@localhost.localdomain>
 <CADvbK_e=4Fo7dmM=4QTZHtNDtsrDVe_VtyG2NVqt_3r9z7R=PA@mail.gmail.com>
 <20190912225154.GF3499@localhost.localdomain>
 <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
 <20190913131954.GX3431@localhost.localdomain>
In-Reply-To: <20190913131954.GX3431@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

From: 'Marcelo Ricardo Leitner'
> Sent: 13 September 2019 14:20
...
> Interestingly, we have/had the opposite problem with netlink. Like, it
> was allowing too much flexibility, such as silently ignoring unknown
> fields (which is what would happen with a new app running on an older
> kernel would trigger here) is bad because the app cannot know if it
> was actually used or not. Some gymnastics in the app could cut through
> the fat here, like probing getsockopt() return size, but then it may
> as well probe for the right sockopt to be used.

Yes, it would also work if the kernel checked that all 'unexpected'
fields were zero (up to some sanity limit of a few kB).

Then an application complied with a 'new' header would work with
an old kernel provided it didn't try so set any new fields.
(And it zeroed the entire structure.)

But you have to start off with that in mind.

Alternatively stop the insanity of setting multiple options
with one setsockopt call.
If multiple system calls are an issue implement a system call
that will set multiple options on the same socket.
(Maybe through a CMSG()-like buffer).
Then the application can set the ones it wants without having
to do the read-modify-write sequence needed for some of the
SCTP ones.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
