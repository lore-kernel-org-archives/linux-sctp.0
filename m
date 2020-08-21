From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Fri, 21 Aug 2020 20:17:04 +0000
Subject: Re: SCTP multi-homed association (::1)->(::1+127.0.0.1) attempting HEARTBEAT on 127.0.0.1->127.0.0.1
Message-Id: <20200821201704.GN3399@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
In-Reply-To: <552de663-8aeb-ff84-a425-988da88ca5cd@sysmocom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi Pau,

On Thu, Aug 20, 2020 at 01:11:02PM +0200, Pau Espin Pedrol wrote:
> Hi all,
> 
> I just submitted the following SCTP bug in the kernel bugtracker. I
> placed it under "IPV6" category since there's no "SCTP" category
> available there. It may be worth asking whoever is in charge to add the
> category so the relevant maintainer is assigned?

We actually don't use that bugzilla.

> 
> https://bugzilla.kernel.org/show_bug.cgi?id 8969
> 
> PS: I'm not registered to the ML, plese keep me in CC.

Aye. But gotta say, you might want to subscribe. It's really low
volume, and will get you aware of recent fixes.

By your description in the bug, seems we fixed it in June. Can you
confirm that your kernel doesn't have this commit in?
471e39df96b9 ("sctp: Don't advertise IPv4 addresses if ipv6only is set
on the socket")

Regards,
Marcelo
