From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 12 Nov 2009 17:34:19 +0000
Subject: Re: [Lksctp-developers] [PATCH 2/3] sctp: fix integer overflow when
Message-Id: <4AFC471B.7060604@hp.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <4AFC37DD.8090605@hp.com>
In-Reply-To: <4AFC37DD.8090605@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Andrei Pelinescu-Onciul wrote:
> 
> The  (unsigned long) cast in the patch above (sctp_association_init()),
> solves the problem on 64 bits, has no performance impact, allows for
> larger timeouts on 64 bits  and is more elegant (well at least from my
> point of view).

You've convinced me.  Queued.

-vlad

> 
> Andrei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
