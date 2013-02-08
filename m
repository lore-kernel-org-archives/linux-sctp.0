From: David Miller <davem@davemloft.net>
Date: Fri, 08 Feb 2013 19:55:35 +0000
Subject: Re: [PATCH net 0/2] two small fixes for sctp key usage
Message-Id: <20130208.145535.2028003181646685456.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <cover.1360327229.git.dborkman@redhat.com>
In-Reply-To: <cover.1360327229.git.dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri,  8 Feb 2013 14:04:33 +0100

> Cryptographically used keys should be zeroed out when our session
> ends resp. memory is freed, thus do not leave them somewhere in the
> memory.
> 
> Daniel Borkmann (2):
>   net: sctp: sctp_setsockopt_auth_key: use kzfree instead of kfree
>   net: sctp: sctp_endpoint_free: zero out secret key data

Applied and queued up for -stable, thanks.
