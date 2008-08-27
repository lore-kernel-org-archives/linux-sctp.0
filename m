From: David Miller <davem@davemloft.net>
Date: Wed, 27 Aug 2008 23:09:15 +0000
Subject: Re: [PATCH 1/2] sctp: correct bounds check in
Message-Id: <20080827.160915.57923023.davem@davemloft.net>
List-Id: <linux-sctp.vger.kernel.org>
References: <48B42ECA.7010800@redhat.com>
	<12198674162757-git-send-email-vladislav.yasevich@hp.com>
In-Reply-To: <12198674162757-git-send-email-vladislav.yasevich@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vladislav.yasevich@hp.com
Cc: eteo@redhat.com, netdev@vger.kernel.org, security@kernel.org, linux-sctp@vger.kernel.org

From: Vlad Yasevich <vladislav.yasevich@hp.com>
Date: Wed, 27 Aug 2008 16:03:34 -0400

> The bonds check to prevent buffer overlflow was not exactly
> right.  It still allowed overflow of up to 8 bytes which is
> sizeof(struct sctp_authkey).
> 
> Since optlen is already checked against the size of that struct,
> we are guaranteed not to cause interger overflow either.
> 
> Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied, and queued for -stable.
