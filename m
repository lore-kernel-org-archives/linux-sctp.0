From: Pavel Emelyanov <xemul@openvz.org>
Date: Tue, 17 Jun 2008 12:29:59 +0000
Subject: Re: [PATCH] sctp: fix error path in sctp_proc_init
Message-Id: <4857AE47.1030008@openvz.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <4857AE19.9050708@openvz.org>
In-Reply-To: <4857AE19.9050708@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlad Yasevich <vladislav.yasevich@hp.com>, David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>

Pavel Emelyanov wrote:
> After the sctp_remaddr_proc_init failed, the proper rollback is
> not the sctp_remaddr_proc_exit, but the sctp_assocs_proc_exit.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Oops, sorry - this is for net-next-2.6.
