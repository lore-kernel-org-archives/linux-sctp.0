From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 19 Mar 2018 18:38:00 +0000
Subject: Re: SCTP abort with T-bit set after handshake
Message-Id: <20180319183800.GN9345@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
In-Reply-To: <482208C5-8F01-4698-80EB-74DB994382F9@attocore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

On Mon, Mar 19, 2018 at 05:06:05PM +0000, David Neil wrote:
> Marcelo,
> Sorry for the slow reply, have been away and then have been struggling to reproduce the problem.

No problem.

> 
> 
> > 
> > A few lines below it will check if an asoc couldn't be found and will
> > increment SCTP_MIB_OUTOFBLUES. There are more places that inc it, but
> > it's a start.
> > 
> > It should show up in netstat -s or /proc/net/sctp/snmp.
> > 
> 
> Have finally caught another instance of the problem while monitoring
> the SCTP statistics. 
> This is not helped by the fact that the out-of-blue counter goes up
> in total by about 600 while running a complete set of tests (I
> assume this is mainly at the end of each test when conections are
> abruptly terminated).

Ouch. This will make it very hard to debug. Even with Neil's
idea of using systemtap, it will likely get too much noise with it.

> I have therefore been capturing the stats every 100msec and looking
> at the counters at the moment when the problem occurred.
> 
> This shows the out-of-blue counter being incremented at the same
> time as the SCTP connection failure.
> 
...

Ok. This didn't help much, sorry. Just the fact that the counter is
going up, on this situation of several tests going on, won't give us
much. It is a good info, it's just that now we have to remove all the
noise together with it.

> 
> > 
> > Btw, is this test public? Can I run it too?  
> 
> Unfortunately, it is private.
> 
> 
> > Or if you can create a
> > small reproducer, that would be great.
> 
> This would be great if I could figure out what the important elements are in what I am doing.
> The tests are opening and closing and aborting large numbers of connections. 
> Some of the connections are used to exchange a lot of data, others hardly carry anything.
> The connection that fails appears to be fairly random. The timing of when it fails appears to be fairly random.
> The failure only occurs after an average of over an hour of running.
> Any hints at the kind of behaviour that could trigger a failure like this?

I noticed that the association you referenced used the same port at
both hosts. You don't have a port re-use happening in there, do you?

I fear you won't have other choice other than trimming this down to a
more specific test.

We could, for example, trigger a Panic when the test fails, but then
it's probably too late for us to do any analysis in the vmcore. And we
can't trigger the panic on Abort generation because it will catch the
other expected failures.

One other idea is, if it takes ~1hr to reproduce, try reducing the
pool of tests that are executed in that window and see how it goes.

  M.
