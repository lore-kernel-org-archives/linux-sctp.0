From: David Miller <davem@davemloft.net>
Date: Thu, 27 Jun 2019 02:30:11 +0000
Subject: Re: [PATCH net] sctp: change to hold sk after auth shkey is created successfully
Message-Id: <20190626.193011.1423969728804124428.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
In-Reply-To: <14de0d292dc2fe01ecadaba00feb925b337b558f.1561393305.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 25 Jun 2019 00:21:45 +0800

> Now in sctp_endpoint_init(), it holds the sk then creates auth
> shkey. But when the creation fails, it doesn't release the sk,
> which causes a sk defcnf leak,
> 
> Here to fix it by only holding the sk when auth shkey is created
> successfully.
> 
> Fixes: a29a5bd4f5c3 ("[SCTP]: Implement SCTP-AUTH initializations.")
> Reported-by: syzbot+afabda3890cc2f765041@syzkaller.appspotmail.com
> Reported-by: syzbot+276ca1c77a19977c0130@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks Xin.
