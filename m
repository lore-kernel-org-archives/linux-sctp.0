From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Mar 2018 20:29:43 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180319202943.GD4832@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Mar 19, 2018 at 05:28:13PM -0300, Marcelo Ricardo Leitner wrote:
> On Mon, Mar 19, 2018 at 03:38:00PM -0300, Marcelo Ricardo Leitner wrote:
> > > > Or if you can create a
> > > > small reproducer, that would be great.
> > > 
> > > This would be great if I could figure out what the important elements are in what I am doing.
> > > The tests are opening and closing and aborting large numbers of connections. 
> > > Some of the connections are used to exchange a lot of data, others hardly carry anything.
> > > The connection that fails appears to be fairly random. The timing of when it fails appears to be fairly random.
> > > The failure only occurs after an average of over an hour of running.
> > > Any hints at the kind of behaviour that could trigger a failure like this?
> > 
> > I noticed that the association you referenced used the same port at
> > both hosts. You don't have a port re-use happening in there, do you?
> 
> If you have several associations using the same (src ip, dst ip, dst
> port) tuple, you may be facing an issue with rhlists.
> (netdev patchset Subject rhashtable: Fix rhltable duplicates insertion)

https://www.mail-archive.com/netdev@vger.kernel.org/msg220650.html

> 
> We use rhltable for the transport list and their description of the
> issue matches your situation too AFAICT.
> 
>   M.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
