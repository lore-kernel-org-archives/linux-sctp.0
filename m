From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 15 Aug 2012 03:23:51 +0000
Subject: Re: [PATCH 00/13] SCTP: Enable netns
Message-Id: <502B1647.3070802@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
In-Reply-To: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Ariyasu <jan.ariyasu@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Jan Ariyasu <jan.ariyasu@hp.com>

On 08/04/2012 05:30 PM, Jan Ariyasu wrote:
> The following set of patches enable network-namespaces for the SCTP protocol.
>
> The multitude of global parameters are stored in a net_generic
> structure, and the bulk of the patches enable the protocol to access
> the parameters on a per-namespace basis.  The first five patches
> enable netns handling of the protocol, procfs and sysfs.
>
> Signed-off-by: Jan Ariyasu <jan.ariyasu@hp.com>
> ---
>

NACK.  Sorry Jan, but Eric's patches are much cleaner and do everything 
that's needed.

-vlad
