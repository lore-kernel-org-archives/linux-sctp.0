From: David Miller <davem@davemloft.net>
Date: Mon, 15 Apr 2013 18:14:05 +0000
Subject: Re: [PATCH net-next 1/2] net: sctp: remove sctp_ep_common struct member 'malloced'
Message-Id: <20130415.141405.2008713283094215984.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1366032438-4412-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1366032438-4412-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: netdev@vger.kernel.org, linux-sctp@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 15 Apr 2013 15:27:17 +0200

> There is actually no need to keep this member in the structure, because
> after init it's always 1 anyway, thus always kfree called. This seems to
> be an ancient leftover from the very initial implementation from 2.5
> times. Only in case the initialization of an association fails, we leave
> base.malloced as 0, but we nevertheless kfree it in the error path in
> sctp_association_new().
> 
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
