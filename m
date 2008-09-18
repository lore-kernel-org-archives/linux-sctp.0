From: David Miller <davem@davemloft.net>
Date: Thu, 18 Sep 2008 23:29:41 +0000
Subject: Re: [PATCH 1/2] sctp: do not enable peer features if we can't do
Message-Id: <20080918.162941.157950819.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <1221773464-28845-1-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: linux-sctp@vger.kernel.org, lksctp-developers@lists.sourceforge.net, netdev@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 18 Sep 2008 17:31:03 -0400

> Do not enable peer features like addip and auth, if they
> are administratively disabled localy.  If the peer resports
> that he supports something that we don't, neither end can
> use it so enabling it is pointless.  This solves a problem
> when talking to a peer that has auth and addip enabled while
> we do not.  Found by Andrei Pelinescu-Onciul <andrei@iptel.org>.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

I applied this, but it is at best borderline for outside the
merge window.  It doesn't fix an OOPS nor a security issue nor
an entry in the 2.6.x regression list, therefore strictly speaking
this fix is not appropriate at this time.

Please apply this criteria when deciding whether to submit future
fixes for net-2.6 inclusion.
