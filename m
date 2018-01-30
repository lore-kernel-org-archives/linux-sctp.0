From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 30 Jan 2018 22:52:27 +0000
Subject: Re: sctp netns "unregister_netdevice: waiting for lo to become free. Usage count = 1"
Message-Id: <20180130225227.GC3503@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
In-Reply-To: <2a9c25b0-9ee7-baf6-f212-2c94b06941ea@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Mon, Jan 29, 2018 at 05:55:45PM +0200, Tommi Rantala wrote:
> Hi,
> 
> When running sctp_test from lksctp-tools in netns in 4.4 and 4.9 with
> suitable arguments, the local loopback device in the netns is not getting
> destroyed after deleting the netns.
> 
...
> 
> Based on a quick test, 4.14 and 4.15 does not suffer from this, but its
> reproducible e.g. in 4.4.113 and 4.9.75
> 
> Any ideas?

By the versions you mentioned and report, maybe f186ce61bb82 ("Fix an
intermittent pr_emerg warning about lo becoming free.") fixed it.

  Marcelo
