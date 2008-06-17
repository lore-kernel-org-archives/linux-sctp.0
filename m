From: David Miller <davem@davemloft.net>
Date: Tue, 17 Jun 2008 21:41:38 +0000
Subject: Re: [PATCH] sctp: fix error path in sctp_proc_init
Message-Id: <20080617.144138.71736435.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <4857AE19.9050708@openvz.org>
	<4857C025.8010701@hp.com>
In-Reply-To: <4857C025.8010701@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: xemul@openvz.org, linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Tue, 17 Jun 2008 09:46:13 -0400

> Pavel Emelyanov wrote:
> > After the sctp_remaddr_proc_init failed, the proper rollback is
> > not the sctp_remaddr_proc_exit, but the sctp_assocs_proc_exit.
> > 
> > Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> Ack for net-next-2.6.
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

I added this bug during the net-2.6 --> net-next-2.6 merge, sorry :-)

I'll apply this, thanks everyone!
