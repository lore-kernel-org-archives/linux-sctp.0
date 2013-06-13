From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 13 Jun 2013 13:08:49 +0000
Subject: Re: [PATCH net-next stable v2] sctp: fully initialize sctp_outq in sctp_outq_init
Message-Id: <20130613130849.GA4058@neilslaptop.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <1371061604-27312-1-git-send-email-nhorman@tuxdriver.com>
 <20130613.024453.1256276769178191648.davem@davemloft.net>
In-Reply-To: <20130613.024453.1256276769178191648.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, sergei.shtylyov@cogentembedded.com, vyasevich@gmail.com, netdev@vger.kernel.org

On Thu, Jun 13, 2013 at 02:44:53AM -0700, David Miller wrote:
> 
> 'net-next' + 'stable' is an invalid set of targets for a patch.
> 
> If the patch is appropriate for 'stable', then it had better be
> appropriate for plain 'net' as well.
> 
Sorry, I just meant to indicate that I had initially applied it to net-next.  I
had meant to add net in there as well, where it also applies cleanly
Neil

