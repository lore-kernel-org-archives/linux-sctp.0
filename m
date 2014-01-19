From: Daniel Borkmann <dborkman@redhat.com>
Date: Sun, 19 Jan 2014 22:44:01 +0000
Subject: Re: [PATCH net-next] sctp: fix missing SCTP mailing list address update
Message-Id: <52DC5531.4080403@redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <1390170293-15851-1-git-send-email-sakiwit@gmail.com>
In-Reply-To: <1390170293-15851-1-git-send-email-sakiwit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jean Sacren <sakiwit@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>, Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

On 01/19/2014 11:24 PM, Jean Sacren wrote:
> The commit 91705c61b5202 ("net: sctp: trivial: update mailing list
> address") updated almost all the SCTP mailing list address from
>
> 	"lksctp-developers@lists.sourceforge.net"
> to
> 	"linux-sctp@vger.kernel.org"
>
> except for the one in include/linux/sctp.h file. Fix this way trivial
> one so that all is updated.
>
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> Cc: Daniel Borkmann <dborkman@redhat.com>

Absolutely, thanks!

Acked-by: Daniel Borkmann <dborkman@redhat.com>
