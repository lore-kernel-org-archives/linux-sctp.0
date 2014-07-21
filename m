From: David Miller <davem@davemloft.net>
Date: Mon, 21 Jul 2014 23:25:37 +0000
Subject: Re: [PATCH net-next v3 1/3] Open out the check for Nagle
Message-Id: <20140721.162537.1473346987310446422.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <063D6719AE5E284EB5DD2968C1650D6D17278F4D@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D17278F4D@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 18 Jul 2014 17:36:24 +0000

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

Please add the "sctp: " subsystem prefix to this subject line.
