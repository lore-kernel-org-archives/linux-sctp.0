From: David Miller <davem@davemloft.net>
Date: Mon, 27 Oct 2014 22:55:45 +0000
Subject: Re: [net 1/2] sctp: add transport state in /proc/net/sctp/remaddr
Message-Id: <20141027.185545.551457974536550723.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1414093721-14921-1-git-send-email-michele@acksyn.org>
In-Reply-To: <1414093721-14921-1-git-send-email-michele@acksyn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: michele@acksyn.org
Cc: linux-sctp@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, netdev@vger.kernel.org, dborkman@redhat.com

From: Michele Baldessari <michele@acksyn.org>
Date: Thu, 23 Oct 2014 21:48:40 +0200

> It is often quite helpful to be able to know the state of a transport
> outside of the application itself (for troubleshooting purposes or for
> monitoring purposes). Add it under /proc/net/sctp/remaddr.
> 
> Signed-off-by: Michele Baldessari <michele@acksyn.org>

You can't change the layout of procfs files, applications parse
these files and any modification can potentially break such tools.

Secondly, even if this change were acceptable, targetting this
change at anything other than the net-next tree is not appropriate
because it is a new feature.
