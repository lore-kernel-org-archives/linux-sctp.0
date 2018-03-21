From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 21 Mar 2018 16:35:54 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180321163554.GE26737@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi David,

On Wed, Mar 21, 2018 at 04:09:30PM +0000, David Neil wrote:
> Marcelo,
> It would not have been easy to fix the connections of the first type
> described below as this is a fundamental part of the design of the
> software.
> 
> But it was possible to change the second type of connection.
> In all cases, where we had multiple SCTP connection differing only
> by the source IP address, I changed them so that they also had
> different source ports.
> 
> i.e. 127.0.0.3,36412 => 127.0.0.1,36412 and 127.0.0.4,36412 => 127.0.0.1,36412
> became 127.0.0.3,2001 => 127.0.0.1,36412 and 127.0.0.4,2002 => 127.0.0.1,36412
> 
> Somewhat surprisingly, this seems to have fixed everything.
> I have now been running the tests in a loop for nearly 36 hours and
> there have been no failures.

Yay, nice!

> 
> I was expecting this change to fix the failures for the second type
> of connection, but not expecting it to fix the failures for the
> first type of connection; but it appears that it has fixed both.
> It appears that having multiple connections differing only in the
> source IP address could cause connection failures on other unrelated
> SCTP connections.

I understand that the first type already used a different src port for
each connection.

But yes, if the hashes of the first type ended up being the same as
the hashes of the second type, the bug could affect both. Consider
that for the rhashtable, once hashed, it doesn't matter what the
actual keys were.

> 
> I am assuming this decription I have given still fits in with the
> theory that the failures were casued by the rhlists bug. Do you need
> any more info to confirm this?

If doable, you could apply those fixes and run the original tests
again. That would be very good to confirm it, but not really needed.

I'll try to write some test case for this. Will let you know once I
have it.

Note sure if you know about it, but we have a growing collection of
test cases @ https://github.com/sctp/sctp-tests

Pull requests are very welcomed. :-)

> 
> From my point of view, this issue is now resolved.

Great! But note that the real fix is to apply the rhashtable patches.
Changing the src port is just a workaround and you may still hit the
issue if the stars align again.

Thanks,
  M.

> Dave.
> 
> 
> > On 19 Mar 2018, at 22:24, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > 
> > On Mon, Mar 19, 2018 at 10:05:56PM +0000, David Neil wrote:
> >> There are two patterns of SCTP connections that we use; I believe we have seen the SCTP connection failures on both types of connection.
> >> 
> >> 1) Every task is assigned a unique SCTP port. All tasks then communicate with each other using the standard localhost address 127.0.0.1. Where TASKa and TASKb both connect to TASKc we would end in the situation where the src IP, dst IP and dst port are the same for two connections, the connections only differ by the src port.
> >> 
> >> 2) Where we are using protocols with well known port numbers (e.g Diameter and S1AP), and have multiple tasks that want to use that port, then we separate the connections by using multiple loopback interfaces. For example with S1AP, we may have one connection with src IP7.0.0.4, src port6412, dst IP7.0.0.1, dst port6412, and a second connection with src IP7.0.0.3, src port6412, dst IP7.0.0.1, dst port6412. In this case the connections only differ by the src IP.
> >> 
> >> Can both these scenarios be explained by this issue with rhlists?
> > 
> > AFAIU both situations, yes. At the very least, worth a try.
> > 
> > Maybe it's easier for you to add some randomness to the src port than
> > to test a new kernel? This would give a good hint I think.
> > 
> 
