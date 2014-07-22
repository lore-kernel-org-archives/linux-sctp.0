From: David Miller <davem@davemloft.net>
Date: Tue, 22 Jul 2014 20:32:57 +0000
Subject: Re: [PATCH net-next v3 2/3] net: sctp: Rename SCTP_XMIT_NAGLE_DELAY to SCTP_XMIT_DELAY
Message-Id: <20140722.133257.1649397778107446356.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1727AF03@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1727AF03@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 22 Jul 2014 08:59:14 +0000

> MSG_MORE and 'corking' a socket would require that the transmit of
> a data chunk be delayed.
> Rename the return value to be less specific.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
> 
> Resend with corrected subject line.
> 
> No change from v2.

Applied.
