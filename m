From: David Miller <davem@davemloft.net>
Date: Wed, 30 Dec 2015 20:44:25 +0000
Subject: Re: [PATCH net-next 0/5] sctp: use transport hashtable to replace association's with rhashtable
Message-Id: <20151230.154425.1221426772185302815.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1451495979.8255.32.camel@edumazet-glaptop2.roam.corp.google.com>
	<20151230173202.GB16270@localhost.localdomain>
	<1451502680.8255.50.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1451502680.8255.50.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: eric.dumazet@gmail.com
Cc: marcelo.leitner@gmail.com, lucien.xin@gmail.com, netdev@vger.kernel.org, linux-sctp@vger.kernel.org, mleitner@redhat.com, vyasevic@redhat.com, daniel@iogearbox.net

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Wed, 30 Dec 2015 14:11:20 -0500

> Let see how funny it will be then.

It is more fun than waiting longer for the more limited uses of it to
trigger problems.

I cannot be convinced that using it in more places in order to find
and fix more bugs is a bad thing.

I'm sorry if a lot of bug fixes in a short period of time concerns
you, but for me that's an even clearer sign that it needs help, and
exposing it to more use cases is one of the best forms of help it can
get.

It also tells me that the people actually working on those fixes, such
as Herbert Xu, are motivated and reliable when they are shown properly
formed bug reports.

I cannot think of a report Herbert and others did not resolve in a
timely manner.  They usually add test cases too.

And that matters more to me than anything else.  A subsystem can be
buggy as shit, but if someone is responsible about fixing the reported
bugs properly, then I have absolutely nothing to worry about.
