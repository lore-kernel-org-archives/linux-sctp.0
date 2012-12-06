From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 06 Dec 2012 19:28:52 +0000
Subject: Re: [PATCH] sctp: Add RCU protection to assoc->transport_addr_list
Message-Id: <20121206192852.GG16122@casper.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <16453bea94a6fc43d657139dff2ce0b5924e2a1f.1354817574.git.tgraf@suug.ch>
 <50C0E585.1080701@gmail.com>
 <20121206184433.GE16122@casper.infradead.org>
 <50C0EAB5.3050303@gmail.com>
 <20121206190835.GF16122@casper.infradead.org>
 <50C0EE8E.3080505@gmail.com>
In-Reply-To: <50C0EE8E.3080505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/06/12 at 02:14pm, Vlad Yasevich wrote:
> Right, but there may be chunks that have cached association with a ref
> before sctp_association_free() is called.  Now, after free they may
> be looking at the transport list for whatever reason...  Most places
> check assoc->dead, but I don't want to get caught.  So, there is
> a remote chance that someone may look at transports and would crash
> without rcu.

You are right, sctp_associate_free() can be called even though there
may still be multiple refs on that assoc around. We are currently
fine as I believe sk_lock serializes all the accesses but better
be safe than sorry.

I've respun the patches in a v2 patch series.
