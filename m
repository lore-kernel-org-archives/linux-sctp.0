From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Mar 2018 22:24:08 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180319222408.GA26737@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Mar 19, 2018 at 10:05:56PM +0000, David Neil wrote:
> There are two patterns of SCTP connections that we use; I believe we have seen the SCTP connection failures on both types of connection.
> 
> 1) Every task is assigned a unique SCTP port. All tasks then communicate with each other using the standard localhost address 127.0.0.1. Where TASKa and TASKb both connect to TASKc we would end in the situation where the src IP, dst IP and dst port are the same for two connections, the connections only differ by the src port.
> 
> 2) Where we are using protocols with well known port numbers (e.g Diameter and S1AP), and have multiple tasks that want to use that port, then we separate the connections by using multiple loopback interfaces. For example with S1AP, we may have one connection with src IP7.0.0.4, src port6412, dst IP7.0.0.1, dst port6412, and a second connection with src IP7.0.0.3, src port6412, dst IP7.0.0.1, dst port6412. In this case the connections only differ by the src IP.
> 
> Can both these scenarios be explained by this issue with rhlists?

AFAIU both situations, yes. At the very least, worth a try.

Maybe it's easier for you to add some randomness to the src port than
to test a new kernel? This would give a good hint I think.

> 
> Thanks,
> Dave.
> 
> 
> > On 19 Mar 2018, at 20:29, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > On Mon, Mar 19, 2018 at 05:28:13PM -0300, Marcelo Ricardo Leitner wrote:
> >> On Mon, Mar 19, 2018 at 03:38:00PM -0300, Marcelo Ricardo Leitner wrote:
> >>>>> Or if you can create a
> >>>>> small reproducer, that would be great.
> >>>> 
> >>>> This would be great if I could figure out what the important elements are in what I am doing.
> >>>> The tests are opening and closing and aborting large numbers of connections. 
> >>>> Some of the connections are used to exchange a lot of data, others hardly carry anything.
> >>>> The connection that fails appears to be fairly random. The timing of when it fails appears to be fairly random.
> >>>> The failure only occurs after an average of over an hour of running.
> >>>> Any hints at the kind of behaviour that could trigger a failure like this?
> >>> 
> >>> I noticed that the association you referenced used the same port at
> >>> both hosts. You don't have a port re-use happening in there, do you?
> >> 
> >> If you have several associations using the same (src ip, dst ip, dst
> >> port) tuple, you may be facing an issue with rhlists.
> >> (netdev patchset Subject rhashtable: Fix rhltable duplicates insertion)
> > 
> > https://www.mail-archive.com/netdev@vger.kernel.org/msg220650.html
> > 
> >> 
> >> We use rhltable for the transport list and their description of the
> >> issue matches your situation too AFAICT.
> >> 
> >>  M.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> 
