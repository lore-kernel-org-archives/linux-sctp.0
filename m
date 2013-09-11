From: David Miller <davem@davemloft.net>
Date: Wed, 11 Sep 2013 20:14:01 +0000
Subject: Re: [PATCH net] net: sctp: fix bug in sctp_poll for SOCK_SELECT_ERR_QUEUE
Message-Id: <20130911.161401.1088919298333377389.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1378565099-20987-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1378565099-20987-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org, jacob.e.keller@intel.com

From: Daniel Borkmann <dborkman@redhat.com>
Date: Sat,  7 Sep 2013 16:44:59 +0200

> If we do not add braces around ...
> 
>   mask |= POLLERR |
>           sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? POLLPRI : 0;
> 
> ... then this condition always evaluates to true as POLLERR is
> defined as 8 and binary or'd with whatever result comes out of
> sock_flag(). Hence instead of (X | Y) ? A : B, transform it into
> X | (Y ? A : B). Unfortunatelty, commit 8facd5fb73 ("net: fix
> smatch warnings inside datagram_poll") forgot about SCTP. :-(
> 
> Introduced by 7d4c04fc170 ("net: add option to enable error queue
> packets waking select").
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied and queued up for -stable.
