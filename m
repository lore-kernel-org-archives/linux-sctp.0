From: David Miller <davem@davemloft.net>
Date: Thu, 10 Sep 2015 00:16:00 +0000
Subject: Re: [PATCH net] sctp: fix race on protocol/netns initialization
Message-Id: <20150909.171600.1487892650387164045.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <27f20cc781cac28bc2ce7229719748a2f6824bd8.1441827818.git.marcelo.leitner@gmail.com>
In-Reply-To: <27f20cc781cac28bc2ce7229719748a2f6824bd8.1441827818.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: marcelo.leitner@gmail.com
Cc: netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed,  9 Sep 2015 17:03:01 -0300

> So the fix then is to invert the initialization order inside
> register_pernet_subsys() so that the control socket is created by last
> and also block socket creation if netns initialization wasn't yet
> performed.

If we really need to we could make ->create() fail with -EAFNOSUPPORT
if kern=1 until the protocol is fully setup.

Or, instead of failing, we could make such ->create() calls block
until the control sock init is complete or fails.

We have actually several visibility issues wrt. control sockets on
protocol init, in general.

For example, such control sockets can briefly be hashed and visible
to socket dumps and packet input.

A lot of really tricky issues involved here.
