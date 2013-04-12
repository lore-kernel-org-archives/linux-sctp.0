From: David Miller <davem@davemloft.net>
Date: Fri, 12 Apr 2013 19:09:56 +0000
Subject: Re: [PATCH v2] sctp: Add buffer utilization fields to /proc/net/sctp/assocs
Message-Id: <20130412.150956.828923278890458461.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1365709796.14620.43.camel@pro6455b.example.com>
In-Reply-To: <1365709796.14620.43.camel@pro6455b.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dilip.daya@hp.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, nhorman@tuxdriver.com, dborkman@redhat.com

From: Dilip Daya <dilip.daya@hp.com>
Date: Thu, 11 Apr 2013 15:49:56 -0400

> From: Dilip Daya <dilip.daya@hp.com>
> 
> sctp: Add buffer utilization fields to /proc/net/sctp/assocs
> 
> This patch adds the following fields to /proc/net/sctp/assocs output:
> 
> 	- sk->sk_wmem_alloc    (transmit queue bytes committed)
> 	- sk->sk_wmem_queued   (persistent queue size)
> 	- sk->sk_sndbuf        (size of send buffer in bytes)
> 	- sk->sk_rcvbuf        (size of receive buffer in bytes)

Please use smaller field names, perhaps "wmema wmemq sndbuf rcvbuf"

> Patch applies to v3.8.6 and v3.9-rc6.

This does not belong in the commit message proper, it belongs in the
ancillary information you provide after the "---" delimeter.

> v2: Not changing spacing between the fields.

Similarly this supplemental information belongs after "---"

> +		seq_printf(seq, "\t%8lu %5d %5d %4d %4d %4d %8d "
> +						"%8d %8d %8d %8d",

This is not indented properly, the second line should have the "
appearing at the first column after the openning parenthesis
of the seq_printf() call.

The goal is not to exclusively use TAB characters to indent the
line into outer space, the goal is to use the appropriate of
TAB, then space, characters as necessary to indent the code to
the correct column.
