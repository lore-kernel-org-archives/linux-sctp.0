From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Wed, 27 Jan 2016 16:02:28 +0000
Subject: Re: Query on SCTP:INIT re-transmission interval behavior
Message-Id: <20160127160228.GA6604@mrl.redhat.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
In-Reply-To: <SG2PR0401MB15190940DB1D58DC1EBFB140FED90@SG2PR0401MB1519.apcprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-sctp@vger.kernel.org

Hi,

On Wed, Jan 27, 2016 at 03:36:11PM +0000, Ravi Puttachannaiah wrote:
> Hi,
> 
> We are using LKSCTP version 1.0.16 and have configured the SCTP configuration parameters as follows:

Okay but in the end who will do the actual handling of the
retransmission is the kernel. Which kernel are you using?

> SctpInitMaxAttempts : 10
> SctpInitRTO : 3000
> SctpMinRTO : 1000
> SctpMaxRTO : 60000
> 
> We observed that SCTP:INIT re-transmission is occurring at interval  6,12,24.., 6,12,24.., 6,12,24....... As per our understanding re-transmission should occur at interval  3,6,12,24..., 3,6,12,24...3,6,12,24... since SctpInitRTO000.
> 
> Could you please let us know if it is an expected behavior or not. Also why re-transmission interval is not started with 3,6,12,24...

That's my understanding too, 3, 6, 12..

How many transports do you have?

  Marcelo
