From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 24 Jun 2020 20:31:23 +0000
Subject: Re: [PATCH] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Message-Id: <20200624203123.GC47547@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <c1121947c9a94703b4ab6dc434a7c3f8@AcuMS.aculab.com>
 <20200623160417.12418-1-minyard@acm.org>
In-Reply-To: <20200623160417.12418-1-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: minyard@acm.org
Cc: Xin Long <lucien.xin@gmail.com>, Michael Tuexen <Michael.Tuexen@lurchi.franken.de>, Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, Corey Minyard <cminyard@mvista.com>

On Tue, Jun 23, 2020 at 11:04:17AM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> If a socket was set ipv6only, it would still send IPv4 addresses in the
> init and init ack packets.  So don't add IPv4 addresses to ipv6only
> sockets.
> 
> Based on a patch by Xin Long <lucien.xin@gmail.com>
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
> I have tested this and it seem to fix the issue.  However, I'm wondering
> if it might be better to fix it where the addresses are put into the
> association as opposed to where they are put into the message.

Yes, it is. It even highlights why this issue was there in the first
place. Sending a patch right after this email.

  Marcelo
