From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 11 Jun 2019 20:52:22 +0000
Subject: Re: [PATCH v3] [sctp] Free cookie before we memdup a new one
Message-Id: <20190611205222.GA31473@hmswarspite.think-freely.org>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
 <20190611192245.9110-1-nhorman@tuxdriver.com>
 <20190611.130856.1857826051148231972.davem@davemloft.net>
In-Reply-To: <20190611.130856.1857826051148231972.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Miller <davem@davemloft.net>
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org, syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com, marcelo.leitner@gmail.com, lucien.xin@gmail.com

On Tue, Jun 11, 2019 at 01:08:56PM -0700, David Miller wrote:
> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Tue, 11 Jun 2019 15:22:45 -0400
> 
> > v2->v3
> > net->sctp
> > also free peer_chunks
> 
> Neil this isn't the first time you're submitting sctp patches right? ;-)
> 
> Subject: "[PATCH v3 net] sctp: Free cookie before we memdup a new one"
> 
> It's "subsystem_prefix: " and I even stated this explicitly yesterday.
> 
No, sorry, I'm trying to do this while I get a CI mess sorted out at the same
time, and I'm not close attention here.

If you want to take over a few dozen user space packages for me in RHEL, I'll
gladly get this right on the first try :)

Neil
