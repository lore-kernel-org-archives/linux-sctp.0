From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 21 Sep 2016 16:12:12 +0000
Subject: Re: Address already in use problem
Message-Id: <20160921161211.GC13620@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <CAFXGft+39Ed=6MDu6E9twGfhRu1yw4b=E5C8QNMQ-trxXVx08Q@mail.gmail.com>
 <20160921154304.GB13620@hmsreliant.think-freely.org>
 <063D6719AE5E284EB5DD2968C1650D6DB010623F@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB010623F@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Laight <David.Laight@ACULAB.COM>
Cc: Sun Paul <paulrbk@gmail.com>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Sep 21, 2016 at 03:56:41PM +0000, David Laight wrote:
> From: Neil Horman
> > Sent: 21 September 2016 16:43
> > On Wed, Sep 21, 2016 at 09:44:30PM +0800, Sun Paul wrote:
> > > Hi
> > >
> > > we have an SCTP application running in JAVA. and we found that there
> > > is a problem when we as a client trying to connect to a remote IP
> > > address.
> > >
> > > If the remote IP address is not accessible, our application will keep
> > > retrying to connect using a self-defined local port address, says
> > > 51001,
> > >
> > > We found that after sometimes, says 2 hrs, this port 51001 is never
> > > able to bind to us again. even we tried to restart the application.
> > >
> > Sounds like you have another application that inadvertently bound to that port.
> > Its not a privlidged port, nor is it well known, so it seems plausible that
> > another application would eventually bind to it.  Thats not a bug, just the way
> > ip works.
> > 
> > run netstat -anp | grep 51001
> > 
> > And see what application is holding the port.
> 
> Not much chance of a distro having a netstat that gives sctp info.
> You might find something in /proc/net/sctp.
> 

True, but there is also no guarantee that the other application that claimed the
port in question is using SCTP.
Neil

> 3.18 contains a fix for a problem with shutdown() being called
> after the remote sends an INIT to restart an active connection
> when there is unacked data.
> If that happens the socket isn't released ever.
> 
> A workaround is to use SO_LINGER to get the connection aborted.
> 
> 	David
> 
> 
