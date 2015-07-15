From: David Miller <davem@davemloft.net>
Date: Wed, 15 Jul 2015 20:58:24 +0000
Subject: Re: [PATCH v2 1/2] sctp: add new getsockopt option SCTP_SOCKOPT_PEELOFF_KERNEL
Message-Id: <20150715.135824.754282841801954470.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1436891629.git.marcelo.leitner@gmail.com>
	<6091a8542d13f43fbe1abfa25062d28d15b15e66.1436891629.git.marcelo.leitner@gmail.com>
	<20150715131827.GA24091@hmsreliant.think-freely.org>
In-Reply-To: <20150715131827.GA24091@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: marcelo.leitner@gmail.com, netdev@vger.kernel.org, vyasevich@gmail.com, linux-sctp@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Wed, 15 Jul 2015 09:18:28 -0400

> Do we need to do something here to prevent user space calls from inadvertently
> accessing this option?

And this is also not what I had anticipated was the implementation.

I didn't mean that adding a new option number specially for the
kernel was the right thing to do.

I meant that having a specific function GPL exported to modules that
the external code calls would do the trick.

That's why we have things like kernel_sendmsg() et al.
