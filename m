From: David Miller <davem@davemloft.net>
Date: Tue, 22 Jul 2008 21:20:53 +0000
Subject: Re: [2.6 patch] make sctp_outq_flush() static
Message-Id: <20080722.142053.12687321.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <20080722172045.GT14846@cs181140183.pp.htv.fi>
	<20080722180532.GD6887@hmsreliant.think-freely.org>
In-Reply-To: <20080722180532.GD6887@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nhorman@tuxdriver.com
Cc: bunk@kernel.org, vladislav.yasevich@hp.com, sri@us.ibm.com, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 22 Jul 2008 14:05:32 -0400

> On Tue, Jul 22, 2008 at 08:20:45PM +0300, Adrian Bunk wrote:
> > sctp_outq_flush() can now become static.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied.
