From: David Miller <davem@davemloft.net>
Date: Tue, 22 Jul 2014 20:32:50 +0000
Subject: Re: [PATCH net-next v3 1/3] net: sctp: Open out the check for Nagle
Message-Id: <20140722.133250.365865462579004160.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D1727AF04@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1727AF04@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 22 Jul 2014 08:59:08 +0000

> The check for Nagle contains 6 separate checks all of which must be true
> before a data packet is delayed.
> Separate out each into its own 'if (test) return SCTP_XMIT_OK' so that
> the reasons can be individually described.
> 
> Also return directly with SCTP_XMIT_RWND_FULL.
> Delete the now-unused 'retval' variable and 'finish' label from
> sctp_packet_can_append_data().
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
> 
> Resend with corrected subject line.
> 
> Changes from v2:
> - Fix inverted test for 'inflight = 0'

Applied, but:

> +	if (inflight = 0)
> +		/* Nothing unacked */
> +		return SCTP_XMIT_OK;
> +	
   ^^^^^^

Trailing whitespace I had to fix up by hand.
