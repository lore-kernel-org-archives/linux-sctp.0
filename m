From: David Miller <davem@davemloft.net>
Date: Wed, 25 Jan 2017 17:27:12 +0000
Subject: Re: [PATCH net] sctp: sctp_addr_id2transport should verify the addr before looking up assoc
Message-Id: <20170125.122712.1048162748923388120.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <2ba9d3e0b3aa05baa3791811c92248126d233c67.1485237713.git.lucien.xin@gmail.com>
In-Reply-To: <2ba9d3e0b3aa05baa3791811c92248126d233c67.1485237713.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com, nhorman@tuxdriver.com

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Jan 2017 14:01:53 +0800

> sctp_addr_id2transport is a function for sockopt to look up assoc by
> address. As the address is from userspace, it can be a v4-mapped v6
> address. But in sctp protocol stack, it always handles a v4-mapped
> v6 address as a v4 address. So it's necessary to convert it to a v4
> address before looking up assoc by address.
> 
> This patch is to fix it by calling sctp_verify_addr in which it can do
> this conversion before calling sctp_endpoint_lookup_assoc, just like
> what sctp_sendmsg and __sctp_connect do for the address from users.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
