From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Date: Tue, 18 Jun 2019 14:53:09 +0000
Subject: Re: general protection fault in sctp_sched_prio_sched
Message-Id: <20190618145309.GO3436@localhost.localdomain>
List-Id: <linux-sctp.vger.kernel.org>
References: <20190618144554.5016-1-hdanton@sina.com>
In-Reply-To: <20190618144554.5016-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: syzbot <syzbot+c1a380d42b190ad1e559@syzkaller.appspotmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>, "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, "vyasevich@gmail.com" <vyasevich@gmail.com>

On Tue, Jun 18, 2019 at 10:45:54PM +0800, Hillf Danton wrote:
...
> > Anyway, with the patch above, after calling
> > sctp_stream_init_ext() ->ext will be either completely valid, or it
> > will not be present at all as it is seting ->ext to NULL if sid
> > initialization ended up failing.
> > 
> Correct with no doubt.
> 
> I was wondering if it is likely for the ->ext, loaded with a valid slab,
> to cause a gpf in sctp_sched_prio_sched() without your patch applied.
> And if the failure to initialise sid could likely change the result.

Thanks, I think I understand now. Well, without the patch, yes, as
syzbot reported. Seems you're also worried if it can happen in other
situations as well, and end up triggering the same gpf but on a
different situation. I don't think so. It should be either
initialized or not initialized. Half-initialized as it was, that's a
pain.

  Marcelo
