From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 25 May 2010 17:11:38 +0000
Subject: Re: Source IP not corresponding to interface
Message-Id: <4BFC04CA.7070207@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4BFBFB26.6050209@kth.se>
In-Reply-To: <4BFBFB26.6050209@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org



Georgios Cheimonidis wrote:
> Hi!
> 
> I have observed a problem while doing some tests with dynamic address
> reconfiguration. Let me first describe my setup and application.
> 
> Setup: I have two hosts, one that acts as a client and another that acts
> as a server. The client has two IPv4 addresses (one on wlan, let's call
> it X, and another on a 3G p-to-p connection, let's call it Y). There are
> two default routes on the client, and the wlan default has a smaller
> metric than the 3G default. The server is single homed. All addresses
> belong to different subnets.
> Both hosts are running the net-next kernel, downloaded from David
> Miller's net-next source tree on 12-May-2010). I have also applied two
> extra patches found in: (a)
> http://www.spinics.net/lists/linux-sctp/msg00881.html and
> (b)http://www.spinics.net/lists/linux-sctp/msg00882.html. I have also
> enabled SCTP debugging messages.
> 

Hi George

Thanks for this report.  I am setting up a reproduction environment now.
Will let you know what I find.

It sounds like the routing might get kind-of funky after you add the
address back.  Does the default route get recreated with the right
metric?

Kernel logs are always nice to have.  You can even look through them
and try finding references to sctp_v4_get_dst() call to see what
it shows you.  Thats where routing and source address selection
is done.

I am also assuming that this is all v4, right?  I've got v6 patch
ready finally.  Passed all the tests I could throw at it.

-vlad
