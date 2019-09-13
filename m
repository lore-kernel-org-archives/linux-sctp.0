From: 'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
Date: Fri, 13 Sep 2019 13:19:54 +0000
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct sctp_paddrthlds
Message-Id: <20190913131954.GX3431@localhost.localdomain>
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
In-Reply-To: <bcaba726b7444efea7b14fcd60e4743a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@aculab.com>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, Neil Horman <nhorman@tuxdriver.com>, "davem@davemloft.net" <davem@davemloft.net>

On Fri, Sep 13, 2019 at 08:36:22AM +0000, David Laight wrote:
> From: Marcelo Ricardo Leitner
> > Sent: 12 September 2019 23:52
> ...
> > Here it is more visible. If net->...ps_retrans is disabled, remaining
> > fields (currently just this one, but as we are extending it now, we
> > have to think about the possibility of more as well) will be ignored,
> > we and we may not want that.
> 
> The only real way to add additional fields is to change the name
> of the structure - that way recompiled programs still work.
> 
> You could require that programs zero the entire structure - but
> that is difficult to verify.
> And, in this case, it seems that the default has to be 0xffff
> rather than 0 - which is, in itself, horrid.

Yep, and with that, a new sockopt as well. May not be the most
beautiful way, but it's the safest. Applications can then probe if the
sockopt is available or not and use what they want/can.

Inner kernel code can then be rearranged like it was for the peeloff
operation and peeloff + flags, and these issues just don't exist then.

We actually had agreed on using new sockopts, on thread
[PATCH net] sctp: make sctp_setsockopt_events() less strict about the option length

Interestingly, we have/had the opposite problem with netlink. Like, it
was allowing too much flexibility, such as silently ignoring unknown
fields (which is what would happen with a new app running on an older
kernel would trigger here) is bad because the app cannot know if it
was actually used or not. Some gymnastics in the app could cut through
the fat here, like probing getsockopt() return size, but then it may
as well probe for the right sockopt to be used.

  Marcelo
