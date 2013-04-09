From: David Miller <davem@davemloft.net>
Date: Tue, 09 Apr 2013 17:21:56 +0000
Subject: Re: [PATCH net-next] net: sctp: introduce uapi header for sctp
Message-Id: <20130409.132156.1556520014623362577.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1365522841-19549-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1365522841-19549-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, nhorman@tuxdriver.com, vyasevich@gmail.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue,  9 Apr 2013 17:54:01 +0200

> This patch introduces an UAPI header for the SCTP protocol,
> so that we can facilitate the maintenance and development of
> user land applications or libraries, in particular in terms
> of header synchronization.
> 
> To not break compatibility, some fragments from lksctp-tools'
> netinet/sctp.h have been carefully included, while taking care
> that neither kernel nor user land breaks, so both compile fine
> with this change (for lksctp-tools I tested with the old
> netinet/sctp.h header and with a newly adapted one that includes
> the uapi sctp header). lksctp-tools smoke test run through
> successfully as well in both cases.
> 
> Suggested-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

This looks great, applied, thanks Daniel.
