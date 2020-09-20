From: David Miller <davem@davemloft.net>
Date: Sun, 20 Sep 2020 21:16:29 +0000
Subject: Re: [PATCH v2] net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant
Message-Id: <20200920.141629.590298755126729557.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20200918132957.GB82043@localhost.localdomain>
        <20200919001211.355148-1-hptasinski@google.com>
In-Reply-To: <20200919001211.355148-1-hptasinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hptasinski@google.com
Cc: marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org, cminyard@mvista.com

From: Henry Ptasinski <hptasinski@google.com>
Date: Sat, 19 Sep 2020 00:12:11 +0000

> When calculating ancestor_size with IPv6 enabled, simply using
> sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
> alignment in the struct sctp6_sock. On x86, there aren't any extra
> bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
> boundary so there were 4 pad bytes that were omitted from the
> ancestor_size calculation.  This would lead to corruption of the
> pd_lobby pointers, causing an oops when trying to free the sctp
> structure on socket close.
> 
> Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")
> Signed-off-by: Henry Ptasinski <hptasinski@google.com>

Applied and queued up for -stable, thank you.
