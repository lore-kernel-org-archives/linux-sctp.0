From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 06 Dec 2012 18:44:33 +0000
Subject: Re: [PATCH] sctp: Add RCU protection to assoc->transport_addr_list
Message-Id: <20121206184433.GE16122@casper.infradead.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <16453bea94a6fc43d657139dff2ce0b5924e2a1f.1354817574.git.tgraf@suug.ch>
 <50C0E585.1080701@gmail.com>
In-Reply-To: <50C0E585.1080701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>

On 12/06/12 at 01:35pm, Vlad Yasevich wrote:
> We may want to mark transports as dead sooner.  Probably right about
> the time we pull them off the list.

We mark it dead in sctp_transport_free() which is called at the
end of sctp_assoc_rm_peer(). Do you want to mark it dead at the
beginning of sctp_assoc_rm_peer() as well? (We still need to
mark in sctp_transport_free() anyway).

> When displaying, we may want to
> look at transport->dead, and skip them.  It will reduce the probability
> that we would be looking at a transport that's about to go away.

Agreed.
