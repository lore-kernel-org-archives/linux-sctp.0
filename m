From: David Miller <davem@davemloft.net>
Date: Sat, 04 Aug 2012 23:57:03 +0000
Subject: Re: [PATCH 00/13] SCTP: Enable netns
Message-Id: <20120804.165703.2163110391266920101.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
In-Reply-To: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jan.ariyasu@gmail.com
Cc: vyasevich@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jan.ariyasu@hp.com

From: Jan Ariyasu <jan.ariyasu@gmail.com>
Date: Sat,  4 Aug 2012 15:30:37 -0600

> The following set of patches enable network-namespaces for the SCTP protocol.
> 
> The multitude of global parameters are stored in a net_generic
> structure, and the bulk of the patches enable the protocol to access
> the parameters on a per-namespace basis.  The first five patches
> enable netns handling of the protocol, procfs and sysfs.
> 
> Signed-off-by: Jan Ariyasu <jan.ariyasu@hp.com>

Patch 02/13 didn't show up at all.
