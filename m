From: David Miller <davem@davemloft.net>
Date: Mon, 15 Apr 2013 18:14:11 +0000
Subject: Re: [PATCH net-next 2/2] net: sctp: minor: make sctp_ep_common's member 'dead' a bool
Message-Id: <20130415.141411.1985602595839232527.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366032438-4412-1-git-send-email-dborkman@redhat.com>
	<1366032438-4412-2-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366032438-4412-2-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 15 Apr 2013 15:27:18 +0200

> Since dead only holds two states (0,1), make it a bool instead
> of a 'char', which is more appropriate for its purpose.
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
