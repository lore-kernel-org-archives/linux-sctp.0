From: David Miller <davem@davemloft.net>
Date: Tue, 14 Oct 2014 16:46:57 +0000
Subject: Re: [PATCH net 0/3] SCTP fixes
Message-Id: <20141014.124657.128658692728989163.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1412888133-833-1-git-send-email-dborkman@redhat.com>
In-Reply-To: <1412888133-833-1-git-send-email-dborkman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dborkman@redhat.com
Cc: linux-sctp@vger.kernel.org, netdev@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Thu,  9 Oct 2014 22:55:30 +0200

> Here are some SCTP fixes.
> 
> [ Note, immediate workaround would be to disable ASCONF (it
>   is sysctl disabled by default). It is actually only used
>   together with chunk authentication. ]

Series applied, thanks guys.
