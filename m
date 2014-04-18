From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 18 Apr 2014 09:39:54 +0000
Subject: Re: [PATCH] sctp: add support for busy polling to sctp protocol
Message-Id: <5350F2EA.8030003@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1397762811-2989-1-git-send-email-nhorman@tuxdriver.com>
In-Reply-To: <1397762811-2989-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org

On 04/17/2014 09:26 PM, Neil Horman wrote:
> The busy polling socket option adds support for sockets to busy wait on data
> arriving on the napi queue from which they have most recently received a frame.
> Currently only tcp and udp support this feature, but theres no reason sctp can't
> do so as well.  Add it in so appliations can take advantage of it
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Vlad Yasevich <vyasevich@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Daniel Borkmann <dborkman@redhat.com>
> CC: netdev@vger.kernel.org

Acked-by: Daniel Borkmann <dborkman@redhat.com>
