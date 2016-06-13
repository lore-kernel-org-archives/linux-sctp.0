From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Mon, 13 Jun 2016 16:04:28 +0000
Subject: Re: [lkp] [sctp] d46e416c11: WARNING: CPU: 2 PID: 727 at net/ipv4/af_inet.c:685 inet_accept+0x10d/0x
Message-Id: <8b8cdc03-da9d-48d0-7c9e-72c72a2235c9@gmail.com>
List-Id: <linux-sctp.vger.kernel.org>
References: <20160612015854.GC20879@yexl-desktop>
In-Reply-To: <20160612015854.GC20879@yexl-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kernel test robot <xiaolong.ye@intel.com>, Xin Long <lucien.xin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, Johan Hedberg <johan.hedberg@intel.com>, linux-bluetooth@vger.kernel.org, lkp@01.org, ltp@lists.linux.it, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>

Em 11-06-2016 22:58, kernel test robot escreveu:
>
>
> FYI, we noticed the following commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git master
> commit d46e416c11c88ef1deb5c7f19271806a5be597fe ("sctp: sctp should change socket state when shutdown is received")
>
> in testcase: ltp
> with following parameters: test=sctp
>
> on test machine: nhm-white2: 8 threads Nehalem with 4G memory
>
> caused below changes:

Hi,

Xin and I are working on a fix for this. Using SCTP_SS_CLOSING for 
sctp_sock_migrate() wasn't a good move. That's what is causing this.
Probably should have just moved to SCTP_SS_CLOSED already as the asoc is 
already closed.

Thanks,
Marcelo

