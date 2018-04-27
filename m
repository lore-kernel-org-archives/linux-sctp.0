From: David Miller <davem@davemloft.net>
Date: Fri, 27 Apr 2018 17:22:36 +0000
Subject: Re: [PATCH net] sctp: handle two v4 addrs comparison in sctp_inet6_cmp_addr
Message-Id: <20180427.132236.1501587012472488998.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <17bfe46d7b9941f2283043f45ea5644c166c32c3.1524723237.git.lucien.xin@gmail.com>
In-Reply-To: <17bfe46d7b9941f2283043f45ea5644c166c32c3.1524723237.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com, syzkaller@googlegroups.com

From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 26 Apr 2018 14:13:57 +0800

> Since sctp ipv6 socket also supports v4 addrs, it's possible to
> compare two v4 addrs in pf v6 .cmp_addr, sctp_inet6_cmp_addr.
> 
> However after Commit 1071ec9d453a ("sctp: do not check port in
> sctp_inet6_cmp_addr"), it no longer calls af1->cmp_addr, which
> in this case is sctp_v4_cmp_addr, but calls __sctp_v6_cmp_addr
> where it handles them as two v6 addrs. It would cause a out of
> bounds crash.
> 
> syzbot found this crash when trying to bind two v4 addrs to a
> v6 socket.
> 
> This patch fixes it by adding the process for two v4 addrs in
> sctp_inet6_cmp_addr.
> 
> Fixes: 1071ec9d453a ("sctp: do not check port in sctp_inet6_cmp_addr")
> Reported-by: syzbot+cd494c1dd681d4d93ebb@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

What a long chain we are building of fixes to fixes to fixes... :(

Applied and queued up for -stable, thanks.
