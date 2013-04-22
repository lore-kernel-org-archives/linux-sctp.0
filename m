From: David Miller <davem@davemloft.net>
Date: Mon, 22 Apr 2013 20:25:48 +0000
Subject: Re: [PATCH net-next] net: sctp: minor: remove dead code from sctp_packet
Message-Id: <20130422.162548.208159519580804410.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366358377-7623-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366358377-7623-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Fri, 19 Apr 2013 09:59:37 +0200

> struct sctp_packet is currently embedded into sctp_transport or
> sits on the stack as 'singleton' in sctp_outq_flush(). Therefore,
> its member 'malloced' is always 0, thus a kfree() is never called.
> Because of that, we can just remove this code.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied, thanks.
