From: David Miller <davem@davemloft.net>
Date: Tue, 11 Nov 2014 20:20:09 +0000
Subject: Re: [PATCH net] net: sctp: fix NULL pointer dereference in af->from_addr_param on malformed packet
Message-Id: <20141111.152009.393006371622381121.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1415638466-20176-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1415638466-20176-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, vyasevich@gmail.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 10 Nov 2014 17:54:26 +0100

> An SCTP server doing ASCONF will panic on malformed INIT ping-of-death
> in the form of:
> 
>   ------------ INIT[PARAM: SET_PRIMARY_IP] ------------>
> 
> While the INIT chunk parameter verification dissects through many things
> in order to detect malformed input, it misses to actually check parameters
> inside of parameters. E.g. RFC5061, section 4.2.4 proposes a 'set primary
> IP address' parameter in ASCONF, which has as a subparameter an address
> parameter.
> 
> So an attacker may send a parameter type other than SCTP_PARAM_IPV4_ADDRESS
> or SCTP_PARAM_IPV6_ADDRESS, param_type2af() will subsequently return 0
> and thus sctp_get_af_specific() returns NULL, too, which we then happily
> dereference unconditionally through af->from_addr_param().
> 
> The trace for the log:
 ...
> A minimal way to address this is to check for NULL as we do on all
> other such occasions where we know sctp_get_af_specific() could
> possibly return with NULL.
> 
> Fixes: d6de3097592b ("[SCTP]: Add the handling of "Set Primary IP Address" parameter to INIT")
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>

Applied and queued up for -stable.
