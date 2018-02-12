From: David Miller <davem@davemloft.net>
Date: Mon, 12 Feb 2018 16:47:07 +0000
Subject: Re: [PATCH net] sctp: do not pr_err for the duplicated node in transport rhlist
Message-Id: <20180212.114707.466856684304915903.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <f5a0c541d1e47f66d3513ab7974a6e9262ebe09d.1518431346.git.lucien.xin@gmail.com>
In-Reply-To: <f5a0c541d1e47f66d3513ab7974a6e9262ebe09d.1518431346.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 12 Feb 2018 18:29:06 +0800

> The pr_err in sctp_hash_transport was supposed to report a sctp bug
> for using rhashtable/rhlist.
> 
> The err '-EEXIST' introduced in Commit cd2b70875058 ("sctp: check
> duplicate node before inserting a new transport") doesn't belong
> to that case.
> 
> So just return -EEXIST back without pr_err any kmsg.
> 
> Fixes: cd2b70875058 ("sctp: check duplicate node before inserting a new transport")
> Reported-by: Wei Chen <weichen@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
