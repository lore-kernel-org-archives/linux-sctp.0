From: David Miller <davem@davemloft.net>
Date: Tue, 08 Apr 2014 16:50:32 +0000
Subject: Re: [PATCH net] net: sctp: wake up all assocs if sndbuf policy is per socket
Message-Id: <20140408.125032.810691136561418545.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1396964037-13245-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1396964037-13245-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, tgraf@suug.ch, nhorman@tuxdriver.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Tue,  8 Apr 2014 15:33:57 +0200

>  [ When net-next opens up again, we need to think how
>    we can ideally make a new list interface and simplify
>    both open-coded list traversals. ]

I don't think you need a new list interface.

Instead, just have a back pointer to the sctp_sk() from the asoc, then
you can do normal list traversals over the asocs.
