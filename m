From: David Miller <davem@davemloft.net>
Date: Thu, 20 Aug 2020 23:38:38 +0000
Subject: Re: [PATCH v2] net: sctp: Fix negotiation of the number of data streams.
Message-Id: <20200820.163838.2031881871934638484.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <3aef12f2fdbb4ee6b885719f5561a997@AcuMS.aculab.com>
        <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
In-Reply-To: <1f2ffcb1180e4080aab114683b06efab@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David.Laight@ACULAB.COM
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com

From: David Laight <David.Laight@ACULAB.COM>
Date: Wed, 19 Aug 2020 14:40:52 +0000

> 
> The number of output and input streams was never being reduced, eg when
> processing received INIT or INIT_ACK chunks.
> The effect is that DATA chunks can be sent with invalid stream ids
> and then discarded by the remote system.
> 
> Fixes: 2075e50caf5ea ("sctp: convert to genradix")
> Signed-off-by: David Laight <david.laight@aculab.com>

Applied and queued up for -stable, thanks David.
