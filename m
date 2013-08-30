From: Neil Horman <nhorman@tuxdriver.com>
Date: Fri, 30 Aug 2013 11:36:30 +0000
Subject: Re: [PATCH net-next] net: sctp: probe: allow more advanced ingress filtering by mark
Message-Id: <20130830113630.GB1142@hmsreliant.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1377795289-1914-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1377795289-1914-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org

On Thu, Aug 29, 2013 at 06:54:49PM +0200, Daniel Borkmann wrote:
> This is a follow-up commit for commit b1dcdc68b1f4 ("net: tcp_probe:
> allow more advanced ingress filtering by mark") that allows for
> advanced SCTP probe module filtering based on skb mark (for a more
> detailed description and advantages using mark, refer to b1dcdc68b1f4).
> The current option to filter by a given port is still being preserved.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

